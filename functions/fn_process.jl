## Packages
using CSV, DataFrames, DataFramesMeta, Dates
using Plots, RCall, StatsBase, XLSX#, ExcelFiles, ExcelReaders


## Depurar fechas
global 	function StrToDate(x)
    try
        Dates.Date.(x)
    catch
        return missing
    end
end


global function StrToInt(x)
    try
        Base.parse.(Int64, x)
    catch
        return missing
    end
end


global function StrToFloat(x)
    try
        Base.parse.(Float64, x)
    catch
        return missing
    end
end

int(x) = floor(Int, x)


replace_text(txt,pat) = DataFrames.replace.(txt, pat => "")


function open_file_r1(webpage)
	# Usando R para leer archivo xls
	RCall.@rput webpage
	R"""
    library("readxl")
	library("rio")
	data <- invisible(rio::import(file = webpage));
    """
	data = RCall.@rget data
    return data
end

function XlToDate(exceldate::String)
    try
        #Dates.Date(Dates.DateTime(1999, 12, 30) + Dates.Day(StrToInt(exceldate)))
        Dates.Date(Dates.DateTime(1899, 12, 30) + Dates.Day(StrToInt(exceldate)))
    catch
        return missing
    end
end


function resize_data(df)
    df = DataFrames.stack(
        df,
        Not(:Variable))
    DataFrames.rename!(
        df,
        ["Variable","Fechas","Valores"])
    return df
end


function dataframe_clean(data)
    #=data = DataFrames.filter(
        row -> (row.x2 != data[1,2]),
        data)=#
	data = DataFrames.dropmissing(data, DataFrames.names(data)[2])
	DataFrames.rename!(
        data,
        Symbol.(Vector(data[1,:])))[2:end,:]
    return data
end
