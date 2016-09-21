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

$di->set(
    "twig",
    function () {
        $twigLoader = new Twig_Loader_Filesystem(__DIR__ . '/../app/views');
        $twig = new Twig_Environment($twigLoader);
        return $twig;
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
