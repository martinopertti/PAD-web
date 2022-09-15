
## ***************************************************************************
##  Semana 5: Introducción y fundamentos de la programación en R   
##  Solución de ejercicios                         
##  Programación para el análisis de datos                      
##  Martín Opertti - 2022                                       
## ***************************************************************************

## 1. Crea un objeto con el año de tu nacimiento y suma tu edad
nacimiento <- 1996
nacimiento + 26

## 2. Borra el objeto
rm(nacimiento)

## 3. Crea un vector con 3 países a los que te gustaría ir de viaje
paises <- c("Islandia", "Inglaterra", "Croacia")

## 4. Agregar 2 países más que te gustaría visitar
otros_paises <- c("Canadá", "Perú")
paises <- c(paises, otros_paises)

## 5. Crea un vector los números enteros que van del 0 al 35 y otro con los 
# números de 0 a 100  que son múltiplos de 5
numeros_35 <- 0:35
numeros_100 <- seq(0, 100, 5)

## 6. Con la función length averiguar el tamaño de los vectores creados en el
# paso 5
length(numeros_35)
length(numeros_100)

## 7. Extraer los primeros 10 valores de cada vector y sumarlos creando un
# nuevo vector.
nuevo_vector <- numeros_35[1:10] + numeros_100[1:10]

## 8. Averigua el tipo de los vectores y comprueba que sean los correctos
class(paises) # El vector de los países debe ser de tipo "character"
class(numeros_35) # El vector de 0 a 35 debe ser numérico (integer o double)
class(numeros_100) # El vector de 0 a 100 debe ser numérico (integer o double)


