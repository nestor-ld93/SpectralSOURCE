#!/bin/sh

#Renombrar archivos SAC a NET.STN.BH[ZNE].SAC
#Requiere las 3 componentes [BH1, BH2, BHZ] o [BHE, BHN, BHZ]

echo '*************Renombrar archivos SAC a NET.STN.BH[ZNE].SAC*************'
echo '*****************Creado por: Zhigang Peng, 2014***********************'
echo '******Ultima modificacion: Nestor Luna Diaz, 23 de enero de 2019******'
echo '**********************************************************************'
echo ''

backup_renombrar='backup_renombrar'
STN_3C='stn_3c.id'

echo '->Lista de archivos antes de renombrar:'
ls *.SAC | wc -l
ls *.SAC

rm -r $backup_renombrar
mkdir $backup_renombrar
cp *.SAC $backup_renombrar

ls *.SAC | awk -F"." '{print $7,$8}' | sort | uniq -c | awk '{if ($1 == 3) print $2,$3}' | sort | uniq > $STN_3C
# find the station name which has three seismograms (three components)
ls `awk '{print "*"$1"."$2".*SAC"}' $STN_3C` | awk -F"." '{print "mv "$0,$7"."$8"."$10"."$12}' | sh
# rename the SAC filename to NET.STN.BH[ZNE].SAC
mv $STN_3C $backup_renombrar

echo ''
echo '->Lista de archivos despues de renombrar:'
ls *.SAC | wc -l
ls *.SAC

echo ''
echo '**************************Fin del programa****************************'
