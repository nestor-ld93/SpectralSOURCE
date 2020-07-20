#!/bin/csh -f

#==================================================================================
echo ""
echo "+==========================================================================+"
echo "|                           SpectralSOURCE v1.2.0                          |"
echo "+==========================================================================+"
echo "| -Parte 1: Spectral                                                       |"
echo "| -Subparte 1: Pre-Procesamiento (I_Pre-procesamiento.csh)                 |"
echo "| -Ultima actualizacion: 09/07/2020                                        |"
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
# - La salida de este Script es necesario para utilizar 'II_Procesamiento.csh'.

###################################################################################
# REQUISITOS MINIMOS:
# - rdseed 5.3.1 o superior (https://github.com/iris-edu-legacy/rdseed)
# - SAC 101.6a o superior (https://ds.iris.edu/ds/nodes/dmc/forms/sac/)
# - sac2xy (https://github.com/msthorne/SACTOOLS)
# - Shell y C-Shell (Linux)
# - ps2eps (Linux)
# - GNU Linux (Kernel 4.15) 64-bit

###################################################################################
# CONDICIONES INICIALES:
# 0) Modificar el metodo de archivo ingresado:
#    Opciones: '1', '2'.
#    ('1' es archivo seed, '2' son archivos SAC y PZ en el directorio de trabajo).
# 1) Modificar el nombre del archivo seed a utilizar.
# 2) Ingrese el número de componentes a utilizar. Opciones: 1 (BHZ) o 3 (BH1-2-Z).
# 3) Ingrese el tipo de gráfico (señal original y deconv.) EPS.
#    Opciones: 'single', 'dual', 'none'.
#    ('single' son gráficos individuales. 'dual' es un gráfico doble.)
# 4) Ingrese 1 para utilizar SNR, 0 para no utilizar
# 5) Ingrese 1 para utilizar filtro, 0 para no utilizar.
# 6) Modificar el filtro (butterworth) Pasa-banda y número de polos.
#    f1 = 0.005, f2 = 0.2 : 7.0 < Mw < 8.0
#    f1 = 0.002, f2 = 0.1 : Mw > 8.0
#    np = 5

set archivo_seed = $1
set N_comp = $2
set tipo_graf = $3
set util_SNR = $4
set util_filtro = $5
set f1 = $6
set f2 = $7
set np = $8
set metodo_archivo = $9
###################################################################################
echo "+--------------------------------------------------------------------------+"
echo "|             --> EL PRE-PROCESAMIENTO INICIARÁ EN 5 s ... <--             |"
echo "+--------------------------------------------------------------------------+"
echo "   -OPCIONES SELECCIONADAS:"
echo "    archivo_seed = $archivo_seed"
echo "    N_comp = $N_comp"
echo "    tipo_graf = $tipo_graf"
echo "    util_SNR = $util_SNR"
echo "    util_filtro = $util_filtro"
if ($util_filtro == 1) then
    echo "    f1 = $f1"
    echo "    f2 = $f2"
    echo "    np = $np"
    echo "+--------------------------------------------------------------------------+"
else if ($util_filtro == 0) then
        echo "+--------------------------------------------------------------------------+"
     else
         echo "  -ADVERTENCIA: Opción (util_filtro) incorrecta. Saliendo del programa."
         exit 1
endif
sleep 5

if ($metodo_archivo == 1) then
    # Extraer de SEED a SAC.
    ./1.0_rdseed2sac_v1.0.csh $archivo_seed
    echo ''
else if ($metodo_archivo == 2) then
        # Remover archivos SAC no usados.
        ./1.0_rm_sac_inv_v1.0.csh
        echo ''
endif

# Renombrar SAC para facilitar tareas.
# Verificar presencia de archivos ".SAC", "RESP". y "SACPZ.".

