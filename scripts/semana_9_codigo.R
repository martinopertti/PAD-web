
## ***************************************************************************
##  Semana 9: Manipulación de datos      
##  Código de la presentación         
##  Programación para el análisis de datos    
##  Martín Opertti - 2022             
## ***************************************************************************


## 0. Cargar paquetes ========================================================

library(tidyverse)


## 1. Manipular datos  =======================================================

# Vamos a trabajar con una base de datos con estadísticas de partidos de la NBA.
# Cada fila es un partido y cada variable es un dato sobre ese partido.


## 1.1. Importar ----

# Exploremos la base:
nba_data <- read_csv("data/nba_data.csv") %>% 
  janitor::clean_names()

glimpse(nba_data)


## 1.2. Exploremos ----

# Analicemos la cantidad de puntos encestados por los equipos 

# pts_home indica cuántos puntos anotó el equipo local y pts_away los visitantes
mean(nba_data$pts_home) 

# Ya vemos que, como muchas de los datos que solemos trabajar, hay casos perdidos.
mean(nba_data$pts_home, na.rm = TRUE) 
mean(nba_data$pts_away, na.rm = TRUE) 

# Miremos la variación
sd(nba_data$pts_home, na.rm = TRUE) 
sd(nba_data$pts_away, na.rm = TRUE) 

# Un histograma nos puede dar una buena primera aproximación
hist(nba_data$pts_home,
     main = "Puntos anotados por partido por equipos de la NBA jugando de local")



##  2. Filtrar observaciones  ==============================================

## Una de las transformaciones más frecuentes cuando manipulamos datos 
# Tenemos datos de muchas temporadas:
table(nba_data$season)

# Filtremos para quedarnos con la temporada 2019 solamente
nba_data_19 <- filter(nba_data, season == 2019)

# Ahora con todas menos la 2020
nba_data_03_19 <- filter(nba_data, season != 2020)

# Ahora con las temporadas 2005, 2010, 2012 y 2017
temporadas <- c(2005, 2010, 2012, 2017)
nba_data_temp <- filter(nba_data, season %in% temporadas)
table(nba_data_temp$season)

# O podría hacer
nba_data_temp <- filter(nba_data, season %in% c(2005, 2010, 2012, 2017))
table(nba_data_temp$season)

# No tenemos datos de rebotes para algunos partidos...
filter(nba_data, is.na(reb_home)) 

# Extraer los casos con datos perdidos en la variable reb_home
data_incompleta <- filter(nba_data, is.na(reb_home)) 
glimpse(data_incompleta)

# Casos que tienen datos en reb_home
data_completa_reb <- filter(nba_data, !is.na(reb_home))
glimpse(data_completa_reb)

# Casos completos (elimino casos con NA en al menos una variable)
data_completa <- drop_na(nba_data)
dim(data_completa_reb)

rm(nba_data_19, nba_data_03_19, temporadas, nba_data_temp,
   data_completa_reb, data_completa, data_incompleta)



##  3. Seleccionar variables (columnas)  ====================================

colnames(nba_data)

# Seleccionar un conjunto de variables
nba_pts <- select(nba_data, pts_home, pts_away)
colnames(nba_pts)

# Seleccionar todas las variables menos las especificadas
nba_all <- select(nba_data, - pts_home)
colnames(nba_all)

# Seleccionar un rango de variables según orden
nba_seq <- select(nba_data, game_date_est:visitor_team_id)
colnames(nba_seq)

# También podemos usar "helpers"
# Por ejemplo, seleccionemos todas las variables que terminen en home
nba_home <- select(nba_data, ends_with("home"))
colnames(nba_home)

rm(nba_pts, nba_all, nba_seq, nba_home)



##  4. Pipelines  ===========================================================

# Supongamos que queremos un dataframe que solo incluya partidos de los Chicago 
# Bulls, sin datos perdidos, y que simplemente contenga la fecha, el nombre 
# y los puntos anotados de los dos equipos. 

data_bulls <- filter(nba_data,
                     home_team == "Chicago Bulls" | visitor_team == "Chicago Bulls")

data_bulls <- drop_na(data_bulls)

data_bulls <- select(data_bulls, 
                     game_date_est, home_team, visitor_team, pts_home, pts_away)

head(data_bulls)

# Podemos usar el pipeline
data_bulls_pip <- nba_data %>% 
  filter(home_team == "Chicago Bulls" | visitor_team == "Chicago Bulls") %>% 
  drop_na() %>% 
  select(game_date_est, home_team, visitor_team, pts_home, pts_away)

# Son iguales
identical(data_bulls, data_bulls_pip)

rm(data_bulls, data_bulls_pip)



##  5. Ordenar filas  =======================================================

