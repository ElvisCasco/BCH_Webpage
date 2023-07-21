function IPC()
    webpage = "https://www.bch.hn/estadisticos/GIE/LIBSeries%20IPC/Serie%20Mensual%20y%20Promedio%20Anual%20del%20%C3%8Dndice%20de%20Precios%20al%20Consumidor.xls"
    # Usando R para leer archivo xls
    data = open_file_r1(webpage)
    data = DataFrames.DataFrame(data)
    # Depurar dataframe
    data = DataFrames.dropmissing(data, DataFrames.names(data)[2])
    data = DataFrames.rename!(
        data,
        Symbol.(Vector(data[1,:])),
        makeunique = true)[2:(end-1),:]
    n_years = Int((Base.size(data)[2] - 2) / 2)
    data = data[!, 1:(n_years+2)]
    c = Base.size(data)[2]
    data = DataFrames.stack(data, 2:c)
    DataFrames.rename!(data, ["Months","Years","Valores"])
    data = DataFrames.dropmissing(data, DataFrames.names(data)[3])
    A = Vector{Union{String}}(data[!, :Years])
    A = StrToFloat(A)
    data[!, :Years] = int.(A)
	if size(data[!,:Months])[1] % 12 == 0
		mes = 12
	else
    	mes = size(data[!,:Months])[1] % 12
	end
    y = data[end, :Years]
    Fechas = Base.collect(
        Dates.Date(1999,1,1):Dates.Month(1):Dates.Date(y,mes,1)
    )
    data = Base.hcat(Fechas,data)
    data = data[!, [1,4]]
    DataFrames.rename!(data, ["Fechas","Valores"])
    data = DataFrames.dropmissing(data, :Valores)
    data[!, :Variable] .= "IPC"
    data = data[!, [1,3,2]]
    data[!, :Periodicidad] .= "Mensual"
    data[!, :Grupo] .= "Precios"
    data[!, :Tipo_Valores] .= "Índices, Base Diciembre 1999"
    data[!, :Fuente] .= "https://www.bch.hn/estadisticas-y-publicaciones-economicas/publicaciones-de-precios/series-ipc"
    # CSV.write(
    #     wd * "/Data/CSV/IPC.csv",
    #     data;
    #     delim = ";")
    return data
end


function IPC_Rubros()
    webpage = "https://www.bch.hn/estadisticos/GIE/LIBSERIE%20IPC%20RUBROS/Serie%20Mensual%20y%20Promedio%20Anual%20del%20%C3%8Dndice%20de%20Precios%20al%20Consumidor%20por%20Rubros.xlsx"
    # Usando R para leer archivo xls
    data = open_file_r1(webpage)    
    data = DataFrames.DataFrame(data)
    # Depurar dataframe
    data = DataFrames.dropmissing(data, names(data)[2])
    data = data[:, mean.(ismissing, eachcol(data)) .< 0.1]
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
    data[!,:Valores] = StrToFloat.(data[!,:Valores])
    data[!,:Variable] = Vector{Union{String}}(data[!,:Variable])
    data[!, :Periodicidad] .= "Mensual"
    data[!, :Grupo] .= "Precios"
    data[!, :Tipo_Valores] .= "Índices, Base Diciembre 1999"
    data[!, :Fuente] .= "https://www.bch.hn/estadisticas-y-publicaciones-economicas/publicaciones-de-precios/series-ipc"
    # CSV.write(
    #     wd * "/data/csv/IPC_Rubros.csv",
    #     data;
    #     delim = ";")
    return data
end


function IPC_Regiones()
    webpage = "https://www.bch.hn/estadisticos/GIE/LIBSerie%20IPC%20Region/Serie%20Mensual%20y%20Promedio%20Anual%20del%20%C3%8Dndice%20de%20Precios%20al%20Consumidor%20por%20Regi%C3%B3n.xlsx"
    # Usando R para leer archivo xls
    data = open_file_r1(webpage)    
    data = DataFrames.DataFrame(data)
    # Depurar dataframe
    data = DataFrames.dropmissing(data, names(data)[2])
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
    data[!,:Valores] = StrToFloat.(data[!,:Valores])
    data[!,:Variable] = Vector{Union{String}}(data[!,:Variable])
    data[!, :Periodicidad] .= "Mensual"
    data[!, :Grupo] .= "Precios"
    data[!, :Tipo_Valores] .= "Índices, Base Diciembre 1999"
    data[!, :Fuente] .= "https://www.bch.hn/estadisticas-y-publicaciones-economicas/publicaciones-de-precios/series-ipc"
    DataFrames.filter!(
        row -> !(row.Variable == "ÍNDICE GENERAL"),
        data)
    # CSV.write(
    #     wd * "/data/csv/IPC_Regiones.csv",
    #     data;
    #     delim = ";")
    return data
end


function TCN_Diario()
    webpage = "https://www.bch.hn/estadisticos/GIE/LIBTipo%20de%20cambio/Precio%20Promedio%20Diario%20del%20D%C3%B3lar.xlsx"
    # Usando R para leer archivo xls
    data = open_file_r1(webpage)    
    data = DataFrames.DataFrame(data)
    # Depurar dataframe
    data = DataFrames.dropmissing(data, names(data)[2])
    data = data[:, mean.(ismissing, eachcol(data)) .< 0.1]
    data = DataFrames.rename!(
        data,
        Symbol.(Vector(data[1,:])),
        makeunique = true)[2:end,:]
    DataFrames.rename!(data, ["Fechas","TCN_Diario_Compra","TCN_Diario_Venta"])
    data[!, :Fechas] = XlToDate.(data[!, :Fechas])
    data = DataFrames.dropmissing(data, :Fechas)
    DataFrames.filter!(
        row -> !(row.Fechas <= Dates.Date("2000-01-01")),
        data)
    data[!,:TCN_Diario_Compra] = StrToFloat.(data[!,:TCN_Diario_Compra])
    data[!,:TCN_Diario_Venta] = StrToFloat.(data[!,:TCN_Diario_Venta])
    c = Base.size(data)[2]
    data = DataFrames.stack(data, 2:c)
    DataFrames.rename!(data, ["Fechas","Variable","Valores"])
    data[!,:Variable] = Vector{Union{String}}(data[!,:Variable])
    data[!, :Periodicidad] .= "Diario"
    data[!, :Grupo] .= "Tipo de Cambio"
    data[!, :Tipo_Valores] .= "Lempiras x 1USD"
    data[!, :Fuente] .= "https://www.bch.hn/estadisticas-y-publicaciones-economicas/tipo-de-cambio-nominal"
    # CSV.write(
    #     wd * "/data/csv/TCN_Diario.csv",
    #     data;
    #     delim = ";")
    return data
end


