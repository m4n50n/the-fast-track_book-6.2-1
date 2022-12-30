<?php

namespace App\Entity;

use App\Repository\ConferenceRepository;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
use Doctrine\ORM\Mapping as ORM;
use Symfony\Bridge\Doctrine\Validator\Constraints\UniqueEntity;
use Symfony\Component\String\Slugger\SluggerInterface;

#[ORM\Entity(repositoryClass: ConferenceRepository::class)]

# https://symfony.com/doc/current/reference/constraints/UniqueEntity.html
# Validates that a particular field (or fields) in a Doctrine entity is (are) unique
#[UniqueEntity('slug')]
class Conference
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column(length: 255)]
    private ?string $city = null;

    #[ORM\Column(length: 4)]
    private ?string $year = null;

    #[ORM\Column]
    private ?bool $isInternational = null;

    #[ORM\OneToMany(mappedBy: 'conference', targetEntity: Comment::class, orphanRemoval: true)]
    private Collection $comments;

    // #[ORM\Column(length: 255)]
    #[ORM\Column(type: 'string', length: 255, unique: true)]
    private ?string $slug = null;

    public function __construct()
    {
        $this->comments = new ArrayCollection();
    }

    /**
     * Al mostrar relaciones de entidad (la conferencia vinculada a un comentario) EasyAdmin intenta utilizar una representación de cadena de la conferencia. 
     * De forma predeterminada utiliza una convención que utiliza el nombre de la entidad y la clave principal (por ejemplo: Conference #1) en caso de que la entidad no dispone del método __toString(), así que la agregamos para que devuelva datos más útiles que identifiquen la relación
     */
    public function __toString(): string
    {
        return $this->city . ' ' . $this->year;
    }

    // Para esto hemos creado el listener ConferenceEntityListener, por lo que será más complejo que lo que hicimos en el método setCreatedAtValue() de la entidad comments
    public function computeSlug(SluggerInterface $slugger)
    {
        if (!$this->slug || $this->slug === '-') {
            $this->slug = (string) $slugger->slug((string) $this)->lower();
        }
    }

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getCity(): ?string
    {
        return $this->city;
    }

    public function setCity(string $city): self
    {
        $this->city = $city;

        return $this;
    }

    public function getYear(): ?string
    {
        return $this->year;
    }

    public function setYear(string $year): self
    {
        $this->year = $year;

        return $this;
    }

    public function isIsInternational(): ?bool
    {
        return $this->isInternational;
    }

    public function setIsInternational(bool $isInternational): self
    {
        $this->isInternational = $isInternational;

        return $this;
    }

    /**
     * @return Collection<int, Comment>
     */
    public function getComments(): Collection
    {
        return $this->comments;
    }

    public function addComment(Comment $comment): self
    {
        if (!$this->comments->contains($comment)) {
            $this->comments->add($comment);
            $comment->setConference($this);
        }

        return $this;
    }

    public function removeComment(Comment $comment): self
    {
        if ($this->comments->removeElement($comment)) {
            // set the owning side to null (unless already changed)
            if ($comment->getConference() === $this) {
                $comment->setConference(null);
            }
        }

        return $this;
    }

    public function getSlug(): ?string
    {
        return $this->slug;
    }

    public function setSlug(string $slug): self
    {
        $this->slug = $slug;

        return $this;
    }
}
