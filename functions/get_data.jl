## Depurar fechas
global 	function StrToDate(x)
    try
        Dates.Date.(x)
    catch
        return 0
    end
end

global function StrToInt(x)
    try
        Base.parse.(Int64, x)
    catch
        return 0
    end
end

global function StrToFloat(x)
    try
        Base.parse.(Float64, x)
    catch
        return 0
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
    data = DataFrames.filter(
        row -> (row.x2 != data[1,2]),  
        data)
    DataFrames.rename!(
        data, 
        Symbol.(Vector(data[1,:])))[2:end,:]
    return data
end

function IPC()
	webfile = "https://www.bch.hn/estadisticos/GIE/LIBSeries%20IPC/Serie%20Mensual%20y%20Promedio%20Anual%20del%20%C3%8Dndice%20de%20Precios%20al%20Consumidor.xls"
	folder = "./data/xls/"
	xlname = "IPC.xls"
	Base.download(webfile, folder * xlname)
	sheet = "DIC.1999 =100 "
	data = DataFrames.DataFrame(
		ExcelFiles.load(
			folder * xlname, 
			sheet))
	# Depurar dataframe
	data = DataFrames.dropmissing(data, :x1)
	data = DataFrames.rename!(
        data, 
        Symbol.(Vector(data[1,:])),
		makeunique = true)[2:(end-1),:]
	n_years = Int((Base.size(data)[2] - 2) / 2)
    data = data[!, 1:(n_years+2)]
	c = Base.size(data)[2]
	data = DataFrames.stack(data, 2:c)
    DataFrames.rename!(data, ["Months","Years","Valores"])
	data[!, :Years] = Base.map(s -> s[1:4], data[!, :Years])
	y = Base.parse(Int64,data[end, :Years])
	Fechas = Base.collect(
		Dates.Date(1999,1,1):Dates.Month(1):Dates.Date(y,12,1)
	)
	data = Base.hcat(Fechas,data)
	data = data[!, [1,4]]
    DataFrames.rename!(data, ["Fechas","Valores"])
	data = DataFrames.dropmissing(data, :Valores)
	data[!, :Variable] .= "IPC"
	data = data[!, [1,3,2]]
	data[!, :Periodicidad] .= "Mes"
	data[!, :Sector] .= "Precios"
	CSV.write(
		"./Data/CSV/IPC.csv",data)
end

function IPC_Rubros()
	webfile = "https://www.bch.hn/estadisticos/GIE/LIBSERIE%20IPC%20RUBROS/Serie%20Mensual%20y%20Promedio%20Anual%20del%20%C3%8Dndice%20de%20Precios%20al%20Consumidor%20por%20Rubros.xlsx"
	folder = "./data/xls/"
	file = "IPC_Rubros.xlsx"
	sheet = "Rubros"
	range = "A1:N5000"
	Base.download(webfile, folder * file)
	data = XLSX.readdata(
		folder * file, #file name
	    sheet, #sheet name
	    range #cell range
    )
	data = DataFrames.DataFrame(data, :auto)
	# Depurar dataframe
	data = DataFrames.dropmissing(data, :x2)
	data = DataFrames.rename!(
        data, 
        Symbol.(Vector(data[1,:])),
		makeunique = true)[2:end,:]
	names_data = DataFrames.names(data)
	DataFrames.rename!(data, Symbol(names_data[1]) => :Variable)
	DataFrames.filter!(
        row -> !(row.Variable == "PROMEDIO"),  
        data)
	n_months = Base.size(data)[1]
	end_date = Dates.Date(1991,1,1) + Dates.Month(n_months-1)
	data[!, :Fechas] = Base.collect(
		Dates.Date(1991,1,1):Dates.Month(1):end_date
	)
	k = Base.size(data)[2]
	data = data[!, Base.vcat([k], Base.collect(2:(k-1)))]
	c = Base.size(data)[2]
	data = DataFrames.stack(data, 2:c)
    DataFrames.rename!(data, ["Fechas","Variable","Valores"])
	data[!, :Periodicidad] .= "Mes"
	data[!, :Sector] .= "Precios"
	CSV.write(
		"./data/csv/IPC_Rubros.csv",data)
end

function IPC_Regiones()
	webfile = "https://www.bch.hn/estadisticos/GIE/LIBSerie%20IPC%20Region/Serie%20Mensual%20y%20Promedio%20Anual%20del%20%C3%8Dndice%20de%20Precios%20al%20Consumidor%20por%20Regi%C3%B3n.xlsx"
	folder = "./data/xls/"
	file = "IPC_Regiones.xlsx"
	sheet = "Hoja1"
	range = "A1:I5000"
	Base.download(webfile, folder * file)
	data = XLSX.readdata(
		folder * file, #file name
	    sheet, #sheet name
	    range #cell range
    )
	data = DataFrames.DataFrame(data, :auto)
	# Depurar dataframe
	data = DataFrames.dropmissing(data, :x2)
	data = DataFrames.rename!(
        data, 
        Symbol.(Vector(data[1,:])),
		makeunique = true)[2:end,:]
	names_data = DataFrames.names(data)
	DataFrames.rename!(data, Symbol(names_data[1]) => :Variable)
	DataFrames.filter!(
        row -> !(row.Variable == "Promedio"),  
        data)
	n_months = Base.size(data)[1]
	end_date = Dates.Date(1991,1,1) + Dates.Month(n_months-1)
	data[!, :Fechas] = Base.collect(
		Dates.Date(1991,1,1):Dates.Month(1):end_date
	)
	k = Base.size(data)[2]
	data = data[!, Base.vcat([k], Base.collect(2:(k-1)))]
	c = Base.size(data)[2]
	data = DataFrames.stack(data, 2:c)
    DataFrames.rename!(data, ["Fechas","Variable","Valores"])
	data[!, :Periodicidad] .= "Mes"
	data[!, :Sector] .= "Precios"
	CSV.write(
		"./data/csv/IPC_Regiones.csv",data)
end

function TCN_Diario()
	webfile = "https://www.bch.hn/estadisticos/GIE/LIBTipo%20de%20cambio/Precio%20Promedio%20Diario%20del%20D%C3%B3lar%20.xlsx"
	folder = "./data/xls/"
	file = "TCN_Diario.xlsx"
	sheet = "Tipo de Cambio Diario"
	range = "A1:C1000000"
	Base.download(webfile, folder * file)
	data = XLSX.readdata(
		folder * file, #file name
	    sheet, #sheet name
	    range #cell range
    )
	data = DataFrames.DataFrame(data, :auto)
	# Depurar dataframe
	data = DataFrames.dropmissing(data, :x2)
	data = DataFrames.rename!(
        data, 
        Symbol.(Vector(data[1,:])),
		makeunique = true)[2:end,:]
	DataFrames.rename!(data, ["Fechas","TCN_Diario_Compra","TCN_Diario_Venta"])
	data[!, :Fechas] = StrToDate.(data[!, :Fechas])
	DataFrames.filter!(
        row -> !(row.Fechas == 0),  
        data)
    c = Base.size(data)[2]
    data = DataFrames.stack(data, 2:c)
	DataFrames.rename!(data, ["Fechas","Variable","Valores"])
	data[!, :Periodicidad] .= "Diario"
	data[!, :Sector] .= "Tipo de Cambio"
    CSV.write(
		"./data/csv/TCN_Diario.csv",data)
end

function TCN_Mensual()
	webfile = "https://www.bch.hn/estadisticos/GIE/LIBTipo%20de%20cambio%20Mensual/Precio%20Promedio%20del%20D%C3%B3lar%20-%20Serie%20Mensual.xlsx"
	folder = "./data/xls/"
	file = "TCN_Mensual.xlsx"
	sheet = "Hoja1"
	range = "B1:CZ40"
	Base.download(webfile, folder * file)
	data = XLSX.readdata(
		folder * file, #file name
	    sheet, #sheet name
	    range #cell range
    )
	data = DataFrames.DataFrame(data, :auto)
	# Depurar dataframe
	data = DataFrames.dropmissing(data, :x2)
	data = DataFrames.rename!(
        data, 
        Symbol.(Vector(data[1,:])),
		makeunique = true)[2:end,:]
	DataFrames.filter!(
        row -> !(row.Mes == "Promedio"),  
        data)
	c = Base.size(data)[2]
	data = DataFrames.stack(data, 2:c)
    DataFrames.rename!(data, ["Months","Years","Valores"])
	data = DataFrames.dropmissing(data, :Valores)
	data[!, :Years] = Base.map(s -> s[1:4], data[!, :Years])
	y = Base.parse(Int64,data[end, :Years])
	Fechas = Base.collect(
		Dates.Date(1996,1,1):Dates.Month(1):Dates.Date(y,12,1)
	)
	n = Base.size(data)[1]
	data = Base.hcat(Fechas[1:n],data)
	data = data[!, [1,4]]
    DataFrames.rename!(data, ["Fechas","Valores"])
	data[!, :Variable] .= "TCN_Mensual_Venta"
	data = data[!, [1,3,2]]
	data[!, :Periodicidad] .= "Mes"
	data[!, :Sector] .= "Tipo de Cambio"
	CSV.write(
		"./data/csv/TCN_Mensual.csv",data)
end

