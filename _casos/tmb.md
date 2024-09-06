--- 
layout: lecture
title: TMB
description: Planta de tratamiento mecánico-biológico.
date: 2024-09-03
ready: true
---

> Implementación de AERMOD para las planta de tratamiento mecánico-biológico.

## Datos

Archivos especificos de este proyecto:
- [Meteorología de superficie.](./data/875530-99999-2024.ish)
- [Modelo digital de elevación.](./data/CEAMSE.tif)
- [Grilla de receptores.      ](./tmb/tmb.rec)
- [Emisiones.                 ](./tmb/gis/emis.csv)
- [aersurface.out](./data/aersurface.out)

## Archivos de control

Archivos necesarios para configurar la ejecución de los programas:
- aermet: [stg1.inp  ](./tmb/stg1.inp), [stg2.inp](./tmb/stg2.inp), [stg3.inp](./tmb/stg3.inp).
- aermap: [aermap.inp](./tmb/aermap.inp)
- aermod: [aermod.inp](./tmb/aermod.inp)


## Pasos para ejecución

Para ejecutar este proyecto necesitamos:
1. Descargar ejecutables.
2. Definir dominio de estudio, límites del predio y grilla de receptores en sistema de coordenadas plano (proyectado).
3. Descargar archivos meteorológicos de superficie del [Integrated Surface Database (ISD)](https://www.ncei.noaa.gov/pub/data/noaa/). Y radiosondeos de de [NOAA/ESRL Radiosonde Database](https://ruc.noaa.gov/raobs). Buscar archivos por `id` de la estación y año.
4. Descargar [modelo digital de elevación](https://www.ign.gob.ar/NuestrasActividades/Geodesia/ModeloDigitalElevaciones/Mapa) (DEM) que contenga el domino que queremos modelar. Reproyectar DEM a sistema de coordenadas definido en el punto 2.
5. Descargar ó construir el archivo `aersurface.out` en base a la cobertura de suelo en las cercanías de la estación de superficie.
6. Descargar y completar los **archivos de control** (`stg1.inp`, `stg2.inp`, `stg3.inp`,`aermap.inp`, `bpip.inp`, `aermod.inp`).
7. Colocar todos los archivos mencionados en un directorio común.
8. Ejecutar programas haciendo doble click sobre el ejecutable o si están en la shell, por ejemplo: ``./aermod.exe < aermod.inp``. El orden recomendado de ejecución es: 1) aersurface 2) aermet, 3) aermap, 4) bpip, 5) aermod.
9. Post-procesar salidas para crear mapas, gráficos y tablas.
