## Symfony 6: La Vía Rápida
https://symfony.com/doc/6.2/the-fast-track/en/index.html

<small>**Se documenta todo el proyecto excepto las partes relacionadas con las plantillas de Twig para el frontend (aunque se realizan todos los pasos siguiendo la documentación).</small>

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

Comandos útiles iniciales:
```bash
## Verificar las versiones instaladas antes de comenzar
php -v # Mostrar la versión de PHP
php -m # Mostrar las extensiones instaladas de PHP
symfony console -V # Mostrar la versión de Symfony
symfony version # Mostrar la versión de Symfony CLI

# Verificar los requisitos necesarios para este proyecto
symfony book:check-requirements

# Verificar los requisitos para ejecutar Symfony en general
symfony check:requirements

# Instalar dependencias del fichero composer.json
symfony composer install

# Actualizar dependencias del fichero composer.json
symfony composer update

# Obtener la lista de dependencias instaladas
symfony composer show

# Obtener lista de librerías instaladas que tienen el nombre de "doctrine"
symfony composer show | grep doctrine

```

```bash
# Crear un nuevo proyecto: https://symfony.com/doc/current/setup.html
symfony new symfonyProject --version=6.2 --webapp # Si no especificamos una versión en concreto, se instalará la última versión estable de Symfony

# https://github.com/symfony/skeleton - Este repositorio se invocará con `symfony new` creando un proyecto básico.
# https://github.com/symfony/website-skeleton - Este repositorio se invocará con `symfony new --full` creando un proyecto completo.
# Ambos proyectos únicamente tienen un archivo `composer.json` con la información de los paquetes que serán instalados. 

# --webapp: Se creará una una aplicación con las dependencias básicas de una aplicación web. Contiene la mayoría de paquetes de Symfony necesarios, incluidos Symfony Messenger y PostgreSQL a través de Doctrine.
```

#### Symfony flex
Symfony *flex* es el componente que se encarga de crear el proyecto. Es un plugin construido sobre composer para gestionar las instalaciones de Symfony.

En https://github.com/symfony/recipes tenemos las "recetas" oficiales (y algunas de terceros que han sido adoptadas por Symfony como oficiales). Por ejemplo, si accedemos al fichero `manifest.json` de https://github.com/symfony/recipes/tree/main/symfony/profiler-pack/1.0, nos indicará que podríamos instalar esta librería en nuestro proyecto a través de uno de los siguientes comandos:

`symfony composer require profiler-pack`
`symfony composer require profiler`
`symfony composer require web-profiler`

#### Estructura del directorio
- La carpeta `/bin` contiene el punto de entrada CLI principal `console`, que se usa prácticamente para todo durante el desarrollo.
- La carpeta `/config` contiene las configuraciones del proyecto y de los *bundles* instalados, así como las rutas de la aplicación. *Las configuraciones predeterminadas cubren la mayoría de necesidades*.
- La carpeta `/public` es el directorio raíz web (*DocumentRoot* en Apache). Dentro se encuentra el controlador frontal `index.php`, que será el punto de entrada de todas las páginas. Todo lo que se almacena dentro de esta carpeta puede ser leído desde un navegador, por lo que no hay que guardar aquí archivos que vulneren la seguridad del proyecto. Generalmente aquí se introducen assets como CSS, imágenes, JavaScript, etc...
- La carpeta `/src` contiene todo el código fuente. Todas las clases que se encuentran dentro de esta carpeta usarán el *namespace* *App*, configurado en el *composer.json* de la carpeta raíz. 
- La carpeta `/var` contiene la caché y los logs en tiempo de ejecución. <u>Es el único directorio que necesita permisos de escritura en producción</u>.
- La carpeta `/vendor` contiene todos los paquetes instalados por composer, incluyendo el propio Symfony, librerias y bundles de terceros. Este directorio es administrado por composer y no necesitamos tocar nada aquí.

#### Instalando componentes
En Symfony hay dos tipos de paquetes que podemos implementar en los proyectos para obtener más funcionalidades:

- ***Componentes***: agregan características de bajo nivel que son útiles para ser usadas en la mayoría de las aplicaciones (enrutamiento, consola, cliente http, mailer, cache ...).
- ***Bundles***: agregan características de alto nivel y se integran con los componentes y librerías de terceros.
  
**El comando *symfony* sustituye a *php/bin*. Por ejemplo, `symfony console list` sería homólogo a `php/bin console list`, pero dentro del contexto de Symfony. El comando *symfony* lo implementa *Symfony CLI*.

**(Algunos de los siguientes paquetes se incluyen por defecto en caso de haber creado la aplicación de Symfony como `webapp`).

