#!/bin/csh -f

echo '************Deconvolucion - Remover respuesta instrumental************'
echo '************rdseed 5.3.1 & SAC 101.6a utilizados**********************'
echo '************Creado por: Nestor Luna Diaz, 5 de octubre de 2016********'
echo '***************Ultima modificacion, 01 de febrero de 2019*************'
echo '**********************************************************************'
echo ''
echo "SELECCION: f1 = $1, f2 = $2, Np = $3"
echo ''

set N = `ls *.SAC | wc -l`
set i = 1

setenv SAC_DISPLAY_COPYRIGHT 0
foreach file ( *.SAC )
echo "  -> ($i/$N). Archivo SAC: $file"
@ i++
   sac <<EOF
#  **********************************************************************
#  ********* [conf.] Desactivar "Quick and Dirty Plot" mode: ************
   qdp off
#  **********************************************************************
#  ***** [conf.] Frecuencias de corte fc para el filtro Pasa-Banda: *****
#   *SETBB f1 0.002
#   *SETBB f2 0.1
#   *SETBB np 5
#  **********************************************************************
#  ***** Leer archivo SAC: **********************************************
   r $file
#  **********************************************************************
#  ********* Correcciones generales de señales 1: ***********************
   rmean
   rtrend
   taper
#  **********************************************************************
#  ********* Remover respuesta instrumental - deconvolucion, ************
#  ********* convertir a Desp: 'NONE', Vel: 'VEL', Acel: 'ACC' **********
   trans from evalresp to vel
#  **********************************************************************
#  ********* Correcciones generales de señales 2: ***********************
   rmean
   rtrend
   taper
#  **********************************************************************
#  *********** Integrando a desplazamiento en nm: ***********************
   int
#   *mul 1.0e-9
#  **********************************************************************
#  ********* Filtro Pasa-Banda, fc=[f1 f2], Butterworth n polos: ********
   bp n $3 corner $1 $2
#  **********************************************************************
#  ********* Correcciones generales de señales 3: ***********************
   rmean
   rtrend
   taper
#  **********************************************************************
#  ********* Escribe archivo SAC filtrado: ******************************
   w ${file}.deconv
#  **********************************************************************
   q
EOF
echo ''

end

echo ''
echo '*******************************Resumen********************************'
echo ''
echo '->Archivos ".deconv" (formato SAC binario deconvolucionado) creados:'
ls *.deconv | wc -l
ls *.deconv

echo ''
echo '**************************Fin del programa****************************'
