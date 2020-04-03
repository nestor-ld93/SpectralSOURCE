#!/bin/csh -f
# Script para cambiar de formato SEED a SAC
# Nestor Luna - 20 Jan 2019

echo '**************Script para cambiar de formato SEED a SAC***************'
echo '************rdseed 5.3.1 & SAC 101.6a utilizados**********************'
echo '************Creado por: Nestor Luna Diaz, 20 de enero de 2019*********'
echo '**************Ultima modificacion, 20 de enero de 2019****************'
echo '**********************************************************************'
echo ''

# Ejecutable de rdseed. Modificarlo de ser necesario.
set rdseed='/opt/rdseed/rdseed.rh6.linux_64'

#set archivo_seed = '2007-08-15_mww8.0_Pisco.seed'

$rdseed -f $1 -R -d -o 1
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
rm RESP*.01.BH*
rm RESP*.02.BH*
rm RESP*.03.BH*
rm RESP*.04.BH*
rm RESP*.05.BH*
rm RESP*.10.BH*
rm RESP*.20.BH*
rm RESP*.30.BH*
rm RESP*.40.BH*
rm RESP*.50.BH*
rm RESP*.60.BH*
rm RESP*.70.BH*
rm RESP*.80.BH*

#$rdseed -f pisco2007.seed -p -d -o 1
#rm *.10.BH*.SAC
#rm SAC_PZs*_10_*99999

echo ''
echo '*******************************Resumen********************************'
echo ''
echo '->Archivos ".SAC" (formato SAC binario) creados:'
ls *.SAC | wc -l
ls *.SAC
echo ''
echo '->Archivos "RESP*.BH*" (Respuesta instrumental) creados:'
ls RESP*.BH* | wc -l
ls RESP*.BH*

echo ''
echo '**************************Fin del programa****************************'