# Usando el pipeline, seleccionemos algunas variables y luego ordenemos
nba_data %>% 
  filter(home_team == "Chicago Bulls" | visitor_team == "Chicago Bulls") %>% 
  select(game_date_est, home_team, visitor_team, pts_home, pts_away) %>% 
  arrange(pts_home)

nba_data %>% 
  filter(home_team == "Chicago Bulls" | visitor_team == "Chicago Bulls") %>% 
  select(game_date_est, home_team, visitor_team, pts_home, pts_away) %>% 
  arrange(desc(pts_home))

# También sirve para fechas o caracteres (alfabeticamente)
nba_data %>% 
  filter(home_team == "Chicago Bulls" | visitor_team == "Chicago Bulls") %>% 
  select(game_date_est, home_team, visitor_team, pts_home, pts_away) %>% 
  arrange(desc(game_date_est))

nba_data %>% 
  filter(home_team == "Chicago Bulls" | visitor_team == "Chicago Bulls") %>% 
  select(game_date_est, home_team, visitor_team, pts_home, pts_away) %>% 
  arrange(home_team)

# Podemos ordenar por más de una variable, en orden
nba_data %>% 
  filter(home_team == "Chicago Bulls" | visitor_team == "Chicago Bulls") %>% 
  select(game_date_est, home_team, visitor_team, pts_home, pts_away) %>% 
  arrange(home_team, desc(pts_home))



##  6. Resumir datos   ======================================================

## Resumen con la media de pts_home
nba_data %>% 
  drop_na() %>% 
  summarise(media = mean(pts_home))

## Con group_by() podemos crear grupos para nuestros resumenes
nba_data %>% 
  drop_na() %>% 
  group_by(season) %>% 
  summarise(media = mean(pts_home))

## Como con la mayoría de las funciones de dplyr, nos devuelve un dataframe, 
# que podemos guardar en un objeto
pts_per_season <- nba_data %>%
  drop_na() %>% 
  group_by(season) %>% 
  summarise(media = mean(pts_home))

## Resumen con frecuencia simple
nba_data %>% 
  group_by(season) %>% 
  summarise(temporadas = n()) # No lleva argumento

## Es lo mismo con count()
count(nba_data, season)

## Pasar a proporción
nba_data %>% 
  group_by(season) %>% 
  summarise(temporadas = n()) %>% 
  mutate(porcentaje = temporadas / sum(temporadas))

## Pasar a porcentaje formateado
nba_data %>% 
  group_by(season) %>% 
  summarise(temporadas = n()) %>% 
  mutate(porcentaje = round((temporadas / sum(temporadas))*100, digits = 1))


## Con ungroup() dejamos de agrupar para las funciones que aún no han corrido,
# Con la lógica del pipeline podemos luego seguir transformado el resumen, 
# por ejemplo quedarnos con las temporadas posteriores a 2010
nba_data %>% 
  drop_na() %>% 
  group_by(season) %>% 
  summarise(media = mean(pts_home)) %>% 
  ungroup() %>% 
  filter(season > 2010)

## Podemos agrupar por dos o más variables si queremos también
nba_data %>% 
  drop_na() %>%
  filter(home_team == "Chicago Bulls" | 
           home_team == "New York Knicks") %>% 
  group_by(season, home_team) %>% 
  summarise(media = mean(pts_home)) 

# Podemos generar varios resumenes son summarise(), que son variables del 
# dataframe que devuelve
nba_data %>% 
  filter(season > 2015) %>%
  group_by(season) %>% 
  summarise(media_pts_home = mean(pts_home),
            suma_pts_home = sum(pts_home),
            max_pts_home = max(pts_home),
            partidos = n()) 

# Es muy flexible por ejemplo podemos hacer operaciones:
nba_data %>% 
  filter(season > 2015) %>%
  group_by(season) %>% 
  summarise(media_pts_home = mean(pts_home) + 100,
            suma_pts_home = sum(pts_home),
            max_pts_home = max(pts_home),
            partidos = n()) 

# Resumir usando across() todas las variables que terminen con cierto termino
nba_data %>%
  group_by(home_team) %>%
  summarise(across(ends_with("pct_home"), ~ mean(.x, na.rm = TRUE)))

# Usar across() con un vector de variables
nba_data %>%
  group_by(home_team) %>%
  summarise(across(c("pts_home", "ast_home"), ~ mean(.x, na.rm = TRUE)))

# Usar across() y where() para condiciones, por ejemplo variables numericas
nba_data %>%
  group_by(home_team) %>%
  summarise(across(where(is.numeric), ~ mean(.x, na.rm = TRUE)))

rm(pts_per_season)



##  7. Renombrar variables  =================================================

nba_data_2 <- nba_data %>% 
  rename(season = season,
         fecha = game_date_est)

colnames(nba_data_2)