function PIB_Enfoque_Produccion()
    # Descargar archivo
    webpage = "https://www.bch.hn/estadisticos/EME/Producto%20Interno%20Bruto%20Anual%20Base%202000/Producto%20Interno%20Bruto%20Enfoque%20de%20la%20Producci%C3%B3n.xls"
    file = "./data/xls/PIB_Enfoque_Produccion.xls"
    sheet = "PIB RAMA"
    Base.download(
        webpage,
        file)
    f = ExcelReaders.openxl(file)
    data = ExcelReaders.readxlsheet(
        file, sheet)
    data = DataFrames.DataFrame(data, :auto)
    names_data = DataFrames.names(data)
    DataFrames.rename!(data, Symbol(names_data[1]) => :Variable)
    # Depurar dataframe
    data = dataframe_clean(data)
	names_data = DataFrames.names(data)
	DataFrames.rename!(data, Symbol(names_data[1]) => :Variable)
    DataFrames.filter!(
        row -> !(row.Variable == "CONCEPTO"),  
        data)
    # Separar datos
	n_years = Int((Base.size(data)[2] - 2) / 2)
    corrientes = data[1:20, 1:(n_years+2)]
    corrientes = resize_data(corrientes)
	corrientes[!, :Tipo_Valores] .= "Corrientes"
    constantes = data[21:40, 1:(n_years+2)]
    constantes = resize_data(constantes)
	constantes[!, :Tipo_Valores] .= "Constantes"
    indices = data[41:60, 1:(n_years+2)]
    indices = resize_data(indices)
	indices[!, :Tipo_Valores] .= "Indices"
    # Unir dataframes
    data = Base.vcat(
        corrientes, constantes, indices)
	data[!, :Fechas] = Base.map(s -> s[1:4], data[!, :Fechas])
	data[!, :Tipo_Valores] .= "Enfoque_Produccion, " .* data[!, :Tipo_Valores]
	data = data[!,[2,1,4,3]]
	data[!, :Fechas] = Dates.Date.(StrToInt(data[!, :Fechas]),1,1)
	data[!, :Periodicidad] .= "Anual"
	data[!, :Sector] .= "Real"
	# Escribir en CSV
    CSV.write("./data/csv/PIB_Enfoque_Produccion.csv", data)
end

function PIB_Enfoque_Gasto()
    # Descargar archivo
    webpage = "https://www.bch.hn/estadisticos/EME/Producto%20Interno%20Bruto%20Anual%20Base%202000/Producto%20Interno%20Bruto%20Enfoque%20del%20Gasto.xls"
    file = "./data/xls/PIB_Enfoque_Gasto.xls"
    sheet = "PIB GASTO "
    Base.download(
        webpage,
        file)
    f = ExcelReaders.openxl(file)
    data = ExcelReaders.readxlsheet(
        file, sheet)
    data = DataFrames.DataFrame(data, :auto)
    # Depurar dataframe
    data = dataframe_clean(data)
	names_data = DataFrames.names(data)
	DataFrames.rename!(data, Symbol(names_data[1]) => :Variable)
    DataFrames.filter!(
        row -> !(row.Variable == "CONCEPTO"),  
        data)
   # Separar datos
	n_years = Int((Base.size(data)[2] - 2) / 2)
    corrientes = data[1:17, 1:(n_years+2)]
    corrientes = resize_data(corrientes)
	corrientes[!, :Tipo_Valores] .= "Corrientes"
    constantes = data[18:34, 1:(n_years+2)]
    constantes = resize_data(constantes)
	constantes[!, :Tipo_Valores] .= "Constantes"
    indices = data[35:51, 1:(n_years+2)]
    indices = resize_data(indices)
	indices[!, :Tipo_Valores] .= "Indices"
    # Unir dataframes
    data = Base.vcat(
        corrientes, constantes, indices)
	data[!, :Fechas] = Base.map(s -> s[1:4], data[!, :Fechas])
	data[!, :Tipo_Valores] .= "Enfoque_Gasto, " .* data[!, :Tipo_Valores]
	data = data[!,[2,1,4,3]]    # Escribir en CSV
	data[!, :Fechas] = Dates.Date.(StrToInt(data[!, :Fechas]),1,1)
	data[!, :Periodicidad] .= "Anual"
	data[!, :Sector] .= "Real"
    CSV.write("./data/csv/PIB_Enfoque_Gasto.csv", data)
end

function PIB_Enfoque_Ingreso()
	# Descargar archivo
	webpage = "https://www.bch.hn/estadisticos/EME/Producto%20Interno%20Bruto%20Anual%20Base%202000/Producto%20Interno%20Bruto%20Enfoque%20del%20Ingreso.xls"
    file = "./data/xls/PIB_Enfoque_Ingreso.xls"
    sheet = "PIB INGRESO serie 00_20"
    Base.download(
        webpage,
        file)
    f = ExcelReaders.openxl(file)
    data = ExcelReaders.readxlsheet(
        file, sheet)
    data = DataFrames.DataFrame(data, :auto)
	# Depurar dataframe
    data = dataframe_clean(data)
	names_data = DataFrames.names(data)
	DataFrames.rename!(data, Symbol(names_data[1]) => :Variable)
	DataFrames.filter!(
		row -> !(row.Variable == "COMPONENTES"),  
		data)
    # Separar datos
	n_years = Int((Base.size(data)[2] - 2) / 2)
    data = data[1:end, 1:(n_years+2)]
	data = resize_data(data)
	data[!, :Fechas] = Base.map(s -> s[1:4], data[!, :Fechas])
	data[!, :Tipo_Valores] .= "Corrientes"
	data[!, :Tipo_Valores] .= "Enfoque_Ingreso, " .* data[!, :Tipo_Valores]
	data = data[!,[2,1,4,3]]
	data[!, :Fechas] = Dates.Date.(StrToInt(data[!, :Fechas]),1,1)
	data[!, :Periodicidad] .= "Anual"
	data[!, :Sector] .= "Real"
    # Escribir en CSV
    CSV.write("./data/csv/PIB_Enfoque_Ingreso.csv", data)
end

function PIB_INPC_L()
    # Descargar archivo
    webpage = "https://www.bch.hn/estadisticos/EME/Producto%20Interno%20Bruto%20Anual%20Base%202000/Producto%20Interno%20Bruto%20e%20Ingreso%20Nacional%20en%20Lempiras.xls"
    file = "./data/xls/PIB_INPC_L.xls"
    sheet = "PIB per cápita en Lps"
    Base.download(
        webpage,
        file)
    f = ExcelReaders.openxl(file)
    data = ExcelReaders.readxlsheet(
        file, sheet)
    data = DataFrames.DataFrame(data, :auto)
    # Depurar dataframe
    data = dataframe_clean(data)
    names_data = DataFrames.names(data)
    DataFrames.rename!(data, Symbol(names_data[1]) => :Variable)
    DataFrames.delete!(data, [1])
    #=DataFrames.filter!(
        row -> !(row.Variable == "#NA"),  
        data)=#
    # Separar datos
    #n_years = Int((Base.size(data)[2] - 2) / 2)
    #data = data[1:end, 1:(n_years+2)]
    data = resize_data(data)
    data[!, :Fechas] = Base.map(s -> s[1:4], data[!, :Fechas])
    data[!, :Tipo_Valores] .= "Corrientes"
	data = data[!,[2,1,4,3]]
	data[!, :Fechas] = Dates.Date.(StrToInt(data[!, :Fechas]),1,1)
	data[!, :Periodicidad] .= "Anual"
	data[!, :Sector] .= "Real"
    # Escribir en CSV
    CSV.write("./data/csv/PIB_INPC_L.csv", data)
end

function PIB_INPC_D()
    # Descargar archivo
    webpage = "https://www.bch.hn/estadisticos/EME/Producto%20Interno%20Bruto%20Anual%20Base%202000/Producto%20Interno%20Bruto%20e%20Ingreso%20Nacional%20en%20D%C3%B3lares.xls"
    file = "./data/xls/PIB_INPC_D.xls"
    sheet = "PIB per-cápita \$"
    Base.download(
        webpage,
        file)
    f = ExcelReaders.openxl(file)
    data = ExcelReaders.readxlsheet(
        file, sheet)
    data = DataFrames.DataFrame(data, :auto)
    # Depurar dataframe
    data = dataframe_clean(data)
    names_data = DataFrames.names(data)
    DataFrames.rename!(data, Symbol(names_data[1]) => :Variable)
    DataFrames.delete!(data, [1])
    #=DataFrames.filter!(
        row -> !(row.Variable == "#NA"),  
        data)=#
    # Separar datos
    #n_years = Int((Base.size(data)[2] - 2) / 2)
    #data = data[1:end, 1:(n_years+2)]
    data = resize_data(data)
    data[!, :Fechas] = Base.map(s -> s[1:4], data[!, :Fechas])
    data[!, :Tipo_Valores] .= "Corrientes"
    data = data[!,[2,1,4,3]]
	data[!, :Fechas] = Dates.Date.(StrToInt(data[!, :Fechas]),1,1)
	data[!, :Periodicidad] .= "Anual"
	data[!, :Sector] .= "Real"
    # Escribir en CSV
    CSV.write("./data/csv/PIB_INPC_D.csv", data)
end

function Oferta_Demanda()
    # Descargar archivo
    webpage = "https://www.bch.hn/estadisticos/EME/Producto%20Interno%20Bruto%20Anual%20Base%202000/Oferta%20y%20Demanda%20Agregada.xls"
    file = "./data/xls/Oferta_Demanda_Global.xls"
    sheet = "O D "
    Base.download(
        webpage,
        file)
    f = ExcelReaders.openxl(file)
    data = ExcelReaders.readxlsheet(
        file, sheet)
    data = DataFrames.DataFrame(data, :auto)
    # Depurar dataframe
    data = dataframe_clean(data)
    names_data = DataFrames.names(data)
    DataFrames.rename!(data, Symbol(names_data[1]) => :Variable)
	DataFrames.filter!(
		row -> !(row.Variable == "#NA"),  
		data)
   	DataFrames.filter!(
		row -> !(row.Variable == "CONCEPTO"),  
		data)
    # Separar datos
    n_years = Int((Base.size(data)[2] - 2) / 2)
    data = data[1:end, 1:(n_years+2)]
    data = resize_data(data)
    data[!, :Fechas] = Base.map(s -> s[1:4], data[!, :Fechas])
    data[!, :Tipo_Valores] .= "Corrientes"
	data = data[!,[2,1,4,3]]
	data[!, :Fechas] = Dates.Date.(StrToInt(data[!, :Fechas]),1,1)
	data[!, :Periodicidad] .= "Anual"
	data[!, :Sector] .= "Real"
    # Escribir en CSV
    CSV.write("./data/csv/Oferta_Demanda.csv", data)