- `symfony composer require profiler --dev` - Instalar el *profiler* de Symfony (al agregar *--dev* le indicamos que la herramienta <u>sólo debe ser instalada para el entorno de desarrollo</u> y no de producción). Esto insertará la barra de herramientas en la parte de abajo de la web.
- `symfony composer require logger` - Instalar el *registro de eventos* (al no especificar un entorno, se instalará para todos los ambientes).
- `symfony composer require debug --dev` Instalar el componente de *depuración* sólo para el ambiente de desarrollo. Esto nos permitirá usar la función *dump()*, de forma que podemos hacer `dump($request)` para que por pantalla se muestre todo el contenido del objeto `$request` de forma muy útil.
- `symfony composer require symfony/maker-bundle --dev`: Es un bundle generador de código que nos permite crear de manera rápida mucho de los elementos de Symfony. En este caso lo instalamos sólo para el entorno de desarrollo. Para ver la lista de cosas que podemos generar con este bundle podemos hacer `symfony console list` o `symfony console list make`.
- `symfony composer require annotations`: Paquete bundle para poder configurar anotaciones en el código.
- `symfony composer require twig` - Instalar bundle *twig*. Aunque algunos paquetes ya lo preinstalan, lo ejecutamos de nuevo para asegurarnos de tener todas las dependencias que vamos a necesitar.
- `symfony composer require "twig/intl-extra:^3"` - Componente adicional para *twig* que necesitaremos en este proyecto para evitar errores a la hora de usar las plantillas.
- `symfony composer require orm` - Instalar el pack de librerías de Doctrine. Con esta instalación se agregarán los siguientes archivos y carpetas:
  - `/config/packages/doctrine.yaml`: Archivo de configuración. Aquí deberá especificarse la cadena de conexión a la base de datos en la propiedad `dbal`. <u>Una vez configurada y si aún no tenemos una base de datos creada</u>, la crearemos con `symfony console doctrine:database:create`. Si no da ningún error al crearla será porque la cadena de conexión es correcta.
  - `/config/packages/doctrine_migrations.yaml`: Archivo de configuración.
  - `/migrations`: Carpeta para los archivos de migraciones. Crearemos una migración con `symfony console make:migration`. Antes de realizarla podremos ejecutar `symfony console doctrine:schema:create --dump-sql` para ver el plan de ejecución y al final la ejecutaremos con `symfony console doctrine:migrations:migrate`. También podemos consultar el estado de las migraciones con `symfony console doctrine:migrations:status`.
  - `/src/Entity`: Carpeta para entidades (clases que representarán a cada tabla). Las crearemos con `symfony console make:entity` y bastará con seguir la "guía" que aparecerá. También podemos usar `symfony console make:entity NombreEntidad` para establecer el nombre desde el propio comando.
  - `/src/Repository`: Clases que ayudarán a centralizar las sentencias SQL que usaremos en cada entidad.
  - La cadena de conexión a la base de datos irá en el fichero `.env`
