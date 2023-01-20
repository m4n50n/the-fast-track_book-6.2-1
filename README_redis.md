## Redis

##### Administrar listas en REDIS
https://www.digitalocean.com/community/cheatsheets/how-to-manage-lists-in-redis

Redis es un almacén de datos de clave-valor en memoria de código abierto. En Redis, una lista es una colección de cadenas ordenadas por orden de inserción, similar a las listas vinculadas . Este tutorial cubre cómo crear y trabajar con elementos en las listas de Redis.

**Creación de listas**
Una clave solo puede contener una lista, pero cualquier lista puede contener más de cuatro mil millones de elementos. Redis lee las listas de izquierda a derecha y puede agregar nuevos elementos de lista al encabezado de una lista (el extremo "izquierdo") con el comando `lpush` o al final (el extremo "derecho") con `rpush`. También puede usar `lpush` o `rpush` para crear una nueva lista:

`lpush key value`

Ambos comandos generan un número entero que muestra cuántos elementos hay en la lista.

`lpush key_philosophy1 "therefore"`
`lpush key_philosophy1 "think"`
`rpush key_philosophy1 "I"`
`lpush key_philosophy1 "I"`
`rpush key_philosophy1 "am"`

La salida del último comando será:

Output
(integer) 5

Tenga en cuenta que puede agregar varios elementos de la lista con una sola declaración `lpush` o `rpush`:

`rpush key_philosophy1 "-" "Rene" "Decartes"`

Los comandos `lpushx` y `rpushx` también se usan para agregar elementos a las listas, pero solo funcionarán si la lista dada ya existe. Si alguno de los comandos falla, devolverá (integer) 0:

`rpushx key_philosophy2 "Happiness" "is" "the" "highest" "good" "-" "Aristotle"`

Output
(integer) 0

Para cambiar un elemento existente en una lista, ejecute el comando `lset` seguido del nombre de la clave, el índice del elemento que desea cambiar y el nuevo valor:

`lset key_philosophy1 5 "sayeth"`

Si intenta agregar un elemento de lista a una clave existente que no contiene una lista, provocará un conflicto en los tipos de datos y devolverá un error. Por ejemplo, el siguiente setcomando crea una clave que contiene una cadena, por lo que el siguiente intento de agregarle un elemento de lista `lpush` fallará:

`set key_philosophy3 "What is love?"`
`lpush key_philosophy3 "Baby don't hurt me"`

Output
(error) WRONGTYPE Operation against a key holding the wrong kind of value

No es posible convertir las claves de Redis de un tipo de datos a otro, por lo que para convertirlas `key_philosophy3` en una lista, deberá eliminar la clave y comenzar de nuevo con un comando `lpush` o `rpush`.

**Recuperar elementos de una lista**
Para recuperar un rango de elementos en una lista, use el comando `lrange` seguido de un desplazamiento inicial y un desplazamiento final. Cada desplazamiento es un índice de base cero, lo que significa que 0 representa el primer elemento de la lista, 1 representa el siguiente, etc.

El siguiente comando devolverá todos los elementos de la lista de ejemplo creada en la sección anterior:

`lrange key_philosophy1 0 7`

Output
1) "I"
2) "think"
3) "therefore"
4) "I"
5) "am"
6) "sayeth"
7) "Rene"
8) "Decartes"
  
Las compensaciones pasadas `lrange` también pueden ser números negativos. Cuando se usa en este caso, -1 representa el elemento final de la lista, -2 representa el penúltimo elemento de la lista, etc. El siguiente ejemplo devuelve los últimos tres elementos de la lista contenida en `key_philosophy1`:

`lrange key_philosophy1 -3 -1`

Output
1) "I"
2) "am"
3) "sayeth"

Para recuperar un solo elemento de una lista, puede usar el comando `lindex` Sin embargo, este comando requiere que proporcione el índice del elemento como argumento. Al igual que con `lrange`, el índice tiene base cero, lo que significa que el primer elemento está en el índice 0, el segundo está en el índice 1, y así sucesivamente:

`lindex key_philosophy1 4`

Output
"am"

Para averiguar cuántos elementos hay en una lista dada, use el comando `llen`, que es la abreviatura de "`l`ist `len`​gth":

`llen key_philosophy1`

Output
(integer) 8

Si el valor almacenado en la clave dada no existe, `llen` devolverá un error.

**Eliminación de elementos de una lista**
El `lrem` comando elimina la primera de un número definido de ocurrencias que coincidan con un valor dado. Para experimentar con esto, crea la siguiente lista:

`rpush key_Bond "Never" "Say" "Never" "Again" "You" "Only" "Live" "Twice" "Live" "and" "Let" "Die" "Tomorrow" "Never" "Dies"`

El siguiente `lrem` ejemplo eliminará la primera aparición del valor `"Live"`:

`lrem key_Bond 1 "Live"`

Este comando generará la cantidad de elementos eliminados de la lista:

Output
(integer) 1

El número pasado a un comando `lrem` también puede ser negativo. El siguiente ejemplo eliminará las dos últimas apariciones del valor `"Never"`:

`lrem key_Bond -2 "Never"`

Output
(integer) 2

El comando `lpop` elimina y devuelve el primer elemento o el elemento "más a la izquierda" de una lista:

`lpop key_Bond`

Output
"Never"

Del mismo modo, para eliminar y devolver el último elemento o el "más a la derecha" de una lista, use `rpop`:

`rpop key_Bond`

Output
"Dies"

Redis también incluye el comando `rpoplpush`, que elimina el último elemento de una lista y lo empuja al principio de otra lista:

`rpoplpush key_Bond key_AfterToday`

Output
"Tomorrow"

Si las claves de origen y destino pasadas al comando `rpoplpush` son las mismas, esencialmente rotará los elementos en la lista.
