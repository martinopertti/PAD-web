
*****************************************************************************
** Ejercicio - Semana 3
*****************************************************************************


**** Cargar datos -----------------------------------------------------------
cd "C:/Users/marti/Dropbox/cursos/Programación para el análisis de datos/clases" 
use "data/wb_paises.dta"

** 1. Borrar las observaciones de Europa y Asia Central

** 2. Crear una nueva variable con el porcentaje de mujeres sobre la poblacion total

** 3. Ordenar los datos según la variable creada en el paso anterior

** 4. ¿Cuáles son los 5 países con menor proporción de mujeres sobre la población total?

** 5. Crear un histograma con el índice de gini

** 6. Crear una nueva variable con el comando recode, recodificando el índice 
* de gini en menor a 35, entre 35 y 45 y 45 y más, con las etiquetas bajo, 
* medio y alto para cada categoría respectivamente

** 7. ¿Qué valor tiene Uruguay en esta variable? Mostrar usando el comando list

** 8. Crear un gráfico de barras con la media y la mediana del acceso a electricidad
* según la variable de indice de gini recodificada creada en el paso 6

** 9. Estimar un modelo de regresión cuya variable dependiente sea el pib per 
* cápita y las variables independientes gasto_educacion y la variable recodificada
* del indice de gini, como variable categórica
