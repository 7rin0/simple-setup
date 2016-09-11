<?php

namespace AppBundle\Controller;

use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use FOS\RestBundle\Controller\Annotations as Rest;
use FOS\RestBundle\Controller\FOSRestController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use FOS\RestBundle\View\View;
use AppBundle\Entity\User;


class UserController extends FOSRestController
{
  /**
  * @Rest\Get("/user/{id}")
  */
  public function getAction($id)
  {
    $restresult = "";
    if ($id === "all") {
      $restresult = $this->getDoctrine()->getRepository('AppBundle:User')->findAll();
    } else {
      $restresult = $this->getDoctrine()->getRepository('AppBundle:User')->find($id);
    }
    if ($restresult === null) {
        return new View("there are no users exist", Response::HTTP_NOT_FOUND);
    }
    return $restresult;
  }

    /**
    * @Rest\Post("/user/")
    */
    public function postAction(Request $request)
    {
      $newUser = new User;
      $name = $request->get('name');
      $role = $request->get('role');
      if(empty($name) || empty($role))
      {
       return new View("NULL VALUES ARE NOT ALLOWED", Response::HTTP_NOT_ACCEPTABLE);
      }
      $newUser->setName($name);
      $newUser->setRole($role);
      $entityManager = $this->getDoctrine()->getManager();
      $entityManager->persist($newUser);
      $entityManager->flush();
      return new View("User Added Successfully", Response::HTTP_OK);
    }
}