end

function VAB_Agro()
    # Descargar archivo
    webpage = "https://www.bch.hn/estadisticos/EME/Producto%20Interno%20Bruto%20Anual%20Base%202000/Valor%20Agregado%20Bruto%20Agropecuario.xlsx"
	folder = "./data/xls/"
    file = "VAB_Agro.xlsx"
    sheet = "VAB Agricultura"
	range = "B1:BZ100"
    Base.download(
        webpage,
        folder * file)
    data = XLSX.readdata(
		folder * file, #file name
	    sheet, #sheet name
	    range #cell range
    )
    data = DataFrames.DataFrame(data, :auto)
 	data = DataFrames.dropmissing(data, :x2)
	data = data[:, StatsBase.mean.(ismissing, eachcol(data)) .< 0.1]
	DataFrames.rename!(
        data, 
        Symbol.(Vector(data[1,:])),
		makeunique = true)[2:end,:]
	names_data = DataFrames.names(data)
    DataFrames.rename!(data, Symbol(names_data[1]) => :Variable)
	data = data[2:end, :]
    # Separar datos
	n_years = Int((Base.size(data)[2] - 2) / 2)
    corrientes = data[1:15, 1:(n_years+2)]
    corrientes = resize_data(corrientes)
	corrientes[!, :Tipo_Valores] .= "Corrientes"
    constantes = data[16:30, 1:(n_years+2)]
    constantes = resize_data(constantes)
	constantes[!, :Tipo_Valores] .= "Constantes"
    # Unir dataframes
    data = Base.vcat(
        corrientes, constantes)
	data[!, :Fechas] = Base.map(s -> s[1:4], data[!, :Fechas])
	constantes[!, :Tipo_Valores] .= "Produccion, " .* constantes[!, :Tipo_Valores]
	data = data[:, [2,1,4,3]]
	data[!, :Fechas] = Dates.Date.(StrToInt(data[!, :Fechas]),1,1)
	data[!, :Periodicidad] .= "Anual"
	data[!, :Sector] .= "Real"
    # Escribir en CSV
    CSV.write("./data/csv/VAB_Agro.csv", data)
end

function VAB_Manufactura()
    # Descargar archivo
    webpage = "https://www.bch.hn/estadisticos/EME/Producto%20Interno%20Bruto%20Anual%20Base%202000/Valor%20Agregado%20Bruto%20Manufactura.xlsx"
	folder = "./data/xls/"
    file = "VAB_Manufactura.xlsx"
    sheet = "VAB Manufactura"
	range = "B1:BZ100"
    Base.download(
        webpage,
        folder * file)
    data = XLSX.readdata(
		folder * file, #file name
	    sheet, #sheet name
	    range #cell range
    )
    data = DataFrames.DataFrame(data, :auto)
 	data = DataFrames.dropmissing(data, :x2)
	data = data[:, StatsBase.mean.(ismissing, eachcol(data)) .< 0.1]
	DataFrames.rename!(
        data, 
        Symbol.(Vector(data[1,:])),
		makeunique = true)[2:end,:]
	names_data = DataFrames.names(data)
    DataFrames.rename!(data, Symbol(names_data[1]) => :Variable)
	data = data[2:end, :]
    # Separar datos
	n_years = Int((Base.size(data)[2] - 2) / 2)
    corrientes = data[1:16, 1:(n_years+2)]
    corrientes = resize_data(corrientes)
	corrientes[!, :Tipo_Valores] .= "Corrientes"
    constantes = data[17:32, 1:(n_years+2)]
    constantes = resize_data(constantes)
	constantes[!, :Tipo_Valores] .= "Constantes"
    # Unir dataframes
    data = Base.vcat(
        corrientes, constantes)
	data[!, :Fechas] = Base.map(s -> s[1:4], data[!, :Fechas])
	data = data[:, [2,1,4,3]]
	data[!, :Fechas] = Dates.Date.(StrToInt(data[!, :Fechas]),1,1)
	data[!, :Periodicidad] .= "Anual"
	data[!, :Sector] .= "Real"
    # Escribir en CSV
    CSV.write("./data/csv/VAB_Manufactura.csv", data)
end

function Imae_Original_TC()
	#=
	webfile = "https://www.bch.hn/estadisticos/EME/ndice%20Mensual%20de%20Actividad%20Econmica%20Serie/Serie%20Indice%20Mensual%20de%20Actividad%20Economica.xlsx?d=w45efc3a92b72451a9b3ee6a8ba57a52d"
	=#
	folder = "./data/xls/"
	file = "Serie Indice Mensual de Actividad Economica.xlsx"
	#Base.download(webfile, folder * file)
	sheet = "Cuadro 1"
	range = "A1:BZ1000000"
	data = XLSX.readdata(
		folder * file, #file name
	    sheet, #sheet name
	    range #cell range
    )
	data = DataFrames.DataFrame(data, :auto)
	# Depurar dataframe
	data = DataFrames.dropmissing(data, :x3)
	data = data[:, StatsBase.mean.(ismissing, eachcol(data)) .< 0.25]
	data = data[3:end, [1,2,5]]
	DataFrames.rename!(data, ["Mes","IMAE_Original","IMAE_TC"])
	x = 1999 + Base.ceil(Base.size(data)[1] / 12)
	Fechas = Base.collect(
		Dates.Date(2000,1,1):Dates.Month(1):Dates.Date(x,12,1)
	)
	n = Base.size(data)[1]
	data = Base.hcat(Fechas[1:n],data)
	data = data[!, [1,3,4]]
    names_data = DataFrames.names(data)
	DataFrames.rename!(data, Symbol(names_data[1]) => :Fechas)
    c = Base.size(data)[2]
    data = DataFrames.stack(data, 2:c)
	DataFrames.rename!(data, ["Fechas","Variable","Valores"])
	data[!, :Periodicidad] .= "Mes"
	data[!, :Sector] .= "Real"
	CSV.write(
		"./data/csv/Imae_Original_TC.csv",data)
end

function Imae_Actividad()
	#=
	webfile = "https://www.bch.hn/estadisticos/EME/ndice%20Mensual%20de%20Actividad%20Econmica%20Serie/Serie%20Indice%20Mensual%20de%20Actividad%20Economica.xlsx?d=w45efc3a92b72451a9b3ee6a8ba57a52d"
	=#
	folder = "./data/xls/"
	file = "Serie Indice Mensual de Actividad Economica.xlsx"
	#Base.download(webfile, folder * file)
	sheet = "Cuadro 2"
	range = "A1:BZ1000000"
	data = XLSX.readdata(
		folder * file, #file name
	    sheet, #sheet name
	    range #cell range
    )
	data = DataFrames.DataFrame(data, :auto)
	# Depurar dataframe
	data = DataFrames.dropmissing(data, :x3)
	data = data[:, StatsBase.mean.(ismissing, eachcol(data)) .< 0.1]
	DataFrames.rename!(
        data, 
        Symbol.(Vector(data[1,:])),
		makeunique = true)[2:(end-1),:]
	data = data[2:end, :]
	x = 1999 + Base.ceil(Base.size(data)[1] / 12)
	Fechas = Base.collect(
		Dates.Date(2000,1,1):Dates.Month(1):Dates.Date(x,12,1)
	)
	n = Base.size(data)[1]
	data = Base.hcat(Fechas[1:n],data)
	k = Base.size(data)[2]
	data = data[!, Base.vcat([1], Base.collect(3:k))]
    names_data = DataFrames.names(data)
	DataFrames.rename!(data, Symbol(names_data[1]) => :Fechas)
	c = Base.size(data)[2]
	data = DataFrames.stack(data, 2:c)
	DataFrames.rename!(data, ["Fechas","Variable","Valores"])
	data[!, :Periodicidad] .= "Mes"
	data[!, :Sector] .= "Real"
	CSV.write(
		"./data/csv/Imae_Actividad.csv",data)
end

function Balanza_Bienes_Trimestral()
	# Descargar archivo
	webpage = "https://www.bch.hn/estadisticos/EME/Balanza%20de%20bienes/Balanza%20de%20Bienes%20trimestral.xlsx"
	folder = "./data/xls/"
    file = "Balanza_Bienes_Trimestral.xlsx"
    sheet = "B.1.2"
	range = "A5:GZ200"
    Base.download(
        webpage,
        folder * file)
	data = XLSX.readdata(
		folder * file, #file name
	    sheet, #sheet name
	    range #cell range
    )
    data = DataFrames.DataFrame(data, :auto)
	# Depurar dataframe
    data = DataFrames.dropmissing(data, :x3)
	data = data[:, mean.(ismissing, eachcol(data)) .< 0.1]
    DataFrames.rename!(
        data, 
        Symbol.(Vector(data[1,:])),
		makeunique = true)[2:end,:]
	data = DataFrames.filter(
        row -> (row.I != data[1,2]),  
        data)
	c = Base.size(data)[2] ÷ 5
	dc = (Base.collect(1:c) .* 5 .+ 1)
	DataFrames.select!(data,Not(dc))
	names_data = DataFrames.names(data)
	m = Base.collect((1:(c*4+3)))
	Fechas = string.(Base.collect(Dates.Date(2004,3,1):Dates.Month(3):(
			Dates.Date(2004,3,1) + Dates.Quarter(Base.size(data)[2]-2))))
	names = vcat("Variable",Fechas)
	DataFrames.rename!(data, names)
	k = Base.size(data)[2]
	data = DataFrames.stack(data, 2:k)
	DataFrames.rename!(data, ["Variable","Fechas","Valores"])
	data = data[!,[2,1,3]]
	data[!,:Fechas] = Dates.Date.(data[!,:Fechas])
	data
	data[!, :Periodicidad] .= "Trimestral"
	data[!, :Sector] .= "Externo"
    # Escribir en CSV
    CSV.write("./data/csv/Balanza_Bienes_Trimestral.csv", data)
