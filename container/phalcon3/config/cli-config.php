<?php
use Doctrine\ORM\Tools\Console\ConsoleRunner;
// http://docs.doctrine-project.org/projects/doctrine-orm/en/latest/reference/configuration.html
require_once 'vendor/autoload.php';

$doctrineSchema = [
  'meta' => [
      'entity_path' => [
          'app/Entity'
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
