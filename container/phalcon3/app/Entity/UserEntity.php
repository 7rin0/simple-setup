<?php
namespace Simtup\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * @ORM\Entity
 * @ORM\Table(name="user", uniqueConstraints={@ORM\UniqueConstraint(name="user_name", columns={"name"})}))
 */
class UserEntity
{
    /**
     * @ORM\Id
     * @ORM\Column(name="id", type="integer")
     * @ORM\GeneratedValue(strategy="AUTO")
     */
    protected $id;

    /**
     * @ORM\Column(type="string", length=64)
     */
    protected $name;

    /**
     * @ORM\Column(type="string", length=150)
     */
    protected $username;

    /**
     * @ORM\Column(type="string", length=100)
     */
    protected $email;

    /**
     * Get array copy of object
     *
     * @return array
     */
    public function getArrayCopy()
    {
        return get_object_vars($this);
    }

    /**
     * Get user id
     *
     * @ORM\return integer
     */
    public function getId()
    {
        return $this->id;
    }

    /**
     * Get name
     *
     * @ORM\return string
     */
    public function getName()
    {
        return $this->name;
    }

    /**
     * Get username
     *
     * @ORM\return string
     */
    public function getUsername()
    {
        return $this->username;
    }

    /**
     * Get username
     *
     * @ORM\return string
     */
    public function getEmail()
    {
        return $this->email;
    }
}
