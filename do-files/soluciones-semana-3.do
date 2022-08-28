
*****************************************************************************
** Soluciones ejercicio - Semana 3
*****************************************************************************


**** Cargar datos -----------------------------------------------------------
cd "C:/Users/marti/Dropbox/cursos/Programación para el análisis de datos/clases" 
use "data/wb_paises.dta"

** 1. Borrar las observaciones de Europa y Asia Central
drop if region == 2

** 2. Crear una nueva variable con el porcentaje de mujeres sobre la poblacion total
gen pob_mujeres_per = (pob_mujeres / pob_total) * 100

** 3. Ordenar los datos según la variable creada en el paso anterior
sort pob_mujeres_per 

** 4. ¿Cuáles son los 5 países con menor proporción de mujeres sobre la población total?
list country_name pob_mujeres_per 

** 5. Crear un histograma con el índice de gini
hist indice_de_gini

** 6. Crear una nueva variable con el comando recode, recodificando el índice 
* de gini en menor a 35, entre 35 y 45 y 45 y más, con las etiquetas bajo, 
* medio y alto para cada categoría respectivamente
recode indice_de_gini (0/35 = 1 Bajo) (35/45 = 2 Medio) (45/max = 3 Alto), gen(gini_rec)

** 7. ¿Qué valor tiene Uruguay en esta variable? Mostrar usando el comando list
list gini_rec if country_name == "Uruguay"

** 8. Crear un gráfico de barras con la media y la mediana del acceso a electricidad
* según la variable de indice de gini recodificada creada en el paso 6
graph bar (mean) acceso_electricidad (median) acceso_electricidad, over(gini_rec)

** 9. Estimar un modelo de regresión cuya variable dependiente sea el pib per 
* cápita y las variables independientes gasto_educacion y la variable recodificada
* del indice de gini, como variable categórica
reg pib_pc gasto_educacion i.gini_rec
