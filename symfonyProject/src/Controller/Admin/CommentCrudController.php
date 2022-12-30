<?php

namespace App\Controller\Admin;

use App\Entity\Comment;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Config\Filters;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\AssociationField;
use EasyCorp\Bundle\EasyAdminBundle\Field\DateTimeField;
use EasyCorp\Bundle\EasyAdminBundle\Field\EmailField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextareaField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use EasyCorp\Bundle\EasyAdminBundle\Filter\EntityFilter;

class CommentCrudController extends AbstractCrudController
{
    # https://symfony.com/bundles/EasyAdminBundle/current/crud.html#crud-controller-configuration
    public static function getEntityFqcn(): string
    {
        return Comment::class;
    }

    /**
     * Método para configurar parámetros a la hora de hacer CRUDs de esta entidad desde el dashboard
     * https://symfony.com/bundles/EasyAdminBundle/current/crud.html
     */
    public function configureCrud(Crud $crud): Crud
    {
        return $crud
            ->setEntityLabelInSingular('Conference Comment')
            ->setEntityLabelInPlural('Conference Comments')
            ->setSearchFields(['author', 'text', 'email'])
            ->setDefaultSort(['createdAt' => 'DESC']);
    }

    /** 
     * Método para configurar filtros en las columnas de esta entidad en el dashboard
     * https://symfony.com/bundles/EasyAdminBundle/current/filters.html
     */
    public function configureFilters(Filters $filters): Filters
    {
        return $filters
            ->add(EntityFilter::new('conference'));
    }

    /**
     * Método para configurar las columnas por defecto del esta entidad en el dashboard
     * https://symfony.com/bundles/EasyAdminBundle/current/fields.html
     * 
     * Si este método está comentado por defecto, aparecerán todas las columnas
     */
    public function configureFields(string $pageName): iterable
    {
        # yield es parecido a return, pero en lugar de detener la ejecución de la función y devolver un valor, yield facilita el valor al bucle que itera sobre el generador y pausa la ejecución de la función generadora.
        # Con la siguiente sentencia hacemos que en la vista de Conference, en el dashboard, solo se vea la columna city pero con el nombre LA_CIUDAD!
        #yield TextField::new("city", "LA_CIUDAD!");

        // return [
        //     IdField::new('id'),
        //     TextField::new('title'),
        //     TextEditorField::new('description'),
        // ];

        yield AssociationField::new('conference');
        yield TextField::new('author');
        yield EmailField::new('email');
        yield TextareaField::new('text')
            ->hideOnIndex();
        yield TextField::new('photoFilename')
            ->onlyOnIndex();

        $createdAt = DateTimeField::new('createdAt')->setFormTypeOptions([
            'html5' => true,
            'years' => range(date('Y'), date('Y') + 5),
            'widget' => 'single_text',
        ]);

        if (Crud::PAGE_EDIT === $pageName) {
            yield $createdAt->setFormTypeOption('disabled', true);
        } else {
            yield $createdAt;
        }
    }
}
