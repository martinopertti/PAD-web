
## ***************************************************************************
##  Semana 5: Introducción y fundamentos de la programación en R   
##  Código de la presentación                                      
##  Programación para el análisis de datos                                 
##  Martín Opertti - 2022                                         
## ***************************************************************************

## En este script vamos a repasar algunas funciones y operadores básicos de R

##  1. Comandos básicos   ====================================================

# Creamos un objeto llamado "year" con este año en forma numérica
year <- 2022

# Lo podemos imprimir simplemente escribiendo su nombre.
year

# Otra forma:
(year <- 2022)

# También se puede imprimir de esta forma:
print(year)

# Podemos chequear si el objeto se creó correctamente mediante la lista del
# environment
ls()

# Ahora, que podemos hacer con este objeto? Lo podemos usar en operaciones
year - 1996



## 2. Objetos   =============================================================

## * 2.1. Crear objetos ----

# Usando la misma lógica, podemos almacenar el resultado
edad <- year - 1996
print(edad)

# Ahora podemos sumar estos objetos
year + edad

# Para obtener ayuda sobre una función usamos:
help(ls)

# Para eliminar el objeto del ambiente:
rm(year)

# Para eliminar todos los objetos del ambiente:
rm(list=ls())
print(year) # No encuentra el objeto porque lo borró


## * 2.2. Tipos de objetos ----

# Podemos volver a crear el objeto anterior, ahora de forma directa:
year <- 2022

# Creamos algunos objetos distintos
nombre <- "Dos mil veintidos"

# Uso la función typeof() para averiguar el tipo
typeof(year) 
typeof(nombre)

# Uso la función class() para averiguar la clase
class(year) # es un vector de tipo numérico
class(nombre) # es un vector de tipo character

year_2 <- "2022"
class(year_2)

vof <- TRUE
class(vof) 

## Por qué importa el tipo de objeto?
# Character
obj_1 <- "10"
class(obj_1)
obj_1 + 20 # Da error

# Numeric
obj_2 <- 10
class(obj_2)
obj_2 + 20 # Funciona

# Numeric to character
obj_1 <- as.numeric(obj_1)
class(obj_1)
is.numeric(obj_1) # Podemos verificarlo directamente también
obj_1 + 20 # Funciona



##  3. Vectores   ===========================================================

## * 3.1.  Crear un vector con c() ----
mi_primer_vector <- c(1, 2, 3, 4, 5) 
print(mi_primer_vector)
class(mi_primer_vector)
length(mi_primer_vector)
str(mi_primer_vector)

# Más vectores:
(v1 <- c(1:5)) # Todos los números de 1 a 5

(v2 <- seq(0, 50, 10)) # De 0 a 50 de a 10 números

(v3 <- c(v1, v2)) # Combino vectores creando un nuevo vector

(v4 <- c("rojo", "verde", "blanco")) # character

(v5 <- c(TRUE, TRUE, FALSE, TRUE)) # lógico


## * 3.2. Coerción automática: ----
(v6 <- c(v2, v4)) # Unir vector numérico con uno de caracteres
class(v6)


## * 3.3.  Indexación: ----
v2
v2[1] # El primer elemento dentro del vector 

# Nos sirve por ejemplo para extraer partes del vector:
(v3 <- v2[1:3]) # Creo nuevo vector con los elementos del 1 al 3

