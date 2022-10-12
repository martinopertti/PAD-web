
## ***************************************************************************
##  Semana 7: Estadística descriptiva y limpieza de datos          
##  Código de la presentación                                      
##  Programación para el análisis de datos                                
##  Martín Opertti - 2022                                         
## ***************************************************************************


##  1. Directorios de trabajo  ===============================================

getwd() # Con está función puedo consultar el directorio

# Podríamos usar setwd() para cambiarlo
# Ahora estamos trabajando en un proyecto de R (.Rproj), por lo que el 
# directorio por defecto debe ser donde está ubicado el .Rproj


# Como todo lo que queremos importar a R está dentro de la carpeta, 
# solo hay que usar directorios relativos:

library(readxl)

datauru <- read_excel("data/datauru.xlsx")
head(datauru, 4) 
rm(datauru)



##  2. Dialectos  ============================================================    

# Creo un data.frame "encuesta"
encuesta <- data.frame(edad = c(18,24,80), 
                       ideologia = c("Izquierda", "Izquierda", "Derecha"),
                       voto = c("Partido A", "Partido A", "Partido C")
                       )

encuesta # Retomemos el data.frame "encuesta"

# Supongamos que quiero quedarme solo con las variables de edad y voto
encuesta_base <-  encuesta[ , c("edad", "voto")] # R Base

library(tidyverse)
encuesta_tidy <- select(encuesta, edad, voto) # Tidyverse

library(data.table)
encuesta_dt <- as.data.table(encuesta)[ , .(edad, voto)]

# Tres formas de lograr lo mismo:
colnames(encuesta_base)
colnames(encuesta_tidy)
colnames(encuesta_dt)



##  3. Importar datos a R   ==================================================

rm(list=ls())


## 3.1. Datos desde .csv ----

# Uno de los formatos más utilizados para almacenar datos son los archivos .csv
# En la carpeta data verán un .csv con datos de gapminder. 
# Tidyverse (mediante readr) nos permite importarlo con la función read_csv()
gapminder_csv <- read_csv("data/gapminder.csv")
head(gapminder_csv) # Usamos head para imprimir las primeras filas


## 3.2. Datos desde excel ----

# En la carpeta hay también un archivo llamado "gapminder" pero en formato excel
# Para importar datos de excel podemos utilizar el paquete readxl 
# Usamos la función read_excel()
gapminder_excel <- readxl::read_excel("data/gapminder.xlsx")
head(gapminder_excel)


## 3.3. Desde un paquete de R ----

# Algunos paquetes vienen con datos, por ejemplo, gapminder.
# En la documentación del paquete se encuentra el nombre de los datos 
# Con una simple asignación los podemos cargar 
library(gapminder)
d_gap <- gapminder


## 3.4. Datos desde SPSS y Stata ----
# Para estos tipos de datos usamos el paquete haven
library(haven)
gapminder_spss <- read_spss("data/gapminder.sav") # SPSS
class(d_gap$continent)
head(gapminder_spss)

gapminder_stata <- read_stata("data/gapminder.dta") # STATA
head(gapminder_stata)

# Para esto no necesitamos cargar paquetes. 
# Guardar un objeto como .rds:
saveRDS(object = d_gap, file = "resultados/d_gap.rds") # Creamos un archivo .rds

miobjeto_rds <- readRDS(file = "resultados/d_gap.rds") # Leemos un archivo .rds

# Con .rda se pueden guardar varios objetos al mismo tiempo!
save(d_gap, miobjeto_rds, 
     file = "resultados/dos_dataframes.Rdata") # Creamos un archivo .Rdata

rm(d_gap, miobjeto_rds) # Eliminamos el objeto del ambiente

load("resultados/dos_dataframes.Rdata") # Leemos un archivo .Rdata



##  4. Exportar datos =======================================================

rm(list = ls())

# Guardar .csv
d_gap <- gapminder
write_excel_csv(d_gap, "resultados/gapminder.csv")

# Guardar excel
library(writexl)
write_xlsx(d_gap, "resultados/gapminder.xlsx")

# Guardar .dta (Stata)
write_dta(d_gap, "resultados/gapminder.dta")

# Guardar .sav (SPSS)
write_sav(d_gap, "resultados/gapminder.sav")

# Guardar .sas (SAS)
write_sas(d_gap, "resultados/gapminder.sas")



##  5. Factores  ============================================================

# Podemos chequear y coercionar factores
is.factor(d_gap$continent) # Chequeo si es factor
levels(d_gap$continent) # Chequeo los niveles

# Transformo a caracter
d_gap$continent <- as.character(d_gap$continent)
class(d_gap$continent)

# De vuelta a factor
d_gap$continent <- as.factor(d_gap$continent) 
class(d_gap$continent)

# Para crear un factor usamos la función factor()
paises_mercosur <- factor(c("Argentina", "Brasil", "Paraguay", "Uruguay"))
table(paises_mercosur)

# La función fct_relevel() nos permite reordenar los niveles del factor
paises_mercosur <- fct_relevel(paises_mercosur, "Uruguay") 
table(paises_mercosur)
rm(list=ls())



##  6. Tibbles  =============================================================

d_gap <- gapminder
class(d_gap) # Ya es un tibble 

d_gap <- as.data.frame(d_gap)
class(d_gap) # Ahora solamente dataframe
print(d_gap)

d_gap <- as_tibble(d_gap) # Pasamos nuevamente a tibble
class(d_gap)
print(d_gap)



##  7. Explorar datos  ======================================================

# R tiene un visor para datos. Pueden clickear en el dataframe en el ambiente o:
View(d_gap)
dim(d_gap) # Número de filas y columnas
names(d_gap) # Nombre de variables
head(d_gap, 3) # Imprime primeras filas (3 en este caso)
str(d_gap) 
summary(d_gap) 
glimpse(d_gap) # Recomiendo utilizar esta función
ncol(d_gap) # Numero de columnas
nrow(d_gap) # Número de filas
runif(nrow(datauru), 0, 100) # Utilizar nrow() o ncol() como argumentos


# Para obtener una tabla de frecuencias de una variable usamos la función 
# table() de R Base
table(d_gap$continent) # Frecuencia simple

tabla_1 <- table(d_gap$continent) # Frecuencia simple

prop.table(tabla_1) # Proporciones

addmargins(tabla_1) # Totales

addmargins(prop.table(tabla_1)) # Proporciones y totales

## Tablas cruzadas

# Creo una variable Mercosur
d_gap$mercosur <- ifelse(d_gap$country == "Uruguay", 1,
                         ifelse(d_gap$country == "Argentina", 1,
                                ifelse(d_gap$country == "Paraguay", 1,
                                       ifelse(d_gap$country == "Brazil", 1,
                                              0))))

tabla_2 <- table(d_gap$continent, d_gap$mercosur)
tabla_2

# Editar nombre de columna
colnames(tabla_2) <- c("No mercosur", "Mercosur")
tabla_2

# Totales por fila o columna
prop.table(tabla_2)

prop.table(tabla_2, 1) # Total por fila

addmargins(prop.table(tabla_2, 1), 2) # Total por filas

prop.table(tabla_2, 2) # Total por filas

addmargins(prop.table(tabla_2, 2), 1) # Total por filas


