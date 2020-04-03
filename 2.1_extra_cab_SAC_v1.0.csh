#!/bin/csh -f

echo '**********Extraer parametros hipocentrales del cabecero SAC***********'
echo '************Creado por: Nestor Luna Diaz, 19 de enero de 2019*********'
echo '**********************************************************************'
echo ''

set CAB_SAC = 'HIPO_IRIS.txt'
rm $CAB_SAC

foreach file ( *.SAC )
saclst KZDATE GCARC DIST EVLA EVLO EVDP MAG DELTA KNETWK KSTNM KCMPNM f $file >> $CAB_SAC
end

echo ''
echo '*******************************Resumen********************************'
echo ''
echo "->Archivo '$CAB_SAC' (ASCII de parametros hipocentrales) contenido:"
echo '   { [Archivo SAC] [Fecha] [Dist. epi. (grados)] [Dist. epi. (km)] [Lat. evento]...'
echo '  ...[Lon. evento] [Prof. evento (km)] [Mag. evento] [Dt (s)] }'

echo ''
echo '**************************Fin del programa****************************'
