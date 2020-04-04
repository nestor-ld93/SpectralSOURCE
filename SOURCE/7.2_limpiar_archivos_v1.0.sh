#!/bin/sh

echo '*******************Limpiar archivos xy utilizados*********************'
echo '************Creado por: Nestor Luna Diaz, 5 de octubre de 2016********'
echo '**********************************************************************'
echo ''

rm SOURCE/[SALIDA_ESTACIONES].txt SOURCE/[SALIDA_FINAL].txt SOURCE/[LISTA_xy].txt
rm -r SOURCE/Graficas_FFT_02
mv SOURCE/[HIPO_IRIS].txt SOURCE/HIPO_IRIS.txt

echo ''
echo '**************************Fin del programa****************************'
