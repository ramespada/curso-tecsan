--- 
layout: lecture
title: Piletas
descripcion: Piletas de recolección tratamiento de lixiviados.
date: 2024-09-03
ready: true
---

> Ejecución de preprocesador de terreno del **AERMOD** (**AERMAP**)

## Datos:
- [Meteorología de superficie.](./piletas/875530-99999-2024)
- [Modelo digital de elvación.](./piletas/ceamse.tif)
- [Grilla de receptores.      ](./piletas/ceamse.rec)
- [Emisiones.                 ](./piletas/emis.csv)

## Archivos de control:

- aermet: [stg1.inp  ](./piletas/stg1.inp), [stg2.inp](./piletas/stg2.inp), [stg3.inp](./piletas/stg3.inp).
- aermap: [aermap.inp](./piletas/aermap.inp)
- aermod: [aermod.inp](./piletas/aermod.inp)


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


