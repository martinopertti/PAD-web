
## ***************************************************************************
##   Semana 12: Estadística Inferencial     
##   Solución de ejercicios             
##   Programación para el análisis de datos    
##   Martín Opertti             
## ***************************************************************************

library(tidyverse)
library(broom)
library(dslabs)

## Data de encuestas de las elecciones 2016 en EEUU del paquete dslabs, 
# de FiveThirtyEight. Pueden consultar la documentación aquí: 
# https://www.rdocumentation.org/packages/dslabs/versions/0.7.3/topics/polls_us_election_2016

data <- polls_us_election_2016 %>% 
  tibble()

data

## 1. Calcular la correlación entre el voto crudo y ajustado a Clinton


## 2. Graficar la correlación


## 3. Crear un gráfico de boxplot con la intención de voto ajustada a trump
# para las encuestadores de grado A- y las de grado C-


## 4. Agregar una línea horizontal con el parámetro de voto que obtuvo Trump
## (46.1) con la función geom_hline()


## 5. Realizar una prueba t para ver si hay diferencias estadísticamente
# signfiicativas entre las encuestadoras de grado A- vs las de grado C-


## 6. Pasar los resultados a un tibble y exportar a un excel


## 7. Estimemos un modelo de regresión para ver si el tamaño
# muestral es relevante en la precisión de las encuestadoras. 

## 7.0. Para ello primero calculemos el valor absoluto de la diferencia entre  
# la intención de voto a Trump en cada encuesta y su % final que obtuvo en 2016 (46.1%)
data <- data %>% 
  mutate(margen = abs(46.1 - rawpoll_trump))

range(data$margen) # Diferencias entre 0.1 y 17.3

# Calculemos también los días que faltan para la elección (electin day es
# el proxy)
data <- data %>% 
  mutate(dias_ele = as.numeric(as.Date("2016-11-08") - enddate))


# 7.1. Estimar modelo (VD = margen, VI = sample size y dias_ele)


# 7.2. Pasar resultados a formato tidy


# 7.3. Graficar coeficientes (sin el intercepto)

