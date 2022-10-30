
## ***************************************************************************
##   Semana 10: Manipulación de datos      
##   Solución de ejercicios             
##   Programación para el análisis de datos    
##   Martín Opertti - 2022             
## ***************************************************************************


## 1. Recrearemos la tabla de posiciones de la temporada 2019. 

## A. Para ello primero eliminemos los partidos de pretemporada y postemporada 
# (utilizando la fecha) y creemos una dummy que indique si el equipo visistante 
# ganó

nba_data <- read_csv("data/nba_data.csv") %>% 
  janitor::clean_names()

nba_19 <- nba_data %>% 
  filter(game_date_est >= "2018-10-16" & game_date_est <= "2019-04-10") %>% 
  mutate(away_team_wins = case_when(pts_away  > pts_home ~ 1,
                                    TRUE ~ 0))

table(nba_19$home_team_wins, nba_19$away_team_wins)

## B. Ahora divide el dataframe "nba_19" en dos: uno con las variables home_team
# y home_team_wins y otro con las variables away_team y away_team_wins y
# renombrar las variables de ambos dataframes para que los dos dataframes tengan
# las mismas  variables: una llamada "equipo"y otra "ganador".

nba_19_home <- nba_19 %>% 
  select(home_team, home_team_wins) %>% 
  rename(equipo = home_team,
         ganador = home_team_wins)

nba_19_home

nba_19_away <- nba_19 %>% 
  select(visitor_team, away_team_wins) %>% 
  rename(equipo = visitor_team,
         ganador = away_team_wins)

nba_19_away

## C. Unir los dos dataframes 
nba_pos_19 <- bind_rows(nba_19_home, nba_19_away)

## D. Crear una variable que tome el valor 1 si el equipo perdió y 0 si ganó
# (inversa a ganador) para luego resumir la suma de partidos ganados y perdidos
# por cada equipo (la tabla de posciones) y ordenar por partidos ganados

nba_pos_19 <- nba_pos_19 %>% 
  mutate(perdedor = case_when(ganador == 1 ~ 0,
                              TRUE ~ 1)) %>% 
  group_by(equipo) %>% 
  summarize(ganados = sum(ganador),
            perdidos = sum(perdedor)) %>% 
  arrange(desc(ganados))

nba_pos_19

# Chequear el resultado aquí: https://www.espn.com/nba/standings/_/season/2020


## 8. Utilizando la tabla de posiciones generada en el punto 7 y el dataframe
# nba_teams, averiguar el equipo con más partidos ganados en 2019 sin nunca
# haber ganado un campeonato (ver variable CHAMPIONSHIP en nba_teams).

nba_teams <- read_csv("data/nba_teams.csv") %>% 
  janitor::clean_names()

nba_teams_ch <- nba_teams %>% 
  mutate(team = paste(city, nickname)) %>% 
  select(team, championships, conference)

nba_teams_ch

nba_pos_19 %>% 
  left_join(nba_teams_ch, by = c("equipo" = "team")) %>% 
  filter(championships == 0) %>% 
  slice_max(n = 1, ganados)


## 9. Por último crea una tabla de posiciones solamente para la conferencia este
# (usando nba_teams) otro tipo de join puede ser útil...

nba_teams <- read_csv("data/nba_teams.csv") %>% 
  janitor::clean_names()

nba_teams_con <- nba_teams %>% 
  mutate(team = paste(city, nickname)) %>% 
  select(team, conference)

nba_teams_con

nba_pos_19 %>% 
  left_join(nba_teams_con, by = c("equipo" = "team")) %>% 
  filter(conference == "east") %>% 
  select(-conference)


