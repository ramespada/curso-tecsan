--- 
layout: lecture
title: TMB
descripcion: Planta de tratamiento mecánico-biológico.
date: 2024-09-03
ready: true
---

> Implementación de AERMOD para las planta de tratamiento mecánico-biológico.

## Datos:
- [Meteorología de superficie.](./data/875530-99999-2024.ish)
- [Modelo digital de elvación.](./data/ceamse.tif)
- [Grilla de receptores.      ](./tmb/ceamse.rec)
- [Emisiones.                 ](./tmb/gis/emis.csv)

## Archivos de control:
- aersurface: [aersurface.out](./data/aersurface.out)
- aermet: [stg1.inp  ](./tmb/stg1.inp), [stg2.inp](./tmb/stg2.inp), [stg3.inp](./tmb/stg3.inp).
- aermap: [aermap.inp](./tmb/aermap.inp)
- aermod: [aermod.inp](./tmb/aermod.inp)


## Pasos para ejecución:
Para ejecutar este proyecto necesitamos:
1. Descargar los ejecutables.
2. Definir dominio de estudio y grilla de receptores en sistema de coordenadas plano (proyectado).
3. Descargar un [modelo digital de elevación](https://www.ign.gob.ar/NuestrasActividades/Geodesia/ModeloDigitalElevaciones/Mapa) (DEM) que contenga el domino que queremos modelar.
4. Reproyectar DEM a sistema de coordenadas definido en el punto 2.
5. Construir un archivo de control para el aermap: [``aermap.inp``](archivos/aermod/aermap.inp)
6. Colocar todos los archivos mencionados en un directorio común.
7. Ejecutar el aermap haciendo doble click sobre el ejecutable o si están en la shell: `` ./aermap.exe < aermap.inp``.


