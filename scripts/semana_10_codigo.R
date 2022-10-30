
## ***************************************************************************
##  Semana 10: Manipulación de datos      
##  Código de la presentación         
##  Programación para el análisis de datos
##  Martín Opertti - 2022             
## ***************************************************************************


## 0. Cargar paquetes y data ================================================

library(tidyverse)

nba_data <- read_csv("data/nba_data.csv") %>% 
  janitor::clean_names()


##  1. Uniones (Merges)  ====================================================

## Unir dataframes por columnas

# Dividamos el dataframe en 2 para volver a unirlo
# mismas variables distintas observaciones
nba_data_18 <- nba_data %>% 
  filter(season == 2018)
table(nba_data_18$season)

nba_data_17 <- nba_data %>% 
  filter(season == 2017)
table(nba_data_17$season)

nba_data_17_18 <- bind_rows(nba_data_17, nba_data_18)
table(nba_data_17_18$season)

# Dividimos el dataframe en 2 pero con distinto número de columnas: 
# mismas variables distintas observaciones
nba_data_18 <- nba_data %>% 
  filter(season == 2018)

nba_data_17 <- nba_data %>% 
  filter(season == 2017) %>% 
  select(-pts_home)

nba_data_17_18 <- bind_rows(nba_data_17, nba_data_18)

rm(nba_data_17, nba_data_17_18, nba_data_18)


# Dividamos el dataframe en 2 para volver a unirlo  mismas observaciones 
# distintas columnas
nba_data_a <- nba_data %>% 
  select(game_date_est:fg3_pct_home)
glimpse(nba_data_a)

nba_data_b <- nba_data %>% 
  select(ast_home:home_team_wins)
glimpse(nba_data_b)

nba_data_C <- bind_cols(nba_data_a, nba_data_b)
glimpse(nba_data_C)



##  2. Uniones (joins)  ====================================================

# Los joins de dplyr nos sirven para unir datos con distintas estructuras
rm(list=ls())

# Problema: Supongamos que queremos averiguar los equipos de cuál conferencia 
# ganaron más partidos en los últimos 10 años. Con nba_data tenemos los datos 
# de los partidos y con nba_teams tenemos qué equipo pertenece a qué conferencia.

## A) Importamos el dataframe a nivel partido con el que veníamos trabajando
nba_data <- read_csv("data/nba_data.csv") %>% 
  janitor::clean_names()

# Importamos dataframe con data a nivel de equipo
nba_teams <- read_csv("data/nba_teams.csv") %>% 
  janitor::clean_names()

glimpse(nba_teams)


## B) Filtramos observaciones y variables relevantes de cada dataframe 

# Data a nivel partido de los últimos 10 años
nba_u10 <- nba_data %>% 
  filter(season > 2010) %>% 
  select(home_team, visitor_team, pts_home, pts_away)

glimpse(nba_u10)

# Data a nivel equipo (unificamos las categorías para que coincidan)
nba_teams_rec <- nba_teams %>% 
  mutate(team = paste(city, nickname)) %>% # Concateno ciudad y nombre
  select(team, conference)

glimpse(nba_teams_rec)


## C) Identifico variables "key" y chequeo que categorías coinidan 
table(nba_teams_rec$team)
table(nba_u10$home_team)


## D) Uno ambos dataframes usando left_join()
# Manera tradicional
nba_full_2 <- left_join(x = nba_u10,
                        y = nba_teams_rec,
                        by = c("home_team" = "team"))

# Con pipeline
nba_full <- nba_u10 %>% 
  left_join(nba_teams_rec, by = c("home_team" = "team"))

# Ambos caminos son iguales:
identical(nba_full, nba_full_2)

glimpse(nba_full)

rm(nba_full_2)


## E) Aplico left_join() para obtener la conferencia del equipo visitante
nba_full <- nba_full %>% 
  left_join(nba_teams_rec, by = c("visitor_team" = "team"))
glimpse(nba_full)


## F) Versión más prolija; con el arugmento suffix puedo definir el nombre de 
# las variables y pongo todo dentro de un pipeline
nba_full <- nba_u10 %>% 
  left_join(nba_teams_rec, by = c("home_team" = "team")) %>% 
  left_join(nba_teams_rec, by = c("visitor_team" = "team"),
            suffix = c("_home", "_away"))
