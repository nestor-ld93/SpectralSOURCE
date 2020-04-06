#!/usr/bin/env python3
#==================================================================================
#   +==========================================================================+  #
#   |                           SpectralSOURCE v1.1.1                          |  #
#   +==========================================================================+  #
#   | -Interfaz gráfica: PyQt5                                                 |  #
#   | -Ultima actualizacion: 31/03/2020                                        |  #
#   +--------------------------------------------------------------------------+  #
#   | -Copyright (C) 2020  Nestor Luna Diaz                                    |  #
#   +--------------------------------------------------------------------------+  #
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

#==================================================================================
# NOTA:
# - Este Script y todos los Sub-Scripts están pensados para eventos con una
#   distancia epicentral de 30°-90° respecto a las estaciones registradoras.
# - Se recomienda utilizar señales con 1 min antes de P y 5 min después de S
#   en formato SEED.

#==================================================================================
# REQUISITOS MINIMOS:
# - rdseed 5.3.1 o superior (https://github.com/iris-edu-legacy/rdseed)
# - SAC 101.6a o superior (https://ds.iris.edu/ds/nodes/dmc/forms/sac/)
# - sac2xy (https://github.com/msthorne/SACTOOLS)
# - Shell y C-Shell (Linux)
# - ps2eps (Linux)
# - MATLAB 8.5 (2015a)
# - python3 (Linux)
# - PyQt5 (Linux)
# - GNU Linux (Kernel 4.15) 64-bit [Se recomienda Kubuntu 18.04 LTS o superior]
#==================================================================================

import sys
import os
import signal
import subprocess
from PyQt5 import uic, QtWidgets

# Archivos y carpetas de SpectralSOURCE:
CAB_SAC = "HIPO_IRIS.txt"
backup_renombrar = "backup_renombrar"
CARPETA_GRAF_single = "Graficas_SAC_single_01"
CARPETA_GRAF_dual = "Graficas_SAC_dual_01"
CARPETA_GRAF = "Graficas_FFT_02"
CARPETA_SOURCE = "SOURCE"
SOURCE_P1 = "7.0_listar_v1.0.sh"
SOURCE_P2 = "SOURCE.m"
SOURCE_P3 = "Resultado.m"
SOURCE_P4 = "ResultadoGRAF.m"
SOURCE_P5 = "7.1_ordernar_graficas_v1.0.csh"
SOURCE_P6 = "7.2_limpiar_archivos_v1.0.sh"
SALIDA_estaciones = "[SALIDA_ESTACIONES].txt"
SALIDA_final = "[SALIDA_FINAL].txt"

ruta_actual = os.getcwd()

qtCreatorFile = "main.ui" # Nombre del archivo aquí.

Ui_MainWindow, QtBaseClass = uic.loadUiType(qtCreatorFile)

class MyApp(QtWidgets.QMainWindow, Ui_MainWindow):
    def __init__(self):
        QtWidgets.QMainWindow.__init__(self)
        Ui_MainWindow.__init__(self)
        self.setupUi(self)
        
        self.Boton_salir.clicked.connect(self.close)
        self.Boton_examinar.clicked.connect(self.abrir_seed)
        self.Boton_verificar.clicked.connect(self.verificar)
        self.Boton_limpiar.clicked.connect(self.limpiar_reiniciar)
        self.Boton_proceder.clicked.connect(self.proceder_SAC_delete)
        
        self.Boton_limpiar_2.clicked.connect(self.limpiar_reiniciar_2)
        self.Boton_limpiar_3.clicked.connect(self.limpiar_reiniciar_3)
        self.Boton_mostrar_res.clicked.connect(self.Mostrar_resultados)
        self.Boton_txt_externo.clicked.connect(self.Archivos_txt_externos)
        
        self.Run_Spectral_01.clicked.connect(self.Spectral_01)
        self.Run_Spectral_02.clicked.connect(self.Spectral_02)
        self.Run_SOURCE_01.clicked.connect(self.SOURCE_01)
        self.Run_SOURCE_02.clicked.connect(self.SOURCE_02)
        self.Run_SOURCE_03.clicked.connect(self.SOURCE_03)
        self.Run_SOURCE_04.clicked.connect(self.SOURCE_04)
        self.Run_SOURCE_05.clicked.connect(self.SOURCE_05)
        
        self.check_filtro.clicked.connect(self.filtro_ui)
        self.check_SAC_delete.clicked.connect(self.SAC_delete_ui)
        self.check_graficar.clicked.connect(self.graficar_fft_ui)