if ($metodo_archivo == 1) then
    set Nsac  = `ls *.SAC | wc -l`
    set Nresp = `ls RESP.* | wc -l`
    if ($Nsac > 0 && $Nresp >0) then
        if ($N_comp == 1) then
            echo "  -Utilizando la componente: BHZ."
            ./1.1_renombrar_BHZ_v1.0.sh $9
            echo ""
        else if ($N_comp == 3) then
                echo "  -Utilizando las componentes: BH1 (BHE), BH2 (BHN), BHZ. [¡ERROR: FALTA PROGRAMAR!]"
                ./1.2_renombrar_BH1-3_v1.0.sh $9
                echo ""
             else
                 echo "  -ADVERTENCIA: Opción (N_comp) incorrecta. Saliendo del programa."
                 echo ""
                 exit 1
        endif
    else
        echo '[ERROR: Archivos ".SAC" y/o "RESP." no encontrados. Saliendo del programa]'
        echo ""
        exit 1
    endif
endif

if ($metodo_archivo == 2) then
    set Nsac  = `ls *.SAC | wc -l`
    set Npz   = `ls SACPZ.* | wc -l`
    if ($Nsac > 0 && $Npz >0) then
        if ($N_comp == 1) then
            echo "  -Utilizando la componente: BHZ."
            ./1.1_renombrar_BHZ_v1.0.sh $9
            echo ""
        else if ($N_comp == 3) then
                echo "  -Utilizando las componentes: BH1 (BHE), BH2 (BHN), BHZ. [¡ERROR: FALTA PROGRAMAR!]"
                ./1.2_renombrar_BH1-3_v1.0.sh $9
                echo ""
             else
                 echo "  -ADVERTENCIA: Opción (N_comp) incorrecta. Saliendo del programa."
                 echo ""
                 exit 1
        endif
    else
        echo '[ERROR: Archivos ".SAC" y/o "SACPZ." no encontrados. Saliendo del programa]'
        echo ""
        exit 1
    endif
endif

# SAC2XY para calcular SNR. Extraer parametros hipocentrales.
if ($util_SNR == 1) then
    echo "  -Extrayendo cabecero SAC. (Se calculará manualmente SNR)."
    ./2.0_sac2xy_SNR_SismoGrafxy_v1.2.csh
    echo ""
else if ($util_SNR == 0) then
        echo "  -Extrayendo cabecero SAC. (NO se calculará SNR)."
        ./2.1_extra_cab_SAC_v1.0.csh
        echo ""
     else
         echo "  -ADVERTENCIA: Opción (util_SNR) incorrecta. Saliendo del programa."
         echo ""
         exit 1
endif

# PPK (Manually Phase Picker).
echo "--> Se iniciará el picado manual en 5 s <--"
sleep 5
./3.0_ppk_v1.0.csh
echo ""

# Deconvolucion - Remover respuesta instrumental.
if ($util_filtro == 1) then
    echo "  -Deconvolución utilizando filtro (butterworth) Pasa-banda."
    ./4.0_deconvolucion_integrando_v1.5.csh $9 $f1 $f2 $np
    echo ""
else if ($util_filtro == 0) then
        echo "  -Deconvolución sin utilizar filtro."
        ./4.0_deconvolucion_integrando_v1.5.csh $9
        echo ""
     else
         echo "  -ADVERTENCIA: Opción (util_filtro) incorrecta. Saliendo del programa."
         echo ""
         exit 1
endif

# Graficar en EPS (single, dual, none)
if ($tipo_graf == 'single') then
     echo "--> Se iniciará el graficado en 5 s (CTRL + C para salir) <--"
     sleep 5
    ./4.1_graficar_SAC_single_v1.0.csh
    echo ""
else if ($tipo_graf == 'dual') then
         echo "--> Se iniciará el graficado en 5 s (CTRL + C para salir) <--"
         sleep 5
         ./4.1_graficar_SAC_dual_v1.1.csh
         echo ""
     else
         echo "  -OPCIÓN 'none' seleccionada. NO se generarán gráficos EPS."
         echo ""
endif

echo '**********************FIN DEL PRE-PROCESAMIENTO***********************'
echo ''