glimpse(nba_full)



## 3. Otro tipo de joins  ==================================================

## Ahora veamos cómo funcionan todos los tipos de joins. Para ello crearemos dos
# dataframes  (incompletos) utilizando nba_teams: equipos del este; ID, nombre, 
# conferencia y año de fundación
nba_east <- nba_teams %>% 
  select(nickname, conference, yearfounded) %>% 
  filter(conference == "east")
print(nba_east)

# Algunos equipos (random, utilizando sample_n()), nombre conferencia y 
# campeonatos ganados
nba_random <- nba_teams %>% 
  select(nickname, championships) %>% 
  sample_n(size = 20)
print(nba_random)

# Utilizando distintos joins puedo unir estos datos de la manera que precise
# Mi dataframe original es nba_east y quiero usar nba_random para obtener más 
# información

# A) Incorporo datos de campeonatos ganados al dataframe nba_east, 
# en caso de estar diponibles
nba_east_2 <- nba_east %>% 
  left_join(nba_random, by = "nickname")
print(nba_east_2)

# B) Puedo llegar a lo mismo usando right_join si asigno de forma distinta a x e y
nba_east_3 <- nba_random %>% 
  right_join(nba_east, by = "nickname")
print(nba_east_3)

# C) Con inner_join() me quedo solo con los equipos presentes en ambos dataframes
nba_east_4 <- nba_east %>% 
  inner_join(nba_random, by = "nickname")
print(nba_east_4)

# D) Con full_join() me quedo con todos los equipos que esten al menos en x o y
nba_total_1 <- nba_east %>% 
  full_join(nba_random, by = "nickname")
print(nba_total_1)



##  4. Estructura de datos  ================================================

rm(list=ls())

## El formato tidy tiene tres reglas: cada fila es una observación, cada y
# columna una variable cada celda es un valor

## Este es un formato típico en el que podemos encontrar datos
wb_desempleo <- data.frame(pais = c("Argentina", "Chile", "Uruguay"),
                           d_2019 = c(9.8, 7.3, 9.3),
                           d_2020 = c(11.7, 11.5, 12.7))
print(wb_desempleo)

## Cambio de estructura (de ancho a largo en este caso) para transformar a 
# formato tidy
wb_unemp_tidy <- wb_desempleo %>% 
  pivot_longer(cols = c("d_2019", "d_2020"), # Columnas a unir 
               names_to = "year", # Nombre de variable "key" 
               values_to = "desempleo") # Nombre de variable con valores
print(wb_unemp_tidy)

## Otro caso es donde las observaciones están en más de una fila.
wb_unemp <- data.frame(
  pais = c("Argentina", "Argentina", "Argentina", "Argentina", "Argentina"),
  year = c(2018, 2019, 2020, 2018, 2019),
  variable = c("desempleo", "desempleo", "desempleo", "pbi_per_capita", "pbi_per_capita"),
  valor = c(9.2, 9.8, 11.7, 11633, 9912))
print(wb_unemp)

# En este caso, para llegar a formato tidy necesitamos pasar de formato largo a ancho
wb_unemp_tidy <- wb_unemp %>% 
  pivot_wider(names_from = variable,
              values_from = valor)
print(wb_unemp_tidy)

## Pasar a formato ancho salidas de summarise()

# Resumen típico con summarise()
nba_data %>%
  mutate(home_team_wins = case_when(
    home_team_wins == 1 ~ "Ganados",
    TRUE ~ "Perdidos"
  )) %>% 
  filter(home_team == "Chicago Bulls") %>% 
  group_by(season, home_team_wins) %>% 
  summarise(n = n())

# Transformalo a formato ancho:

nba_data %>%
  mutate(home_team_wins = case_when(
    home_team_wins == 1 ~ "Ganados",
    TRUE ~ "Perdidos"
  )) %>% 
  filter(home_team == "Chicago Bulls") %>% 
  group_by(season, home_team_wins) %>% 
  summarise(n = n()) %>% 
  pivot_wider(names_from = home_team_wins,
              values_from = n)

