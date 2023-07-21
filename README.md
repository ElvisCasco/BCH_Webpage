# PaginaWebBCH
Proceso para descargar y procesar datos desde la página web del [Banco Central de Honduras (BCH)](www.bch.hn) usando Julia, teniendo como resultado un solo archivo.

Para ejecutar este proceso desde una computadora, una vez descargados todos los archivos que contiene este repositorio, se necesitan tres cosas:
1) Instalar [R](https://cran.r-project.org/bin/windows/base/) y los paquetes "readxl" y "rio"
2) Instalar [Julia](https://julialang.org/downloads/) y luego instalar las librerías "CSV", "DataFrames", y "RCall"; y
3) Sustituir el directorio en el código del archivo "BCH_Webpage.qmd"; en este caso, el que está guardado es "wd = "C:/IE/BCH_Webpage""

El procedimiento se ejecuta a través de los códigos en "BCH_Webpage.qmd"; si no se tiene instalado Quarto, puede ejecutarse directamente desde Julia, pegando estas líneas en el prompt (cambiando previamente la ruta especificada en la variable "wd":

```
using CSV,DataFrames,RCall

wd = "C:/IE/BCH_Webpage";
include(wd * "/functions/fn_process.jl");
include(wd * "/functions/fn_get_data.jl");
data = get_data()
CSV.write(
    wd * "/data/database.csv",
    data;
    delim = ";")
````

Las funciones utilizadas se encuentran en la carpeta "functions", archivos "fn_process.jl" y "fn_get_data.jl".

Los datos actualizados se guardan en la carpeta "data", archivo "database.csv".

Los datos del archivo "database.csv" cargados en Power BI (tablas y gráficos) pueden verse en la página web del [BCH](https://www.bch.hn/estadisticas-y-publicaciones-economicas/reportes-dinamicos/series-estadisticas-consolidadas).
