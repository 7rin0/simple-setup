<?php

use Phalcon\Mvc\Controller;

// https://docs.phalconphp.com/en/latest/api/Phalcon_Di.html
// https://docs.phalconphp.com/en/latest/api/Phalcon_Mvc_Controller.html

class IndexController extends Controller
{
    public function indexAction()
    {
      $twig = $this->getDi()->get('twig');
      $template = $twig->loadTemplate('index.html.twig');
      echo $template->render(array('hello_world'=>'Hello world! Twig variable.'));
    }
}
