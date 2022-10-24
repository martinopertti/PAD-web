
## ***************************************************************************
##  Semana 8: Estadística descriptiva y limpieza de datos          
##  Código de la presentación                                      
##  Programación para el análisis de datos                                
##  Martín Opertti - 2022                                         
## ***************************************************************************


## 1. Estadisticos descriptivos =============================================

library(tidyverse)
library(gapminder)

d_gap <- gapminder

# R cuenta también con funciones para obtener estadísticos descriptivos
mi_media <- mean(d_gap$lifeExp, na.rm = TRUE) # Media
median(d_gap$lifeExp) # Mediana
sd(d_gap$lifeExp) # Desvío estandar
mi_rango <- range(d_gap$lifeExp) # Rango
max(d_gap$lifeExp) # Minimo
min(d_gap$lifeExp) # Maximo

# También podemos crear un histograma muy fácilmente
hist(d_gap$lifeExp,
     main = "Distribución de expectativa de vida (Gapminder)")

# Gráfico de dispersión (scatterplot)
plot(d_gap$lifeExp, d_gap$gdpPercap,
     main = "Relación entre expectativa de vida y PBI per cápita")

quantile(d_gap$lifeExp, probs = c(0.2, 0.4, 0.8)) # Cuantiles
quantile(d_gap$lifeExp, probs = seq(0, 1, 0.2)) # Cuantiles

# Con la función ntile() de dplyr podemos asignar quintiles en una variable
d_gap$lifeExp_quant <- ntile(d_gap$lifeExp, 5)

# Tabla cruzada 
table(d_gap$continent, d_gap$lifeExp_quant)



##  2. Crear y recodificar variables   ======================================

rm(list=ls())

## 2.1.  Crear variables con mutate() de dplyr ----

d_gap <- gapminder
head(d_gap, 3)

# Primero veamos cómo crear una constante
d_gap <- mutate(d_gap, var1 = "Valor fijo") # Variable de caracteres
d_gap <- mutate(d_gap, var2 = 7) # Variable numérica
head(d_gap, 3)

# También podemos crear ambas variables dentro de la misma línea 
d_gap <- gapminder
d_gap <- mutate(d_gap, 
var1 = "Valor fijo",
                var2 = 7)
head(d_gap, 3)

# Podríamos haber hecho lo mismo con R Base
d_gap <- gapminder
d_gap$var1 <- "Valor fijo"
d_gap$var2 <- 7
head(d_gap, 3)

# Con mutate() también podemos hacer operaciones sobre variables ya existentes
# Calculemos el pbi total (pbi per capita * población)
d_gap <- mutate(gapminder, gdp = gdpPercap * pop)
head(d_gap, 3)

# Podemos calcular el logaritmo
d_gap <- mutate(d_gap, gdp_log = log(gdp))
head(d_gap, 3)


## 2.2. Atrasar y retrasar variables con lag() y lead() ----

# Primero nos quedamos con los datos de Uruguay
data_uru <- filter(gapminder, country == "Uruguay") 
data_uru <- mutate(data_uru, gdpPercap_lag = lag(gdpPercap, n=1))
data_uru <- mutate(data_uru, gdpPercap_lead = lead(gdpPercap, n=1))
head(data_uru, 3)

## Rankings e identificadores
d_gap <- mutate(gapminder, id = row_number()) # Identificador (números consecutivos)

head(d_gap, 3)
d_gap <- mutate(d_gap, gdp_rank = row_number(gdpPercap)) # Ranking según variable
d_gap <- arrange(d_gap, desc(gdp_rank)) # Ordeno los datos según el ranking
head(d_gap, 3)


## 2.3 Transformar tipo de datos de variables 

# Exploro tipo de variables
glimpse(d_gap)

# Variable continente a caracteres y año a factor
d_gap <- d_gap %>% 
  mutate(continent = as.character(continent),
         year = as.factor(year))

# Exploro tipo de variables
glimpse(d_gap)

# Variable año a numérica nuevamente
d_gap <- d_gap %>% 
  mutate(year = as.numeric(year))

# Exploro tipo de variables
glimpse(d_gap)



## 3. Recodificaciones condicionales =========================================

rm(list=ls())


## 3.1. Recodificación con case_when() ----
d_gap <- gapminder