function TCN_Mensual()
    webpage = "https://www.bch.hn/estadisticos/GIE/LIBTipo%20de%20cambio%20Mensual/Tipo%20de%20Cambio%20Serie%20Mensual.xlsx"
    # Usando R para leer archivo xls
    data = open_file_r1(webpage)    
    data = DataFrames.DataFrame(data)
    # Depurar dataframe
    data = DataFrames.dropmissing(data, DataFrames.names(data)[2])
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
    A = Vector{Union{String}}(data[!, :Years])
    A = StrToFloat(A)
    data[!, :Years] = int.(A)
    y = data[end, :Years]
	if size(data[!,:Months])[1] % 12 == 0
		mes = 12
	else
    	mes = size(data[!,:Months])[1] % 12
	end
    Fechas = Base.collect(
        Dates.Date(1996,1,1):Dates.Month(1):Dates.Date(y,mes,1)
    )
    n = Base.size(data)[1]
    data = Base.hcat(Fechas[1:n],data)
    data = data[!, [1,4]]
    DataFrames.rename!(data, ["Fechas","Valores"])
    data[!, :Variable] .= "TCN_Mensual_Venta"
    data = data[!, [1,3,2]]
    data[!, :Periodicidad] .= "Mensual"
    data[!, :Grupo] .= "Tipo de Cambio"
    data[!, :Tipo_Valores] .= "Lempiras x 1USD"
    data[!, :Fuente] .= "https://www.bch.hn/estadisticas-y-publicaciones-economicas/tipo-de-cambio-nominal"
    # CSV.write(
    #     wd * "/data/csv/TCN_Mensual.csv",
    #     data;
    #     delim = ";")
    return data
end


function PIB_Enfoque_Produccion()
    # Descargar archivo
    webpage = "https://www.bch.hn/estadisticos/EME/Producto%20Interno%20Bruto%20Anual%20Base%202000/Producto%20Interno%20Bruto%20Enfoque%20de%20la%20Producci%C3%B3n.xls"
    # Usando R para leer archivo xls
    data = open_file_r1(webpage)    
    data = DataFrames.DataFrame(data)
    # Depurar dataframe
    data = DataFrames.dropmissing(data, DataFrames.names(data)[2])
    DataFrames.rename!(
        data,
        Symbol.(Vector(data[1,:])))[2:end,:]
    names_data = DataFrames.names(data)
    DataFrames.rename!(data, Symbol(names_data[1]) => :Variable)
    DataFrames.filter!(
        row -> !(row.Variable == "CONCEPTO"),
        data)
    # Separar datos
    n_years = Int((Base.size(data)[2] - 2) / 2)
    corrientes = data[1:20, 1:(n_years+2)]
    n_cols = size(corrientes)[2]
    corrientes = DataFrames.stack(corrientes, 2:n_cols)
    DataFrames.rename!(corrientes,["Variable","Fechas","Valores"])
    corrientes = DataFrames.dropmissing(corrientes, DataFrames.names(corrientes)[2])
    corrientes[!, :Tipo_Valores] .= "Corrientes, Millones de Lempiras"
    constantes = data[21:40, 1:(n_years+2)]
    n_cols = size(constantes)[2]
    constantes = DataFrames.stack(constantes, 2:n_cols)
    DataFrames.rename!(constantes,["Variable","Fechas","Valores"])
    constantes = DataFrames.dropmissing(constantes, DataFrames.names(constantes)[2])
    constantes[!, :Tipo_Valores] .= "Constantes, Millones de Lempiras"
    indices = data[41:60, 1:(n_years+2)]
    n_cols = size(indices)[2]
    indices = DataFrames.stack(indices, 2:n_cols)
    DataFrames.rename!(indices,["Variable","Fechas","Valores"])
    indices = DataFrames.dropmissing(indices, DataFrames.names(indices)[2])
    indices[!, :Tipo_Valores] .= "Índices"
    # Unir dataframes
    data = Base.vcat(
        corrientes, constantes, indices)
    data[!, :Fechas] = Vector{Union{String}}(data[!, :Fechas])
    data[!, :Fechas] = replace_text.(data[!, :Fechas], "p/")
    data[!, :Fechas] = StrToFloat.(data[!, :Fechas])
    data[!, :Fechas] = Int.(data[!, :Fechas])
    data[!, :Fechas] = Dates.Date.(data[!, :Fechas],1,1)
    data[!, :Tipo_Valores] .= "Enfoque_Produccion, " .* data[!, :Tipo_Valores]
    data[!, :Periodicidad] .= "Anual"
    data[!, :Grupo] .= "Real, Enfoque_Producción"
    data[!, :Fuente] .= "https://www.bch.hn/estadisticas-y-publicaciones-economicas/Grupo-real/cuentas-nacionales-anuales/producto-interno-bruto-(base-2000)"
    data = data[!,[2,1,3,5,6,4,7]]
    # Escribir en CSV
    # CSV.write(
    #     wd * "/data/csv/PIB_Enfoque_Produccion.csv",
    #     data;
    #     delim = ";")
    return data
end


function PIB_Enfoque_Gasto()
    # Descargar archivo
    webpage = "https://www.bch.hn/estadisticos/EME/Producto%20Interno%20Bruto%20Anual%20Base%202000/Producto%20Interno%20Bruto%20Enfoque%20del%20Gasto.xls"
    # Usando R para leer archivo xls
    data = open_file_r1(webpage)
    data = DataFrames.DataFrame(data)
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
    n_cols = size(corrientes)[2]
    corrientes = DataFrames.stack(corrientes, 2:n_cols)
    DataFrames.rename!(corrientes,["Variable","Fechas","Valores"])
    corrientes = DataFrames.dropmissing(corrientes, DataFrames.names(corrientes)[2])
    corrientes[!, :Tipo_Valores] .= "Corrientes, Millones de Lempiras"
    constantes = data[18:34, 1:(n_years+2)]
    n_cols = size(constantes)[2]
    constantes = DataFrames.stack(constantes, 2:n_cols)
    DataFrames.rename!(constantes,["Variable","Fechas","Valores"])
    constantes = DataFrames.dropmissing(constantes, DataFrames.names(constantes)[2])
    constantes[!, :Tipo_Valores] .= "Constantes, Millones de Lempiras"
    indices = data[35:51, 1:(n_years+2)]
    n_cols = size(indices)[2]
    indices = DataFrames.stack(indices, 2:n_cols)
    DataFrames.rename!(indices,["Variable","Fechas","Valores"])
    indices = DataFrames.dropmissing(indices, DataFrames.names(indices)[2])
    indices[!, :Tipo_Valores] .= "Índices"
    # Unir dataframes
    data = Base.vcat(
        corrientes, constantes, indices)
    data[!, :Fechas] = Vector{Union{String}}(data[!, :Fechas])
    data[!, :Fechas] = replace_text.(data[!, :Fechas], "p/")
    data[!, :Fechas] = StrToFloat.(data[!, :Fechas])
    data[!, :Fechas] = Int.(data[!, :Fechas])
    data[!, :Fechas] = Dates.Date.(data[!, :Fechas],1,1)
    data[!, :Tipo_Valores] .= "Enfoque_Gasto, " .* data[!, :Tipo_Valores]
    data[!, :Periodicidad] .= "Anual"
    data[!, :Grupo] .= "Real, Enfoque_Gasto"
    data[!, :Fuente] .= "https://www.bch.hn/estadisticas-y-publicaciones-economicas/Grupo-real/cuentas-nacionales-anuales/producto-interno-bruto-(base-2000)"
    data = data[!,[2,1,3,5,6,4,7]]    
    # Escribir en CSV
    # CSV.write(
    #     wd * "/data/csv/PIB_Enfoque_Gasto.csv",
    #     data;
    #     delim = ";")
    return data