#============================================================================================================
#==========================================Principal: SOURCE=================================================
#============================================================================================================
        
    def graficar_fft_ui(self):
        if (self.check_graficar.isChecked()==False):
            self.combo_graf_2.setEnabled(False)  # Se desactiva el tipo de gráficos.
            self.Run_SOURCE_04.setEnabled(False) # Se desactiva "SOURCE (Parte 4)".
            
        else:
            self.combo_graf_2.setEnabled(True)   # Se activa el tipo de gráficos.
            self.Run_SOURCE_04.setEnabled(True)  # Se activa "SOURCE (Parte 4)".
        
    def Archivos_txt_externos(self):
        self.Run_SOURCE_01.setEnabled(False)     # Se desactiva "SOURCE (Parte 1)".
        self.Run_SOURCE_02.setEnabled(False)     # Se desactiva "SOURCE (Parte 2)".
        self.Run_SOURCE_03.setEnabled(True)      # Se activa "SOURCE (Parte 3)".
        self.Run_SOURCE_04.setEnabled(True)      # Se activa "SOURCE (Parte 4)".
        self.Boton_mostrar_res.setEnabled(True)  # Se activa el botón "Mostrar resultados ...".
        self.Boton_limpiar_2.setEnabled(True)    # Se activa el boton "Limpiar resultados y reiniciar".
        self.Resultados_01.setText("")           # Se elimina el contenido de cuadro de texto Resultados_01.
        self.Resultados_02.setText("")           # Se elimina el contenido de cuadro de texto Resultados_02.
        self.check_graficar.setChecked(True)     # Check a graficar.
        self.check_graficar.setEnabled(True)     # Se activa el check para graficar.
        self.combo_graf_2.setEnabled(True)       # Se activa el combobox para seleccionar formato de gráfico.
        self.combo_falla.setEnabled(True)        # Se activa el combobox para seleccionar tipo de falla.
        
    def Mostrar_resultados(self): # Muestra los resultados (textos) dentro de "Principal: SOURCE"
        self.Resultados_01.setText("")
        self.Resultados_02.setText("")
        
        f = open(CARPETA_SOURCE+"/"+SALIDA_estaciones,"r")  # Abre el archivo como lectura.
        for linea in f:
            linea = linea.strip('\n')
            self.Resultados_01.append(str(linea))
        f.close()
        
        f = open(CARPETA_SOURCE+"/"+SALIDA_final,"r")  # Abre el archivo como lectura.
        for linea in f:
            linea = linea.strip('\n')
            self.Resultados_02.append(str(linea))
        f.close()
        
    def SOURCE_01(self):
        comando_01 = "./"+CARPETA_SOURCE+"/"+SOURCE_P1
        process = subprocess.Popen(comando_01, shell=True)
        
        self.Run_SOURCE_01.setEnabled(False)    # Se desactiva "SOURCE (Parte 1)".
        self.Run_SOURCE_02.setEnabled(True)     # Se activa "SOURCE (Parte 2)".
        self.Boton_limpiar_2.setEnabled(True)   # Se activa el boton "Limpiar resultados y reiniciar".
        self.Boton_txt_externo.setEnabled(True) # Se activa el botón "Tengo los archivos txt de salida""
        
    def SOURCE_02(self):
        comando_01 = 'matlab -r "run('+"'"+ruta_actual+"/"+CARPETA_SOURCE+"/"+SOURCE_P2+"'"+');exit"'
        process = subprocess.Popen(comando_01, shell=True)
        
        self.Run_SOURCE_02.setEnabled(False)    # Se desactiva "SOURCE (Parte 2)".
        self.Run_SOURCE_03.setEnabled(True)     # Se activa "SOURCE (Parte 3)".
        self.combo_falla.setEnabled(True)       # Se activa el combobox para seleccionar tipo de falla.
        
    def SOURCE_03(self):
        tipo_falla = self.combo_falla.currentText()
        if (tipo_falla == '1. Dip-Slip (Subducción)'):
            tipo_falla = '1'
        if (tipo_falla == '2. Normal Dip-Slip (Continental)'):
            tipo_falla = '2'
        if (tipo_falla == '3. Strike-Slip'):
            tipo_falla = '3'
        
        comando_01 = 'matlab -nojvm -r "tipo_falla='+tipo_falla+';run('
        comando_01+= "'"+ruta_actual+"/"+CARPETA_SOURCE+"/"+SOURCE_P3+"'"+');exit"'
        process = subprocess.Popen(comando_01, shell=True)
        
        self.check_graficar.setEnabled(True)        # Se activa el check para graficar.
        
        if (self.check_graficar.isChecked()==False):
            self.Run_SOURCE_04.setEnabled(False)    # Se desactiva "SOURCE (Parte 4)".
            self.combo_graf_2.setEnabled(False)     # Se desactiva el combobox para seleccionar formato de gráfico.
        else:
            self.Run_SOURCE_04.setEnabled(True)     # Se activa "SOURCE (Parte 4)".
            self.combo_graf_2.setEnabled(True)      # Se activa el combobox para seleccionar formato de gráfico.
        
        self.Boton_mostrar_res.setEnabled(True)     # Se activa el botón "Mostrar resultados ...".
        
    def SOURCE_04(self):
        if (self.check_graficar.isChecked()==False):
            gen_graf = '0'
            tipo_graf = self.combo_graf_2.currentText()
        else:
            gen_graf = '1'
            tipo_graf = self.combo_graf_2.currentText()
        
        
        comando_01 = 'matlab -r "gen_graf='+gen_graf+';'+'tipo_graf='+"'"+tipo_graf+"'"+';run('
        comando_01+= "'"+ruta_actual+"/"+CARPETA_SOURCE+"/"+SOURCE_P4+"'"+');exit"'
        process = subprocess.Popen(comando_01, shell=True)
        
        self.Run_SOURCE_05.setEnabled(True)    # Se activa "SOURCE (Parte 5)".
        
    def SOURCE_05(self):
        comando_01 = "./"+CARPETA_SOURCE+"/"+SOURCE_P5
        process = subprocess.Popen(comando_01, shell=True)
        
        self.Run_SOURCE_05.setEnabled(False)   # Se desactiva "SOURCE (Parte 5)".
        
    def limpiar_reiniciar_2(self):
        comando_01 = "./"+CARPETA_SOURCE+"/"+SOURCE_P6
        process = subprocess.Popen(comando_01, shell=True)
        
        self.Run_SOURCE_01.setEnabled(True)      # Se activa "SOURCE (Parte 1)".
        self.Run_SOURCE_02.setEnabled(False)     # Se desactiva "SOURCE (Parte 2)".
        self.Run_SOURCE_03.setEnabled(False)     # Se desactiva "SOURCE (Parte 3)".
        self.Run_SOURCE_04.setEnabled(False)     # Se desactiva "SOURCE (Parte 4)".
        self.Run_SOURCE_05.setEnabled(False)     # Se desactiva "SOURCE (Parte 5)".
        self.check_graficar.setChecked(True)     # Check a graficar.
        self.check_graficar.setEnabled(False)    # Se desactiva el check para graficar.
        self.combo_graf_2.setEnabled(False)      # Se desactiva el combobox para seleccionar formato de gráfico.
        self.Boton_mostrar_res.setEnabled(False) # Se desactiva el botón "Mostrar resultados ...".
        self.Resultados_01.setText("")           # Se elimina el contenido de cuadro de texto Resultados_01.
        self.Resultados_02.setText("")           # Se elimina el contenido de cuadro de texto Resultados_02.
    
    def limpiar_reiniciar_3(self):
        comando_01 = "./"+CARPETA_SOURCE+"/"+SOURCE_P6
        comando_02 = "rm "+CARPETA_SOURCE+"/"+"*.fft.xy"
        process = subprocess.Popen(comando_01, shell=True)
        process = subprocess.Popen(comando_02, shell=True)
        
        self.Run_SOURCE_01.setEnabled(False)     # Se desactiva "SOURCE (Parte 1)".
        self.Run_SOURCE_02.setEnabled(False)     # Se desactiva "SOURCE (Parte 2)".
        self.Run_SOURCE_03.setEnabled(False)     # Se desactiva "SOURCE (Parte 3)".
        self.Run_SOURCE_04.setEnabled(False)     # Se desactiva "SOURCE (Parte 4)".
        self.Run_SOURCE_05.setEnabled(False)     # Se desactiva "SOURCE (Parte 5)".
        self.check_graficar.setChecked(True)     # Check a graficar.
        self.check_graficar.setEnabled(False)    # Se desactiva el check para graficar.
        self.combo_graf_2.setEnabled(False)      # Se desactiva el combobox para seleccionar formato de gráfico.
        self.Boton_mostrar_res.setEnabled(False) # Se desactiva el botón "Mostrar resultados ...".
        self.Resultados_01.setText("")           # Se elimina el contenido de cuadro de texto Resultados_01.
        self.Resultados_02.setText("")           # Se elimina el contenido de cuadro de texto Resultados_02.
        self.combo_falla.setEnabled(False)       # Se desactiva el combobox para seleccionar tipo de falla.
        self.Boton_limpiar_2.setEnabled(False)   # Se desactiva el boton "Limpiar resultados y reiniciar".


