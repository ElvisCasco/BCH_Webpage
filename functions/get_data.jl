function resize_data(df)
    df = DataFrames.stack(
        df, 
        Not(:Variable))
    DataFrames.rename!(
        df, 
        ["Variable","Fechas","Montos"])
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
	data[!, :Enfoque] .= "Produccion"
    # Escribir en CSV
    CSV.write("./data/csv/PIB_Enfoque_Produccion.csv", data)
    data
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
	data[!, :Enfoque] .= "Gasto"
    # Escribir en CSV
    CSV.write("./data/csv/PIB_Enfoque_Gasto.csv", data)
    data
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
	data[!, :Enfoque] .= "Ingreso"
    # Escribir en CSV
    CSV.write("./data/csv/PIB_Enfoque_Ingreso.csv", data)
    data
end