end


function PIB_Enfoque_Ingreso()
    # Descargar archivo
    webpage = "https://www.bch.hn/estadisticos/EME/Producto%20Interno%20Bruto%20Anual%20Base%202000/Producto%20Interno%20Bruto%20Enfoque%20del%20Ingreso.xls"
    # Usando R para leer archivo xls
    data = open_file_r1(webpage)
    data = DataFrames.DataFrame(data)
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
    data[!, :Fechas] = Vector{Union{String}}(data[!, :Fechas])
    data[!, :Fechas] = replace_text.(data[!, :Fechas], "p/")
    data[!, :Fechas] = StrToFloat.(data[!, :Fechas])
    data[!, :Fechas] = Int.(data[!, :Fechas])
    data[!, :Fechas] = Dates.Date.(data[!, :Fechas],1,1)
    data[!, :Tipo_Valores] .= "Corrientes, Millones de Lempiras"
    data[!, :Tipo_Valores] .= "Enfoque_Ingreso" .* data[!, :Tipo_Valores]
    data[!, :Periodicidad] .= "Anual"
    data[!, :Grupo] .= "Real, Enfoque_Ingreso"
    data[!, :Fuente] .= "https://www.bch.hn/estadisticas-y-publicaciones-economicas/Grupo-real/cuentas-nacionales-anuales/producto-interno-bruto-(base-2000)"
    data = data[!,[2,1,3,5,6,4,7]]
    # Escribir en CSV
    # CSV.write(
    #     wd * "/data/csv/PIB_Enfoque_Ingreso.csv",
    #     data;
    #     delim = ";")
    return data
end


function PIB_INPC_L()
    # Descargar archivo
    webpage = "https://www.bch.hn/estadisticos/EME/Producto%20Interno%20Bruto%20Anual%20Base%202000/Producto%20Interno%20Bruto%20e%20Ingreso%20Nacional%20en%20Lempiras.xls"
    # Usando R para leer archivo xls
    data = open_file_r1(webpage)
    data = DataFrames.DataFrame(data)
    # Depurar dataframe
    data = dataframe_clean(data)
    names_data = DataFrames.names(data)
    DataFrames.rename!(data, Symbol(names_data[1]) => :Variable)
    DataFrames.delete!(data, [1])
    data = resize_data(data)
    data[!, :Fechas] = Vector{Union{String}}(data[!, :Fechas])
    data[!, :Fechas] = replace_text.(data[!, :Fechas], "p/")
    data[!, :Fechas] = StrToFloat.(data[!, :Fechas])
    data[!, :Fechas] = Int.(data[!, :Fechas])
    data[!, :Fechas] = Dates.Date.(data[!, :Fechas],1,1)
    data[!, :Tipo_Valores] .= "Corrientes, Millones de Lempiras"
    data = data[!,[2,1,4,3]]
    data[!, :Periodicidad] .= "Anual"
    data[!, :Grupo] .= "Real"
    data[!, :Fuente] .= "https://www.bch.hn/estadisticas-y-publicaciones-economicas/Grupo-real/cuentas-nacionales-anuales/producto-interno-bruto-(base-2000)"
    data = data[!,[1,2,4,5,6,3,7]]
    # data[!,[1,2,4,5,6,3,7]]
    # CSV.write(
    #     wd * "/data/csv/PIB_INPC_L.csv",
    #     data;
    #     delim = ";")
    return data
end


function PIB_INPC_D()
    # Descargar archivo
    webpage = "https://www.bch.hn/estadisticos/EME/Producto%20Interno%20Bruto%20Anual%20Base%202000/Producto%20Interno%20Bruto%20e%20Ingreso%20Nacional%20en%20D%C3%B3lares.xls"
    # Usando R para leer archivo xls
    data = open_file_r1(webpage)
    data = DataFrames.DataFrame(data)
    # Depurar dataframe
    data = dataframe_clean(data)
    names_data = DataFrames.names(data)
    DataFrames.rename!(data, Symbol(names_data[1]) => :Variable)
    DataFrames.delete!(data, [1])
    data = resize_data(data)
    data[!, :Fechas] = Vector{Union{String}}(data[!, :Fechas])
    data[!, :Fechas] = replace_text.(data[!, :Fechas], "p/")
    data[!, :Fechas] = StrToFloat.(data[!, :Fechas])
    data[!, :Fechas] = Int.(data[!, :Fechas])
    data[!, :Fechas] = Dates.Date.(data[!, :Fechas],1,1)
    data[!, :Tipo_Valores] .= "Corrientes, Millones de Lempiras"
    data = data[!,[2,1,4,3]]
    data[!, :Periodicidad] .= "Anual"
    data[!, :Grupo] .= "Real"
    data[!, :Fuente] .= "https://www.bch.hn/estadisticas-y-publicaciones-economicas/Grupo-real/cuentas-nacionales-anuales/producto-interno-bruto-(base-2000)"
    data = data[!,[1,2,4,5,6,3,7]]
    # Escribir en CSV
    # CSV.write(
    #     wd * "/data/csv/PIB_INPC_D.csv",
    #     data;
    #     delim = ";")
    return data
end


function Oferta_Demanda()
    # Descargar archivo
    webpage = "https://www.bch.hn/estadisticos/EME/Producto%20Interno%20Bruto%20Anual%20Base%202000/Oferta%20y%20Demanda%20Agregada.xls"
    # Usando R para leer archivo xls
    data = open_file_r1(webpage)
    data = DataFrames.DataFrame(data)
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
    data[!, :Fechas] = Vector{Union{String}}(data[!, :Fechas])
    data[!, :Fechas] = replace_text.(data[!, :Fechas], "p/")
    data[!, :Fechas] = StrToFloat.(data[!, :Fechas])
    data[!, :Fechas] = Int.(data[!, :Fechas])
    data[!, :Fechas] = Dates.Date.(data[!, :Fechas],1,1)
    data[!, :Tipo_Valores] .= "Corrientes, Millones de Lempiras"
    data = data[!,[2,1,4,3]]
    data[!, :Periodicidad] .= "Anual"
    data[!, :Grupo] .= "Real"
    data[!, :Fuente] .= "https://www.bch.hn/estadisticas-y-publicaciones-economicas/Grupo-real/cuentas-nacionales-anuales/producto-interno-bruto-(base-2000)"
    data = data[!,[1,2,4,5,6,3,7]]
    # Escribir en CSV
    # CSV.write(
    #     wd * "/data/csv/Oferta_Demanda.csv",
    #     data;
    #     delim = ";")
    return data
end


