#!/bin/csh -f

echo '********Convertir formato SAC a formato XY para calcular SNR**********'
echo '**********Extraer parametros hipocentrales del cabecero SAC***********'
echo '************Creado por: Nestor Luna Diaz, 19 de enero de 2019*********'
echo '**********************************************************************'
echo ''

set CAB_SAC = 'HIPO_IRIS.txt'
set SNR_CARPETA = 'SNR_SismoGrafxy'
rm $CAB_SAC

foreach file ( *.SAC )
sac2xy $file ${file}.xy
saclst KZDATE GCARC AZ EVLA EVLO EVDP MAG DELTA KNETWK KSTNM KCMPNM f $file >> $CAB_SAC
end

echo ''
echo '*******************************Resumen********************************'
echo ''
echo '->Archivos ".xy" (formato ASCII de FFT) creados:'
ls *.SAC.xy | wc -l
ls *.SAC.xy

echo ''
echo "->Archivo '$CAB_SAC' (ASCII de parametros hipocentrales) contenido:"
echo '   { [Archivo SAC] [Fecha] [Dist. epi. (grados)] [Azim. (grados)] [Lat. evento]...'
echo '  ...[Lon. evento] [Prof. evento (km)] [Mag. evento] [Dt (s)] }'

mv *.xy $SNR_CARPETA
cp $CAB_SAC $SNR_CARPETA

echo ''
echo '**************************Fin del programa****************************'
