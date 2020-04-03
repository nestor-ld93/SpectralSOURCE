#!/bin/csh -f

#==================================================================================
echo ""
echo "+==========================================================================+"
echo "|                           SpectralSOURCE v1.0.0                          |"
echo "+==========================================================================+"
echo "| -Parte 2: SOURCE                                                         |"
echo "| -Subparte 5: 7.1_ordernar_graficas_v1.0.csh                              |"
echo "| -Ultima actualizacion: 20/03/2020                                        |"
echo "+--------------------------------------------------------------------------+"
echo "| -Copyright (C) 2020  Nestor Luna Diaz                                    |"
echo "+--------------------------------------------------------------------------+"
echo ""
#==================================================================================

#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.

#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.

#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <https://www.gnu.org/licenses/>.

#==================================================================================

echo '**************Ordenar graficas png generadas en Matlab****************'
echo '**********************************************************************'
echo ''

set CARPETA_GRAF = 'Graficas_FFT_02'

echo '->Archivos ".png" a ordenados:'
ls *.png | wc -l
ls *.png

echo ''
echo '->Archivos ".eps" a ordenados:'
ls *.eps | wc -l
ls *.eps

mkdir $CARPETA_GRAF
mv *.png $CARPETA_GRAF
mv *.eps $CARPETA_GRAF

echo ''
echo '**************************Fin del programa****************************'
