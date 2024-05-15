# BCH_Webpage.qmd
Proceso para descargar y procesar datos desde la página web del [Banco Central de Honduras (BCH)](www.bch.hn) usando Julia, teniendo como resultado un solo archivo.

Para ejecutar este proceso desde una computadora, una vez descargados todos los archivos que contiene este repositorio, se necesitan tres cosas:
1) Instalar [R](https://cran.r-project.org/bin/windows/base/) y los paquetes "readxl" y "rio"
2) Instalar [Julia](https://julialang.org/downloads/) y luego instalar las librerías "CSV", "DataFrames", "Dates", "RCall" y "StatsBase"; y
3) Abrir el archivo "BCH_Webpage.qmd"; en este caso, el directorio por default es "wd = @__DIR__", el mismo en el que se encuentran los archivos descargados

El procedimiento se ejecuta a través de los códigos en "BCH_Webpage.qmd"; si no se tiene instalado Quarto, puede ejecutarse directamente desde Julia, pegando estas líneas en el prompt (cambiando previamente la ruta en donde se encuentran las carpetas "data" y "functions" en la variable "wd"; por ejemplo, wd = "C:/Users/your_user/Downloads/BCH_Webpage-main".^[En las rutas por default, debe cambiarse "\" por "/".]):

```
using CSV,DataFrames,Dates,RCall,StatsBase

wd = @__DIR__;
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
