<?php

namespace App\MessageHandler;

use App\Message\CommentMessage;
use App\Repository\CommentRepository;
use App\SpamChecker;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\Messenger\Attribute\AsMessageHandler;

/**
 * AsMessageHandlerayuda a Symfony a registrarse y configurar automáticamente la clase como un controlador de Messenger. 
 * Por convención, la lógica de un controlador vive en un método llamado __invoke().  
 */
#[AsMessageHandler]

// Este objeto recibe un objeto mensaje y es el handler el que se encarga de procesar dicho mensaje 
// Por lo tanto, ahora es el handler el que deberá interactuar con el spamChecker
class CommentMessageHandler
{
    public function __construct(
        private EntityManagerInterface $entityManager,
        private SpamChecker $spamChecker,
        private CommentRepository $commentRepository,
    ) {
    }

    # https://www.php.net/manual/en/language.oop5.magic.php#object.invoke
    # Aquí se recibirá el objeto de tipo Comment que se deberá procesar (es decir, el objeto comentario insertado)
    public function __invoke(CommentMessage $message)
    {
        $comment = $this->commentRepository->find($message->getId());
        if (!$comment) {
            return;
        }

        if ($this->spamChecker->getSpamScore($comment, $message->getContext()) === 0) {
            $comment->setStatus('OK');
        } else { $comment->setStatus('SPAM'); }

        $this->entityManager->flush();
    }
}