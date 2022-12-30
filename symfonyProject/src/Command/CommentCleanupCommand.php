<?php 

namespace App\Command;

use App\Repository\CommentRepository;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;

#[AsCommand('app:comment:cleanup', 'Cleaning SPAM comments from the database')]
class CommentCleanupCommand extends Command
{
    public function __construct(
        private CommentRepository $commentRepository,
    ) {
        parent::__construct();
    }

    // Método para configurar y documentar el comando
    protected function configure()
    {
        $this
            # La siguiente opción "dry-run" nos permite pasar "dry run" como argumento en el comando, pero no realiza ningún cambio, sólo lo simula
            ->addOption('dry-run', null, InputOption::VALUE_NONE, 'Dry run')
        ;
    }

    // En este método se programa la acción a realizar
    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $io = new SymfonyStyle($input, $output);

        // En caso de pasar el argumetno "dry-run" al comando, simulará la ejecución y sólo contaremos el número de elementos que queremos eliminar
        if ($input->getOption('dry-run')) {
            $io->note('Dry mode enabled');

            $count = $this->commentRepository->countOldRejected();
        } else { # Si no pasamos "dry-run"como argumento, se ejecutará el proceso eliminado los comentarios marcados como SPAM
            $count = $this->commentRepository->deleteOldRejected();
        }

        $io->success(sprintf('Deleted "%d" old rejected/spam comments.', $count));

        return Command::SUCCESS;
    }
}