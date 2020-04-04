#!/bin/sh

#==================================================================================
echo ""
echo "+==========================================================================+"
echo "|                           SpectralSOURCE v1.0.0                          |"
echo "+==========================================================================+"
echo "| -Parte 2: SOURCE                                                         |"
echo "| -Subparte 1: 7.0_listar_v1.0.sh                                          |"
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

echo '****************Lista archivos para trabajar con matlab***************'
echo '**********************************************************************'
echo ''

ls SOURCE/*.fft.xy > SOURCE/[LISTA_xy].txt
mv SOURCE/HIPO_IRIS.txt SOURCE/[HIPO_IRIS].txt

echo 'Se crearon los archivos:'
echo '[LISTA].txt & [HIPO_IRIS].txt'

echo ''
echo '**************************Fin del programa****************************'
