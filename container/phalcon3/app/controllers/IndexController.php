<?php

use Phalcon\Mvc\Controller;

// https://docs.phalconphp.com/en/latest/api/Phalcon_Di.html
// https://docs.phalconphp.com/en/latest/api/Phalcon_Mvc_Controller.html

class IndexController extends Controller
{
    public function indexAction()
    {
      // Simple test, to be removed soon ...
      $this->debugAction();

      $twig = $this->getDi()->get('twig');
      $template = $twig->loadTemplate('index.html.twig');
      echo $template->render(array('hello_world'=>'Hello world! Twig variable.'));
    }

    /**
     * Not a route yet ...
     */
    public function debugAction()
    {
      // Simple test, to be removed soon ...
      Kint::dump($GLOBALS, $_SERVER);
    }
}
