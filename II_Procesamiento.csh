#!/bin/csh -f

#==================================================================================
echo ""
echo "+==========================================================================+"
echo "|                           SpectralSOURCE v1.0.0                          |"
echo "+==========================================================================+"
echo "| -Parte 1: Spectral                                                       |"
echo "| -Subparte 2: Procesamiento (II_Procesamiento.csh)                        |"
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

###################################################################################
# NOTA:
# - Este Script y todos los Sub-Scripts están pensados para eventos con una
#   distancia epicentral de 30°-90° respecto a las estaciones registradoras.
# - Se recomienda utilizar señales con 1 min antes de P y 5 min después de S
#   en formato SEED.
# - La salida de este Script es necesario para utilizar 'SOURCE.m'.

###################################################################################
# REQUISITOS MINIMOS:
# - rdseed 5.3.1 o superior (https://github.com/iris-edu-legacy/rdseed)
# - SAC 101.6a o superior (https://ds.iris.edu/ds/nodes/dmc/forms/sac/)
# - sac2xy (https://github.com/msthorne/SACTOOLS)
# - Shell y C-Shell (Linux)
# - ps2eps (Linux)
# - GNU Linux (Kernel 4.15) 64-bit

###################################################################################
# ELIMINAR ARCHIVOS INNECESARIOS (*.deconv, *.fft):
# 1) Ingrese 1 para eliminar, 0 para no eliminar

set eliminar = $1
###################################################################################

echo "+--------------------------------------------------------------------------+"
echo "|               --> EL PROCESAMIENTO INICIARÁ EN 5 s ... <--               |"
echo "+--------------------------------------------------------------------------+"
sleep 5

# Calcula la FFT (Transformada rapida de Fourier) considerando Fs.
./5.0_fft_v1.1.sh
echo ''

# SAC2XY para SOURCE.
./6.0_sac2xy_SOURCE_v1.0.csh

if ($eliminar == 1) then
    echo "  Eliminando archivos innecesarios (*.deconv, *.fft)."
    rm *.deconv *.fft
else if ($eliminar == 0) then
        echo "  No se eliminarán archivos innecesarios."
     else
         echo "  -ADVERTENCIA: Opción (eliminar) incorrecta. Saliendo del programa."
         exit 1
endif

echo ''

echo '************************FIN DEL PROCESAMIENTO*************************'
echo ''
