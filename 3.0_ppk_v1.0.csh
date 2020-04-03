#!/bin/csh -f

echo '********************PPK (Manually Phase Picker)***********************'
echo '************rdseed 5.3.1 & SAC 101.6a utilizados**********************'
echo '************Creado por: Nestor Luna Diaz, 5 de octubre de 2016********'
echo '**************Ultima modificacion, 25 de enero de 2019****************'
echo '**********************************************************************'
echo ''

echo '[Zoom: Seleccionar region] [Desac. Zoom: O]'
echo '[Picar P: A] [Picar S: S] [Salir: q]'
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
#  ***** Leer archivo SAC: **********************************************
   r $file
#  **********************************************************************
#  ********* Picar fase P: **********************************************
#  *** [Zoom: Seleccionar region] [Picar P: A] [Picar S: S] [Desac. Zoom: O] [Salir: q] **
   ppk
#  **********************************************************************
#  ********* Escribe archivo SAC picado: ********************************
   w ${file}
#  **********************************************************************
   q
EOF

end

echo ''
echo '*******************************Resumen********************************'
echo ''
echo '->Archivos ".SAC" (formato SAC binario PPK) creados:'
ls *.SAC | wc -l
ls *.SAC

echo ''
echo '**************************Fin del programa****************************'