function VAB_Agro()
    # Descargar archivo
    webpage = "https://www.bch.hn/estadisticos/EME/Producto%20Interno%20Bruto%20Anual%20Base%202000/Valor%20Agregado%20Bruto%20Agropecuario.xlsx"
    # Usando R para leer archivo xls
    data = open_file_r1(webpage)
    data = DataFrames.DataFrame(data)
    # Depurar dataframe
    data = DataFrames.dropmissing(data, names(data)[2])
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
    corrientes[!, :Tipo_Valores] .= "Corrientes, Millones de Lempiras"
    constantes = data[16:30, 1:(n_years+2)]
    constantes = resize_data(constantes)
    constantes[!, :Tipo_Valores] .= "Constantes, Millones de Lempiras"
    # Unir dataframes
    data = Base.vcat(
        corrientes, constantes)
    data[!, :Fechas] = Vector{Union{String}}(data[!, :Fechas])
    data[!, :Fechas] = replace_text.(data[!, :Fechas], "p/")
    data[!, :Fechas] = StrToFloat.(data[!, :Fechas])
    data[!, :Fechas] = Int.(data[!, :Fechas])
    data[!, :Fechas] = Dates.Date.(data[!, :Fechas],1,1)
    data = data[:, [2,1,4,3]]
    data[!, :Periodicidad] .= "Anual"
    data[!, :Grupo] .= "Real, Enfoque_Producción"
    data[!, :Fuente] .= "https://www.bch.hn/estadisticas-y-publicaciones-economicas/Grupo-real/cuentas-nacionales-anuales/producto-interno-bruto-(base-2000)"
    data = data[!,[1,2,4,5,6,3,7]]
    # Escribir en CSV
    # CSV.write(
    #     wd * "/data/csv/VAB_Agro.csv",
    #     data;
    #     delim = ";")
    return data
end


function VAB_Manufactura()
    # Descargar archivo
    webpage = "https://www.bch.hn/estadisticos/EME/Producto%20Interno%20Bruto%20Anual%20Base%202000/Valor%20Agregado%20Bruto%20Manufactura.xlsx"
    # Usando R para leer archivo xls
    data = open_file_r1(webpage)
    data = DataFrames.DataFrame(data)
    # Depurar dataframe
    data = DataFrames.dropmissing(data, names(data)[2])
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
    corrientes[!, :Tipo_Valores] .= "Corrientes, Millones de Lempiras"
    constantes = data[17:32, 1:(n_years+2)]
    constantes = resize_data(constantes)
    constantes[!, :Tipo_Valores] .= "Constantes, Millones de Lempiras"
    # Unir dataframes
    data = Base.vcat(
        corrientes, constantes)
    data[!, :Fechas] = Vector{Union{String}}(data[!, :Fechas])
    data[!, :Fechas] = replace_text.(data[!, :Fechas], "p/")
    data[!, :Fechas] = StrToFloat.(data[!, :Fechas])
    data[!, :Fechas] = Int.(data[!, :Fechas])
    data[!, :Fechas] = Dates.Date.(data[!, :Fechas],1,1)
    data = data[:, [2,1,4,3]]
    data[!, :Periodicidad] .= "Anual"
    data[!, :Grupo] .= "Real"
    data[!, :Fuente] .= "https://www.bch.hn/estadisticas-y-publicaciones-economicas/Grupo-real/cuentas-nacionales-anuales/producto-interno-bruto-(base-2000)"
    data = data[!,[1,2,4,5,6,3,7]]
    # Escribir en CSV
    # CSV.write(
    #     wd * "/data/csv/VAB_Manufactura.csv",
    #     data;
    #     delim = ";")
    return data
end


function Imae_Original_TC()
    webpage = "https://www.bch.hn/estadisticos/EME/Series%20pblicas/%C3%8Dndice%20Mensual%20de%20Actividad%20Econ%C3%B3mica.xlsx"
    # Usando R para leer archivo xls
    data = open_file_r1(webpage)
    data = DataFrames.DataFrame(data)
    # Depurar dataframe
    data = DataFrames.dropmissing(data, names(data)[3])
    data = data[:, StatsBase.mean.(ismissing, eachcol(data)) .< 0.25]
    data = data[3:end, [1,2,5]]
    DataFrames.rename!(data, ["Mensual","IMAE_Original","IMAE_TC"])
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
    data[!, :Variable] = Vector{Union{String}}(data[!, :Variable])
    data[!, :Periodicidad] .= "Mensual"
    data[!, :Grupo] .= "Real"
    data[!, :Tipo_Valores] .= "Índices, Base 2000"
    data[!, :Fuente] .= "https://www.bch.hn/estadisticas-y-publicaciones-economicas/Grupo-real/indice-mensual-de-actividad-economica"
    # CSV.write(
    #     wd * "/data/csv/Imae_Original_TC.csv",
    #     data;
    #     delim = ";")
    return data
end


function Imae_Actividad()
    webpage = "https://www.bch.hn/estadisticos/EME/Series%20pblicas/%C3%8Dndice%20Mensual%20de%20Actividad%20Econ%C3%B3mica.xlsx"
    # Usando R para leer archivo xls
    data = open_file_r1(webpage)
    data = DataFrames.DataFrame(data)
    # Depurar dataframe
    data = DataFrames.dropmissing(data, names(data)[3])
    data = data[:, StatsBase.mean.(ismissing, eachcol(data)) .< 0.1]
    DataFrames.rename!(
        data,
        Symbol.(Vector(data[1,:])),
        makeunique = true)[2:(end-1),:]
    data = data[3:end, :]
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
    data[!, :Valores] = StrToFloat.(data[!, :Valores])
    data[!, :Periodicidad] .= "Mensual"
    data[!, :Grupo] .= "Real"
    data[!, :Tipo_Valores] .= "Índices, Base 2000"
    data[!, :Variable] = Vector{Union{String}}(data[!, :Variable])
    data[!, :Fuente] .= "https://www.bch.hn/estadisticas-y-publicaciones-economicas/Grupo-real/indice-mensual-de-actividad-economica"
    # CSV.write(
    #     wd * "/data/csv/Imae_Actividad.csv",
    #     data;
    #     delim = ";")
    return data
end


function Balanza_Bienes_Trimestral()
    # Descargar archivo
    webpage = "https://www.bch.hn/estadisticos/EME/Balanza%20de%20bienes/Balanza%20de%20Bienes%20trimestral.xlsx"
    # Usando R para leer archivo xls
    data = open_file_r1(webpage)
    data = DataFrames.DataFrame(data)
    # Depurar dataframe
    data = DataFrames.dropmissing(data, names(data)[3])
    data = data[:, mean.(ismissing, eachcol(data)) .< 0.1]
    DataFrames.rename!(
        data,
        Symbol.(Vector(data[1,:])),
        makeunique = true)[3:end,:]
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
    names_data = vcat("Variable",Fechas)
    DataFrames.rename!(data, names_data)
    k = Base.size(data)[2]
    data = DataFrames.stack(data, 2:k)
    DataFrames.rename!(data, ["Variable","Fechas","Valores"])
    data = data[!,[2,1,3]]
    data[!, :Fechas] = Vector{Union{String}}(data[!, :Fechas])
    data[!,:Fechas] = Dates.Date.(data[!,:Fechas])
    data[!,:Valores] = StrToFloat.(data[!,:Valores])
    data[!, :Tipo_Valores] .= "Millones de USD"
    data[!, :Periodicidad] .= "Trimestral"
    data[!, :Grupo] .= "Externo"
    data[!, :Fuente] .= "https://www.bch.hn/estadisticas-y-publicaciones-economicas/Grupo-externo/balanza-de-pagos/cuenta-corriente/balanza-de-bienes"
    data = data[!, [1,2,3,5,4,6,7]]
    data = data[!,[1,2,3,4,6,5,7]]
    # Escribir en CSV
    # CSV.write(
    #     wd * "/data/csv/Balanza_Bienes_Trimestral.csv",
    #     data;
    #     delim = ";")
    return data
