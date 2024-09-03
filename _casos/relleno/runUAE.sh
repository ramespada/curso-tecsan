#!/bin/sh

EXE=AERMETUE.exe

ISH=SIDERAR.ISH
AERSURFACE_FILE=AERSURFACE.OUT

touch DUMMY.FSL

# del namelist -----------------
PROYECTO=SIDERAR
ini_date="2018-01-01"   #YYYY-MM-DD_HH:MM:SS (%Y-%m-%d_%H:%M:%s)
end_date="2022-12-30"   #YYYY-MM-DD_HH:MM:SS (%Y-%m-%d_%H:%M:%s)
tz=3                    #time-zone

id_up=87576     #Ezeiza AERO
id_sfc=87480    #Rosario AERO

#Fechas:
read byr bmon bday bhr bmin bsec <<< ${ini_date//[-:\/_ ]/ }
read eyr emon eday ehr emin esec <<< ${end_date//[-:\/_ ]/ }
#-----------------------------

cat << EOF > aermet.inp
** Stage 1: Lectura y procesamiento de datos de entrada.
JOB
MESSAGES STG1.MSG
REPORT   STG1.RPT

SURFACE
DATA       $ISH ISHD
EXTRACT    EXTRACT_SFC.DSK
QAOUT      QA_SFC.OUT

XDATES     $byr/$bmon/$bday TO $eyr/$emon/$eday
LOCATION   $id_sfc 00.000S  000.000W  $tz  +0025

UPPERAIR
DATA       DUMMY.FSL FSL
EXTRACT    EXTRACT_UP.DSK
QAOUT      QA_UA.OUT

XDATES     $byr/$bmon/$bday TO $eyr/$emon/$eday
LOCATION   $id_up  00.000S  000.000W  $tz  +0025
EOF

./$EXE
cp aermet.inp STG1.INP

cat << EOF > aermet.inp

********************************************************
** AERMET - STAGE 2 Input Produced by:
** AERMET View Ver. 9.4.0
** Lakes Environmental Software Inc.
** Date: 2021/01/28
** File: C:\Users\ry08629\OneDrive - YPF\Escritorio\Modelado 2020\EneFeb21\meteo\2014\AEP-14.IN2
********************************************************
JOB
   REPORT      STG2.RPT
   MESSAGES    STG2.MSG
UPPERAIR
   QAOUT      QA_UA.OUT
SURFACE
   QAOUT      QA_SFC.OUT
MERGE
   OUTPUT      $PROYECTO.MRG
   XDATES     $byr/$bmon/$bday TO $eyr/$emon/$eday
EOF
./$EXE

cp aermet.inp STG2.INP

cat << EOF > aermet.inp

****************************************************
** AERMET - STAGE 3 Input produced by:
** AERMET View Ver. 9.4.0
** Lakes Enviornmental Software Inc.
** Date: 2021/01/28
** File: /c/Users/User/Desktop/SIDERAR/AERMETUAE
****************************************************

** Stage 3 - Estimación de parametros de la capa límite y creación de .SFC y .PFL
JOB
MESSAGES STG3.MSG
REPORT   STG3.RPT
METPREP
DATA        $PROYECTO.MRG
MODEL       AERMOD
LOCATION    $id_sfc 00.000S 000.000W  $tz
XDATES     $byr/$bmon/$bday TO $eyr/$emon/$eday
OUTPUT      $PROYECTO.SFC
PROFILE     $PROYECTO.PFL
** Métodos para precesamiento de datos:
METHOD   WIND_DIR  RANDOM
METHOD   REFLEVEL  SUBNWS
NWS_HGT  WIND      10.0
METHOD   UASELECT SUNRISE
UAWINDOW -12 12
AERSURF $AERSURFACE_FILE
EOF
./$EXE