#============================================================================================================
#==========================================Principal: Spectral===============================================
#============================================================================================================

    def proceder_SAC_delete(self):
        if (self.check_SAC_delete.isChecked()==True and self.list_est_delete.toPlainText()!="" and self.list_est_delete.toPlainText()!='¡No iniciar ni finalizar con ";"!'):
            lista = self.list_est_delete.toPlainText()
            lista = lista.replace(" ","")  # Elimina el espacio generado al final del texto.
            lista_final = lista.split(";") # Reemplaza los ";" y genera una "lista".
            
            f = open(CAB_SAC,"r")  # Abre el archivo como lectura.
            lineas = f.readlines() # Crea lista con cada una de las líneas del archivo.
            f.close()
            
            i = 0                  # Contador para el bucle while.
            n = len(lista_final)   # Cantidad de estaciones en la lista_final.
            comando_01 = ""
            comando_02 = ""
            
            while i < n:
                comando_01 = comando_01 + " " + "*" + lista_final[i] + "*.SAC*"
                comando_02 = comando_02 + " " + "RESP*" + lista_final[i] + "*"
                
                i2 = 0              # Contador para el bucle for.
                n2 = len(lineas)    # Cantidad de lineas del archivo.
                
                while i2 < n2:
                    if (lineas[i2].find(lista_final[i]) != -1): # Busca las lineas que contengan las estaciones.
                        lineas[i2]=""
                    i2 += 1
                i += 1
            
            f = open(CAB_SAC,"w")  # Abre el archivo como escritura, pero vacio.
            for linea in lineas:
                f.write(linea)     # Escribe las estaciones resultantes.
            f.close()
            comando_del_01 = "rm" + comando_01
            comando_del_02 = "rm" + comando_02
            
            process = subprocess.Popen(comando_del_01, shell=True)
            process = subprocess.Popen(comando_del_02, shell=True)
            
            mensaje_del = "--------------------------------------------------"*2
            mensaje_del+= "\nSe ejecutó el comando para eliminar las estaciones y respuestas:\n" + str(lista_final)
            self.Mostrar_errores.setText(mensaje_del)
        
        self.Run_Spectral_02.setEnabled(True)  # Se activa "Spectral (Parte 2)".
        
    def SAC_delete_ui(self):
        if (self.check_SAC_delete.isChecked()==False):
            self.list_est_delete.setEnabled(False)  # Se desactiva la lista de estaciones corruptas a eliminar.
        else:
            self.list_est_delete.setEnabled(True)  # Se activa la lista de estaciones corruptas a eliminar.
        
    def limpiar_reiniciar(self):
        comando_1 = "rm *.deconv *.fft *.SAC RESP* " + CAB_SAC + " "
        comando_1+= "-r " + backup_renombrar + " " + CARPETA_GRAF_single + " " + CARPETA_GRAF_dual
        process = subprocess.Popen(comando_1, shell=True)
        
        self.Boton_examinar.setEnabled(True)  # Se activa "Examinar".
        self.ruta_seed.setEnabled(True)       # Se activa la ruta del archivo seed.
        self.ruta_seed.setText("")            # Se elimina el contenido de ruta_seed.
        
        self.combo_graf.setEnabled(True)      # Se activa el combobox tipo de gráfico.
        
        self.check_filtro.setEnabled(True)    # Se activa el checkbox utilizar filtro.
        self.check_filtro.setChecked(True)    # Check en filtro
        self.filtro_01.setEnabled(True)       # Se activa el filtro 1.
        self.filtro_02.setEnabled(True)       # Se activa el filtro 2.
        self.num_p.setEnabled(True)           # Se activa el número de polos.
        
        self.check_eliminar.setEnabled(False) # Se desactiva el checkbox eliminar archivos.
        self.check_eliminar.setChecked(True)  # Check en eliminar archivos.
        self.check_SNR.setEnabled(True)       # Se activa el chek utilizar SNR.
        self.check_SNR.setChecked(False)      # No chek a utilizar SNR.
        
        self.Boton_verificar.setEnabled(True) # Se activa "Verificar parámetros...".
        self.Mostrar_errores.setText("")      # Se elimina el contenido de Mostrar_errores.
        
        self.Run_Spectral_01.setEnabled(False)  # Se desactiva "Spectral (Parte 1)".
        self.Run_Spectral_02.setEnabled(False)  # Se desactiva "Spectral (Parte 2)".
        
        self.check_SAC_delete.setEnabled(False) # Se desactiva el check eliminar estaciones corruptas.
        self.check_SAC_delete.setChecked(False) # No check en eliminar estaciones corruptas.
        self.list_est_delete.setEnabled(False)  # Se desactiva la lista de estaciones corruptas a eliminar.
        self.list_est_delete.setPlainText('¡No iniciar ni finalizar con ";"!')   # Reiniciar texto list_est_delete.
        self.Boton_proceder.setEnabled(False)   # Se desactiva "Proceder".
        
    def filtro_ui(self):
        if (self.check_filtro.isChecked()==False):
            self.filtro_01.setEnabled(False)
            self.filtro_02.setEnabled(False)
            self.num_p.setEnabled(False)
        else:
            self.filtro_01.setEnabled(True)
            self.filtro_02.setEnabled(True)
            self.num_p.setEnabled(True)
    
    def abrir_seed(self):
        #ruta_actual = str(subprocess.Popen("pwd", shell=True))
        ruta_actual = os.getcwd()
        
        filePath, _ = QtWidgets.QFileDialog.getOpenFileName(self,directory=ruta_actual,filter="Archivos seed (*.seed)")
        
        if (filePath != "" and filePath.find(".seed")>0): # Condición para que el archivo sea .seed.
            self.ruta_seed.setText(filePath)
        
    def Spectral_01(self):
        ruta_actual = os.getcwd()
        
        archivo_seed = self.ruta_seed.toPlainText()
        archivo_seed = archivo_seed.replace(ruta_actual+"/","")
        
        f1 = self.filtro_01.toPlainText()
        f2 = self.filtro_02.toPlainText()
        np = str(self.num_p.value())
        tipo_graf = self.combo_graf.currentText()
        N_comp = self.combo_comp.currentText()
        
        if (self.check_filtro.isChecked()==True):
            util_filtro = "1"
        else:
            util_filtro = "0"
        
        if (self.check_SNR.isChecked()==True):
            util_SNR = "1"
        else:
            util_SNR = "0"
        
        comando_1 = "./I_Pre-procesamiento.csh"
        comando_1+= " "+archivo_seed+" "+N_comp+" "+tipo_graf+" "+util_SNR+" "+util_filtro+" "+f1+" "+f2+" "+np
        process = subprocess.Popen(comando_1, shell=True)
        
        self.Run_Spectral_01.setEnabled(False) # Se desactiva "Spectral (Parte 1)".
        self.Boton_examinar.setEnabled(False)  # Se desactiva "Examinar".
        self.Boton_verificar.setEnabled(False) # Se desactiva verificar parámetros.
        self.combo_graf.setEnabled(False)      # Se desactiva el combobox tipo de gráfico.
        self.ruta_seed.setEnabled(False)       # Se desactiva la ruta del archivo seed.
        self.check_filtro.setEnabled(False)    # Se desactiva el check utilizar filtro.
        self.check_SNR.setEnabled(False)       # Se desactiva el chek utilizar SNR.
        self.filtro_01.setEnabled(False)       # Se desactiva el filtro 1.
        self.filtro_02.setEnabled(False)       # Se desactiva el filtro 2.
        self.num_p.setEnabled(False)           # Se desactiva el número de polos.
        
        self.check_eliminar.setEnabled(True)   # Se activa el check eliminar archivos.
        self.check_SAC_delete.setEnabled(True) # Se activa el check eliminar estaciones corruptas.
        self.Boton_proceder.setEnabled(True)   # Se activa "Proceder".
        
    def Spectral_02(self):
        
        if (self.check_eliminar.isChecked()==True):
            eliminar_archivos = "1"
        else:
            eliminar_archivos = "0"
        
        comando_1 = "./II_Procesamiento.csh"
        comando_1+= " "+eliminar_archivos
        process = subprocess.Popen(comando_1, shell=True)
        
        self.Run_Spectral_02.setEnabled(False)  # Se desactiva "Spectral (Parte 2)".
        self.check_eliminar.setEnabled(False)   # Se desactiva el check eliminar archivos.
        self.check_SAC_delete.setEnabled(False) # Se desactiva el check eliminar estaciones corruptas.
        self.list_est_delete.setEnabled(False)  # Se desactiva la lista de estaciones corruptas a eliminar.
        self.Boton_proceder.setEnabled(False)   # Se desactiva "Proceder".
        
        self.Run_SOURCE_01.setEnabled(True)       # Se activa "SOURCE (Parte 1)".
        
    def verificar(self):
        archivo_seed = self.ruta_seed.toPlainText()
        f1 = self.filtro_01.toPlainText()
        f2 = self.filtro_02.toPlainText()
        #np = self.num_p.value()
        #tipo_graf = self.combo_graf.currentText()
        error_filtro = 0
        
        if (archivo_seed != "" and archivo_seed.find(".seed")>0):
            mensaje_01 = "- Archivo seed correcto."
        else:
            mensaje_01 = "- ERROR: Archivo seed no ingresado."
        
        if (self.check_filtro.isChecked()==True):
            if (f1.find(",") < 0):
                mensaje_02 = "- Formato de filtro 1 correcto."
            else:
                mensaje_02 = "- ERROR: Formato de filtro 1 incorrecto."
                error_filtro = 1
            
            if (f2.find(",") < 0):
                mensaje_03 = "- Formato de filtro 2 correcto."
            else:
                mensaje_03 = "- ERROR: Formato de filtro 2 incorrecto."
                error_filtro = 1
                
            if (error_filtro == 0):
                if (float(f1) < float(f2)):
                    mensaje_04 = "- Valores del filtro correctos."
                else:
                    mensaje_04 = "- ERROR: f1 > f2."
            else:
                mensaje_04 = "- ERROR: No es posible verificar el/los valores del filtro."
        else:
            mensaje_02 = ""
            mensaje_03 = ""
            mensaje_04 = ""
        
        mensaje_final = mensaje_01 + "\n" + mensaje_02 + "\n" + mensaje_03 + "\n" + mensaje_04
        self.Mostrar_errores.setText(mensaje_final)
        
        if (mensaje_final.find("ERROR") < 0): # Condición para activar spectral.
            self.Run_Spectral_01.setEnabled(True) # Se activa "Spectral (Parte 1).
        else:
            self.Run_Spectral_01.setEnabled(False)
        

if __name__ == "__main__":
    app =  QtWidgets.QApplication(sys.argv)
    window = MyApp()
    window.show()
    sys.exit(app.exec_())
