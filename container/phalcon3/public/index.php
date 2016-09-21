<?php

use Phalcon\Loader;
use Phalcon\Mvc\View;
use Phalcon\Mvc\Application;
use Phalcon\Di\FactoryDefault;
use Phalcon\Mvc\Url as UrlProvider;
use Phalcon\Db\Adapter\Pdo\Mysql as DbAdapter;

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

// $twigLoader = new Twig_Loader_Filesystem('./templates');
// $twig = new Twig_Environment($twigLoader);

// Setup the view component
$di->set(
    "view",
    function () {
        $view = new View();
        $view->setViewsDir("../app/views/");
        return $view;
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