end


function Balanza_Bienes_Anual()
    # Descargar archivo
    webpage = "https://www.bch.hn/estadisticos/EME/Balanza%20de%20bienes/Balanza%20de%20Bienes%20anual.xlsx"
    # Usando R para leer archivo xls
    data = open_file_r1(webpage)
    data = DataFrames.DataFrame(data)
    # Depurar dataframe
    data = DataFrames.dropmissing(data, names(data)[2])
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
    data[!, :Fechas] = Vector{Union{String}}(data[!, :Fechas])
    data[!, :Fechas] = Base.map(s -> s[1:4], data[!, :Fechas])
    data[!,:Fechas] = Dates.Date.(StrToInt.(data[!,:Fechas]),1,1)
    data[!,:Valores] = StrToFloat.(data[!,:Valores])
    data[!, :Tipo_Valores] .= "Millones de USD"
    data[!,:Variable] = String.(data[!,:Variable])
    data[!, :Periodicidad] .= "Anual"
    data = data[data[!,:Variable] .!== "IMPORTACIONES", :]#DataFramesMeta.@where(data, :Variable !== "IMPORTACIONES")
    data[!, :Grupo] .= "Externo"
    data[!, :Fuente] .= "https://www.bch.hn/estadisticas-y-publicaciones-economicas/Grupo-externo/balanza-de-pagos/cuenta-corriente/balanza-de-bienes"
    data = data[!, [1,2,3,5,4,6,7]]
    data = data[!,[1,2,3,4,6,5,7]]
    # Escribir en CSV
    # CSV.write(
    #     wd * "/data/csv/Balanza_Bienes_Anual.csv",
    #     data;
    #     delim = ";")
    return data
end


function Exportaciones_Mercancias_Trimestral()
    # Descargar archivo
    webpage = "https://www.bch.hn/estadisticos/EME/Exportaciones%20Trim/Exportaciones%20FOB%20Mercanc%C3%ADas%20Generales%20trimestral.xlsx"
    # Usando R para leer archivo xls
    data = open_file_r1(webpage)
    data = DataFrames.DataFrame(data)
    # Depurar dataframe
    r = Base.size(data)[1]
    data = data[3:r,:]
    data = DataFrames.rename!(
        data,
        Symbol.(Vector(data[1,:])),
        makeunique = true)[2:end,:]
    names_data = DataFrames.names(data)
    DataFrames.rename!(
        data, vcat("Variable", 
            Base.collect(names_data[2:Base.size(names_data)[1]])))
    data = data[!, DataFrames.Not(r"missing")]
    data = data[!, DataFrames.Not(r"2008")]
    Fechas = string.(Base.collect(Dates.Date(2004,3,1):Dates.Month(3):(
                Dates.Date(2004,3,1) + Dates.Quarter(Base.size(data)[2]-2))))
    names_data = vcat("Variable",Fechas)	
    DataFrames.rename!(data, names_data)
    # Agregar descripción
    var1 = data[1,1]
    for i in 2:4
        data[i,1] = var1 * ": " * data[i,1]
    end
    var1 = data[5,1]
    for i in 6:10
        data[i,1] = var1 * ": " * data[i,1]
    end
    rx = Base.size(data)[1]
    for i in 12:(rx-3)
        for j in 1:3
            if ismissing.(data[i-j,2]) .== true #&& ismissing.(data[i+1,2]) .== true
                datax = data[i-j,1]
                data[i,1] = datax * ": " * data[i,1]
            end
        end
    end
    data = DataFrames.dropmissing(data, names(data)[2])
    r = Base.size(data)[1]
    data[r-2,1] = "SUB-TOTAL"
    data[r-1,1] = "OTROS PRODUCTOS"
    data[r,1] = "TOTAL MERCANCÍAS GENERALES"
    # Agregar variables descriptivas
    c = Base.size(data)[2]
    data = DataFrames.stack(data, 2:c)
    DataFrames.rename!(data, ["Variable","Fechas","Valores"])
    data = data[!,[2,1,3]]
    data[!,:Fechas] = Vector{Union{String}}(data[!, :Fechas])
    data[!,:Fechas] = Dates.Date.(data[!,:Fechas])
    data[!,:Valores] = StrToFloat.(data[!,:Valores])
    data[!,:Variable] = String.(data[!,:Variable])
    data[!, :Tipo_Valores] .= "Millones de USD"
    data[!, :Periodicidad] .= "Trimestral"
    data[!, :Grupo] .= "Externo"
    data[!, :Fuente] .= "https://www.bch.hn/estadisticas-y-publicaciones-economicas/Grupo-externo/balanza-de-pagos/cuenta-corriente/exportaciones"
    data = data[!, [1,2,3,5,4,6,7]]
    data = data[!,[1,2,3,4,6,5,7]]
    # Escribir en CSV
    # CSV.write(
    #     wd * "/data/csv/Exportaciones_Mercancias_Trimestral.csv",
    #     data;
    #     delim = ";")
    return data
end


function Exportaciones_Bienes_Transformacion_Trimestral()
    # Descargar archivo
    webpage = "https://www.bch.hn/estadisticos/EME/Exportaciones%20Trim/Exportaciones%20FOB%20Bienes%20para%20Transformaci%C3%B3n%20trimestral.xlsx"
    # Usando R para leer archivo xls
    data = open_file_r1(webpage)
    data = DataFrames.DataFrame(data)
    # Depurar dataframe
        r = Base.size(data)[1]
    data = data[3:r,:]
    data = DataFrames.rename!(
        data,
        Symbol.(Vector(data[1,:])),
        makeunique = true)[2:end,:]
    names_data = DataFrames.names(data)
    DataFrames.rename!(
        data, vcat("Variable", 
            Base.collect(names_data[2:Base.size(names_data)[1]])))
    data = data[!, DataFrames.Not(r"missing")]
    data = data[!, DataFrames.Not(r"2008")]
    Fechas = string.(Base.collect(Dates.Date(2004,3,1):Dates.Month(3):(
                Dates.Date(2004,3,1) + Dates.Quarter(Base.size(data)[2]-2))))
    names_data = vcat("Variable",Fechas)	
    DataFrames.rename!(data, names_data)
    data = DataFrames.dropmissing(data, names(data)[2])

    # Agregar variables descriptivas
    c = Base.size(data)[2]
    data = DataFrames.stack(data, 2:c)
    DataFrames.rename!(data, ["Variable","Fechas","Valores"])
    data = data[!,[2,1,3]]
    data[!,:Fechas] = Vector{Union{String}}(data[!, :Fechas])
    data[!,:Fechas] = Dates.Date.(data[!,:Fechas])
    data[!,:Valores] = StrToFloat.(data[!,:Valores])
    data[!,:Variable] = String.(data[!,:Variable])
    data[!, :Tipo_Valores] .= "Millones de USD"
    data[!, :Periodicidad] .= "Trimestral"
    data[!, :Grupo] .= "Externo"
    data[!, :Fuente] .= "https://www.bch.hn/estadisticas-y-publicaciones-economicas/Grupo-externo/balanza-de-pagos/cuenta-corriente/exportaciones"
    data = data[!, [1,2,3,5,4,6,7]]
    data = data[!,[1,2,3,4,6,5,7]]
    # Escribir en CSV
    # CSV.write(
    #     wd * "/data/csv/Exportaciones_Bienes_Transformacion_Trimestral.csv",
    #     data;
    #     delim = ";")
    return data
