
## ***************************************************************************
##   Semana 9: Manipulación de datos      
##   Solución de ejercicios             
##   Programación para el análisis de datos    
##   Martín Opertti - 2022             
## ***************************************************************************

library(tidyverse)
library(gapminder)

rm(list = ls())

## 1. Importar dataframe "nba_data", usaremos solo datos de la temporada 2019,
# filtrar y explorar el dataframe de la temporada 19. Nombrar este dataframe
# "nba_19"
nba_data <- read_csv("data/nba_data.csv") %>% 
  janitor::clean_names()

nba_19 <- nba_data %>% 
  filter(season == 2019)

glimpse(nba_19)


## 2. Usaremos únicamente las variables de fecha del partido, nombre y puntaje 
# de equipo local y visitante y  si ganó el equipos local. Seleccionar esas 
# variables y ordenar descendentemente según puntos del local. Nombrar este 
# dataframe "nba_19". 
nba_19 <- nba_19 %>% 
  select(game_date_est,  home_team, pts_home, visitor_team, pts_away,
         home_team_wins) %>% 
  arrange(desc(pts_home))

nba_19

##  Ahora con el dataframe generado en los puntos 1 y 2 calcularemos varias 
# tablas y valores


## 3. Calcular el promedio de puntos que anotó cada equipo jugando como LOCAL y
# filtrar por los 10 equipos con mayor promedio anotador (slice_max() puede ser
# útil)
nba_19 %>% 
  group_by(home_team) %>% 
  summarize(media = mean(pts_home, na.rm = TRUE)) %>% 
  slice_max(n = 10, media)


## 4. Extraer la suma de puntos del partido con mayor anotación (total,  
# suma de ambos equipos) en la temporada
nba_19 %>% 
  mutate(pts_total = pts_home + pts_away) %>% 
  slice_max(n = 1, pts_total) %>% 
  summarize(suma = sum(pts_total))


## 5. Utilizando la lista de equipos debajo, filtrar  los partidos en los que
# estos equipos jugaron de local (El operador %in% puede serte útil). Luego, en
# el mismo pipeline calcular el desvío estandar de los puntos anotados por 
# cada equipo 
equipos <- c("Boston Celtics", "Milwaukee Bucks",
             "New York Knicks", "Atlanta Hawks")

nba_19 %>% 
  filter(home_team %in% equipos) %>% 
  group_by(home_team) %>% 
  summarize(desvio = sd(pts_home))


## 6. Calcular en una tabla el máximo y mínimo de puntos según equipo (jugando 
# como local) y según resultado. Es decir, la tabla debe tener cuatro valores 
# por equipo: máximo de puntos en partidos ganados, máximo de puntos en partidos
# perdidos, mínimo de puntos en partidos ganados y máximo de puntos en partidos
# ganados (siempre usando pts_home y home_team). 
nba_19 %>% 
  group_by(home_team, home_team_wins) %>% 
  summarize(max = max(pts_home),
            min = min(pts_home))

