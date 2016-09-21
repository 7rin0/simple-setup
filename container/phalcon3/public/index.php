<?php

// TODO: split logical from business part into
// more readble parts
use Phalcon\Loader;
use Phalcon\Mvc\View;
use Phalcon\Mvc\Application;
use Phalcon\Di\FactoryDefault;
use Phalcon\Mvc\Url as UrlProvider;
use Phalcon\Db\Adapter\Pdo\Mysql as DbAdapter;

error_reporting(-1);
ini_set('display_errors', -1);

// Register an autoloader
$loader = new Loader();

$loader->registerDirs(
    [
        "../app/controllers/",
        "../app/models/",
    ]
);

// Add composer autoload
$loader->registerFiles(['../vendor/autoload.php']);

// Register all loader configs
$loader->register();

// Create a DI
$di = new FactoryDefault();

// Setup the view component
$di->set(
    "view",
    function () {
        $view = new View();
        $view->setViewsDir("../app/views/");
        return $view;
    }
);

// Implement Twig
$di->set(
    "twig",
    function () {
        $twigLoader = new Twig_Loader_Filesystem(__DIR__ . '/../app/views');
        $twig = new Twig_Environment($twigLoader);
        return $twig;
    }
);

// TODO: implement YML config manager
// Implement Doctrine
$di->set(
    "doctrine",
    function () {
        $doctrineSchema = [
          'doctrine' => [
            'meta' => [
                'entity_path' => [
                    'app/entities'
                ],
                'auto_generate_proxies' => true,
                'proxy_dir' =>  __DIR__.'/../cache/proxies',
                'cache' => null,
            ],
            'connection' => [
                'driver'   => 'pdo_mysql',
                'host'     => 'localhost',
                'dbname'   => 'phalcon3',
                'user'     => 'root',
                'password' => 'root',
            ]
          ]
        ];
        $config = \Doctrine\ORM\Tools\Setup::createAnnotationMetadataConfiguration(
            $doctrineSchema['meta']['entity_path'],
            $doctrineSchema['meta']['auto_generate_proxies'],
            $doctrineSchema['meta']['proxy_dir'],
            $doctrineSchema['meta']['cache'],
            false
        );

        $em = \Doctrine\ORM\EntityManager::create($doctrineSchema['connection'], $config);

        return ConsoleRunner::createHelperSet($em);
    }
);

# Set url
$di->set(
    "url",
    function () {
        $url = new UrlProvider();
        $url->setBaseUri("/");
        return $url;
    }
);

$application = new Application($di);

try {
    // Handle the request
    $response = $application->handle();
    $response->send();
} catch (\Exception $e) {
    echo "Exception: ", $e->getMessage();
}