end

function Balanza_Bienes_Anual()
	# Descargar archivo
	webpage = "https://www.bch.hn/estadisticos/EME/Balanza%20de%20bienes/Balanza%20de%20Bienes%20anual.xlsx"
	folder = "./data/xls/"
    file = "Balanza_Bienes_Anual.xlsx"
    sheet = "B.1.1"
	range = "A5:GZ200"
    Base.download(
        webpage,
        folder * file)
	data = XLSX.readdata(
		folder * file, #file name
	    sheet, #sheet name
	    range #cell range
    )
    data = DataFrames.DataFrame(data, :auto)
	# Depurar dataframe
    data = DataFrames.dropmissing(data, :x2)
	data = data[:, mean.(ismissing, eachcol(data)) .< 0.1]
    	data = data[:, StatsBase.mean.(ismissing, eachcol(data)) .< 0.1]
	DataFrames.rename!(
        data, 
        Symbol.(Vector(data[1,:])),
		makeunique = true)[2:(end-1),:]
	data = data[2:end, :]
	k = Base.size(data)[2]
	data = DataFrames.stack(data, 2:k)
	DataFrames.rename!(data, ["Variable","Fechas","Valores"])
	data = data[!,[2,1,3]]
	data[!, :Fechas] = Base.map(s -> s[1:4], data[!, :Fechas])
	data[!,:Fechas] = Dates.Date.(StrToInt.(data[!,:Fechas]),1,1)
	data[!, :Periodicidad] .= "Anual"
	data = data[data[!,:Variable] .!== "IMPORTACIONES", :]#DataFramesMeta.@where(data, :Variable !== "IMPORTACIONES")
	data[!, :Sector] .= "Externo"
    # Escribir en CSV
    CSV.write("./data/csv/Balanza_Bienes_Anual.csv", data)
end

function Exportaciones_Mercancias_Trimestral()
	# Descargar archivo
	webpage = "https://www.bch.hn/estadisticos/EME/Exportaciones%20Trim/Exportaciones%20FOB%20Mercanc%C3%ADas%20Generales%20trimestral.xlsx"
	folder = "./data/xls/"
    file = "Exportaciones_Mercancias_Trimestral.xlsx"
    sheet = "B.1.7"
	ranges = "A5:FZ200"
    Base.download(
        webpage,
        folder * file)
	data = XLSX.readdata(
		folder * file, #file name
	    sheet, #sheet name
	    ranges #cell range
    )
    data = DataFrames.DataFrame(data, :auto)
	r = Base.size(data)[1]
	c = Base.size(data)[2]
	data = data[4:r,:]
	data
	# Depurar dataframe
	var1 = data[2,1]
	for i in 3:5
		data[i,1] = var1 * ": " * data[i,1]
	end
	var1 = data[6,1]
	for i in 7:11
		data[i,1] = var1 * ": " * data[i,1]
	end
	rx = Base.size(data)[1]
	for i in 13:(rx-4)
		for j in 1:3
			if ismissing.(data[i-j,2]) .== true #&& ismissing.(data[i+1,2]) .== true
				datax = data[i-j,1]
				data[i,1] = datax * ": " * data[i,1]
			end
		end
	end
	data = DataFrames.dropmissing(data, :x2)
	r = Base.size(data)[1]
	data[r-2,1] = "SUB-TOTAL"
	data[r-1,1] = "OTROS PRODUCTOS"
	data[r,1] = "TOTAL MERCANCÍAS GENERALES"
    DataFrames.rename!(
        data, 
        Symbol.(Vector(data[1,:])),
		makeunique = true)[2:end,:]
	r = Base.size(data)[1]
	data = data[2:r,:]
	names_data = DataFrames.names(data)
	DataFrames.rename!(
		data, vcat("Variable", Base.collect(names_data[2:Base.size(names_data)[1]])))
	data = data[!, DataFrames.Not(r"missing")]
	data = data[!, DataFrames.Not(r"2008")]
	c = Base.size(data)[2]
	Fechas = string.(Base.collect(Dates.Date(2004,3,1):Dates.Month(3):(
			Dates.Date(2004,3,1) + Dates.Quarter(c-2))))
	data
	DataFrames.rename!(
		data, vcat("Variable", Base.collect(Fechas)))
	data
	c = Base.size(data)[2]
	data = DataFrames.stack(data, 2:c)
	DataFrames.rename!(data, ["Variable","Fechas","Valores"])
	data = data[!,[2,1,3]]
	data[!,:Fechas] = Dates.Date.(data[!,:Fechas])
	data
	data[!, :Periodicidad] .= "Trimestral"
	data[!, :Sector] .= "Externo"
    # Escribir en CSV
    CSV.write("./data/csv/Exportaciones_Mercancias_Trimestral.csv", data)
	data
end

function Exportaciones_Otros_Trimestral()
	# Descargar archivo
	webpage = "https://www.bch.hn/estadisticos/EME/Exportaciones%20Trim/Exportaciones%20FOB%20Otros%20Productos%20trimestral.xlsx"
	folder = "./data/xls/"
    file = "Exportaciones_Otros_Trimestral.xlsx"
    sheet = "B.1.9"
	ranges = "A5:FZ200"
    Base.download(
        webpage,
        folder * file)
	data = XLSX.readdata(
		folder * file, #file name
	    sheet, #sheet name
	    ranges #cell range
    )
    data = DataFrames.DataFrame(data, :auto)
	r = Base.size(data)[1]
	c = Base.size(data)[2]
	data = data[4:r,:]
	data
	# Depurar dataframe
	var1 = data[2,1]
	data[3,1] = var1 * ": " * data[3,1]
	rx = Base.size(data)[1]
	for i in 4:(rx-1)
		for j in 1:3
			if ismissing.(data[i-j,2]) .== true #&& ismissing.(data[i+1,2]) .== true
				datax = data[i-j,1]
				data[i,1] = datax * ": " * data[i,1]
			end
		end
	end
	data
	data = DataFrames.dropmissing(data, :x2)
	r = Base.size(data)[1]
	data
	data[r-2,1] = "SUB-TOTAL OTROS PRODUCTOS"
	data[r-1,1] = "LOS DEMAS OTROS PRODUCTOS"
	data[r,1] = "TOTAL OTROS PRODUCTOS"
    DataFrames.rename!(
        data, 
        Symbol.(Vector(data[1,:])),
		makeunique = true)[2:end,:]
	r = Base.size(data)[1]
	data = data[2:r,:]
	names_data = DataFrames.names(data)
	DataFrames.rename!(
		data, vcat("Variable", Base.collect(names_data[2:Base.size(names_data)[1]])))
	data = data[!, DataFrames.Not(r"missing")]
	data = data[!, DataFrames.Not(r"2008")]
	c = Base.size(data)[2]
	Fechas = string.(Base.collect(Dates.Date(2004,3,1):Dates.Month(3):(
			Dates.Date(2004,3,1) + Dates.Quarter(c-2))))
	data
	DataFrames.rename!(
		data, vcat("Variable", Base.collect(Fechas)))
	data
	c = Base.size(data)[2]
	data = DataFrames.stack(data, 2:c)
	DataFrames.rename!(data, ["Variable","Fechas","Valores"])
	data = data[!,[2,1,3]]
	data[!,:Fechas] = Dates.Date.(data[!,:Fechas])
	data
	data[!, :Periodicidad] .= "Trimestral"
	data[!, :Sector] .= "Externo"
    # Escribir en CSV
    CSV.write("./data/csv/Exportaciones_Otros_Trimestral.csv", data)
	data#==#
end

function Exportaciones_Bienes_Transformacion_Trimestral()
	# Descargar archivo
	webpage = "https://www.bch.hn/estadisticos/EME/Exportaciones%20Trim/Exportaciones%20FOB%20Bienes%20para%20Transformaci%C3%B3n%20trimestral.xlsx"
	folder = "./data/xls/"
    file = "Exportaciones_Bienes_Transformacion_Trimestral.xlsx"
    sheet = "Hoja1"
	ranges = "A5:FZ200"
    Base.download(
        webpage,
        folder * file)
	data = XLSX.readdata(
		folder * file, #file name
	    sheet, #sheet name
	    ranges #cell range
    )
    data = DataFrames.DataFrame(data, :auto)
	r = Base.size(data)[1]
	c = Base.size(data)[2]
	data = data[4:r,:]
	data
	# Depurar dataframe
	data = DataFrames.dropmissing(data, :x2)
    DataFrames.rename!(
        data, 
        Symbol.(Vector(data[1,:])),
		makeunique = true)[2:end,:]
	r = Base.size(data)[1]
	data = data[2:r,:]
	names_data = DataFrames.names(data)
	DataFrames.rename!(
		data, vcat("Variable", Base.collect(names_data[2:Base.size(names_data)[1]])))
	data = data[!, DataFrames.Not(r"missing")]
	#data = data[!, DataFrames.Not(r"2008")]
	c = Base.size(data)[2]
	Fechas = string.(Base.collect(Dates.Date(2004,3,1):Dates.Month(3):(
			Dates.Date(2004,3,1) + Dates.Quarter(c-2))))
	data
	DataFrames.rename!(
		data, vcat("Variable", Base.collect(Fechas)))
	data
	c = Base.size(data)[2]
	data = DataFrames.stack(data, 2:c)
	DataFrames.rename!(data, ["Variable","Fechas","Valores"])
	data = data[!,[2,1,3]]
	data[!,:Fechas] = Dates.Date.(data[!,:Fechas])
	data
	data[!, :Periodicidad] .= "Trimestral"
	data[!, :Sector] .= "Externo"
    # Escribir en CSV
    CSV.write("./data/csv/Exportaciones_Bienes_Transformacion_Trimestral.csv", data)