end


function Exportaciones_Mercancias_Anual()
    # Descargar archivo
    webpage = "https://www.bch.hn/estadisticos/EME/Exportaciones%20Anuales/Exportaciones%20FOB%20Mercanc%C3%ADas%20Generales%20anual.xlsx"
    # Usando R para leer archivo xls
    data = open_file_r1(webpage)
    data = DataFrames.DataFrame(data)
    # Depurar dataframe
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
    var1 = data[1,1]
    for i in 2:4
        data[i,1] = var1 * ": " * data[i,1]
    end
    var1 = data[5,1]
    for i in 6:10
        data[i,1] = var1 * ": " * data[i,1]
    end
    rx = Base.size(data)[1]
    for i in 12:(rx-4)
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
    for i in 2:Base.size(data)[2]
        DataFrames.rename!(data, names(data)[i] .=> string(2000+i-2))
    end
    c = Base.size(data)[2]
    data = DataFrames.stack(data, 2:c)
    DataFrames.rename!(data, ["Variable","Fechas","Valores"])
    data = data[!,[2,1,3]]
    data[!,:Fechas] = Vector{Union{String}}(data[!, :Fechas])
    data[!, :Fechas] = Dates.Date.(StrToInt(data[!, :Fechas]),1,1)
    data[!, :Tipo_Valores] .= "Volumen en Miles y Valor en Millones de USD"
    data[!, :Periodicidad] .= "Anual"
    data[!, :Grupo] .= "Externo"
    data[!, :Fuente] .= "https://www.bch.hn/estadisticas-y-publicaciones-economicas/Grupo-externo/balanza-de-pagos/cuenta-corriente/exportaciones"
    data = data[!, [1,2,3,5,4,6,7]]
    data[!,[1,2,3,4,6,5,7]]
    # Escribir en CSV
    # CSV.write(
    #     wd * "/data/csv/Exportaciones_Mercancias_Anual.csv",
    #     data;
    #     delim = ";")
    return data
end


function Exportaciones_Bienes_Transformacion_Anual()
    # Descargar archivo
    webpage = "https://www.bch.hn/estadisticos/EME/Exportaciones%20Anuales/Exportaciones%20FOB%20Bienes%20para%20Transformaci%C3%B3n%20anual.xlsx"
    # Usando R para leer archivo xls
    data = open_file_r1(webpage)
    data = DataFrames.DataFrame(data)
    # Depurar dataframe
    r = Base.size(data)[1]
    c = Base.size(data)[2]
    data = data[4:r,:]
    # Depurar dataframe
    data = DataFrames.dropmissing(data, names(data)[2])
    DataFrames.rename!(
        data,
        Symbol.(Vector(data[1,:])),
        makeunique = true)[2:end,:]
    names_data = DataFrames.names(data)
    for i in 2:Base.size(data)[2]
        DataFrames.rename!(data, names(data)[i] .=> string(2003+i-2))
    end
    c = Base.size(data)[2]
    data = DataFrames.stack(data, 2:c)
    DataFrames.rename!(data, ["Variable","Fechas","Valores"])
    data = data[!,[2,1,3]]
    data[!,:Fechas] = Vector{Union{String}}(data[!, :Fechas])
    data[!, :Fechas] = Dates.Date.(StrToInt(data[!, :Fechas]),1,1)
    data[!,:Fechas] = Dates.Date.(data[!,:Fechas])
    data[!, :Tipo_Valores] .= "Millones de USD"
    data[!, :Periodicidad] .= "Anual"
    data[!, :Grupo] .= "Externo"
    data[!, :Fuente] .= "https://www.bch.hn/estadisticas-y-publicaciones-economicas/Grupo-externo/balanza-de-pagos/cuenta-corriente/exportaciones"
    data = data[!, [1,2,3,5,4,6,7]]
    data = data[!,[1,2,3,4,6,5,7]] 
    # Escribir en CSV
    # CSV.write(
    #     wd * "/data/csv/Exportaciones_Bienes_Transformacion_Anual.csv",
    #     data;
    #     delim = ";")
    return data
end


function Importaciones_Mercancias_Seccion_Trimestral()
    # Descargar archivo
    webpage = "https://www.bch.hn/estadisticos/EME/Importaciones%20Trimestrales/Importaciones%20CIF%20Mercanc%C3%ADas%20Generales%20Secci%C3%B3n%20trimestral.xlsx"
    # Usando R para leer archivo xls
    data = open_file_r1(webpage)
    data = DataFrames.DataFrame(data)
    # Depurar dataframe
    r = Base.size(data)[1]
    data = data[3:r,:]
    data = DataFrames.rename!(
        data,
        Symbol.(Vector(data[1,:])),
        makeunique = true)[2:end,:]
    names_data = DataFrames.names(data)
    DataFrames.rename!(
        data, vcat("Variable", 
            Base.collect(names_data[2:Base.size(names_data)[1]])))	
    data = data[!, DataFrames.Not(r"missing")]
    data = data[!, DataFrames.Not(r"2008")]
    data = data[!, DataFrames.Not(r"2007")]
    Fechas = string.(Base.collect(Dates.Date(2004,3,1):Dates.Month(3):(
                Dates.Date(2004,3,1) + Dates.Quarter(Base.size(data)[2]-2))))
    names_data = vcat("Variable",Fechas)	
    DataFrames.rename!(data, names_data)
    data = DataFrames.dropmissing(data, names(data)[2])
    # Agregar variables descriptivas
    c = Base.size(data)[2]
    data = DataFrames.stack(data, 2:c)
    DataFrames.rename!(data, ["Variable","Fechas","Valores"])
    data = data[!,[2,1,3]]
    data[!,:Fechas] = Vector{Union{String}}(data[!, :Fechas])
    data[!,:Fechas] = Dates.Date.(data[!,:Fechas])
    data[!,:Variable] = String.(data[!,:Variable])	
    data[!, :Tipo_Valores] .= "Millones de USD"
    data[!, :Periodicidad] .= "Trimestral"
    data[!, :Grupo] .= "Externo"
    data[!, :Fuente] .= "https://www.bch.hn/estadisticas-y-publicaciones-economicas/Grupo-externo/balanza-de-pagos/cuenta-corriente/importaciones"
    data = data[!, [1,2,3,5,4,6,7]]
    data[!,:Valores] = StrToFloat.(data[!,:Valores])
    data = data[!,[1,2,3,4,6,5,7]]
    # Escribir en CSV
    # CSV.write(
    #     wd * "/data/csv/Importaciones_Mercancias_Seccion_Trimestral.csv",
    #     data;
    #     delim = ";")
    return data
end


