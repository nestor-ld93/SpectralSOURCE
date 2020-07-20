#!/bin/sh

#Renombrar archivos SAC a NET.STN.BH[Z].SAC
#Requiere 1 componente [BHZ]

echo '**************Renombrar archivos SAC a NET.STN.BH[Z].SAC**************'
echo '*****************Creado por: Zhigang Peng, 2014***********************'
echo '******Ultima modificacion: Nestor Luna Diaz, 30 de junio de 2020******'
echo '**********************************************************************'
echo ''

backup_renombrar='backup_renombrar'
STN_ZC='stn_zc.id'
PZ_ZC='pz_zc.id'

if [ $1 -eq 1 ];
then
    #echo '->Archivos a eliminar (otras componentes):'
    rm *.BH1*.SAC *.BH2*.SAC
    rm *.BHE*.SAC *.BHN*.SAC
    rm RESP.*BH1 RESP.*BH2
    rm RESP.*BHE RESP.*BHN
    echo ''

    echo '->Lista de archivos antes de renombrar:'
    ls *.SAC | wc -l
    ls *.SAC

    rm -r $backup_renombrar
    mkdir $backup_renombrar
    cp *.SAC $backup_renombrar

    ls *.SAC | awk -F"." '{print $7,$8}' | sort | uniq -c | awk '{if ($1 == 1) print $2,$3}' | sort | uniq > $STN_ZC
    # find the station name which has three seismograms (three components)
    ls `awk '{print "*"$1"."$2".*SAC"}' $STN_ZC` | awk -F"." '{print "mv "$0,$7"."$8"."$10"."$12}' | sh
    # rename the SAC filename to NET.STN.BH[ZNE].SAC
    
    mv $STN_ZC $backup_renombrar

    echo ''
    echo '->Lista de archivos despues de renombrar:'
    ls *.SAC | wc -l
    ls *.SAC
fi

if [ $1 -eq 2 ];
then
    #echo '->Archivos a eliminar (otras componentes):'
    rm *.BH1*.SAC *.BH2*.SAC
    rm *.BHE*.SAC *.BHN*.SAC
    rm SACPZ.*BH1 SACPZ.*BH2
    rm SACPZ.*BHE SACPZ.*BHN
    echo ''

    echo '->Lista de archivos antes de renombrar:'
    ls *.SAC | wc -l
    ls *.SAC
    ls SACPZ.* | wc -l
    ls SACPZ.*

    rm -r $backup_renombrar
    mkdir $backup_renombrar
    cp *.SAC $backup_renombrar
    cp SACPZ.* $backup_renombrar

    ls *.SAC | awk -F"." '{print $1,$2}' | sort | uniq -c | awk '{if ($1 == 1) print $2,$3}' | sort | uniq > $STN_ZC
    # find the station name which has three seismograms (three components)
    ls `awk '{print "*"$1"."$2".*SAC"}' $STN_ZC` | awk -F"." '{print "mv "$0,$1"."$2"."$4"."$9}' | sh
    # rename the SAC filename to NET.STN.BH[ZNE].SAC

    ls SACPZ.* | awk -F"." '{print $2,$3}' | sort | uniq -c | awk '{if ($1 == 1) print $2,$3}' | sort | uniq > $PZ_ZC
    # find the station name which has three seismograms (three components)
    ls `awk '{print "*"$1"."$2".*BHZ"}' $PZ_ZC` | awk -F"." '{print "mv "$0,$2"."$3"."$5".SAC.PZ"}' | sh
    # rename the SACPZ filename to NET.STN.BH[ZNE].SAC.PZ

    mv $STN_ZC $backup_renombrar
    mv $PZ_ZC $backup_renombrar

    echo ''
    echo '->Lista de archivos despues de renombrar:'
    ls *.SAC | wc -l
    ls *.SAC
    echo ''
    ls *.SAC.PZ | wc -l
    ls *.SAC.PZ
fi


echo ''
echo '**************************Fin del programa****************************'