end

function Exportaciones_Mercancias_Anual()
	# Descargar archivo
	webpage = "https://www.bch.hn/estadisticos/EME/Exportaciones%20Anuales/Exportaciones%20FOB%20Mercanc%C3%ADas%20Generales%20anual.xlsx"
	folder = "./data/xls/"
    file = "Exportaciones_Mercancias_Anual.xlsx"
    sheet = "B.1.3"
	ranges = "A5:FZ200"
    Base.download(
        webpage,
        folder * file)
	data = XLSX.readdata(
		folder * file, #file name
	    sheet, #sheet name
	    ranges #cell range
    )
    data = DataFrames.DataFrame(data, :auto)
	r = Base.size(data)[1]
	c = Base.size(data)[2]
	data = data[3:r,:]
    DataFrames.rename!(
        data, 
        Symbol.(Vector(data[1,:])),
		makeunique = true)[2:end,:]
	r = Base.size(data)[1]
	data = data[2:r,:]	
	data
	# Depurar dataframe
	var1 = data[2,1]
	for i in 3:5
		data[i,1] = var1 * ": " * data[i,1]
	end
	var1 = data[6,1]
	for i in 7:11
		data[i,1] = var1 * ": " * data[i,1]
	end
	rx = Base.size(data)[1]
	for i in 13:(rx-4)
		for j in 1:3
			if ismissing.(data[i-j,2]) .== true #&& ismissing.(data[i+1,2]) .== true
				datax = data[i-j,1]
				data[i,1] = datax * ": " * data[i,1]
			end
		end
	end
	data = DataFrames.dropmissing(data, 3)
	r = Base.size(data)[1]
	data[r-2,1] = "SUB-TOTAL"
	data[r-1,1] = "OTROS PRODUCTOS"
	data[r,1] = "TOTAL MERCANCÍAS GENERALES"
	names_data = DataFrames.names(data)
	DataFrames.rename!(data, names_data[1] => :Variable)
	data = data[!, DataFrames.Not(r"Variac")]
	data = data[!, DataFrames.Not(r"Particip")]
	data = data[!, DataFrames.Not(r"missing")]
	c = Base.size(data)[2]
	data = DataFrames.stack(data, 2:c)
	DataFrames.rename!(data, ["Variable","Fechas","Valores"])
	data = data[!,[2,1,3]]
	data[!, :Fechas] = Base.map(s -> s[1:4], data[!, :Fechas])
	data[!, :Fechas] = Dates.Date.(StrToInt(data[!, :Fechas]),1,1)
	data[!,:Fechas] = Dates.Date.(data[!,:Fechas])
	data
	data[!, :Periodicidad] .= "Anual"
	data[!, :Sector] .= "Externo"
    # Escribir en CSV
    CSV.write("./data/csv/Exportaciones_Mercancias_Anual.csv", data)
	data
end

function Exportaciones_Otros_Anual()
	# Descargar archivo
	webpage = "https://www.bch.hn/estadisticos/EME/Exportaciones%20Anuales/Exportaciones%20FOB%20Otros%20Productos%20anual.xlsx"
	folder = "./data/xls/"
    file = "Exportaciones_Otros_Anual.xlsx"
    sheet = "B.1.5"
	ranges = "A5:FZ200"
    Base.download(
        webpage,
        folder * file)
	data = XLSX.readdata(
		folder * file, #file name
	    sheet, #sheet name
	    ranges #cell range
    )
    data = DataFrames.DataFrame(data, :auto)
	r = Base.size(data)[1]
	c = Base.size(data)[2]
	data = data[3:r,:]
    DataFrames.rename!(
        data, 
        Symbol.(Vector(data[1,:])),
		makeunique = true)[2:end,:]
	r = Base.size(data)[1]
	data = data[2:r,:]	
	# Depurar dataframe
	var1 = data[2,1]
	data[3,1] = var1 * ": " * data[3,1]
	data[4,1] = var1 * ": " * data[4,1]
	rx = Base.size(data)[1]
	data
	for i in 5:(rx-1)
		for j in 1:3
			if ismissing.(data[i-j,2]) .== true
				datax = data[i-j,1]
				data[i,1] = datax * ": " * data[i,1]
			end
		end
	end
	data
	data = DataFrames.dropmissing(data, 3)
	r = Base.size(data)[1]
	data[r-2,1] = "SUB-TOTAL"
	data[r-1,1] = "OTROS PRODUCTOS"
	data[r,1] = "TOTAL MERCANCÍAS GENERALES"
	names_data = DataFrames.names(data)
	DataFrames.rename!(data, names_data[1] => :Variable)
	data = data[!, DataFrames.Not(r"Variac")]
	data = data[!, DataFrames.Not(r"Particip")]
	data = data[!, DataFrames.Not(r"missing")]
	c = Base.size(data)[2]
	data = DataFrames.stack(data, 2:c)
	DataFrames.rename!(data, ["Variable","Fechas","Valores"])
	data = data[!,[2,1,3]]
	data[!, :Fechas] = Base.map(s -> s[1:4], data[!, :Fechas])
	data[!, :Fechas] = Dates.Date.(StrToInt(data[!, :Fechas]),1,1)
	data[!,:Fechas] = Dates.Date.(data[!,:Fechas])
	data
	data[!, :Periodicidad] .= "Anual"
	data[!, :Sector] .= "Externo"
    # Escribir en CSV
    CSV.write("./data/csv/Exportaciones_Otros_Anual.csv", data)
end

function Exportaciones_Bienes_Transformacion_Anual()
	# Descargar archivo
	webpage = "https://www.bch.hn/estadisticos/EME/Exportaciones%20Anuales/Exportaciones%20FOB%20Bienes%20para%20Transformaci%C3%B3n%20anual.xlsx"
	folder = "./data/xls/"
    file = "Exportaciones_Bienes_Transformacion_Anual.xlsx"
    sheet = "B.1.4"
	ranges = "A5:FZ200"
    Base.download(
        webpage,
        folder * file)
	data = XLSX.readdata(
		folder * file, #file name
	    sheet, #sheet name
	    ranges #cell range
    )
    data = DataFrames.DataFrame(data, :auto)
	r = Base.size(data)[1]
	c = Base.size(data)[2]
	data = data[4:r,:]
	data
	# Depurar dataframe
	data = DataFrames.dropmissing(data, :x2)
    DataFrames.rename!(
        data, 
        Symbol.(Vector(data[1,:])),
		makeunique = true)[2:end,:]
	r = Base.size(data)[1]
	data = data[2:r,:]
	data = data[!, DataFrames.Not(r"/")]
	names_data = DataFrames.names(data)
	DataFrames.rename!(
		data, vcat("Variable", Base.collect(names_data[2:Base.size(names_data)[1]])))
	data = data[!, DataFrames.Not(r"missing")]
	data = data[!, DataFrames.Not(r"_1")]
	c = Base.size(data)[2]
	data = data[!,1:(c-3)]
	c = Base.size(data)[2]
	data = DataFrames.stack(data, 2:c)
	DataFrames.rename!(data, ["Variable","Fechas","Valores"])
	data = data[!,[2,1,3]]
	data.Fechas .= DataFrames.replace.(data.Fechas, r" " => "")
	data[!, :Fechas] = Base.map(s -> s[1:4], data[!, :Fechas])
	data[!, :Fechas] = Dates.Date.(StrToInt(data[!, :Fechas]),1,1)
	data[!,:Fechas] = Dates.Date.(data[!,:Fechas])
	data
	data[!, :Periodicidad] .= "Anual"
	data[!, :Sector] .= "Externo"
    # Escribir en CSV
    CSV.write("./data/csv/Exportaciones_Bienes_Transformacion_Anual.csv", data)
end

function Importaciones_Mercancias_Trimestral()
	# Descargar archivo
	webpage = "https://www.bch.hn/estadisticos/EME/Importaciones%20Trimestrales/Importaciones%20CIF%20Mercanc%C3%ADas%20Generales%20COUDE%20trimestral.xlsx"
	folder = "./data/xls/"
    file = "Importaciones_Mercancias_Trimestral.xlsx"
    sheet = "B.1.17"
	ranges = "A5:FZ200"
    Base.download(
        webpage,
        folder * file)
	data = XLSX.readdata(
		folder * file, #file name
	    sheet, #sheet name
	    ranges #cell range
    )
    data = DataFrames.DataFrame(data, :auto)
	r = Base.size(data)[1]
	c = Base.size(data)[2]
	data = data[4:r,:]
	data = DataFrames.dropmissing(data, :x2)
    DataFrames.rename!(
        data, 
        Symbol.(Vector(data[1,:])),
		makeunique = true)[2:end,:]
	names_data = DataFrames.names(data)
	DataFrames.rename!(
		data, vcat("Variable", Base.collect(names_data[2:Base.size(names_data)[1]])))
	r = Base.size(data)[1]
	data = data[2:r,:]
	data = data[!, DataFrames.Not(r"missing")]
	c = Base.size(data)[2]
	Fechas = string.(Base.collect(Dates.Date(2004,3,1):Dates.Month(3):(
			Dates.Date(2004,3,1) + Dates.Quarter(c-2))))
	DataFrames.rename!(
		data, vcat("Variable", Base.collect(Fechas)))
	data
	c = Base.size(data)[2]
	data = DataFrames.stack(data, 2:c)
	DataFrames.rename!(data, ["Variable","Fechas","Valores"])
	data = data[!,[2,1,3]]
	data[!,:Fechas] = Dates.Date.(data[!,:Fechas])
	data
	data[!, :Periodicidad] .= "Trimestral"
	data[!, :Sector] .= "Externo"
    # Escribir en CSV
    CSV.write("./data/csv/Importaciones_Mercancias_Trimestral.csv", data)
