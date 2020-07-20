#!/bin/csh -f

echo '************Deconvolucion - Remover respuesta instrumental************'
echo '************rdseed 5.3.1 & SAC 101.6a utilizados**********************'
echo '************Creado por: Nestor Luna Diaz, 5 de octubre de 2016********'
echo '***************Ultima modificacion, 01 de julio de 2020***************'
echo '**********************************************************************'
echo ''
echo "SELECCION: f1 = $2, f2 = $3, Np = $4"
echo ''

set N = `ls *.SAC | wc -l`
set i = 1

setenv SAC_DISPLAY_COPYRIGHT 0
if ($1 == 1) then
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
   bp n $4 corner $2 $3
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
endif

if ($1 == 2) then
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
   trans from polezero subtype ${file}.PZ to vel
#  **********************************************************************
#  ********* Correcciones generales de señales 2: ***********************
   rmean
   rtrend
   taper
#  **********************************************************************
#  *********** Integrando a desplazamiento en nm: ***********************
   int
   mul 1.0e9
#  **********************************************************************
#  ********* Filtro Pasa-Banda, fc=[f1 f2], Butterworth n polos: ********
   bp n $4 corner $2 $3
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
endif

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