- `symfony composer require "admin:^4"` - Instalar el backend de administración *EasyAdmin* ("admin" es un alias para el paquete *easycorp/easyadmin-bundle*). Con esta instalación se agregarán los siguientes archivos y carpetas:
  - Se añaden *SecurityBundle* y *EasyAdminBundle* a la lista de bundles en `/config/bundles.php`
  - Se crea la carpeta `/translations`
  - Se crean los archivos:
    - `/config/packages/security.yaml`: Aquí configuraremos parámetros de seguridad como por ejemplo el control de acceso por rutas en la parte de *access_control* (https://symfony.com/bundles/EasyAdminBundle/current/security.html#security-entire-backend).
    - `/config/packages/translation.yaml`: Para configurar parámetros de idioma (y así poner en español el Dashboard, por ejemplo). 
    - `/config/packages/uid.yaml`
    - `/config/packages/validator.yaml`

#### Entornos en Symfony
Symfony dispone de tres tipos de entornos, los cuales comparten el mismo código fuente pero tienen configuraciones diferentes:

- **DEV**: Se encuentran habilitadas las herramientas de depuración. En este entorno la caché se regenera en cada petición.
- **PROD**: La aplicación se centra en el rendimiento y usa un sistema de caché. En este entorno la caché se regenera al acceder a la página por primera vez y luego se mantiene consultando directamente a la caché para mejorar los tiempos de respuesta.
- **TEST**: Está preparado para ejecutar pruebas automatizadas como si estuvieramos en producción, pero sin estarlo.

El entorno se definirá en la variable de entorno *APP_ENV* en el archivo `.env`, por ejemplo `APP_ENV=dev`. El archivo `.env` debería estar en el servidor y en local usaríamos usar un fichero `.env.local`.

**Cualquier otro paquete podrá agregar más variables de entorno automáticamente al archivo `.env`.

#### Controladores
Una página web vendrá dada por tres elementos:

- Ruta
- Controlador
- Plantilla
  
Si Symfony detecta que se está intentando acceder a una página por medio de una URL, intentará encontrar una ruta que coincida con esa dirección. La ruta será <u>el vínculo entre la URL y el controlador</u>.

En Symfony, la mayoría de los controladores se implementan como clases de PHP. Podrán ser creados manualmente o usando el paquete *maker*.

`symfony console make:controller`: deberemos especificar un nombre en formato *CamelCase* y acabado en "Controller", por ejemplo `ControlHorasController`. Esto creará dos elementos:

1. *<u>Controlador</u>*: Se creará dentro de la carpeta `/src/Controller`. Además, automáticamente dentro del controlador se creará un comentario con la ruta (url) de acceso y un *name*, que será un identificador único que servirá para referenciar nuestras páginas internamente sin usar las rutas (ya que en algún momento puede ser que queramos cambiar las rutas y esto obligaría a cambiar todas las referencias al controlador). La función principal del controlador será devolver una respuesta HTTP a una petición realizada por un cliente.

2. *<u>Plantilla</u>*: Se creará dentro de la carpeta `/templates/nombrecontrolador/index.html.twig`. Symfony utiliza el motor de plantillas *Twig*. En este archivo se insertará el código HTML a renderizar y además podrá recibir variables PHP.

#### Configuraciones
En Symfony, las configuraciones podemos escribirlas en formato *yaml*, *xml*, *php* o usando *anotaciones* en el propio código. Las más utilizadas son *yaml* (para los bundles) y *anotaciones* (para las rutas).

#### Doctrine
Para trabajar con bases de datos, Symfony usa *Doctrine*, que es un conjunto de librerías que otorga tres componentes:
- ***Doctrine DBAL***: Capa de abstracción de la base de datos que nos permite conectar a distintos motores por medio de una API estándar (muy parecido a PDO).
- ***Doctrine ORM***: Librería de manipulación de objetos de la base de datos que permite usar objetos en lugar de tablas. Para esto tendremos un objeto PHP que represente a cada tabla de la base de datos.
- ***Doctrine Migrations***: Librería que nos permitirá mantener sincronizada la estructura de la base de datos.

#### Bundle de administración de Backoffice
Para administrar los datos de nuestro sitio web usaremos **Easy Admin** (https://symfony.com/bundles/EasyAdminBundle/current/index.html), considerado el bundle de administración oficial por parte de Symfony.

Una vez instalado (podemos buscarlo en https://github.com/symfony/recipes y en su archivo `manifest.json` se indica los alias que podemos usar para instalarlo), es necesario seguir los siguientes pasos para configurarlo:

1. Generar el panel de administración web ejecutando el comando `symfony console make:admin:dashboard` (https://symfony.com/bundles/EasyAdminBundle/current/dashboards.html#dashboard-route). Esto creará por defecto el fichero `/src/Controller/Admin/DashboardController.php` habilitando la URL `http://localhost:8005/admin`.
2. Crear los controladores CRUD para administrar las entidades de *Doctrine ORM* con `symfony console make:admin:crud` aceptando los parámetros por defecto.
3. Vincular los controladores CRUD en el método `configureMenuItems()` dentro de `DashboardController.php` (https://symfony.com/bundles/EasyAdminBundle/current/dashboards.html#main-menu).
4. Configurar el tablero según https://symfony.com/bundles/EasyAdminBundle/current/dashboards.html#dashboard-configuration. La configuración se define en el método `configureDashboard()`.
5. Agregar el método `__toString()` en las entidades para que las relaciones puedan mostrarse de forma práctica.
6. Con todos los pasos anteriores aplicados ya podremos acceder al Dashboard para realizar CRUDs de las entidades.
7. El panel de administración puede configurarse de forma personalizada siguiendo:
   - https://symfony.com/doc/6.2/the-fast-track/en/9-backend.html#customizing-easyadmin
   - https://symfony.com/bundles/EasyAdminBundle/current/dashboards.html#dashboard-configuration

#### Events y Subscribers
https://symfony.com/doc/current/components/event_dispatcher.html

Symfony cuenta con un componente propio para disparar o lanzar elementos: ***Event Dispatcher***. Estos eventos pueden ser escuchados por los ***Subscribers***, que reaccionarán a lo ocurrido.

<u>Para poder detectar un evento</u> podemos crear un suscriptor (subscriber) que contenga un método estático `getSubscriberdEvents()` que permitirá la configuración.

Para crear un subscriber podemos usar el ***maker-bundle*** de Symfony haciendo `symfony console make:subscriber`
   
#### Otras notas
**yield es parecido a return, pero en lugar de detener la ejecución de la función y devolver un valor, yield facilita el valor al bucle que itera sobre el generador y pausa la ejecución de la función generadora.
https://www.php.net/manual/es/language.generators.syntax.php#:~:text=En%20su%20forma%20m%C3%A1s%20simple,ejecuci%C3%B3n%20de%20la%20funci%C3%B3n%20generadora

#### Enlaces de interés
- **PhpStorm**: https://www.jetbrains.com/es-es/phpstorm/
- **PHP**: http://php.net/
- **Composer**: https://getcomposer.org/
- **Docker**: https://www.docker.com/
- **Docker compose**: https://docs.docker.com/compose/install/
- **Symfony CLI**: https://symfony.com/download
- **Documentación oficial** del libro: https://symfony.com/doc/6.2/the-fast-track/en/index.html