# Creemos una variable que indique si el país es Uruguay o no
d_gap <- mutate(d_gap, 
                uruono = case_when(
                  country == "Uruguay" ~ "Si")
                )



table(d_gap$uruono)
table(d_gap$uruono_2)

## Con case_when() podemos establecer varias condiciones fácilmente
d_gap <- mutate(d_gap, mercosur = case_when(country == "Uruguay" ~ 1,
                                            country == "Argentina" ~ 1,
                                            country == "Paraguay" ~ 1,
                                            country == "Brazil" ~ 1,
                                            TRUE ~ 0))
table(d_gap$mercosur)

paises_mercosur <- c("Argentina", "Paraguay", "Brazil", "Uruguay")

# También podemos usar operadores para simplificar
d_gap <- mutate(d_gap, mercosur_2 = case_when(
  country %in% c("Argentina", "Paraguay", "Brazil", "Uruguay") ~ 1,
  TRUE ~ 0)
  ) 

d_gap <- mutate(d_gap, mercosur_3 = case_when(
  country == "Argentina" | country == "Paraguay" | country == "Brazil" | country == "Uruguay" ~ 1,
  TRUE ~ 0)
)

identical(d_gap$mercosur, d_gap$mercosur_2)
identical(d_gap$mercosur_2, d_gap$mercosur_3)

# También puedo crear variables en función a dos variables 
d_gap <- mutate(d_gap, var1 = case_when(gdpPercap > 20000 ~ 1,
                                        lifeExp > 75 ~ 1,
                                        TRUE ~ 0))
table(d_gap$var1)


## 3.2. Recodificación condicional con ifelse() ----

# Recodificacion con ifelse (una sola condición)
d_gap$poburu <- ifelse(d_gap$pop > 3000000, 1, 0)
table(d_gap$poburu)

# ifelse() anidado para varias condiciones
d_gap <- gapminder
d_gap$mercosur <-  ifelse(d_gap$country == "Uruguay", 1,
                          ifelse(d_gap$country == "Argentina", 1,
                                 ifelse(d_gap$country == "Paraguay", 1,
                                        ifelse(d_gap$country == "Brazil", 1, 
                                               0))))
table(d_gap$mercosur)



##  4. Datos perdidos   ====================================================


## 4.1. Datos perdidos y vectores ----
# Creo un vector que incluye datos perdidos
vector_n <- c(1, 2, 3, 4, NA, 5)
mean(vector_n) # No funciona si no especifico el argumento na.rm = TRUE
mean(vector_n, na.rm = TRUE) # Funciona

# Para chequear si cada observación es un dato perdido o no
is.na(vector_n)

# Operaciones con vectores y datos perdidos
vector1 <- c(1, 2, 3, 4)
vector2 <- c(1, 0, 1, NA)
vector_final <- vector1 / vector2
vector_final # Operaciones con valores NA arrojar resultados NA


## 4.2. Usos de is.na() ----

# Por ejemplo, usando any() podemos ver si hay al menos un valor perdido
any(is.na(vector2))

# Con which() podemos ver cuáles valores son perdidos
which(is.na(vector2))

# Con mean() podemos calcular el procentaje de datos perdidos
mean(is.na(vector2))

# Con sum() podemos calcular cuántos valores son perdidos
sum(is.na(vector2)) 

## NA cuando anexamos datos
encuesta <- data.frame(edad = c(18,24,80), 
                       ideologia = c("Izquierda", "Izquierda", "Derecha"),
                       voto = c("Partido A", "Partido A", "Partido C"))

encuesta_2 <- data.frame(edad = c(40, 44, NA), 
                         ideologia = c("Derecha", "Izquierda", "Derecha"),
                         voto = c("Partido B", "Partido A", "Partido C"),
                         genero = c("Mujer", "Hombre", "Mujer"))

encuesta_anexada <- plyr::rbind.fill(encuesta, encuesta_2)
print(encuesta_anexada)

# Con complete.cases vemos que filas están completas
complete.cases(encuesta_anexada)

# Con drop_na() de dplyr eliminamos las observaciones con datos perdidos en al menos una variable
drop_na(encuesta_anexada)

# También con drop_na() podemos eliminar casos con datos perdidos en una variable específica
drop_na(encuesta_anexada, edad)