end

function Importaciones_Mercancias_Seccion_Trimestral()
	# Descargar archivo
	webpage = "https://www.bch.hn/estadisticos/EME/Importaciones%20Trimestrales/Importaciones%20CIF%20Mercanc%C3%ADas%20Generales%20Secci%C3%B3n%20trimestral.xlsx"
	folder = "./data/xls/"
    file = "Importaciones_Mercancias_Seccion_Trimestral.xlsx"
    sheet = "B.1.16"
	ranges = "A5:FZ200"
    Base.download(
        webpage,
        folder * file)
	data = XLSX.readdata(
		folder * file, #file name
	    sheet, #sheet name
	    ranges #cell range
    )
    data = DataFrames.DataFrame(data, :auto)
	r = Base.size(data)[1]
	c = Base.size(data)[2]
	data = data[4:r,:]
	data = DataFrames.dropmissing(data, :x2)
    DataFrames.rename!(
        data, 
        Symbol.(Vector(data[1,:])),
		makeunique = true)[2:end,:]
	names_data = DataFrames.names(data)
	DataFrames.rename!(
		data, vcat("Variable", Base.collect(names_data[2:Base.size(names_data)[1]])))
	r = Base.size(data)[1]
	data = data[2:r,:]
	data = data[!, DataFrames.Not(r"missing")]
	data = data[!, DataFrames.Not(r"2007")]
	c = Base.size(data)[2]
	Fechas = string.(Base.collect(Dates.Date(2004,3,1):Dates.Month(3):(
			Dates.Date(2004,3,1) + Dates.Quarter(c-2))))
	DataFrames.rename!(
		data, vcat("Variable", Base.collect(Fechas)))
	data
	c = Base.size(data)[2]
	data = DataFrames.stack(data, 2:c)
	DataFrames.rename!(data, ["Variable","Fechas","Valores"])
	data = data[!,[2,1,3]]
	data[!,:Fechas] = Dates.Date.(data[!,:Fechas])
	data
	data[!, :Periodicidad] .= "Trimestral"
	data[!, :Sector] .= "Externo"
    # Escribir en CSV
    CSV.write("./data/csv/Importaciones_Mercancias_Seccion_Trimestral.csv", data)
end

function Importaciones_Combustibles_Trimestral()
	# Descargar archivo
	webpage = "https://www.bch.hn/estadisticos/EME/Importaciones%20Trimestrales/Importaciones%20CIF%20Combustibles%20trimestral.xlsx"
	folder = "./data/xls/"
    file = "Importaciones_Combustibles_Trimestral.xlsx"
    sheet = "B.1.18"
	ranges = "A5:FZ200"
    Base.download(
        webpage,
        folder * file)
	data = XLSX.readdata(
		folder * file, #file name
	    sheet, #sheet name
	    ranges #cell range
    )
    data = DataFrames.DataFrame(data, :auto)
	r = Base.size(data)[1]
	c = Base.size(data)[2]
	data = data[4:r,:]
		var1 = data[2,1]
    DataFrames.rename!(
        data, 
        Symbol.(Vector(data[1,:])),
		makeunique = true)[2:end,:]
	r = Base.size(data)[1]
	data = data[2:r,:]
	names_data = DataFrames.names(data)
	DataFrames.rename!(
		data, vcat("Variable", Base.collect(names_data[2:Base.size(names_data)[1]])))
	data = data[!, DataFrames.Not(r"missing")]
	data = DataFrames.dropmissing(data, :Variable)
	var1 = data[1,1]
	for i in 2:4
		data[i,1] = var1 * ": " * data[i,1]
	end
	rx = Base.size(data)[1]
	for i in 6:(rx-4)
		for j in 1:3
			if ismissing.(data[i-j,2]) .== true #&& ismissing.(data[i+1,2]) .== true
				datax = data[i-j,1]
				data[i,1] = datax * ": " * data[i,1]
			end
		end
	end
	c = Base.size(data)[2]
	Fechas = string.(Base.collect(Dates.Date(2004,3,1):Dates.Month(3):(
			Dates.Date(2004,3,1) + Dates.Quarter(c-2))))
	DataFrames.rename!(
		data, vcat("Variable", Base.collect(Fechas)))
	names_data = DataFrames.names(data)
	data = DataFrames.dropmissing(data, names_data[2])
	r = Base.size(data)[1]
	data[r-1,1] = "ENERGIA ELECTRICA"
	data[r,1] = "TOTAL COMBUSTIBLES, LUBRICANTES Y ENERGIA ELECTRICA"
	c = Base.size(data)[2]
	data = DataFrames.stack(data, 2:c)
	DataFrames.rename!(data, ["Variable","Fechas","Valores"])
	data = data[!,[2,1,3]]
	data[!,:Fechas] = Dates.Date.(data[!,:Fechas])
	data
	data[!, :Periodicidad] .= "Trimestral"
	data[!, :Sector] .= "Externo"
    # Escribir en CSV
    CSV.write("./data/csv/Importaciones_Combustibles_Trimestral.csv", data)
end