function Importaciones_Combustibles_Trimestral()
    # Descargar archivo
    webpage = "https://www.bch.hn/estadisticos/EME/Importaciones%20Trimestrales/Importaciones%20CIF%20Combustibles%20trimestral.xlsx"
    # Usando R para leer archivo xls
    data = open_file_r1(webpage)
    data = DataFrames.DataFrame(data)
    r = Base.size(data)[1]
    data = data[3:r,:]
    data = DataFrames.rename!(
        data,
        Symbol.(Vector(data[1,:])),
        makeunique = true)[2:end,:]
    names_data = DataFrames.names(data)
    DataFrames.rename!(
        data, vcat("Variable", 
            Base.collect(names_data[2:Base.size(names_data)[1]])))	
    # Agregar descripción de producto
    data = DataFrames.dropmissing(data, :Variable)
    data = data[!, DataFrames.Not(r"missing")]
    data = data[!, DataFrames.Not(r"2008")]
    data = data[!, DataFrames.Not(r"2007")]
    var1 = data[1,1]
    for i in 2:4
        data[i,1] = var1 * ": " * data[i,1]
    end
    rx = Base.size(data)[1]
    for i in 5:(rx-6)
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
    data[!,:Fechas] = Vector{Union{String}}(data[!, :Fechas])
    data[!,:Fechas] = Dates.Date.(data[!,:Fechas])
    data[!, :Tipo_Valores] .= "Volumen en Millones de Barriles, Valores en Millones de USD"
    data[!, :Periodicidad] .= "Trimestral"
    data[!, :Grupo] .= "Externo"
    data[!, :Fuente] .= "https://www.bch.hn/estadisticas-y-publicaciones-economicas/Grupo-externo/balanza-de-pagos/cuenta-corriente/importaciones"
    data = data[!, [1,2,3,5,4,6,7]]
    data = data[!,[1,2,3,4,6,5,7]]
    # Escribir en CSV
    # CSV.write(
    #     wd * "/data/csv/Importaciones_Combustibles_Trimestral.csv",
    #     data;
    #     delim = ";")
    return data
end


function Importaciones_Bienes_Transformacion_Trimestral()
    # Descargar archivo
    webpage = "https://www.bch.hn/estadisticos/EME/Importaciones%20Trimestrales/Importaciones%20CIF%20Bienes%20para%20Transformaci%C3%B3n%20trimestral.xlsx"
    # Usando R para leer archivo xls
    data = open_file_r1(webpage)
    data = DataFrames.DataFrame(data)
    # Depurar dataframe
    r = Base.size(data)[1]
    c = Base.size(data)[2]
    data = data[3:r,:]
    data = DataFrames.dropmissing(data, names(data)[2])
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
    data = DataFrames.stack(data, 2:c)
    DataFrames.rename!(data, ["Variable","Fechas","Valores"])
    data = data[!,[2,1,3]]
    data[!,:Fechas] = Vector{Union{String}}(data[!, :Fechas])
    data[!,:Fechas] = Dates.Date.(data[!,:Fechas])
    data[!, :Tipo_Valores] .= "Millones de USD"
    data[!, :Periodicidad] .= "Trimestral"
    data[!, :Grupo] .= "Externo"
    data[!, :Fuente] .= "https://www.bch.hn/estadisticas-y-publicaciones-economicas/Grupo-externo/balanza-de-pagos/cuenta-corriente/importaciones"
    data = data[!, [1,2,3,5,4,6,7]]
    data = data[!,[1,2,3,4,6,5,7]]
    # Escribir en CSV
    # CSV.write(
    #     wd * "/data/csv/Importaciones_Bienes_Transformacion_Trimestral.csv",
    #     data;
    #     delim = ";")
    return data
end


function Importaciones_Mercancias_Seccion_Anual()
    # Descargar archivo
    webpage = "https://www.bch.hn/estadisticos/EME/Importaciones%20Anuales/Importaciones%20CIF%20Mercancias%20Generales%20Secci%C3%B3n%20anual.xlsx"
    # Usando R para leer archivo xls
    data = open_file_r1(webpage)
    data = DataFrames.DataFrame(data)
    # Depurar dataframe
    r = Base.size(data)[1]
    c = Base.size(data)[2]
    data = data[2:r,:]
    data = DataFrames.dropmissing(data, names(data)[2])
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
    data = DataFrames.stack(data, 2:c)
    DataFrames.rename!(data, ["Variable","Fechas","Valores"])
    data = data[!,[2,1,3]]
    data[!,:Fechas] = Vector{Union{String}}(data[!, :Fechas])
    data[!, :Fechas] = Base.map(s -> s[1:4], data[!, :Fechas])
    data[!, :Fechas] = Dates.Date.(StrToInt(data[!, :Fechas]),1,1)
    data[!, :Tipo_Valores] .= "Millones de USD"
    data[!, :Periodicidad] .= "Anual"
    data[!, :Grupo] .= "Externo"
    data[!, :Fuente] .= "https://www.bch.hn/estadisticas-y-publicaciones-economicas/Grupo-externo/balanza-de-pagos/cuenta-corriente/importaciones"
    data = data[!, [1,2,3,5,4,6,7]]
    data = data[!,[1,2,3,4,6,5,7]]
    # Escribir en CSV
    # CSV.write(
    #     wd * "./data/csv/Importaciones_Mercancias_Seccion_Anual.csv",
    #     data;
    #     delim = ";")
    return data
end


function Importaciones_Combustibles_Anual()
    # Descargar archivo
    webpage = "https://www.bch.hn/estadisticos/EME/Importaciones%20Anuales/Importaciones%20CIF%20Combustibles%20anual.xlsx"
    # Usando R para leer archivo xls
    data = open_file_r1(webpage)
    data = DataFrames.DataFrame(data)
    # Depurar dataframe
    r = Base.size(data)[1]
    c = Base.size(data)[2]
    data = data[4:r,:]
        var1 = data[2,1]
    DataFrames.rename!(
        data,
        Symbol.(Vector(data[1,:])),
        makeunique = true)[2:end,:]
    names_data = DataFrames.names(data)
    DataFrames.rename!(
        data, vcat("Variable", Base.collect(names_data[2:Base.size(names_data)[1]])))
    #data = data[!, DataFrames.Not(r"missing")]
    data = DataFrames.dropmissing(data, :Variable)
    var1 = data[1,1]
    for i in 2:4
        data[i,1] = var1 * ": " * data[i,1]
    end
    rx = Base.size(data)[1]
    for i in 6:(rx-6)
        for j in 1:3
            if ismissing.(data[i-j,2]) .== true #&& ismissing.(data[i+1,2]) .== true
                datax = data[i-j,1]
                data[i,1] = datax * ": " * data[i,1]
            end
        end
    end
    names_data = DataFrames.names(data)
    data = DataFrames.dropmissing(data, names_data[2])
    r = Base.size(data)[1]
    data[r-1,1] = "ENERGIA ELECTRICA"
    data[r,1] = "TOTAL COMBUSTIBLES, LUBRICANTES Y ENERGIA ELECTRICA"
    for i in 2:Base.size(data)[2]
        DataFrames.rename!(data, names(data)[i] .=> string(2000+i-2))
    end
    c = Base.size(data)[2]
    data = DataFrames.stack(data, 2:c)
    DataFrames.rename!(data, ["Variable","Fechas","Valores"])
    data = data[!,[2,1,3]]
    data[!,:Fechas] = Vector{Union{String}}(data[!, :Fechas])
    data[!, :Fechas] = Base.map(s -> s[1:4], data[!, :Fechas])
    data[!, :Fechas] = Dates.Date.(StrToInt(data[!, :Fechas]),1,1)
    data[!, :Tipo_Valores] .= "Millones de Barriles y Millones de USD"
    data[!, :Periodicidad] .= "Anual"
    data[!, :Grupo] .= "Externo"
    data[!, :Fuente] .= "https://www.bch.hn/estadisticas-y-publicaciones-economicas/Grupo-externo/balanza-de-pagos/cuenta-corriente/importaciones"
    data = data[!, [1,2,3,5,4,6,7]]
    data = data[!,[1,2,3,4,6,5,7]]
    # Escribir en CSV
    # CSV.write(
    #     wd * "/data/csv/Importaciones_Combustibles_Anual.csv",
    #     data;
    #     delim = ";")
    return data
