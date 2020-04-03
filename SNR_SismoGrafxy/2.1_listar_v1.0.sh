#!/bin/sh

echo '****************Lista archivos para trabajar con matlab***************'
echo '***********Creado por: Nestor Luna Diaz, 06 de febrero de 2019********'
echo '**********************************************************************'
echo ''

ls *.SAC.xy > [LISTA_xy].txt
mv HIPO_IRIS.txt [HIPO_IRIS].txt

echo 'Se crearon los archivos:'
echo '[LISTA_xy].txt & [HIPO_IRIS].txt'

echo ''
echo '**************************Fin del programa****************************'
