--- 
layout: lecture
title: Relleno
descripcion: Unidades de disposición de RSUs.
date: 2024-09-03
ready: true
---

> Ejecución de preprocesador de terreno del **AERMOD** (**AERMAP**)

## Datos:
- [Meteorología de superficie.](./relleno/875530-99999-2024)
- [Modelo digital de elvación.](./relleno/ceamse.tif)
- [Grilla de receptores.      ](./relleno/ceamse.rec)
- [Emisiones.                 ](./relleno/emis.csv)

## Archivos de control:

- aermet: [stg1.inp  ](./relleno/stg1.inp), [stg2.inp](./relleno/stg2.inp), [stg3.inp](./relleno/stg3.inp).
- aermap: [aermap.inp](./relleno/aermap.inp)
- aermod: [aermod.inp](./relleno/aermod.inp)


## Ejecutables:

- [aermet.exe](https://gaftp.epa.gov/Air/aqmg/SCRAM/models/related/aermap/aermap_exe.zip).
- [aermap.exe](https://gaftp.epa.gov/Air/aqmg/SCRAM/models/related/aermap/aermap_exe.zip).
- [aermod.exe](https://gaftp.epa.gov/Air/aqmg/SCRAM/models/related/aermap/aermap_exe.zip).


## Pasos para ejecución:
Para ejecutar este proyecto necesitamos:
1. Descargar los ejecutables.
2. Definir dominio de estudio y grilla de receptores en sistema de coordenadas plano (proyectado).
3. Descargar un [modelo digital de elevación](https://www.ign.gob.ar/NuestrasActividades/Geodesia/ModeloDigitalElevaciones/Mapa) (DEM) que contenga el domino que queremos modelar.
4. Reproyectar DEM a sistema de coordenadas definido en el punto 2.
5. Construir un archivo de control para el aermap: [``aermap.inp``](archivos/aermod/aermap.inp)
6. Colocar todos los archivos mencionados en un directorio común.
7. Ejecutar el aermap haciendo doble click sobre el ejecutable o si están en la shell: `` ./aermap.exe < aermap.inp``.


