#!/bin/csh -f

echo '******************Convertir formato SAC a formato XY******************'
echo '************Creado por: Nestor Luna Diaz, 19 de enero de 2019*********'
echo '**********************************************************************'
echo ''

set Carpetra_SOURCE = 'SOURCE'
set CAB_SAC = 'HIPO_IRIS.txt'

foreach file ( *.fft )
sac2xy $file ${file}.xy
end

echo ''
echo '*******************************Resumen********************************'
echo ''
echo '->Archivos ".xy" (formato ASCII de FFT) creados:'
ls *.fft.xy | wc -l
ls *.fft.xy

mv *.xy $Carpetra_SOURCE
cp $CAB_SAC $Carpetra_SOURCE

echo ''
echo '**************************Fin del programa****************************'
