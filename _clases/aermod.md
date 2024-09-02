--- 
layout: lecture
title: Aermod
descripcion: Aermod
date: 2024-09-04
ready: true
---

# AERMOD

Tutorial para uso de **AERMOD**. Para mayor información se recomienda consultar la [guía de usuario](https://gaftp.epa.gov/Air/aqmg/SCRAM/models/preferred/aermod/aermod_userguide.pdf).
{: .fs-6 .fw-300 }
---

## Directorio de trabajo

Aermod requiere como entradas los productos de preprocesador [``AERMET``](./aermet.md), por lo que es conveniente trabajar en el mismo directorio donde se ejecuto el programa y se generaron los archivos de salida con extensiones .SFC y .PFL.
Para esta prueba podemos usar las salidas generadas en el tutorial de [``AERMET``](./aermet.md) o descargar los siguientes archivos:

+ [SURFACE_FILE: PRUEBA.SFC](./archivos/aermod/PRUEBA.SFC){: .btn .btn-outline }
+ [PROFILE_FILE: PRUEBA.PFL](./archivos/aermod/PRUEBA.PFL){: .btn .btn-outline }
 
## Descarga
El aermod se puede descargar de la web de la USEPA: [``aermod_exe.zip``](https://gaftp.epa.gov/Air/aqmg/SCRAM/models/preferred/aermod/aermod_exe.zip), es necesario descomprimirlo y luego colocar el ejcutable ``aermod.exe`` en el directorio de trabajo.
## Preparacion de datos de entrada

Para poder ejecutar el **AERMOD** es necesario contar con:

+ **Archivos meteorologicos.** ``PRUEBA.SFC`` y ``PRUEBA.FSL`` generados por el [**AERMET**](/aermet.html).
+ **Informacion de Receptores.**
  - Punto central del predio donde se encuentran las fuentes (``xc`` ``yc``).
  - Dominio de modelado (limites: ``xmin`` ``xmax`` ``ymin`` ``ymax``).
  - Espacio entre receptores ``dx`` (generalmente usamos 50 metros).

+ **Informacion de Emisiones.** depende del tipo de fuente emisora, para una fuente puntual es:
  - coordenadas, altura y diámetro del emisor.
  - caudal másico emitido [g/s]
  - temperatura  del efluente [ºK]
  - velocidad de salida [m/s]
+ **Informacion de Edificios.** Si hubiera edificios que influencien el flujo en las vecindades del emisor también es necesario conocer las coordenadas de sus vértices y altura promedio.

## Archivo de control ``aermod.inp``.

**AERMOD** al ser ejecutado busca un archivo de control con nombre ``aermod.inp``. En este se especifica la ubicacion de los archivos de entrada, opciones y configuracion de la corrida.
Un ejemplo de ``aermod.inp`` completo sería:

```Text
**
** Archivo de "Control" para corrida de aermod.
**

**Opciones generales de corrida 
CO STARTING
   TITLEONE  PRUEBA
   MODELOPT  CONC FLAT
   AVERTIME  MONTH 
   POLLUTID  NOX
   RUNORNOT  RUN
   EVENTFIL  OUTPUT.LOG
   ERRORFIL  ERRORS.LOG
   FLAGPOLE  1.5
CO FINISHED 

**Informacion de fuentes
SO STARTING
   ELEVUNIT  METERS
   LOCATION  FUENTE1  POINT  361833.281  6139544.02  0
   SRCPARAM  FUENTE1 96.7 15 453 27.13 5
   SRCGROUP  ALL 
SO FINISHED

**Grilla de receptores
RE STARTING
   GRIDCART  CAR1 STA
                  XYINC 359333.281 100 50.0 6137044.02 100 50.0
   GRIDCART  CAR1 END
RE FINISHED

**Informacion meteorologica
ME STARTING  
   SURFFILE  PRUEBA.SFC
   PROFFILE  PRUEBA.PFL
   SURFDATA  87576 2021 SAEZ
   UAIRDATA  87576 2021 SAEZ
   PROFBASE  0.0  METERS
ME FINISHED

**Opciones de salida
OU STARTING  
   RECTABLE  ALLAVE  FIRST
   MAXTABLE  ALLAVE  50
   SUMMFILE  AERTEST_PRUEBA_NOX_MONTH.SUM
   PLOTFILE  MONTH  ALL  FIRST AERPLOT_PRUEBA_NOX_MONTH.OUT
OU FINISHED
```

Este archivo se estructura en las siguientes secciones:
+ **CO**: especificaciones generales de ejecucion.
+ **SO**: especificaciones de fuentes (**SO**urces).
+ **RE**: especificaciones de **RE**ceptores.
+ **ME**: especificaciones de informacion **ME**teorologica.
+ **EV**: especificaciones de procesamiento de **EV**entos (opcional).
+ **OU**: especificaciones generales de archivos de salida (**OU**tput).

hay que especificar siempre el inicio y finalizacion de cada seccion, por ejemplo:


```
CO STARTING
**      ....
**	(especificaciones de seccion de COntrol)
**      ....
CO FINISHED
```

Cada especificacion sigue la siguiente notacion:

```
KEYWORD <arg1> <arg2> ... <argN>
```

donde ``KEYWORD`` son palabras reservadas para definir parámetros de ejecucion, y ``arg1``, ``arg2``, ... son "argumentos" o los valores que toma la keyword. Por ejemplo:

```Text
TITLEONE PRUEBA
```

la keyword es ``TITLEONE`` que sirve para especificar el nombre del proyecto. y ``PRUEBA`` es el valor que toma, en este caso entonces el titulo del proyecto será *PRUEBA*.

Revisar la lista de KEYWORDS en: [Keywords](./refs/KEYWORDSaermod.md), en este tutorial solo se describen algunos de los más importantes.

Vamos a preparar el archivo de entrada, por lo que debemos crear un nuevo archivo de texto y guardarlo con el nombre ``aemod.inp``.

### CONTROL (CO)

En esta sección se definen opciones generales para la corrida.

```Text
CO STARTING
   TITLEONE  PRUEBA
   MODELOPT  CONC FLAT
   AVERTIME  MONTH 
   POLLUTID  NOX
   RUNORNOT  RUN
   EVENTFIL  OUTPUT.LOG
   ERRORFIL  ERRORS.LOG
   FLAGPOLE  1.5
CO FINISHED 
```

Los parámetros más importantes son:
+ ``MODELOPT`` define las opciones generales de la corrida, tiene muchos argumentos posibles. *CONC* indica que se calcularán concentraciones. Para correr sin topografía se puede usar el argumento *FLAT*, caso contrario *ELEV* será utilizado que indica que si se considerará la topografía.
+ ``AVERTIME``: es el periodo de promediado de las concentraciones se expresa en horas, opciones válidas son: 1,2,3,4,6,8,12 o 24. También son argumentos válidos: *MONTH* y *ANNUAL*.
+ ``POLLUTID``: es el nombre del contaminante, puede ser cualquier texto, salvo que se defina: como **NO2** o **PM25**, en tal caso **AERMOD** interpreta que se debe a dichos contaminantes y reajusta algunos parámetros y rutinas para tratarlos.
+ ``FLAGPOLE`` Se define la altura del receptor sobre el nivel del terreno, en general se usa 1.5 metros.

### EMISORES: (SO)

En esta sección se enumeran las fuentes y sus parámetros de emisión.

```Text
SO STARTING
   ELEVUNIT  METERS
   LOCATION  FUENTE1  POINT  361833.281  6139544.02  0
   SRCPARAM  FUENTE1 96.7 15 453 27.13 5
   SRCGROUP  ALL 
SO FINISHED
```
Para nuestra prueba, vamos a tomar la considerar una fuente puntual con la siguientes características:

|Nombre| Tipo de fuente|Analitos|ALTURA [m]|DIÁMETRO CONDUCTO[m]   | x UTM21S   | y UTM21S|z|
|-|-|-|-|-|-|-|-|
|FUENTE1|Puntual|     NOx, MP    | 15|  5 | 361833.281|6139544.02|0


la keyword ``LOCATION`` define una fuente, su tipo, su id (nombre) y su ubicacion:
```
   LOCATION  <nombre>  <tipo>  <x> <y> <z>
```
los tipos de fuente más comunes son: ``POINT``, ``LINE`` y ``AERAPOLY``.

Para nuestro ejemplo vamos a completarla de la siguiente manera:

```
   LOCATION  FUENTE1  POINT  361833.281  6139544.02  0
```
> **Es importante destacar que las coordenadas de emisores (y también receptores) deben ser coordenadas planas cartesianas, ya que el aermod no puede hacer los cálculos con coordenadas de latitud y longitud.**


La keyword ``SRCPARAM`` define los parámetros de emision para cada fuente y sus argumentos dependen del tipo de fuente definida en ``LOCATION``, para una fuente puntual tipo  "POINT" sería:

```
   SRCPARAM <nombre> <Q> <H> <T> <U> <D>
```
donde, Q: caudal másico emitido [g/s], H: altura del conducto [m], T: temperatura de salida [ºK], U: velocidad de salida [m/s] y D: diámetro del conducto [m].

Los parámetros de emision para la ``FUENTE1`` son los siguientes:


ANALITO|CAUDAL EMISIÓN [m3/s]|TEMPERATURA[K]|VELOCIDAD[m/s]|CONCENTRACIÓN[mg/Nm3]|TASA[g/s]|
|-|-|-|-|-|-|
NOx|	819|	453	|27,13|	196|	96,7|

Entonces para el ejemplo quedaría así:

```
   SRCPARAM FUENTE1 96.7 15 453 27.13 5
```


#### Múltiples fuentes
Para considerar varias fuentes, siempre que las mismas emitan el mismo contaminante, las podemos agregar en la sección de emisión. Primero agregamos líneas con la ubicación luego de la keyword ``LOCATION`` y usando el mismo "ID" o nombre de fuente, se agregan líneas con sus parámetros de emisión siguiendo la keyword ``SRCPARAM``:  

```Text
SO STARTING
   ELEVUNIT  METERS
   LOCATION  FUENTE1  POINT  361833.28  6139544.02  0
   LOCATION  FUENTE2  POINT  361838.15  6139534.45  0
   LOCATION  FUENTE3  POINT  361843.11  6139514.42  0
   SRCPARAM  FUENTE1 96.7 15 453 27.13 5
   SRCPARAM  FUENTE2 12 8 423 16 2
   SRCPARAM  FUENTE3 114 25 483 34 6
   SRCGROUP  ALL 
SO FINISHED
```




### RECEPTORES (RE)

<!-- Esto no se si tiene sentido dejarlo, toda la del disscart -->
<!-- 
La forma más sencilla de definir un receptor es utilizando la keyword ``DISCCART``:

```Text
RE STARTING
   DISCCART 339250.72 6166414.50
   DISCCART 339300.72 6166414.50
   DISCCART 339400.72 6166414.50
(...continúa...)
RE FINISHED
```

``DISCCART`` toma como argumentos la posicion *x* e *y* (en metros) del receptor a considerar. 
También acepta como argumentos opcionales, la altura del terreno en esa ubicacion, y otros parámetros necesarios para contemplar la influencia de la topografía sobre la pluma. -->
<!-- 
Comúnmente nos encontramos en el caso de tener que definir muchos receptores, en forma de grillas regulares, o concéntricas, que usando ``DISCCART`` involucraría muchas líneas para especificar.  -->

Se deben definir *receptores* que son los puntos en los que el aermod va a calcular las concentraciones de contaminante dispersado. 
Existen keywords que nos permiten definir grillas:
+ ``GRIDCART``: define una grilla en coordenadas cartesianas.
<!-- + ``GRIDPOLR``: define una grilla de círculos concéntricos en coordenadas polares. -->



Para usar ``GRIDCART`` definimos los siguientes parámetros:

```Text
RE STARTING
   GRIDCART  CAR1 STA
                  XYINC ${xmin} ${nx} ${dx} ${ymin} ${ny} ${dy}
   GRIDCART  CAR1 END
RE FINISHED
```

Cada grilla se define con su nombre en su primer argumento ``CAR1`` y definiendo el inicio y fin con ``STA`` y ``END`` respectivamente. 

```
GRIDCART  CAR1 STA
      ....
	(especificaciones de la grilla cartesiana 1: CAR1)
      ....
GRIDCART  CAR1 END
```

``XYINC`` es una keyword que permite generar una grilla regular y toma como argumentos:
- coordenada X del vértice sur-oeste del dominio: ``xmin``
- el numero de receptores en la dimension X: ``nx``
- el espaciado de los receptores en la dimension X: ``dx`` (generalmente 50 metros)
- coordenada Y del vértice sur-oeste del dominio :``ymin``
- el numero de receptores en la dimension Y: ``ny``
- el espaciado de los receptores en la dimension Y: ``dy`` (generalmente 50 metros)

Visto esquemáticamente este sería un domino rectangular generado mediante ``GRIDCART`` especificando la *keyword* ``XYINC``:

```
(xini,yfin)                       (xfin,yfin)
    (+)-------------------------(+)         
     |...........................|          
     |...........................| ^        
     |...........................| |        
     |............(+)............| ny       
     |..........(xc,yc)..........| |        
     |...........................| v        
     |..........<--nx-->.........|          
    (+)-------------------------(+)         
(xini,yini)                       (xfin,yini)
```

En nuestro caso tenemos que definir una grilla con separación de 50 metros. En un dominio cuadrado de 5000 x 5000 metros. 
Para determinar las coordenadas iniciales, siendo el vértice sud-oeste del domino, restamos 2500 metros a las coordenadas centrales que en este caso son las mismas que las de la fuente.


- ``xmin``: ``xc``-2500 = 361833.281 - 2500 = 359333.281
- ``nx``: 100
- ``dx``: 50

- ``ymin``: ``yc``-2500 = 6139544.02 - 2500 = 6137044.02
- ``ny``: 100 
- ``dy``: 50


Por lo tanto vamos completar la sección de la siguiente forma:

```Text
RE STARTING
   GRIDCART  CAR1 STA
                  XYINC 359333.281 100 50.0 6137044.02 100 50.0
   GRIDCART  CAR1 END
RE FINISHED
```


En el caso de haber ejecutado previamente el [AERMAP](./aermap.html), esta sección se simplifica a:

```Text
RE STARTING
   INCLUDED  PRUEBA.ROU
RE FINISHED
```                    

donde ``PRUEBA.ROU`` es el archivo de salida del AERMAP.



### METEOROLOGÍA (ME)

En esta sección se indica la ubicación de los archivos meteorológicos de superficie y radiosondeos (``SURFFILE`` y ``PROFFILE``), con sus identificaciones (``SURFDATA`` y ``UAIRDATA``).

<!-- (con las keywords: ``SURFFILE`` y ``PROFFILE`` respectivamente), y luego algunos parámetros que no son de mayor relevancia: -->

```Text
ME STARTING  
   SURFFILE  PRUEBA.SFC
   PROFFILE  PRUEBA.PFL
   SURFDATA  87576 2021 SAEZ
   UAIRDATA  87576 2021 SAEZ
   PROFBASE  0.0  METERS
ME FINISHED  
```

La keyword ``PROFBASE`` indica cual es la altura de base para definir el perfil de temperatura potencial y es obligatorio.


### OPCIONES DE SALIDA (OU)
Esta sección incluye todas las opciones de escritura de los datos de salida.

```Text
OU STARTING  
   RECTABLE  ALLAVE  FIRST
   MAXTABLE  ALLAVE  15
   SUMMFILE  AERTEST_PRUEBA_NOX_MONTH.SUM
   PLOTFILE  MONTH  ALL  FIRST AERPLOT_PRUEBA_NOX_MONTH.OUT
OU FINISHED
```
+ ``RECTABLE`` sirve para definir la tabla de máximos valores por receptor, ``ALLAVE`` reporta todos los tiempos de promediado utilizados en la corrida y ``FIRST-THIRD`` define que se deben mostrar los valores máximos calculados en cada receptor.

+ ``MAXTABLE`` sirve para definir la tabla de máximos valores totales encontrados , ``ALLAVE`` reporta todos los tiempos de promediado utilizados en la corrida y se debe definir que cantidad de máximos se desea mostrar, en este caso 15.

+ ``SUMMFILE`` define el nombre del archivo de salida que posee además de información sobre la corrida y fechas procesadas, la tabla con las máximas concentraciones encontradas.

+ ``PLOTFILE`` sirven para definir el nombre del archivo de salida con la tabla de máximos valores encontrados por receptor (sirve para hacer los mapas de concentraciones máximas), requiere la definicion del periodo temporal y el grupo de emisores a considerar (``SRCGROUP`` definido en fuentes:``SO``), también da la posibilidad de  mostrar los máximos totales (FIRST) o descartarlos y usar los segundos (SECOND), terceros (THIRD), etc.



### Múltiples tiempos de promediado

Para considerar distintos tiempos de promediado en la misma corrida del modelo, debemos en primera instancia modificar las opciones de control (CO). En la línea de la keyword ``AVERTIME`` podemos agregar tiempos adicionales, en este caso 1 y 24 representando horas. 

```Text
CO STARTING
   TITLEONE  PRUEBA
   MODELOPT  CONC FLAT
   AVERTIME  MONTH 1 24 
   POLLUTID  NOX
   RUNORNOT  RUN
   EVENTFIL  OUTPUT.LOG
   ERRORFIL  ERRORS.LOG
   FLAGPOLE  1.5
CO FINISHED 
```
Para visualizar los resultados de los distintos tiempos de promediado, vamos a agregar archivos de salida específicos para cada tiempo en la sección de opciones. Agregamos una nueva línea por cada nuevo tiempo de promediado con la keyword ``PLOTFILE``. 

```Text
OU STARTING  
   RECTABLE  ALLAVE  FIRST
   MAXTABLE  ALLAVE  50
   SUMMFILE  AERTEST_PRUEBA_NOX_MONTH.SUM
   PLOTFILE  MONTH  ALL  FIRST AERPLOT_PRUEBA_NOX_MONTH.OUT
   PLOTFILE  1  ALL  FIRST AERPLOT_PRUEBA_NOX_1.OUT
   PLOTFILE  24  ALL  FIRST AERPLOT_PRUEBA_NOX_24.OUT
OU FINISHED
```


## Ejecucion

Para ejecutar el **AERMOD** nos aseguramos tener los siguientes archivos en el directorio de trabajo:
- Ejecutable: ``aermod.exe``
- Archivo de control ``aermod.inp``
- Archivos meteorológicos: ``PRUEBA.SFC``, ``PRUEBA.FSL``

Luego se ejecuta ``aermod.exe``.

Si todo sale bien, se van a crear los archivos especificados con las keywords ``SUMFILE`` y ``PLOTFILE`` de la sección **OUT**, en nuestro caso:

+ ``aermod.out`` contiene el registro de toda la información de la corrida, receptores, máximos y resultados para todos los receptores. Al ser el archivo de salida mas completo, suele ser requerido para ser auditado.

+ ``AERTEST_PRUEBA_NOX_MONTH.SUM``  muestra un resumen de la corrida con las tablas de máximas concentraciones encontradas para todos los receptores para el periodo modelado.

+ ``AERPLOT_PRUEBA_NOX_MONTH.OUT`` representa la máxima concentración encontrada para cada receptor en forma de tabla, permitiendo interpretar gráficamente el resultado mediante posprocesamiento.

+ ``ERRORS.LOG`` Guarda registro de errores y advertencias durante la corrida.
+ ``OUTPUT.LOG`` Guarda registro de la configuración de la corrida.

Verificamos rápidamente que fue una corrida exitosa si en el archivo ``AERTEST_PRUEBA_NOX_MONTH.SUM`` no presenta mensajes de error:

```
    ******** FATAL ERROR MESSAGES ******** 
               ***  NONE  ***         
```