function csv_ingresos()
	## 2022
	webfile = "https://www.bch.hn/operativos/INTL/LIBREPORTESINFORMES/Balanza%20Cambiaria%202022.xlsx"
	folder = "./data/xls/"
	xlname = "Balanza Cambiaria 2022.xlsx"
	sheet = "BalanzaCambiaria"
	range = "A4:D33"
	Base.download(webfile, folder * xlname)
	Fechas = Dates.Date(2022,1,1)
	#=
	Fechas = Base.collect(
		Dates.Date(2022,1,1):Dates.Month(1):Dates.Date(2022,12,1)
	)
	=#
	data = XLSX.readdata(
		folder * xlname, 
		sheet, 
		range)
	data = data[:, Not(2:3)]
	data = DataFrames.DataFrame(data, :auto)
	DataFrames.rename!(data, ["Concepto", string(Fechas)])
	data = DataFrames.stack(data, 2)
	#=
	DataFrames.rename!(
		data2022, vcat("Concepto", Base.collect(string.(Fechas))))
	data2022 = DataFrames.stack(data2022, 2:13)
	=#
	DataFrames.rename!(data, ["Concepto","Fechas","Monto"])
	CSV.write(folder * "ingresos2022.csv", data)
	
	## 2021
	webfile = "https://www.bch.hn/operativos/INTL/LIBREPORTESINFORMES/Balanza%20Cambiaria%202021.xlsx"
	folder = "./data/xls/"
	xlname = "Balanza Cambiaria 2021.xlsx"
	sheet = "BalanzaCambiaria"
	range = "A4:P33"
	Base.download(webfile, folder * xlname)
	Fechas = Base.collect(
		Dates.Date(2021,1,1):Dates.Month(1):Dates.Date(2021,12,1)
	)
	data = XLSX.readdata(
		folder * xlname, 
		sheet, 
		range)
	data = data[:, Not(2:3)]
	data = data[:, Not(9)]
	data = DataFrames.DataFrame(data, :auto)
	DataFrames.rename!(
		data, vcat("Concepto", Base.collect(string.(Fechas))))
	data = DataFrames.stack(data, 2:13)
	DataFrames.rename!(data, ["Concepto","Fechas","Monto"])
	CSV.write(folder * "ingresos2021.csv", data)

	## 2020
	webfile = "https://www.bch.hn/operativos/INTL/LIBREPORTESINFORMES/Balanza%20Cambiaria%202020.xlsx"
	folder = "./data/xls/"
	xlname = "Balanza Cambiaria 2020.xlsx"
	sheet = "rptBalanzaCambiariaIdioma"
	range = "A4:O34"
	Base.download(webfile, folder * xlname)
	Fechas = Base.collect(
		Dates.Date(2020,1,1):Dates.Month(1):Dates.Date(2020,12,1)
	)
	data = XLSX.readdata(
		folder * xlname, 
		sheet, 
		range)
	data = data[:, Not(2:3)]
	data = DataFrames.DataFrame(data, :auto)
	DataFrames.rename!(
		data, vcat("Concepto", Base.collect(string.(Fechas))))
	data = DataFrames.stack(data, 2:13)
	DataFrames.rename!(data, ["Concepto","Fechas","Monto"])
	CSV.write(folder * "ingresos2020.csv", data)

	## 2019
	webfile = "https://www.bch.hn/operativos/INTL/LIBREPORTESINFORMES/Balanza%20Cambiaria%202019.xlsx"
	folder = "./data/xls/"
	xlname = "Balanza Cambiaria 2019.xlsx"
	sheet = "rptBalanzaCambiariaIdioma"
	range = "A4:O34"
	Base.download(webfile, folder * xlname)
	Fechas = Base.collect(
		Dates.Date(2019,1,1):Dates.Month(1):Dates.Date(2019,12,1)
	)
	data = XLSX.readdata(
		folder * xlname, 
		sheet, 
		range)
	data = data[:, Not(2:3)]
	data = DataFrames.DataFrame(data, :auto)
	DataFrames.rename!(
		data, vcat("Concepto", Base.collect(string.(Fechas))))
	data = DataFrames.stack(data, 2:13)
	DataFrames.rename!(data, ["Concepto","Fechas","Monto"])
	CSV.write(folder * "ingresos2019.csv", data)

	## 2018
	webfile = "https://www.bch.hn/operativos/INTL/LIBREPORTESINFORMES/Balanza%20Cambiaria%202018.xlsx"
	folder = "./data/xls/"
	xlname = "Balanza Cambiaria 2018.xlsx"
	sheet = "rptBalanzaCambiariaIdioma"
	range = "A4:O34"
	Base.download(webfile, folder * xlname)
	Fechas = Base.collect(
		Dates.Date(2018,1,1):Dates.Month(1):Dates.Date(2018,12,1)
	)
	data = XLSX.readdata(
		folder * xlname, 
		sheet, 
		range)
	data = data[:, Not(2:3)]
	data = DataFrames.DataFrame(data, :auto)
	DataFrames.rename!(
		data, vcat("Concepto", Base.collect(string.(Fechas))))
	data = DataFrames.stack(data, 2:13)
	DataFrames.rename!(data, ["Concepto","Fechas","Monto"])
	CSV.write(folder * "ingresos2018.csv", data)

	## 2017
	webfile = "https://www.bch.hn/operativos/INTL/LIBREPORTESINFORMES/Balanza%20Cambiaria%202017.xlsx"
	folder = "./data/xls/"
	xlname = "Balanza Cambiaria 2017.xlsx"
	sheet = "rptBalanzaCambiariaIdioma"
	range = "A4:N33"
	Base.download(webfile, folder * xlname)
	Fechas = Base.collect(
		Dates.Date(2017,1,1):Dates.Month(1):Dates.Date(2017,12,1)
	)
	data = XLSX.readdata(
		folder * xlname, 
		sheet, 
		range)
	data = data[:, Not(2)]
	data = DataFrames.DataFrame(data, :auto)
	DataFrames.rename!(
		data, vcat("Concepto", Base.collect(string.(Fechas))))
	data = DataFrames.stack(data, 2:13)
	DataFrames.rename!(data, ["Concepto","Fechas","Monto"])
	CSV.write(folder * "ingresos2017.csv", data)

	## 2016
	webfile = "https://www.bch.hn/operativos/INTL/LIBREPORTESINFORMES/Balanza%20Cambiaria%202016.xls"
	folder = "./data/xls/"
	xlname = "Balanza Cambiaria 2016.xls"
	sheet = "ING-EGR15 Español"
	range = "B13:N43"
	Base.download(webfile, folder * xlname)
	Fechas = Base.collect(
		Dates.Date(2016,1,1):Dates.Month(1):Dates.Date(2016,12,1)
	)
	f = ExcelReaders.openxl(folder * xlname)
	data = ExcelReaders.readxl(
		f, 
		sheet * "!" *
		range)
	data = DataFrames.DataFrame(data, :auto)
	DataFrames.rename!(
		data, vcat("Concepto", Base.collect(string.(Fechas))))
	data = DataFrames.stack(data, 2:13)
	DataFrames.rename!(data, ["Concepto","Fechas","Monto"])
	CSV.write(folder * "ingresos2016.csv", data)

	## 2015
	webfile = "https://www.bch.hn/operativos/INTL/LIBREPORTESINFORMES/Balanza%20Cambiaria%202015.xls"
	folder = "./data/xls/"
	xlname = "Balanza Cambiaria 2015.xls"
	sheet = "ING-EGR15 Español"
	range = "D15:P45"
	Base.download(webfile, folder * xlname)
	Fechas = Base.collect(
		Dates.Date(2015,1,1):Dates.Month(1):Dates.Date(2015,12,1)
	)
	f = ExcelReaders.openxl(folder * xlname)
	data = ExcelReaders.readxl(
		f, 
		sheet * "!" *
		range)
	data = DataFrames.DataFrame(data, :auto)
	DataFrames.rename!(
		data, vcat("Concepto", Base.collect(string.(Fechas))))
	data = DataFrames.stack(data, 2:13)
	DataFrames.rename!(data, ["Concepto","Fechas","Monto"])
	CSV.write(folder * "ingresos2015.csv", data)

	## 2014
	webfile = "https://www.bch.hn/operativos/INTL/LIBREPORTESINFORMES/Balanza%20Cambiaria%202014.xls"
	folder = "./data/xls/"
	xlname = "Balanza Cambiaria 2014.xls"
	sheet = "ING-EGR12 Español"
	range = "D15:P45"
	Base.download(webfile, folder * xlname)
	Fechas = Base.collect(
		Dates.Date(2014,1,1):Dates.Month(1):Dates.Date(2014,12,1)
	)
	f = ExcelReaders.openxl(folder * xlname)
	data = ExcelReaders.readxl(
		f, 
		sheet * "!" *
		range)
	data = DataFrames.DataFrame(data, :auto)
	DataFrames.rename!(
		data, vcat("Concepto", Base.collect(string.(Fechas))))
	data = DataFrames.stack(data, 2:13)
	DataFrames.rename!(data, ["Concepto","Fechas","Monto"])
	CSV.write(folder * "ingresos2014.csv", data)

	## 2013
	webfile = "https://www.bch.hn/operativos/INTL/LIBREPORTESINFORMES/Balanza%20Cambiaria%202013.xls"
	folder = "./data/xls/"
	xlname = "Balanza Cambiaria 2013.xls"
	sheet = "ING-EGR12 Español"
	range = "D15:P45"
	Base.download(webfile, folder * xlname)
	Fechas = Base.collect(
		Dates.Date(2013,1,1):Dates.Month(1):Dates.Date(2013,12,1)
	)
	f = ExcelReaders.openxl(folder * xlname)
	data = ExcelReaders.readxl(
		f, 
		sheet * "!" *
		range)
	data = DataFrames.DataFrame(data, :auto)
	DataFrames.rename!(
		data, vcat("Concepto", Base.collect(string.(Fechas))))
	data = DataFrames.stack(data, 2:13)
	DataFrames.rename!(data, ["Concepto","Fechas","Monto"])
	CSV.write(folder * "ingresos2013.csv", data)

	## 2012
	webfile = "https://www.bch.hn/operativos/INTL/LIBREPORTESINFORMES/Balanza%20Cambiaria%202012.xls"
	folder = "./data/xls/"
	xlname = "Balanza Cambiaria 2012.xls"
	sheet = "ING-EGR12 Español"
	range = "D11:P41"
	Base.download(webfile, folder * xlname)
	Fechas = Base.collect(
		Dates.Date(2012,1,1):Dates.Month(1):Dates.Date(2012,12,1)
	)
	f = ExcelReaders.openxl(folder * xlname)
	data = ExcelReaders.readxl(
		f, 
		sheet * "!" *
		range)
	data = DataFrames.DataFrame(data, :auto)
	DataFrames.rename!(
		data, vcat("Concepto", Base.collect(string.(Fechas))))
	data = DataFrames.stack(data, 2:13)
	DataFrames.rename!(data, ["Concepto","Fechas","Monto"])
	CSV.write(folder * "ingresos2012.csv", data)

	## 2011
	webfile = "https://www.bch.hn/operativos/INTL/LIBREPORTESINFORMES/Balanza%20Cambiaria%202011.xls"
	folder = "./data/xls/"
	xlname = "Balanza Cambiaria 2011.xls"
	sheet = "ING-EGR10 Español"
	range = "D11:P41"
	Base.download(webfile, folder * xlname)
	Fechas = Base.collect(
		Dates.Date(2011,1,1):Dates.Month(1):Dates.Date(2011,12,1)
	)
	f = ExcelReaders.openxl(folder * xlname)
	data = ExcelReaders.readxl(
		f, 
		sheet * "!" *
		range)
	data = DataFrames.DataFrame(data, :auto)
	DataFrames.rename!(
		data, vcat("Concepto", Base.collect(string.(Fechas))))
	data = DataFrames.stack(data, 2:13)
	DataFrames.rename!(data, ["Concepto","Fechas","Monto"])
	CSV.write(folder * "ingresos2011.csv", data)

	## 2010
	webfile = "https://www.bch.hn/operativos/INTL/LIBREPORTESINFORMES/Balanza%20Cambiaria%202010.xls"
	folder = "./data/xls/"
	xlname = "Balanza Cambiaria 2010.xls"
	sheet = "2010"
	range = "D10:P40"
	Base.download(webfile, folder * xlname)
	Fechas = Base.collect(
		Dates.Date(2010,1,1):Dates.Month(1):Dates.Date(2010,12,1)
	)
	f = ExcelReaders.openxl(folder * xlname)
	data = ExcelReaders.readxl(
		f, 
		sheet * "!" *
		range)
	data = DataFrames.DataFrame(data, :auto)
	DataFrames.rename!(
		data, vcat("Concepto", Base.collect(string.(Fechas))))
	data = DataFrames.stack(data, 2:13)
	DataFrames.rename!(data, ["Concepto","Fechas","Monto"])
	CSV.write(folder * "ingresos2010.csv", data)

	## 2009
	webfile = "https://www.bch.hn/operativos/INTL/LIBREPORTESINFORMES/Balanza%20Cambiaria%202009.xls"
	folder = "./data/xls/"
	xlname = "Balanza Cambiaria 2009.xls"
	sheet = "Balanza Cambiaria 2009"
	range = "A13:M43"
	Base.download(webfile, folder * xlname)
	Fechas = Base.collect(
		Dates.Date(2009,1,1):Dates.Month(1):Dates.Date(2009,12,1)
	)
	f = ExcelReaders.openxl(folder * xlname)
	data = ExcelReaders.readxl(
		f, 
		sheet * "!" *
		range)
	data = DataFrames.DataFrame(data, :auto)
	DataFrames.rename!(
		data, vcat("Concepto", Base.collect(string.(Fechas))))
	data = DataFrames.stack(data, 2:13)
	DataFrames.rename!(data, ["Concepto","Fechas","Monto"])
	CSV.write(folder * "ingresos2009.csv", data)

	## 2008
	webfile = "https://www.bch.hn/operativos/INTL/LIBREPORTESINFORMES/Balanza%20Cambiaria%202008.xls"
	folder = "./data/xls/"
	xlname = "Balanza Cambiaria 2008.xls"
	sheet = "ING-EGR08"
	range = "A12:M41"
	Base.download(webfile, folder * xlname)
	Fechas = Base.collect(
		Dates.Date(2008,1,1):Dates.Month(1):Dates.Date(2008,12,1)
	)
	f = ExcelReaders.openxl(folder * xlname)
	data = ExcelReaders.readxl(
		f, 
		sheet * "!" *
		range)
	data = DataFrames.DataFrame(data, :auto)
	DataFrames.rename!(
		data, vcat("Concepto", Base.collect(string.(Fechas))))
	data = DataFrames.stack(data, 2:13)
	DataFrames.rename!(data, ["Concepto","Fechas","Monto"])
	CSV.write(folder * "ingresos2008.csv", data)

	## 2007
	webfile = "https://www.bch.hn/operativos/INTL/LIBREPORTESINFORMES/Balanza%20Cambiaria%202007.xls"
	folder = "./data/xls/"
	xlname = "Balanza Cambiaria 2007.xls"
	sheet = "ING-EGR07"
	range = "A12:M41"
	Base.download(webfile, folder * xlname)
	Fechas = Base.collect(
		Dates.Date(2007,1,1):Dates.Month(1):Dates.Date(2007,12,1)
	)
	f = ExcelReaders.openxl(folder * xlname)
	data = ExcelReaders.readxl(
		f, 
		sheet * "!" *
		range)
	data = DataFrames.DataFrame(data, :auto)
	DataFrames.rename!(
		data, vcat("Concepto", Base.collect(string.(Fechas))))
	data = DataFrames.stack(data, 2:13)
	DataFrames.rename!(data, ["Concepto","Fechas","Monto"])
	CSV.write(folder * "ingresos2007.csv", data)

	## 2006
	webfile = "https://www.bch.hn/operativos/INTL/LIBREPORTESINFORMES/Balanza%20Cambiaria%202006.xls"
	folder = "./data/xls/"
	xlname = "Balanza Cambiaria 2006.xls"
	sheet = "ING-EGR06"
	range = "A12:M41"
	Base.download(webfile, folder * xlname)
	Fechas = Base.collect(
		Dates.Date(2006,1,1):Dates.Month(1):Dates.Date(2006,12,1)
	)
	f = ExcelReaders.openxl(folder * xlname)
	data = ExcelReaders.readxl(
		f, 
		sheet * "!" *
		range)
	data = DataFrames.DataFrame(data, :auto)
	DataFrames.rename!(
		data, vcat("Concepto", Base.collect(string.(Fechas))))
	data = DataFrames.stack(data, 2:13)
	DataFrames.rename!(data, ["Concepto","Fechas","Monto"])
	CSV.write(folder * "ingresos2006.csv", data)

	## 2000-2005
	webfile = "https://www.bch.hn/operativos/INTL/LIBREPORTESINFORMES/Balanza%20Cambiaria%202000-2006.xls"
	folder = "./data/xls/"
	xlname = "Balanza Cambiaria 2000-2006.xls"

	## 2005
	sheet = "BALANZA CAMBIARIA 2005"
	range = "A14:M43"
	Base.download(webfile, folder * xlname)
	Fechas = Base.collect(
		Dates.Date(2005,1,1):Dates.Month(1):Dates.Date(2005,12,1)
	)
	f = ExcelReaders.openxl(folder * xlname)
	data = ExcelReaders.readxl(
		f, 
		sheet * "!" *
		range)
	data = DataFrames.DataFrame(data, :auto)
	DataFrames.rename!(
		data, vcat("Concepto", Base.collect(string.(Fechas))))
	data = DataFrames.stack(data, 2:13)
	DataFrames.rename!(data, ["Concepto","Fechas","Monto"])
	CSV.write(folder * "ingresos2005.csv", data)

	## 2004
	sheet = "BALANZA CAMBIARIA 2004"
	range = "A13:M42"
	Base.download(webfile, folder * xlname)
	Fechas = Base.collect(
		Dates.Date(2004,1,1):Dates.Month(1):Dates.Date(2004,12,1)
	)
	f = ExcelReaders.openxl(folder * xlname)
	data = ExcelReaders.readxl(
		f, 
		sheet * "!" *
		range)
	data = DataFrames.DataFrame(data, :auto)
	DataFrames.rename!(
		data, vcat("Concepto", Base.collect(string.(Fechas))))
	data = DataFrames.stack(data, 2:13)
	DataFrames.rename!(data, ["Concepto","Fechas","Monto"])
	CSV.write(folder * "ingresos2004.csv", data)

	## 2003
	sheet = "BALANZA CAMBIARIA 2003"
	range = "A13:M42"
	Base.download(webfile, folder * xlname)
	Fechas = Base.collect(
		Dates.Date(2003,1,1):Dates.Month(1):Dates.Date(2003,12,1)
	)
	f = ExcelReaders.openxl(folder * xlname)
	data = ExcelReaders.readxl(
		f, 
		sheet * "!" *
		range)
	data = DataFrames.DataFrame(data, :auto)
	DataFrames.rename!(
		data, vcat("Concepto", Base.collect(string.(Fechas))))
	data = DataFrames.stack(data, 2:13)
	DataFrames.rename!(data, ["Concepto","Fechas","Monto"])
	CSV.write(folder * "ingresos2003.csv", data)

	## 2002
	sheet = "BALANZA CAMBIARIA 2002"
	range = "A12:M39"
	Base.download(webfile, folder * xlname)
	Fechas = Base.collect(
		Dates.Date(2002,1,1):Dates.Month(1):Dates.Date(2002,12,1)
	)
	f = ExcelReaders.openxl(folder * xlname)
	data = ExcelReaders.readxl(
		f, 
		sheet * "!" *
		range)
	data = DataFrames.DataFrame(data, :auto)
	DataFrames.rename!(
		data, vcat("Concepto", Base.collect(string.(Fechas))))
	data = DataFrames.stack(data, 2:13)
	DataFrames.rename!(data, ["Concepto","Fechas","Monto"])
	CSV.write(folder * "ingresos2002.csv", data)

	## 2001
	sheet = "BALANZA CAMBIARIA 2001"
	range = "A13:M40"
	Base.download(webfile, folder * xlname)
	Fechas = Base.collect(
		Dates.Date(2001,1,1):Dates.Month(1):Dates.Date(2001,12,1)
	)
	f = ExcelReaders.openxl(folder * xlname)
	data = ExcelReaders.readxl(
		f, 
		sheet * "!" *
		range)
	data = DataFrames.DataFrame(data, :auto)
	DataFrames.rename!(
		data, vcat("Concepto", Base.collect(string.(Fechas))))
	data = DataFrames.stack(data, 2:13)
	DataFrames.rename!(data, ["Concepto","Fechas","Monto"])
	CSV.write(folder * "ingresos2001.csv", data)

	## 2000
	sheet = "BALANZA CAMBIARIA 2000"
	range = "A13:M40"
	Base.download(webfile, folder * xlname)
	Fechas = Base.collect(
		Dates.Date(2000,1,1):Dates.Month(1):Dates.Date(2000,12,1)
	)
	f = ExcelReaders.openxl(folder * xlname)
	data = ExcelReaders.readxl(
		f, 
		sheet * "!" *
		range)
	data = DataFrames.DataFrame(data, :auto)
	DataFrames.rename!(
		data, vcat("Concepto", Base.collect(string.(Fechas))))
	data = DataFrames.stack(data, 2:13)
	DataFrames.rename!(data, ["Concepto","Fechas","Monto"])
	CSV.write(folder * "ingresos2000.csv", data)
end

function BalCam_Ingresos()
    csv_ingresos()
	years = Base.collect(2000:2022)
	n = Base.size(years)[1]
	data = DataFrames.DataFrame(
			Concepto = String[],
			Fechas = Date[],
			Monto = Float64[])
	for i = 1:n
		df_year = CSV.read(
			"./data/xls/ingresos" * string(years[i]) * ".csv",
			DataFrames.DataFrame)
	    DataFrames.append!(data, 
			df_year
		)
	end
	DataFrames.rename!(data, ["Variable","Fechas","Valores"])
	data.Variable .= Base.uppercase.(data.Variable)
	data = data[!,[2,1,3]]
	data[!, :Periodicidad] .= "Mes"
	data[!, :Sector] .= "Externo"
	CSV.write(
		"./data/csv/BalCam_Ingresos.csv",data)
end

function ticks_dynamic(df)
	tick_years = Dates.Date.(df.Fechas)
	DateTick = Dates.format.(tick_years, "uuu-yyyy")
	Plots.plot!(
		xgrid = false,
		xticks = (tick_years, DateTick),
		framestyle = :zerolines,
		nticks = 1,
		#xrot=60,
		xtickfontsize = 1)
end