
## ***************************************************************************
##  Semana 10: Manipulación de datos
##  Ejercicios             
##  Progrmación para el análisis de datos
##  Martín Opertti - 2022
## ***************************************************************************


## 1. Recrearemos la tabla de posiciones de la temporada 2019. 

## A. Para ello primero eliminemos los partidos de pretemporada y postemporada 
# (utilizando la fecha) y creemos una dummy que indique si el equipo visistante ganó
nba_data <- read_csv("data/nba_data.csv") %>% 
  janitor::clean_names()

nba_19 <- nba_data %>% 
  filter(game_date_est >= "2018-10-16" & game_date_est <= "2019-04-10") %>% 
  mutate(away_team_wins = case_when(pts_away  > pts_home ~ 1,
                                    TRUE ~ 0))
table(nba_19$home_team_wins, nba_19$away_team_wins)   

## B. Ahora divide el dataframe "nba_19" en dos: uno con las variables home_team
# y HOME_TEAM_WINS y otro con las variables away_team y AWAY_TEAM_WINS y
# renombrar las variables de ambos dataframes para que los dos dataframes tengan
# las mismas  variables: una llamada "equipo"y otra "ganador".


## C. Unir los dos dataframes 

# Nuestras observaciones pasaron de ser partidos a ser partidos-equipo. Cada 
# partido tiene dos filas, nuestra unidad pasa a ser el resultado de cada
# equipo en cada partido

## D. Crear una variable que tome el valor 1 si el equipo perdió y 0 si ganó
# (inversa a ganador) para luego resumir la suma de partidos ganados y perdidos
# por cada equipo (la tabla de posciones) y ordenar por partidos ganados

# Chequear el resultado aquí: https://www.espn.com/nba/standings/_/season/2020


## 2. Utilizando la tabla de posiciones generada en el punto 7 y el dataframe
# nba_teams, averiguar el equipo con más partidos ganados en 2019 sin nunca
# haber ganado un campeonato (ver variable CHAMPIONSHIP en nba_teams).

# left_join() te puede servir! (recuerda unificar categorías como en el 
# ejemplo en clase)



## 3. Por último crea una tabla de posiciones solamente para la conferencia este
#  (usando nba_teams) otro tipo de join puede ser útil...


