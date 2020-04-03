#!/bin/csh -f

echo '**************Ordenar graficas png generadas en Matlab****************'
echo '************Creado por: Nestor Luna Diaz, 5 de octubre de 2016********'
echo '**********************************************************************'
echo ''

set CARPETA_GRAF = 'Graficas_xy_01'

echo '->Archivos ".png" a ordenados:'
ls *.png | wc -l
ls *.png

echo ''
echo '->Archivos ".eps" a ordenados:'
ls *.eps | wc -l
ls *.eps

mkdir $CARPETA_GRAF
mv *.png $CARPETA_GRAF
mv *.eps $CARPETA_GRAF

echo ''
echo '**************************Fin del programa****************************'
