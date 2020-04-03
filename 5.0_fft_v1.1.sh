#!/bin/sh

echo '*****************FFT (Transformada rapida de Fourier)*****************'
echo '************rdseed 5.3.1 & SAC 101.6a utilizados**********************'
echo '************Creado por: Nestor Luna Diaz, 5 de octubre de 2016********'
echo '**************Ultima modificacion, 21 de marzo de 2019****************'
echo '**********************************************************************'
echo ''

CAB_SAC='HIPO_IRIS.txt'
export SAC_DISPLAY_COPYRIGHT=0

Nf=`ls *.deconv | wc -l`
i=1

while read -r file KZDATE GCARC DIST EVLA EVLO EVDP MAG DELTA KNETWK KSTNM KCMPNM; do
    RESULTADO=$( echo "$DELTA >= 0.049" | bc )
    if [ $RESULTADO -eq 0 ];
    then
        #echo "$DELTA Es menor que 0.049"
        N=8192
        echo "  -> ($i/$Nf). ${file}.deconv [D = $GCARC°, Dt = $DELTA s, N = $N muestras a usar]"
    else
        #echo "$DELTA Es mayor o igual que 0.049"
        N=4096
        echo "  -> ($i/$Nf). ${file}.deconv [D = $GCARC°, Dt = $DELTA s, N = $N muestras a usar]"
    fi
    i=$((i + 1))
   sac <<EOF
#  **********************************************************************
#  ********* [conf.] Desactivar "Quick and Dirty Plot" mode: ************
   qdp off
#  ********* [conf.] Parámetros de ventana de tiempo: *******************
#  ********* Numero de datos Desde A [1er arribo] ***********************
   cut A N $N
#  **********************************************************************
#  ***** Leer archivo SAC y convirtiendo a metros: **********************
   r ${file}.deconv
   mul 1.0e-9
#  **********************************************************************
#  ********* Correcciones generales de señales 1: ***********************
   *rmean
   *rtrend
   taper
#  **********************************************************************
#  ***** Transformada rápida de Fourier discreta: ***********************
   fft
   keepam
#  **********************************************************************
#  ********* Escribe archivo SAC FFT: ***********************************
   w ${file}.fft
#  **********************************************************************
   q

EOF
echo ""

done < $CAB_SAC

#echo ''
echo '*******************************Resumen********************************'
echo ''
echo '->Archivos ".fft" (formato SAC binario FFT) creados:'
ls *.fft | wc -l
ls *.fft

echo ''
echo '**************************Fin del programa****************************'
