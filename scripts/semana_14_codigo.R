
## ***************************************************************************
##   Semana 14: Programación avanzada    
##   Código de la presentación         
##   Programación para el análisis de datos    
##   Martín Opertti
## ***************************************************************************


## 0. Paquetes  ==============================================================

library(tidyverse)
library(gapminder)


## 1. Loops  =================================================================

# Supongamos que queremos imprimir en la consola los primeros 8 números primos
# seguidos de la frase "es un número primo". Podríamos hacer esto:
print("2 es un numero primo")
print("3 es un numero primo")
print("5 es un numero primo")
print("7 es un numero primo")
print("11 es un numero primo")

# o con un loop 
numeros_primos <- c(2, 3, 5, 7, 11)

for (i in seq_along(numeros_primos)){
  
  print(paste(numeros_primos[i], "es un numero primo"))

  }


# Para guardar el output de un loop debemos crear un objeto vacío para
# almacenarlo antes, con su dimensión esperada
objeto <- vector("character", # definimos el tipo de los datos  
                 length(numeros_primos))  # definimos la extensión

for (i in seq_along(numeros_primos)){

    objeto[i] <- paste(numeros_primos[i], "es un numero primo")

    }

objeto


# Para crear objetos de forma separada dentro de un loop usamos asign().

rm(list=ls())

# Para asignar un nombre a cada elemento
numeros_primos <- c(2, 3, 5, 7, 11)

# Creo un vector con el nombre de cada objeto
nom_np <- paste(as.character(numeros_primos), "obj", sep = "_") 

for (i in seq_along(numeros_primos)){
  
  assign(nom_np[i],
         paste(numeros_primos[i], "es un numero primo")
         )
  
}

ls()[1:5] # Objetos en el ambiente



## 2. Listas  ==============================================================

rm(list=ls())

d_gap <- gapminder::gapminder

# Crear lista
ejemplo_lista <- list(c("Uruguay", "Paraguay"), # Vector lenght = 2
                      d_gap, # Dataframe de gapminder
                      2 # Valor suelto
                      )

class(ejemplo_lista)

ejemplo_lista

# Indexación listas
ejemplo_lista[[1]] # Primer elemento de lista
ejemplo_lista[[1]][[2]] # Segundo valor del rpimer elemento

# Divido el dataframe de gapminder según continente
lista_df <- d_gap %>%
  group_split(continent, named = TRUE) %>% 
  setNames(sort(unique(d_gap$continent)))

lista_df

length(lista_df)
names(lista_df)

# De esta forma, puedo hacer un loop para guardar cada uno de ellos 
# Es necesario para que este código funcione que estés en un proyecto de R
# en la carpeta del curso, y tengas una carpeta que se llame "resultados" y
# dentro de esta, una que se llame "loops"
for (i in seq_along(lista_df)) {
  
  filename <-  paste0("resultados/loops/", names(lista_df)[i], ".csv")
  write.csv(lista_df[[i]], filename)
  
  }

# Quedan 5 dataframes guardados en la carpeta resultados/loops

rm(list = ls())

# Lista con dataframes en la carpeta
filenames <- list.files("resultados/loops", full.names=TRUE)

# Creo la lista con los nombres que va a tener cada base (quitar .csv)
namesfiles <- substr(filenames, 18, nchar(filenames)-4) 

# Ahora hago un loop para leer cada base
for (i in seq_along(filenames)) {
  
  assign(namesfiles[i], 
         read_csv(filenames[i])
  )
}

ls()


## 3. Funcionales  =========================================================

# En R se puede lograr lo mismo que los loops con menos código y más 
# eficiencia

# Creamos una lista de dataframes con los 5 dataframes
lista_df_new <- list(Africa, Americas, Asia, Europe, Oceania)

# Incluir los nombres de los objetos de una lista
names(lista_df_new) <- c("Africa", "Americas", "Asia", "Europe", "Oceania")

# Usamos map para crear una variable nueva y eliminar una existente 
# dentro de cada dataframe
list_df_final <- map(lista_df_new, function(df) {
  
  df <- df %>% 
    mutate(var_nueva = "Valor nuevo") %>% 
    select(-lifeExp)
  
})

# Chequeamos
Africa <- list_df_final[[1]] # Extraigo el primer df
head(Africa, 5)


# Podríamos haber hecho todo con lapply() o map()
filenames <- list.files("resultados/loops", full.names=TRUE)
lista_df_2 <- map(filenames, read.csv)
# El output es una lista de dataframes, a la cuál le agrego nombres
names(lista_df_2) <- c("Africa", "Americas", "Asia", "Europe", "Oceania")


# Transformar lista con mas de un dataframe en un solo dataframe
df_gapminder <- bind_rows(lista_df_2)
as_tibble(df_gapminder)




## 4. Condicionales  =====================================================

# Supongamos que tenemos un script donde cargamos un vector numérico distinto 
# cada vez que lo utilizamos. Queremos una medida de resumen para el vector 
# cada vez que corremos el script. Normalmente usamos la media, pero queremos
# decirle a R que cuando haya algún valor mayor o igual a 10, calcule la
# mediana, no la media. Para eso usamos condicionales:

vector_numerico <- c(1, 4, 5, 6, 7, 8, 9, 60)


if(max(vector_numerico) < 10){
  
  mean(vector_numerico)
  
} else {
  
  median(vector_numerico)  
}

vector_numerico <- c(1, 4, 5, 6, 7, 8, 9, 2)

if(max(vector_numerico) < 10){
  
  mean(vector_numerico)
  
} else {
  
  median(vector_numerico)  
  
}

