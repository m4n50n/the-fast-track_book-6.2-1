## Symfony 6: La Vía Rápida
https://symfony.com/doc/6.2/the-fast-track/en/index.html

```bash
# Verificar los requisitos necesarios para este proyecto
symfony book:check-requirements
```
### Descripción del proyecto
Tendremos una lista de conferencias en la página de inicio y una página para cada conferencia en la que se insertarán comentarios. Un comentario se compondrá de un texto y una imagen opcional.

El proyecto consistirá en una web traducional con frontend, backend y un SPA para teléfonos móviles.

#### Creando el proyecto
```bash
symfony new symfonyProject --version=6.2 --php=8.1 --webapp

# https://github.com/symfony/skeleton - Este repositorio se invocará con `symfony new` creando un proyecto básico.
# https://github.com/symfony/website-skeleton - Este repositorio se invocará con `symfony new --full` creando un proyecto completo.
# Ambos proyectos únicamente tienen un archivo `composer.json` con la información de los paquetes que serán instalados. 

# --webapp: Se creará una aplicación con la menor cantidad de dependencias posibles. Contiene la mayoría de paquetes de Symfony necesarios, incluidos Symfony Messenger y PostgreSQL a través de Doctrine.

cd symfonyProject
```





