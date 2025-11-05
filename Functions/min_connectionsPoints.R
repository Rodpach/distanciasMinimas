min_connectionsPoints = function(pointShape){
  
  minline = function(x,y, pointShape){
    # Toma dos poligonos (X y Y) de la capa multipoligonos de sitios_area y calcula la distancia
    # minima que existe entre los puntos y crea una linestring de esta distancia.
    
    #Convierte en puntos cada poligono seleccionado
    X = pointShape[x,]
    Y = pointShape[y,]
    
    #calcula distancia entre puntos X y Y
    puntos_distancia = sf::st_distance(X,Y)
    
    #Toma los puntos que tienen menor distancia entre X y Y
    dist_min_dim = which(puntos_distancia == min(puntos_distancia), arr.ind = TRUE)[1,]
    
    #Aisla los puntos seleccionados de cada capa
    p_X = X[dist_min_dim[1],]
    p_Y = Y[dist_min_dim[2],]
    
    #Une los puntos en un multipoint
    multipoint_XY = sf::st_union(p_X, p_Y)
    
    #Transforma los puntos en un linestring
    linestring_XY = sf::st_cast(multipoint_XY, 'LINESTRING')
    
    #Agrega el atributo de distancia
    linestring_XY$distance = as.numeric(min(puntos_distancia))
    
    linestring_XY
  }
  
  #realiza todas las combinaciones posibles en pares
  combination_pol = combn(1:base::nrow(pointShape),2, simplify = F)
  
  #Realiza todas las combinaciones creadas por combination_pol para medir distancia entre parches
  connection_linestrings = suppressWarnings(lapply(combination_pol, function(x){
    minline(x[1], x[2], pointShape)
  }))
  
  #Aplasta las listas en un solo objetto sf
  connection_linestrings = do.call(what = sf:::rbind.sf, args = connection_linestrings)

  return(connection_linestrings)
}

