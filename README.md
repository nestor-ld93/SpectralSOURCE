# SpectralSOURCE
Es un programa semi-automático en lenguaje C-Shell, Bash y Matlab con el objetivo de estimar del momento sísmico escalar y las características de la fuente sísmica (dimensiones, caída de esfuerzos y deslizamiento) utilizando registros de desplazamiento de la onda P en la componente vertical (BHZ).

Las salidas generadas por **SpectralSOURCE** son las siguientes:

- Resultados del momento sísmico y frecuencias esquina para cada estación: **[SALIDA_ESTACIONES].txt**.
- Resultados finales del momento sísmico, magnitud momento, dimensiones de la fuente, caída de esfuerzos y deslizamiento considerando diversos modelos: **[SALIDA_FINAL].txt**.
- Gráficas en formato EPS o PNG de los espectros de desplazamiento para cada estación: **Gráficas_FFT_02**.

## IMÁGENES PRINCIPALES

![app menu](https://lh3.googleusercontent.com/-STDFZqjnPq4/XoelijcW-oI/AAAAAAAABBI/28CS8w8Y-XwRVe5AuitllfGngwN_qV79ACLcBGAsYHQ/h864/Figura-2.png "Principales espectros de desplazamiento para el sismo de Arequipa del 23 de junio del 2001 - Perú")

## RECOMENDACIONES
- Utilizar registros en formato SEED.
- Utilizar registros de estaciones de banda ancha en la componente vertical (BHZ) de la red internacional del IRIS a una distancia epicentral de 30°-90°.
- Utilizar señales con 1 min antes del primer arribo de la onda P y 5 min después de S.

## REQUISITOS MÍNIMOS
- rdseed 5.3.1 o superior (https://github.com/iris-edu-legacy/rdseed)
- SAC 101.6a o superior (https://ds.iris.edu/ds/nodes/dmc/forms/sac/)
- sac2xy (https://github.com/msthorne/SACTOOLS)
- Shell y C-Shell (Linux)
- ps2eps (Linux)
- MATLAB 8.5 (2015a)
- GNU Linux (Kernel 4.15) 64-bit [Se recomienda Kubuntu 18.04 LTS o superior]

## ¿CÓMO DESCARGAR?
- Para obtener la última versión estable, descargue desde la pestaña "releases".
- Para obtener la última versión candidata a estable, descargue desde el botón "Clone or download" o ejecute en un terminal:
`git clone https://github.com/quantum-phy/SpectralSOURCE`

## ¿CÓMO EJECUTAR?
1. Descargar las señales de la red internacional del IRIS (un archivo en formato SEED).
1. Copiar el archivo SEED en la misma ubicación donde se encuentra el programa **I_Pre-procesamiento.csh**.
1. Editar el archivo **I_Pre-procesamiento.csh** para incluir el nombre del archivo SEED, el filtro a utilizar y el tipo de gráficos (registros de ondas) a generar. Por el momento, se recomienda no modificar parámetros adicionales.
1. Ejecutar en un terminal: `./I_Pre-procesamiento.csh`.
1. Picar manualmente el primer arribo de la onda P (proceso iterativo).
1. Ejecutar en un terminal: `./II_Procesamiento.csh`.
1. Ingresar a la carpeta **SOURCE** y ejecutar en un terminal `./7.0_listar_v1.0.sh`.
1. Ingresar a MATLAB y ejecutar `SOURCE.m`.
1. Identificar manualmente la parte plana del espectro y picar la frecuencia esquina (proceso iterativo).
1. Editar `Resultado.m` para considerar el tipo de falla (sólo para las relaciones de escalamiento de Papazachos) y ejecutarlo.
1. Ejecutar `ResultadoGRAF.m`.
1. Ejecutar `7.1_ordernar_graficas_v1.0.csh`.

## NOTAS IMPORTANTES
- Las estaciones registradoras muchas veces presentan señales corruptas, aprovechar las pausas de **SpectralSOURCE** para eliminarlas; o en su defecto, eliminarlas al final de todo el programa. Por ejemplo, una de las pausas es cuando se termina la ejecutación de **I_Pre-procesamiento.csh** (a parte de eliminar los archivos corruptos, se deberán eliminar las líneas asociadas dentro del archivo **HIPO_IRIS.txt**).
- Por defecto, **SOURCE** trabaja con el modelo PREM **([PREM]_1s_IDV.txt)**, este modelo puede ser reemplazado por otro según sea el caso (realizar las modificaciones necesarias al programa para acoplar otro modelo).
- El archivo **[HIPO_IRIS].txt** contiene los parámetros de cada estación además de los parámetros hipocentrales del sismo. Estos parámetros son obtenidos del cabecero de los archivos SAC, por lo tanto, puede contener errores (sobre todo la profundidad del evento. Línea 1, columna 7). De ser necesario, modificar **[HIPO_IRIS].txt**.

## LISTA DE CAMBIOS
- (v1.0.0) [03/04/2020] Lanzamiento inicial.
