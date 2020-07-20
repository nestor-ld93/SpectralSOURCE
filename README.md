# SpectralSOURCE
Programa semi-automático con interfaz PyQt5 en lenguaje C-Shell, Bash y Matlab con el objetivo de estimar las características de la fuente sísmica (momento sísmico, magnitud momento, dimensiones del área de ruptura, caída de esfuerzos y deslizamiento) utilizando el método del análisis espectral de las ondas P en la componente vertical (BHZ).

Las salidas generadas por **SpectralSOURCE** son las siguientes:

- Resultados del momento sísmico y frecuencia esquina para cada estación: **[SALIDA_ESTACIONES].txt**.
- Resultados finales del momento sísmico, magnitud momento, dimensiones del área de ruptura, caída de esfuerzos y deslizamiento considerando diversos modelos: **[SALIDA_FINAL].txt**.
- Gráficas en formato EPS o PNG de los espectros de desplazamiento para cada estación: **Gráficas_FFT_02**.

## IMÁGENES PRINCIPALES (en KDE Plasma 5.19)

![app menu](https://lh3.googleusercontent.com/-4ctEGX_p5W0/XwpEfPhPx5I/AAAAAAAABHs/lvDD_9D9Cr8oDl-0zveYcZ_ye_ln67CfgCLcBGAsYHQ/h809/SpectralSOURCE_PyQt5_01.png "Interfaz gráfica en PyQt5 de SpectralSOURCE: Spectral")
![app menu](https://lh3.googleusercontent.com/-dCcVLp9dDVw/Xv5H499in4I/AAAAAAAABGI/oIu94dGon2otdcmMXlXjJBBMnfVjVFQ7ACLcBGAsYHQ/h809/SpectralSOURCE_PyQt5_02.png "Interfaz gráfica en PyQt5 de SpectralSOURCE: SOURCE")
![app menu](https://lh3.googleusercontent.com/-3aHZD1JlgA0/Xv5H5OHXLwI/AAAAAAAABGQ/Y6ZZyg2YW5UM7txgiHgys0GgN2L8jiTLwCLcBGAsYHQ/h864/Figura-2.png "Principales espectros de desplazamiento para el sismo de Arequipa del 23 de junio del 2001 - Perú")

## RECOMENDACIONES
- Utilizar registros en formato SEED (IRIS hasta el 2019). Si no es posible, utilizar archivos SAC más archivos de polos y zeros (IRIS desde el 2020).
- Utilizar registros de estaciones de banda ancha en la componente vertical (BHZ) de la red internacional IRIS a una distancia epicentral de 30°-90°.
- Utilizar señales con 1 min antes del primer arribo de la onda P y 5 min después de S.

## REQUISITOS MÍNIMOS
- rdseed 5.3.1 o superior (https://github.com/iris-edu-legacy/rdseed)
- SAC 101.6a o superior (https://ds.iris.edu/ds/nodes/dmc/forms/sac/)
- sac2xy (https://github.com/msthorne/SACTOOLS)
- Shell y C-Shell
- ps2eps
- MATLAB 8.5 (2015a)
- python3
- python3-pyqt5
- GNU Linux (Kernel 4.15) 64-bit [Se recomienda una distribución con KDE Plasma 5.12 o superior]

## ¿CÓMO DESCARGAR?
- Para obtener la última versión estable, descargue desde la pestaña [[Releases](https://github.com/nestor-ld93/SpectralSOURCE/releases)].
- Para obtener la última versión candidata a estable, descargue desde el botón [Code] o ejecute en un terminal:
`git clone https://github.com/nestor-ld93/SpectralSOURCE`

## ¿CÓMO EJECUTAR?
1. Descargar las señales de la red internacional IRIS (un archivo en formato SEED). También es válido descargar señales en formato SAC (little-endian o big-endian) comprimidos en TAR (contiene archivos SAC mas archivos de polos y zeros).
1. Copiar el archivo SEED en la misma ubicación donde se encuentra el programa **I_Pre-procesamiento.csh**. O en su defecto, descomprimir el contenido del archivo TAR y copiar los archivos SAC y SACPZ en el directorio donde se encuentra el programa **I_Pre-procesamiento.csh**.
1. Ejecutar en un terminal: `./SpectralSOURCE.py` e ingresar el archivo SEED (o marcar el check "`Utilizar archivos SAC y PZ`"), el filtro a utilizar y el tipo de gráficos (registros de ondas) a generar. Por el momento, los parámetros adicionales se encuentran desactivados.
1. Verificar los parámetros e iniciar "`Spectral (Parte 1)`".
1. Picar manualmente el primer arribo de la onda P (proceso iterativo).
1. Decidir si eliminar estaciones corruptas y proceder.
1. Iniciar "`Spectral (Parte 2)`".
1. Ingresar a la pestaña "`Principal: SOURCE`" y ejecutar "`1. Listar archivos`".
1. Ejecutar "`2. SOURCE.m`" (se abrirá matlab) e identificar manualmente la parte plana del espectro y picar la frecuencia esquina (proceso iterativo). Esperar a que Matlab se cierre automáticamente.
1. Seleccionar el tipo de falla (utilizado para las relaciones de escalamiento de Papazachos) y ejecutar "`3. Resultado.m`" (se abrirá matlab en modo línea de comandos). Esperar a que Matlab muestre los resultados.
1. Si el usuario lo desea, puede visualizar los resultados en la interfaz gráfica haciendo clic en "`Mostrar resultados ...`".
1. Seleccionar el formato de gráficos (EPS o PNG) para los espectros de desplazamiento y ejecutar "`4. ResultadoGRAF`".
1. Ejecutar "`5. Ordenar gráficos`".

## NOTAS IMPORTANTES
- Las estaciones registradoras muchas veces presentan señales corruptas, aprovechar la opción **Eliminar estaciones corruptas (separar con ";")** para eliminarlas. Ingresar únicamente el nombre de las estaciones con el separador ";". Por ejemplo: `RAR;XMAS;RSSD` (no incluir símbolos adicionales al inicio ni al final). Esta opción eliminará los archivos de las estaciones y su conexión con el contenido de **HIPO_IRIS.txt**.
- Por defecto, **SOURCE** trabaja con el modelo PREM **([PREM]_1s_IDV.txt)**, este modelo puede ser reemplazado por otro según sea el caso (realizar las modificaciones necesarias al programa para acoplar otro modelo).
- El archivo **[HIPO_IRIS].txt** contiene los parámetros de cada estación además de los parámetros hipocentrales del sismo. Estos datos son obtenidos del cabecero de los archivos SAC, por lo tanto, puede contener errores (sobre todo la profundidad del evento. Línea 1, columna 7). De ser necesario, modificar **[HIPO_IRIS].txt**.
- La pestaña "`Principal: SOURCE`" contiene los elementos "`Limpiar resultados y reiniciar`" y "`Limpiar todos los archivos y reiniciar`". La primera opción únicamente elimina los resultados de **SOURCE** y permite empezar nuevamente "`1. Listar archivos`"; mientras que el segundo, elimina todos los archivos necesarios para empezar **SOURCE** y se deberá iniciar nuevamente con **SPECTRAL**.
- La pestaña "`Principal: SOURCE`" contiene el elemento "`Tengo los archivos txt de salida`", dicha opción habilitará **SOURCE** desde "`3. Resultado.m`" siempre y cuando se copien los archivos "[HIPO_IRIS].txt", "[LISTA_xy].txt", "[SALIDA_ESTACIONES].txt" y "[SALIDA_FINAL].txt" en la carpeta **SOURCE**.
- IRIS finalizó la distribución de archivos seed a finales del 2019. Como alternativa rápida, es posible la solicitud de archivos SAC más polos y zeros en un fichero TAR. **SpectralSOURCE** considera la nueva nomenclatura (2020 del IRIS) de nombres de archivos SAC mas polos y zeros. **No renombrar ningún archivo del IRIS, SpectralSOURCE lo realizará**.

## LISTA DE CAMBIOS
- (v1.0.0) [03/04/2020] Lanzamiento inicial.
- (v1.1.0) [04/04/2020] Cambios a varios archivos para enlazarlos al programa principal: **SpectralSOURCE.py**
- (v1.1.0) [04/04/2020] Se añadió una interfaz gráfica en PyQt5.
- (v1.1.1) [06/04/2020] Corrección en el esquema de colores.
- (v1.1.1) [06/04/2020] Con Plasma 5.12 o superior, es posible tener el modo claro o modo oscuro dependiendo del esquema de colores seleccionado.
- (v1.1.2) [16/04/2020] Correcciones a los enlaces externos.
- (v1.2.0) [20/07/2020] Agregado nueva opción para utilizar directamente archivos SAC y SACPZ descargados del IRIS.
- (v1.2.0) [20/07/2020] Script **1.1_renombrar_BHZ_v1.0.sh** mejorado para tener en cuenta la nueva nomenclatura (nombre de archivos SAC) del IRIS al utilizar señales descargadas en formato SAC little-endian o big-endian.
- (v1.2.0) [20/07/2020] Se reemplazó los TextEdit por SpinBox de los filtros.
- (v1.2.0) [20/07/2020] Se agregaron detalles a los gráficos finales.