end


function Importaciones_Bienes_Transformacion_Anual()
    # Descargar archivo
    webpage = "https://www.bch.hn/estadisticos/EME/Importaciones%20Anuales/Importaciones%20CIF%20Bienes%20para%20Transformaci%C3%B3n%20anual.xlsx"
    # Usando R para leer archivo xls
    data = open_file_r1(webpage)
    data = DataFrames.DataFrame(data)
    # Depurar dataframe
    r = Base.size(data)[1]
    c = Base.size(data)[2]
    data = data[2:r,:]
    data = DataFrames.dropmissing(data, names(data)[2])
    DataFrames.rename!(
        data,
        Symbol.(Vector(data[1,:])),
        makeunique = true)[2:end,:]
    names_data = DataFrames.names(data)
    for i in 2:Base.size(data)[2]
        DataFrames.rename!(data, names(data)[i] .=> string(2003+i-2))
    end
    r = Base.size(data)[1]
    data = data[2:r,:]
    c = Base.size(data)[2]
    data = DataFrames.stack(data, 2:c)
    DataFrames.rename!(data, ["Variable","Fechas","Valores"])
    data = data[!,[2,1,3]]
    data[!,:Fechas] = Vector{Union{String}}(data[!, :Fechas])
    data[!, :Fechas] = replace_text.(data[!, :Fechas], " p")
    data[!, :Fechas] = replace_text.(data[!, :Fechas], " r")
    data[!, :Fechas] = Dates.Date.(StrToInt(data[!, :Fechas]),1,1)
    data[!, :Tipo_Valores] .= "Millones de USD"
    data[!, :Periodicidad] .= "Anual"
    data[!, :Grupo] .= "Externo"
    data[!, :Fuente] .= "https://www.bch.hn/estadisticas-y-publicaciones-economicas/Grupo-externo/balanza-de-pagos/cuenta-corriente/importaciones"
    data = data[!, [1,2,3,5,4,6,7]]
    data = data[!,[1,2,3,4,6,5,7]]
    # Escribir en CSV
    # CSV.write(
    #     wd * "/data/csv/Importaciones_Bienes_Transformacion_Anual.csv",
    #     data;
    #     delim = ";")
    return data
end


function BalCam()
    # Descargar archivo
    webpage = "https://www.bch.hn/operativos/INTL/LIBBALANZA%20CAMBIARIA%20SERIE/Balanza%20Cambiaria%20Serie%202000-Actualidad.xlsx"
    # Usando R para leer archivo xls
    RCall.@rput webpage
    R"""
    library("readxl")
    library("rio")
    data <- rio::import(file = webpage, which = 2)
    """
    data = RCall.@rget data	
    data = DataFrames.DataFrame(data)
    # Depurar dataframe
    data = DataFrames.dropmissing(data, names(data)[2])
    data = DataFrames.dropmissing(data, names(data)[4])
    data[!,:Variable] = data[!,1] .* " " .* data[!,2]
    ncols = size(data)[2]
    data = data[!,vcat(ncols,collect(3:(ncols-1)))]
    #mes = (size(data)[2] - 1) % 12
    y = Int(2002 + ceil((size(data)[2] - 1) / 12))
	if (size(data)[2] - 1) % 12 == 0
		mes = 12
	else
    	mes = (size(data)[2] - 1) % 12
	end
    Fechas = Base.collect(
        Dates.Date(2003,1,1):Dates.Month(1):Dates.Date(y,mes,1)
    )
    for i in 2:Base.size(data)[2]
        DataFrames.rename!(data, names(data)[i] .=> string(Fechas[i-1]))
    end
    data[30,1] = "TOTAL INGRESOS"
    data[56,1] = "TOTAL EGRESOS"
    c = Base.size(data)[2]
    data = DataFrames.stack(data, 2:c)
    DataFrames.rename!(data, ["Variable","Fechas","Valores"])
    data = data[!,[2,1,3]]
    data[!,:Fechas] = Vector{Union{String}}(data[!, :Fechas])
    data[!, :Fechas] = Dates.Date.(data[!,:Fechas])
    data[!, :Tipo_Valores] .= "Miles de USD"
    data[!,:Valores] = StrToFloat.(data[!,:Valores])
    data[!, :Periodicidad] .= "Mensual"
    data[!, :Grupo] .= "Externo"
    data[!, :Fuente] .= "https://www.bch.hn/estadisticas-y-publicaciones-economicas/Grupo-externo/balanza-de-pagos/cuenta-corriente/importaciones"
    data = data[!, [1,2,3,5,4,6,7]]
    data = data[!,[1,2,3,4,6,5,7]]
    # Escribir en CSV
    # CSV.write(
    #     wd * "/data/csv/BalCam.csv",
    #     data;
    #     delim = ";")
    return data
end


function get_data()
    funciones = [
    ## Publicaciones de Precios
    IPC(),
    IPC_Rubros(),
    IPC_Regiones(),
    ## Tipo de Cambio Nominal
    TCN_Diario(),
    TCN_Mensual(),
    ## Sector Real
    PIB_Enfoque_Produccion(),
    PIB_Enfoque_Gasto(),
    PIB_Enfoque_Ingreso(),
    PIB_INPC_L(),
    PIB_INPC_D(),
    Oferta_Demanda(),
    VAB_Agro(),
    VAB_Manufactura(),
    Imae_Original_TC(),
    Imae_Actividad(),
    ## Sector Externo
    Balanza_Bienes_Trimestral(),
    Balanza_Bienes_Anual(),
    Exportaciones_Mercancias_Trimestral(),
    #Exportaciones_Otros_Trimestral(),
    Exportaciones_Bienes_Transformacion_Trimestral(),
    Exportaciones_Mercancias_Anual(),
    #Exportaciones_Otros_Anual(),
    Exportaciones_Bienes_Transformacion_Anual(),
    #Importaciones_Mercancias_Trimestral(),
    Importaciones_Mercancias_Seccion_Trimestral(),
    Importaciones_Combustibles_Trimestral(),
    Importaciones_Bienes_Transformacion_Trimestral(),
    #Importaciones_Mercancias_Anual(),
    Importaciones_Mercancias_Seccion_Anual(),
    Importaciones_Combustibles_Anual(),
    Importaciones_Bienes_Transformacion_Anual(),
    BalCam()
    ]

data = []
    for i in 1:size(funciones)[1]
    push!(
        data,
        funciones[i])
    end
    data = vcat(data...)
end