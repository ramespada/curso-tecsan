--- 
layout: lecture
title: CT-Buenayre
descripcion: Central térmica BuenAyre.
date: 2024-09-03
ready: true
---

> Implementación de AERMOD para la central de biogás.

## Datos:

- [Meteorología de superficie.](./data/875530-99999-2024.ish)
- [Modelo digital de elvación.](./data/ceamse.tif)
- [Grilla de receptores.      ](./ctbay/ctbay.rec)
- [Emisiones.                 ](./ctbay/gis/emis.csv)
- [Edificios.                 ](./ctbay/gis/emis.csv)

## Archivos de control:
- aersurface: [aersurface.out](./data/aersurface.out)
- aermet: [stg1.inp  ](./ctbay/stg1.inp), [stg2.inp](./ctbay/stg2.inp), [stg3.inp](./ctbay/stg3.inp).
- aermap: [aermap.inp](./ctbay/aermap.inp)
- bpiprm: [bpip.inp](./ctbay/bpip.inp)
- aermod: [aermod.inp](./ctbay/aermod.inp)


## Pasos para ejecución:

Para ejecutar este proyecto necesitamos:
1. Descargar los ejecutables.
2. Definir dominio de estudio y grilla de receptores en sistema de coordenadas plano (proyectado).
3. Descargar un [modelo digital de elevación](https://www.ign.gob.ar/NuestrasActividades/Geodesia/ModeloDigitalElevaciones/Mapa) (DEM) que contenga el domino que queremos modelar.
4. Reproyectar DEM a sistema de coordenadas definido en el punto 2.
5. Construir un archivo de control para el aermap: [``aermap.inp``](archivos/aermod/aermap.inp)
6. Colocar todos los archivos mencionados en un directorio común.
7. Ejecutar el aermap haciendo doble click sobre el ejecutable o si están en la shell: `` ./aermap.exe < aermap.inp``.


