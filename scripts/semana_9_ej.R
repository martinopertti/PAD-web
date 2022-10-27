
## ***************************************************************************
##  Semana 9: Manipulación de datos
##  Ejercicios             
##  Progrmación para el análisis de datos
##  Martín Opertti - 2022
## ***************************************************************************


## 1. Importar dataframe "nba_data", usaremos solo datos de la temporada 2019,
# filtrar y explorar el dataframe de la temporada 19. Nombrar este dataframe "nba_19"


## 2. Usaremos únicamente las variables de fecha del partido, nombre y puntaje 
# de equipo local y visitante y  si ganó el equipos local. Seleccionar esas 
# variables y ordenar descendentemente según puntos del local. Nombrar este 
# dataframe "nba_19". 

# Usar pipeline! 
# (nombre de variables: GAME_DATE_EST, home_team, PTS_home, visitor_team, 
# PTS_away, HOME_TEAM_WINS)

#  Ahora con el dataframe generado en los puntos 1 y 2 calcularemos varias 
# tablas y valores


## 3. Calcular el promedio de puntos que anotó cada equipo jugando como LOCAL y
# filtrar por los 10 equipos con mayor promedio anotador (slice_max() puede ser útil)


## 4. Extraer la suma de puntos de los 10 partidos con mayor antoación (total, 
# suma de ambos equipos) en la temporada

## 5. Crear una tabla con frecuencia simple y porcentaje de partidos que ganaron
# los equipos locales

## 6. Utilizando la lista de equipos debajo, filtrar  los partidos en los que
# estos equipos jugaron de local (El operador %in% puede serte útil). Luego, en
# el mismo pipeline  calcular el desvío estandar de los puntos anotados por 
# cada equipo 

equipos <- c("Boston Celtics", "Milwaukee Bucks",
             "New York Knicks", "Atlanta Hawks")


## 7. Calcular en una tabla el máximo y mínimo de puntos según equipo (jugando 
# como local) y según resultado. Es decir, la tabla debe tener cuatro valores 
# por equipo: máximo de puntos en partidos ganados, máximo de puntos en partidos
# perdidos, mínimo de puntos en partidos ganados y máximo de puntos en partidos
# ganados (siempre usando PTS_home y home_team). 


