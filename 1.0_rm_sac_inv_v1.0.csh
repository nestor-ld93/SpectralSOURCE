#!/bin/csh -f
# Script para cambiar de formato SEED a SAC
# Nestor Luna - 20 Jan 2019

echo '**************Script para eliminar archivos SAC no usados*************'
echo '************Creado por: Nestor Luna Diaz, 20 de enero de 2019*********'
echo '**************Ultima modificacion, 11 de julio de 2020****************'
echo '**********************************************************************'
echo ''

# Ejecutable de rdseed. Modificarlo de ser necesario.
#set rdseed='/opt/rdseed/rdseed.rh6.linux_64'

#set archivo_seed = '2007-08-15_mww8.0_Pisco.seed'

#$rdseed -f $1 -R -d -o 1
#echo '->Archivos a eliminar (registros de aceleración y redundantes):'
rm *.01.BH*.SAC
rm *.02.BH*.SAC
rm *.03.BH*.SAC
rm *.04.BH*.SAC
rm *.05.BH*.SAC
rm *.10.BH*.SAC
rm *.20.BH*.SAC
rm *.30.BH*.SAC
rm *.40.BH*.SAC
rm *.50.BH*.SAC
rm *.60.BH*.SAC
rm *.70.BH*.SAC
rm *.80.BH*.SAC
rm *.XX.BH*.SAC
rm SACPZ*.01.BH*
rm SACPZ*.02.BH*
rm SACPZ*.03.BH*
rm SACPZ*.04.BH*
rm SACPZ*.05.BH*
rm SACPZ*.10.BH*
rm SACPZ*.20.BH*
rm SACPZ*.30.BH*
rm SACPZ*.40.BH*
rm SACPZ*.50.BH*
rm SACPZ*.60.BH*
rm SACPZ*.70.BH*
rm SACPZ*.80.BH*
rm SACPZ*.XX.BH*

#$rdseed -f pisco2007.seed -p -d -o 1
#rm *.10.BH*.SAC
#rm SAC_PZs*_10_*99999

echo ''
echo '*******************************Resumen********************************'
echo ''
echo '->Archivos ".SAC" (formato SAC binario) a utilizar:'
ls *.SAC | wc -l
ls *.SAC
echo ''
echo '->Archivos "SACPZ*.BH*" (Polos y zeros) a utilizar:'
ls SACPZ*.BH* | wc -l
ls SACPZ*.BH*

echo ''
echo '**************************Fin del programa****************************'
