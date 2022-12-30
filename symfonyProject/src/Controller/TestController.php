<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\HttpFoundation\Request;

class TestController extends AbstractController
{
    // #[Route('/', name: 'app_test')]
    #[Route('/hello/{name}', name: 'app_test')]
    public function index(Request $request, String $name): Response
    {      
        dump($request); # Prueba de depuración (aparecerá en la barra del profiler)

        /**
         * Obtener query params
         * Symfony se encarga de añadir los query params de la petición al objeto Request, el cual podemos obtener con Request $request
         */        
        $greet_query = "";
        if ($request->query->has("hello")) { // Comprobar si existe el query param "hello"
            $greet_query = $request->query->get("hello");
        }

        /**
         * Obtener path params (es decir, parámetros que forman parte de la url)
         * Para probar esto, podríamos probar la siguiente ruta:
         * #[Route('/hello/{name}', name: 'app_test')]         * 
         * name será el path param
         * 
         * Este parámetro lo capturamos añadiendo al método el argumento String $name
         */
        $greet_path = $name;
                
        // Retornar HTML de prueba - Este código sería una mala práctica -. Lo correcto es usar el sistema de plantillas Twig que incorpora Symfony, por lo que lo dejamos comentado
        // return new Response(<<<EOF
        //     <html>
        //     <head>
        //     </head>
        //     <body>
        //         $greet
        //         <p>PRUEBA TEST!!!!</p>
        //     </body>            
        //     </html>
        //     EOF
        // );

        // Con este código renderizamos la plantilla usando el motor de plantillas Twig
        // El método render se encargará de retornar un objeto Response procesando primero los datos dinámicos procesados en el Controller y luego lo que hay en la plantilla
        return $this->render('test/index.html.twig', [
            // Variables que pasaremos a la plantilla
            "greet_query" => $greet_query,
            "greet_path" => $greet_path
        ]);

        # Una URL de test en el navegador sería: http://localhost:8005/hello/joseUno?hello=joseDos
    }
}
