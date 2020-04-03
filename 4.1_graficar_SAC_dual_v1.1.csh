#!/bin/csh -f

echo '************Graficar - señal original y  deconvolucionada*************'
echo '************rdseed 5.3.1 & SAC 101.6a utilizados**********************'
echo '************Creado por: Nestor Luna Diaz, 5 de octubre de 2016********'
echo '*****************Ultima modificacion, 23 de marzo de 2019*************'
echo '**********************************************************************'
echo ''

set CARPETA_GRAF = 'Graficas_SAC_dual_01'
rm -r $CARPETA_GRAF
mkdir $CARPETA_GRAF

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
#  ********* [conf.] Remover archivos sgf: ******************************
   sc rm -f *.sgf
#  **********************************************************************
#  ********* [conf.] Relación de aspecto y/x: ***************************
   vspace 0.5
#  **********************************************************************
#  ***** Leer archivo SAC: **********************************************
   r $file ${file}.deconv
#  **********************************************************************
#  ********* Correcciones generales de señales 1: ***********************
   *rmean
   *rtrend
   *taper
#  **********************************************************************
#  ********* Etiquetas de ejes, grillas y color: ************************
   xlabel "Tiempo (s)"
   ylabel "Amplitud (nm) Desp.      Amplitud (Cuentas) Vel."
   grid on
   color blue
#  **********************************************************************
#  *************** Convertir sgf a ps: **********************************
   bd sgf
   p1
   saveimg ${file}.ps
#  **********************************************************************
#  ********* Remover archivos sgf: **************************************
   sc rm -f *.sgf
#  **********************************************************************
   q
EOF

ps2eps ${file}.ps
echo ''
end

rm *.ps

echo ''
echo '*******************************Resumen********************************'
echo ''
echo '->Archivos ".eps" creados:'
ls *.eps | wc -l
ls *.eps

mv *.eps $CARPETA_GRAF

echo ''
echo '**************************Fin del programa****************************'
