<?php

use Phalcon\Mvc\Controller;

class IndexController extends Controller
{
    public function indexAction()
    {
      $twigLoader = new Twig_Loader_Filesystem(__DIR__ . '/../views');
      $twig = new Twig_Environment($twigLoader);
      $template = $twig->loadTemplate('index.html.twig');
      echo $template->render(array());
    }
}
