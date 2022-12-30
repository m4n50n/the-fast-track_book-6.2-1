## Symfony 6: La Vía Rápida
https://symfony.com/doc/6.2/the-fast-track/en/index.html (Los pasos y toda la documentación que se sigue parte de aquí)

<small>**He documentado y desarrollado todo el proyecto excepto la parte de twig, formularios y frontend que sólo la he desarrollado pero no documentado y luego, las partes de test, workflow, emails de admin y cache (pasos 17, 19, 20, 21) no están ni desarrolladas ni documentadas. En el paso 21 sí que he configurado HTTP caché pero no funciona.</small>

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
- `symfony composer require security` - Instalar bundle security. Aunque algunos paquetes ya lo preinstalan, lo ejecutamos de nuevo para asegurarnos de tener todas las dependencias que vamos a necesitar.
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

- Ruta (`symfony console debug:router` para que se muestren todas las del sitio)
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
2. Crear los controladores CRUD para administrar las entidades de *Doctrine ORM* con `symfony console make:admin:crud` aceptando los parámetros por defecto. Con `symfony console debug:router` podremos comprobar todas las rutas configuradas en el sitio.
3. Vincular los controladores CRUD en el método `configureMenuItems()` dentro de `DashboardController.php` (https://symfony.com/bundles/EasyAdminBundle/current/dashboards.html#main-menu).
4. Configurar el tablero según https://symfony.com/bundles/EasyAdminBundle/current/dashboards.html#dashboard-configuration. La configuración se define en el método `configureDashboard()`.
5. Agregar el método `__toString()` en las entidades para que las relaciones puedan mostrarse de forma práctica.
6. Con todos los pasos anteriores aplicados ya podremos acceder al Dashboard para realizar CRUDs de las entidades.
7. El panel de administración puede configurarse de forma personalizada siguiendo:
   - https://symfony.com/doc/6.2/the-fast-track/en/9-backend.html#customizing-easyadmin
   - https://symfony.com/bundles/EasyAdminBundle/current/dashboards.html#dashboard-configuration

##### Asegurando el panel de administración
https://symfony.com/doc/current/security.html#the-user

** Más información sobre administración de usuarios: https://dev.to/nabbisen/symfony-6-and-easyadmin-4-hashing-password-3eec

1. Creamos un usuario admin ejecutando `symfony console make:user Admin`. <u>Si no existe la entidad *User*, la creará también en base a los parámetros que vayamos insertando en la consola</u>. Además, automáticamente configurará los parámetros de autenticación en el fichero `security.yaml`. Si a partir de aquí quisiéramos añadir más propiedades a la entidad *Admin* tendríamos que usar `symfony console make:entity`.
2. Ejecutar `symfony console make:auth` para configurar el método de autenticación de usuarios al dashboard. Este comando hará varias cosas:
    - Actualizará la configuración de seguridad en `security.yaml`
    - Creará el fichero `/src/Security/AppAuthenticator.php`
    - Creará el fichero `/src/Controller/SecurityController.php`
    - Creará el fichero `/templates/security/login.html.twig`
3. En este proyecto se ha configurado la parte de usuarios en el panel de administración para poder hacer CRUDs de los mismos en `AdminCrudController.php` (aunque la hemos llamado Admin, realmente la entidad será para los usuarios registrados). El hash de la password se aplicará al hacer un insert/update de un usuario mediante el subscriber `EasyAdminUserEventSubscriber`.

Para crear una forma de autenticación: https://symfony.com/doc/current/security.html

#### Escuchando eventos (Events y Subscribers)
https://symfony.com/doc/6.2/the-fast-track/en/12-event.html#discovering-symfony-events

https://symfony.com/doc/current/components/event_dispatcher.html

Symfony cuenta con un componente propio para disparar o lanzar elementos: *Event Dispatcher*. Este componente envía ciertos eventos en momentos específicos que los *listeners* pueden escuchar. Estos *listeners* son hooks internos de Symfony. 

Algunos eventos permiten interactuar con el ciclo de vida de las solicitudes HTTP. Durante el manejo de una solicitud, el dispatcher envia eventos cuando se crea una solicitud, cuando un controlador está a punto de ejecutarse, cuando una respuesta está lista, cuando se lanza una excepción, etc ... Un listener podrá escuchar uno o más eventos y ejecutar alguna lógica basada en el contexto del evento.

Muchos componentes y bundles de Symfony como Security, Messenger, Workflow o Mailer utilizan los eventos.

Para evitar tener un archivo de configuración que describa qué eventos necesita escuchar un listener, crearemos *suscriptores* (subscribers). Un subscriber es un oyente que detectará el evento y que dispondrá de un método estático `getSubscribedEvents()` que devolverá la configuración. Esto permite que los suscriptores se registren en el dispatcher de Symfony automáticamente.

Para crear un subscriber podemos usar el *maker-bundle* de Symfony haciendo `symfony console make:subscriber`. Al crearlo, nos pedirá un nombre y el evento que debe escuchar (por ejemplo, `Symfony\Component\HttpKernel\Event\ControllerEvent`, que es el que se envía justo antes de que se llame a un controlador. De esta manera podríamos inyectar una variable global, por ejemplo, para que el controlador pueda disponer de ella cuando se ejecute). 

De esta forma podríamos realizar <u><i>callbacks complejos</i></u> para eventos de Doctrine, por ejemplo.

<u>Explicación detallada:</u>
En Symfony, un listener es una clase que se suscribe a un evento y que es notificada cada vez que se dispara ese evento. Un listener puede ser cualquier clase que implemente el método *onEventName* para manejar el evento, donde *EventName* es el nombre del evento que está escuchando. Los listeners se pueden utilizar para hacer cosas como modificar el comportamiento de la aplicación cuando se dispara un evento, o para realizar tareas secundarias cuando se dispara un evento.

Por otro lado, un subscriber es una clase que se suscribe a un conjunto de eventos y que puede manejar varios eventos de manera centralizada. Un subscriber es un tipo especial de listener que implementa el método *getSubscribedEvents()* para devolver una lista de eventos a los que se suscribe y los métodos de manejo de eventos correspondientes. Los subscribers se utilizan para organizar mejor el código y evitar tener muchos listeners individuales para manejar diferentes eventos.

En resumen, un listener es una clase que se suscribe a un solo evento y maneja ese evento, mientras que un subscriber es una clase que se suscribe a varios eventos y maneja esos eventos de manera centralizada. Ambas clases se utilizan para realizar tareas cuando se dispara un evento en la aplicación Symfony.

Los listeners y subscribers se suelen registrar como servicios en el archivo "services.yaml" de la aplicación.

Para registrar un listener como servicio en *services.yaml*, debes especificar el nombre del servicio, la clase del listener y cualquier parámetro que necesite el listener. Luego, debes utilizar la anotación "@event_dispatcher.listener" para indicar qué eventos debe manejar el listener. Por ejemplo:

```yaml
services:
  app.listener.example:
    class: App\Listener\ExampleListener
    arguments: ['@doctrine.orm.entity_manager']
    tags:
      - { name: kernel.event_listener, event: kernel.request, method: onKernelRequest }
```

Para registrar un subscriber como servicio en "services.yaml", debes especificar el nombre del servicio, la clase del subscriber y cualquier parámetro que necesite el subscriber. Luego, debes utilizar la anotación "@event_dispatcher.subscriber" para indicar qué eventos debe manejar el subscriber. Por ejemplo:

```yaml
services:
  app.subscriber.example:
    class: App\Subscriber\ExampleSubscriber
    arguments: ['@doctrine.orm.entity_manager']
    tags:
      - { name: kernel.event_subscriber }
```

Es importante tener en cuenta que no hay una regla fija sobre cómo debes utilizar listeners o subscribers en Symfony. Depende de tus necesidades y de cómo quieras organizar tu código. Ambos pueden ser útiles en diferentes situaciones y puedes utilizar una combinación de ambos según sea necesario.

Puedes especificar qué listeners deben utilizarse para manejar diferentes eventos de seguridad, como por ejemplo el evento *InteractiveLoginEvent* que se dispara cuando un usuario inicia sesión de manera interactiva. Puedes utilizar un listener para realizar tareas adicionales cuando se dispara este evento, como por ejemplo actualizar el último inicio de sesión del usuario en la base de datos.

**Nota importante**: No confundir el sistema de eventos de Symfony con los de Doctrine (https://symfony.com/doc/current/doctrine/events.html). Aunque los listeners sean similares, no funcionan de la misma manera.

#### Gestionando el ciclo de vida de los objetos de Doctrine
https://symfony.com/doc/6.2/the-fast-track/en/13-lifecycle.html
https://symfony.com/doc/4.1/doctrine/common_extensions.html
https://symfony.com/bundles/StofDoctrineExtensionsBundle/current/index.html
https://symfony.com/doc/current/doctrine/events.html -> Sistema de eventos de Doctrine

Cómo realizar <u>callbacks simples</u>:
- `#[ORM\HasLifecycleCallbacks]`: <i>Comentario a añadir antes de definir la clase</i>
- `#[ORM\PrePersist]`: Triggered con inserts. <i>Comentario añadido al método a ejecutar</i>
- `#[ORM\PostPersist]`: Triggered con inserts. <i>Comentario añadido al método a ejecutar</i>
- `#[ORM\PreUpdate]`: Triggered con updates. <i>Comentario añadido al método a ejecutar</i>
- `#[ORM\PostUpdate]`: Triggered con updates. <i>Comentario añadido al método a ejecutar</i>

**Los <u>callbacks complejos</u> se explica en la parte de *listeners* y *subscribers*.

#### Akismet (Control de SPAM)
Usaremos la API de Akismet (https://akismet.com/) para validar si los comentarios son considerados (o no) como SPAM. 

Crearemos la clase `/src/SpamChecker.php`, donde irá toda la lógica para este proceso. Para terminar, apuntaremos a este proceso en `ConferenceController.php` para que detecte si un comentario es SPAM o no a la hora de hacer un insert, por ejemplo.

Esto funcionará obviamente al insertar comentarios en el formulario del front. Para que funcione en los CRUDs del panel de administración habría que implementar allí la llamada a SpamChecker.

https://akismet.com/development/api/#detailed-docs
https://akismet.com/development/api/#comment-check

#### Asincronía
Las tareas asíncronas nos permitirán ejecutar acciones sin necesidad de hacer esperar al usuario cuando dichas acciones no forman parte del objetivo principal de lo que se está haciendo.

Por ejemplo, cuando un usuario inserta un comentario y llamamos a la API de Akismet para saber si es SPAM o no, tiene sentido que el usuario espere la respuesta del insert, pero no de la comprobación de SPAM (ya que la velocidad de respuesta va a depender de la API de Akismet y esto no podemos controlarlo). En este caso, el método de comprobación de SPAM debería ser asíncrono.

https://symfony.com/doc/current/messenger.html

El componente <u>***Messenger***</u> es el encargado de gestionar el código asíncrono cuando usamos Symfony. Para instalarlo:
`symfony composer require messenger` - Esto creará también el fichero *messenger.yaml* y agregará variables de entorno en el fichero *.env*
`symfony composer require redis-messenger` - Instalar el messenger de Redis para usar Redis como cola de mensajes en caso de ser necesario.

Cuando alguna lógica deba ejecutarse de forma asíncrona, se envía un mensaje al bus de mensajería, el cual almacena el mensaje en una cola y regresa inmediatamente para permitir que el flujo de trabajo se reanude lo más rápido posible.

Por otro lado, habrá un *consumidor* (*consumer*) que estará ejecutándose continuamente en segundo plano para leer los mensajes encolados y ejecutar la lógica asociada. El consumidor podrá estar en el mismo servidor o en uno separado (en caso de que usemos Redis, por ejemplo).

Toda la lógica se dividirá en dos elementos (objetos):
- <u>Mensaje</u>: Será una clase que contendrá el mensaje que será transmitido. La clase solo almacenará el código del mensaje, el cual será serializado "por debajo" para almacenarse en la cola. La clase contendrá únicamente un id y un array de datos extra llamado *contexto*. La crearemos en `src/Message/CommentMessage.php`.
- <u>Manejador del mensaje</u>: será una especie de *controlador* que recibe un objeto ***mensaje*** y se encarga de procesarlo. Este ***handler*** será el que deba interactuar, en nuestro ejemplo, con el validador de SPAM. Lo crearemos en `src/MessageHandler/CommentMessageHandler.php`.

Por defecto, los manejadores son llamados sincrónicamente, así que para que sean ***asíncronos*** es necesario configurar explícitamente la cola a utilizar para cada handler en la configuración del messenger (en *messenger.yml*).

Para probar todo esto, insertamos un nuevo comentario (desde el formulario) cuando toda la lógica esté aplicada y veremos que se inserta con *pending* en la columna *status*.

Posteriormente ejecutaremos el consumidor manualmente con el comando:
`symfony console messenger:consume async -vv`

En lugar de iniciar el consumidor cada vez que se inserta un comentario y luego pararlo con control + C, usaremos Symfony CLI para que use un demonio en su lugar y lo ejecute en segundo plano.

`symfony run -d --watch=config,src,templates,vendor symfony console messenger:consume async -vv
`

La opción  `--watch` le dice a Symfony que el comando debe reiniciarse siempre que haya un cambio en el sistema de archivos en los directorios `/config/`, `/src/`, `/templates/` o `/vendor/`.

Para ver los logs y los trabajos en ejecución:
- `symfony server:log`
- `symfony server:status`

##### Reintentar mensajes fallidos
En caso de que el mensaje se pierda y no se llegue a verificar (porque Akismet esté caído, por ejemplo), *Messenger* puede realizar reintentos. Esto se configura por defecto en `config/packages/messenger.yaml` (https://symfony.com/doc/6.2/the-fast-track/en/18-async.html#retrying-failed-messages). En la parte de `max_retries` se configurará el número de veces que el consumidor intentará manejar el mensaje. Además, en caso de fallo lo almacenará en la cola configurada en `failed` en lugar de descartarlo.

Mediante los siguientes comandos podremos ver los mensajes fallidos y reintentarlos manualmente:
`symfony console messenger:failed:show`
`symfony console messenger:failed:retry`

#### Workflow
Un workflow o flujo de trabajo es la definición de rutas, acciones y cambios de estado posibles para objetos que van "avanzando" en una lógica de negocio en particular.

En este proyecto, tendría sentido para por ejemplo hacer que un administrador aprobase o rechazase un mensaje después de la verificación de SPAM. Por ahora no lo aplicaremos en este proyecto.

#### Almacenando en caché para mejorar el rendimiento
La velocidad del sitio puede verse afectada por varias razones: logs muy grandes, sentencias SQL no optimizadas, índices no definidos en la base de datos, sentencias sencillas que se repiten muchas veces, imágenes pesadas, falta de optimización en general, etc...

Veremos 3 estrategias relacionadas con el uso de la caché de la aplicación:

***Caché HTTP***: Esta caché es útil para páginas que no son dinámicas o que no necesitan serlo constantemente, como por ejemplo la página de inicio de una web. En esta página podemos establecer una caché que no cambie en horas o días.

En este caso agregaremos una caché de proxy inverso para habilitar el almacenamiento en caché. Modificaremos el método `setSharedMaxAge()` en nuestra página de inicio (que se corresponde en este caso con el `ConferenceController.php`) para configurar la caducidad (en segundos) de la memoria caché del navegador para proxies inversos. 

Deberemos configurar el fichero `framework.yaml` y propiedad `http_cache` para habilitar el proxy inverso HTTP.

*<u>Importante</u>*: en este caso lo que hacemos no es del todo correcto, ya que el controlador de conferencias puede llegar a ser muy dinámico al ir insertando conferencias sin refrescar la caché, pero como es la que tenemos asignada como página de inicio lo dejaremos así para probar.

***Evitando consultas SQL con ESI***: No desarrollada en este proyecto
***Caché para operaciones pesadas***: No desarrollada en este proyecto 

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
