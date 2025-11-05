min_distPoints2Obj = function(puntosCapa, id, puntosObj){

  distancias_puntosObj = function(puntos_capa, puntosO){ #FUNCION PARA OBTENER DISTANCIA MINIMA
    linea_distancias = sf::st_distance(puntos_capa, puntosO)
    
    linea_distancias_min = which(linea_distancias == min(linea_distancias), arr.ind = TRUE)[1,]
    
    #Aisla los puntos seleccionados de cada capa
    
    punto_focal = puntos_capa[linea_distancias_min[1],]
    punto_objetivo = puntosO[linea_distancias_min[2],]
    
    #Une los puntos en un multipoint
    focal_objetivo = sf::st_union(punto_focal, punto_objetivo)
    
    #Transforma los puntos en un linestring
    linea_min = sf::st_cast(focal_objetivo, 'LINESTRING')
    
    #Agrega el atributo de distancia
    linea_min$distance = as.numeric(min(linea_distancias))
    
    return(linea_min) 
  }

  puntos_Categoriaslista = split(puntos_pol, dplyr::pull(puntos_pol, id))
  
  lineasMin_Categoriaslista <- suppressWarnings(lapply(puntos_Categoriaslista, distancias_puntosObj, puntosO = puntosObj))

  lineasMin_Categoriaslista = dplyr::bind_rows(lineasMin_Categoriaslista)

  return(lineasMin_Categoriaslista)

}

