<?php

namespace AppBundle\Controller;

use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;

class SearchController extends Controller
{
    /**
     * @Route("/search/{key}", name="search")
     */
    public function searchAction($key)
    {
      // get finder object first for our index
      $finder = $this->container->get('fos_elastica.finder.app.user');

      // Find by index!
      $users = $finder->find($key);

      // Return users.
      return $users;
    }
}
