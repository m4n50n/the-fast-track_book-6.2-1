## Symfony 6: La Vía Rápida
https://symfony.com/doc/6.2/the-fast-track/en/index.html

```bash
# Parámetros de configuración de Git dentro de la máquina (recomendable antes de crear una nueva app de Symfony)
git config --global user.email "josegarciarodriguez89@hotmail.com"
git config --global user.name "Jose Clemente Garcia Rodriguez"
git config --global --add safe.directory /var/www/symfonyProject
```

### Descripción del proyecto
Tendremos una lista de conferencias en la página de inicio y una página para cada conferencia en la que se insertarán comentarios. Un comentario se compondrá de un texto y una imagen opcional.

El proyecto consistirá en una web tradicional con frontend, backend y un SPA para teléfonos móviles.

#### Creando el proyecto
```bash
## Verificar las versiones instaladas antes de comenzar
php -v # Mostrar la versión de PHP
php -m # Mostrar las extensiones instaladas de PHP
symfony console -V # Mostrar la versión de Symfony
symfony version # Mostrar la versión de Symfony CLI

# Verificar los requisitos necesarios para este proyecto
symfony book:check-requirements
```

```bash
# Crear un nuevo proyecto: https://symfony.com/doc/current/setup.html
symfony new symfonyProject --version=6.2 --webapp # Si no especificamos una versión en concreto, se instalará la última versión estable de Symfony

# https://github.com/symfony/skeleton - Este repositorio se invocará con `symfony new` creando un proyecto básico.
# https://github.com/symfony/website-skeleton - Este repositorio se invocará con `symfony new --full` creando un proyecto completo.
# Ambos proyectos únicamente tienen un archivo `composer.json` con la información de los paquetes que serán instalados. 

# --webapp: Se creará una una aplicación con las dependencias básicas de una aplicación web. Contiene la mayoría de paquetes de Symfony necesarios, incluidos Symfony Messenger y PostgreSQL a través de Doctrine.
```






