--- 
layout: lecture
title: Aermap
descripcion: Preprocesador de terreno.
date: 2024-09-03
clase: 03
ready: true
---

> Tutorial para ejecución de preprocesador de terreno del **AERMOD** (**AERMAP**)

El **AERMAP** es un preprocesador del **AERMOD** que permite generar una grilla de receptores sobre un terreno complejo y calcular parámetros que permitan al **AERMOD** modelar la interacción de la pluma con el terreno.

## Resumen:

Para ejecutar el **AERMAP** necesitamos:
1. Descargar el ejecutable [aermap.exe](https://gaftp.epa.gov/Air/aqmg/SCRAM/models/related/aermap/aermap_exe.zip).
2. Definir dominio de estudio y grilla de receptores en sistema de coordenadas plano (proyectado).
3. Descargar un [modelo digital de elevación](https://www.ign.gob.ar/NuestrasActividades/Geodesia/ModeloDigitalElevaciones/Mapa) (DEM) que contenga el domino que queremos modelar.
4. Reproyectar DEM a sistema de coordenadas definido en el punto 2.
5. Construir un archivo de control para el aermap: [``aermap.inp``](archivos/aermod/aermap.inp)
6. Colocar todos los archivos mencionados en un directorio común.
7. Ejecutar el aermap haciendo doble click sobre el ejecutable o si están en la shell: `` ./aermap.exe < aermap.inp``.

---

## Descarga de ejecutable:

El AERMAP se encuentra en la página web de US-EPA: [aermap.exe](https://gaftp.epa.gov/Air/aqmg/SCRAM/models/related/aermap/aermap_exe.zip).

Lo descomprimimos, entramos a la carpeta ``aermap_exe`` y deberiamos encontrar adentro el ejecutable ``aermap.exe``.

<!-- > :information_source: También podemos encontar el código fuente en: [aermap_source.zip](https://gaftp.epa.gov/Air/aqmg/SCRAM/models/related/aermap/aermap_source.zip). -->



## Definición de dominio y grilla de receptores

Vamos a definir el dominio y la grilla de receptores de misma forma que lo hicimos en el tutorial de [AERMOD](./aermod.html#receptores-re):


| ``xc  ``  |  361833.2 | Punto central X                  |
| ``yc  ``  | 6139544.0 | Punto central Y                  | 
| ``xmin``  |  359333.2 | Vértice sur-oeste X              |
| ``ymin``  | 6137044.0 | Vértice sur-oeste Y              |
| ``nx  ``  |  100      | Numero de receptores-X           | 
| ``ny  ``  |  100      | Numero de receptores-Y           |
| ``dx  ``  |  50.0     | Espaciado entre receptores X [m] |
| ``dy  ``  |  50.0     | Espaciado entre receptores Y [m] |

Esquema del dominio:

```
(xmin,ymax)                       (xmax,ymax)
    (+)-------------------------(+)         
     |...........................|          
     |...........................| ^        
     |...........................| |        
     |............(+)............| ny       
     |..........(xc,yc)..........| |        
     |...........................| v        
     |..........<--nx-->.........|          
    (+)-------------------------(+)         
(xmin,ymin)                       (xmax,ymin)
```


## Descarga de modelo digital de elevación:

Existen varios modelos digitales de elevación (DEM) con cobertura global, por ejemplo: *ASTER* o *SRTM*.
Una versión ajustada a nuestro país es el modelo digital de elevación adaptado por el Instituto Geográfico Nacional (IGN), que se puede descargar entrando [aquí](https://www.ign.gob.ar/NuestrasActividades/Geodesia/ModeloDigitalElevaciones/Mapa).

Vamos a descargar el producto *MDE 30m*, la grilla número: *3560-18*, ya que nuestro proyecto va a estar centrado en Ezeiza.

![](/tut/imgs/IGN_MAPA.png)

<!-- 
### Combinar DEMs:
En caso de necesitar combinar varios DEMs para cubrir el dominio a modelar se puede utilizar desde la consola, de la herramienta [GDAL](https://gdal.org/), el comando:

```shell
gdal_merge.py 3557-13.img 3560-18.img -o merge.tif
``` -->

### Reproyección de DEM:
El DEM que descargaremos va a estar en sistema de coordenadas geográficas (lat,lon), pero vamos a necesitar convertirlo a un sistema proyectado para trabajar. Generalmente para Argentina usamos alguna faja UTM (Universal Transverse Mercator). Por lo tanto necesitamos transformar el archivo a el nuevo sistema de coordenadas:

Para hacer la reproyección, necesitamos una herramienta extrena, puede ser un programa _GIS_ como *Qgis* o *ArcGis*, o herramientas específicas como gdal (que se incluyen al instalar Qgis). Si no logran hacer la reporyección, en [este link](/tut/archivos/aremap/3560-18-utm21s.tif) pueden bajar la capa proyectada en UTM21S. 

Una forma de hacerlo desde la terminal o shell es utilizando el comando ``gdalwarp`` de la herramienta ``gdal`` (debe estar previamente instalado):
<!-- 

no vi una manera directa de hacerlo andar, si vas a la web te baja el src para que vos lo complies... (creo), sino para bajar binarios en Windows, lo hace vía conda... así que falta tenerlo para poder bajarlo directo. 

-->

```shell
gdalwarp -tr ${dx} ${dx} -r cubicspline -t_srs epsg:${epsg_local} -te ${xmin2} ${ymin2} ${xmax2} ${ymax2} ${IGN-MDE} PRUEBA.tif
```

donde ``${dx}`` y ``${dy}`` es al resolución espacial del nuevo DEM (50m). ``${epsg_local}`` es el código de la proyección que necesitamos, en nuestro caso va a ser UTM sur, faja 21, y por lo tanto: ``${epsg_local}`` es 32721.  ``${xmin2} ${ymin2} ${xmax2} ${ymax2}`` son las coordenadas de los vertices del dem a recortar (en coordenadas proyectadas), vamos a usar las mismas que para el dominio pero dejando 100m de borde hacia cada lado, ya que el AERMAP lo va a necesitar para hacer calculos en el borde del dominio. Por ultimo ``${IGN_MDE}`` es el nombre del archivo descargado de la web del IGN. 

Para nuestro ejemplo:

```shell
gdalwarp -tr 50 50 -r cubicspline -t_srs epsg:32721 -te 359233.2 6136944.0 364433.281 6142144.0 merge.tif PRUEBA.tif
```


## Archivo de control ``aermap.inp``

Para ejecutar el *aermap* es necesario crear el archivo de control ``aermap.exe``, un ejemplo sería:

```Text
CO STARTING
   TITLEONE  GRILLA DE RECEPTORES: PRUEBA
   TERRHGTS  EXTRACT
   DATATYPE  NED
   DATAFILE  PRUEBA.tif
   DOMAINXY  359333.2 6137044.0 -21 364333.281 6142044.0 -21
   ANCHORXY  0 0 0 0 -21 3
   FLAGPOLE  1.5
   RUNORNOT  RUN
CO FINISHED
RE STARTING
   GRIDCART  CAR1 STA
                  XYINC 359333.281 100 50.0 6137044.02 100 50.0
   GRIDCART  CAR1 END
RE FINISHED
OU STARTING
   RECEPTOR  PRUEBA.ROU
** SOURCLOC  PRUEBA.SOU
OU FINISHED
```

Este archivo de texto cuenta con las siguiente secciones:

+ CO: Sección de **CO**ntrol de corrida.
+ RE: Sección de **RE**ceptores.
+ OU: Sección de configuración de salidas (**OU**tputs).


#### **CO**

En la sección de **CO** hay que definir varios parámetros:

```Text
CO STARTING
   TITLEONE  GRILLA DE RECEPTORES: PRUEBA
   TERRHGTS  EXTRACT
   DATATYPE  NED
   DATAFILE  PRUEBA.tif
   DOMAINXY  359333.281 6137044.02 -21 364333.281 6142044.02 -21
   ANCHORXY  0 0 0 0 -21 3
   FLAGPOLE  1.5
   RUNORNOT  RUN
CO FINISHED
```

los más relevantes son:
+ ``DATATYPE``: el tipo de archivo de entrada, por razones históricas debemos elegir ``NED``.
+ ``DATAFILE``: indica el nombre del DEM a procesar, en nuestro caso ``PRUEBA.tif``.
+ ``DOMAINXY``: indica el dominio a modelar y la faja UTM a usar (xmin ymin utmzn xmax ymax utmzn).
+ ``ANCHORXY``: Permite relacionar las coordenadas de la grilla de receptores definida por el usuario con el sistema de coordenadas de de nuestra grilla con la UTM elegida. Como las coordenadas de la ubicación de receptores ya fueron referenciadas al sistema utm, se deben utilizar las mismas. (xusr yusr xutm yutm utmzn datumid), donde xusr=xutm y yusr=yutm, utmzn es la faja utilizada y datumid=3 es el sistema geodesico *WGS84*.
+ ``FLAGPOLE``: define la altura sobre el nivel del piso, en metros, donde ubicará a los receptores (default: 1.5)


#### **RE**
En la sección de receptores **RE** hay que definir una grilla de receptores, lo podemos hacer con las keywords: 
+ ``GRIDCART``: define una grilla regular en coordenadas cartesianas.
+ ``GRIDPOLR``: define una grilla de circulos concentricos en coordenadas polares.

De la misma forma que lo hicimos en el tutorial de [AERMOD](./aermod.html) con ``GRIDCART `` podriamos definir la grilla como:

```Text
RE STARTING
   GRIDCART  CAR1 STA
                  XYINC 359333.281 100 50.0 6137044.02 100 50.0
   GRIDCART  CAR1 END
RE FINISHED
```



<!--
En general es recomendable utilizar una grilla establecida por el usuario, para excluir receptores del polígono del predio, definir ubicaciones de receptores críticos o variar la densidad de receptores en función a la distancia a la fuente u otro criterio.
Para utilizar una grilla definida por el usuario, solo necesitamos un archivo de texto con las coordendas x e y, e incluirlo en nuestro archivo de control de la siguiente manera:

```Text
RE STARTING
RE INCLUDED PRUEBA.REC
RE FINISHED
```

Donde ``PRUEBA.REC`` es un archivo de texto, donde en vez de dejar la extensión como _.txt_ la vamos a cambiar a .REC.
La información del archivo debe estar definida de la sigiente manera:

```Text

RE DISCCART 339250.72 6166414.50
RE DISCCART 339300.72 6166414.50
RE DISCCART 339350.72 6166414.50
RE DISCCART 339400.72 6166414.50
(...continúa...)

```
-->
<!--
Para realizar esto proponemos utilizar herramientas de SIG (por ejemplo: *QGIS* o *ArcGIS*):

1. Crear un nuevo proyecto de QGIS y cargar las capas de predio y fuentes.
2. Debemos definir el dominio de modelado, no puede exceder un radio de 50km (en ese caso debemos usar otro sistema de modelado, como CALPUFF) este siempre debe asegurar que incorpora las concentraciones máximas, es posible que luego de una corrida preliminar haya que redefinir la grilla. Como una dimensión inicial vamos a utilizar 3km de radio.
Crear capa de DOMINIO  (MOSTRAR PASOS PASOS).
3. Vamos a ubicar receptores separados por 50m. (MOSTRAR PASOS)
4. La calidad de aire dentro de los límites del predio no se debe considerar en el análisis siempre que haya una barrera fìsica (cerco, pared, etc.) ya que no se la considera "calidad de aire ambiente". A tal fin vamos a eliminar los receptores que esten contenidos en el polígono del predio (mostrar los pasos).
5. Vamos a facilitar la creación del formato de archivo que requiere AERMAP, agregando un campo inicial de texto que contenga "RE DISSCART" 
6. El archivo será exportado como CSV donde coordenadas XY (mostrar y ver si no hay que poner antes las $x $y)
7. Cambiamos la extensión del archivo.

Al abrir el archivo con el block de notas deberíamos ver tantas filas como receptores con el formato (RE DISSCART X Y)
-->

#### **OU**

Para la sección **OU** solo es necesario indicar el nombre del archivo de salida usando la keyword ``RECEPTOR``:

```Text
OU STARTING
   RECEPTOR  PRUEBA.ROU
OU FINISHED
```
en este caso el archivo de receptores lo nombramos ``PRUEBA.ROU`` (la extensión ``.ROU`` es una convención).

## Ejecución:

Para ejecutar el aermap, ponemos el ejecutable ``aermap.exe``, el DEM ``PRUEBA.tif`` y el archivo de control en un mismo directorio, y ejecutamos el programa haciendo doble click, o si estamos en una terminal:

```shell
./aermap.exe < aermap.inp
```

Se va a crear un archivo ``PRUEBA.ROU`` donde está definida la grilla de receptores y que será necesario para ejecutar el **AERMOD**.

