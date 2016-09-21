<?php

use Phalcon\Mvc\Controller;

class IndexController extends Controller
{
    public function indexAction()
    {
      $twig = $this->getDi()->get('twig');
      $template = $twig->loadTemplate('index.html.twig');
      echo $template->render(array('hello_world'=>'Hello world! Twig variable.'));
    }
}
