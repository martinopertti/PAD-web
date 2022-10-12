
## ***************************************************************************
##  Semana 7: Estadística descriptiva y limpieza de datos          
##  Solución de ejercicio                                          
##  Programación para el análisis de datos                                
##  Martín Opertti - 2022                                         
## ***************************************************************************

## Trabajaremos con un dataframe con datos de económicos y políticos de Uruguay. 
# La base se llama "datauru" y esta en formato excel (.xlsx)

## 1. Importar dataframe "datauru" y asignarle el mismo nombre "datauru" 
library(tidyverse)
library(readxl)

datauru <- read_excel("data/datauru.xlsx")

## 2. Imprime "datauru" y fijate las variables del dataframe y su tipo
# (puedes ayudarte con el codebook que está en la carpeta "data")
print(datauru)

## 3. Cuántas variables y observaciones tiene datauru?
dim(datauru)

## 4. Usa glimpse() para obtener un resumen de las variables
glimpse(datauru)

## 5. Crea una tabla para saber a qué partido político pertenece cada presidente
table(datauru$presidente, datauru$partido)

## 6. Transformar la variable "partido" a factores y cambiar su orden 
datauru$partido <- as.factor(datauru$partido)
levels(datauru$partido)
table(datauru$partido)

## 7. Cambiar el orden del factor partido por otro que no sea alfabético
datauru$partido <- fct_relevel(datauru$partido, "Partido Colorado")
levels(datauru$partido)
table(datauru$partido)


