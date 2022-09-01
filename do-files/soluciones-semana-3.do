
*****************************************************************************
** Soluciones ejercicio - Semana 3
*****************************************************************************


**** Cargar datos -----------------------------------------------------------
cd "C:/Users/marti/Dropbox/cursos/Programación para el análisis de datos/clases" 
use "data/wb_paises.dta", clear

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

** 6. Crear una nueva variable que:
* - tome el valor 2 si el país pertenece a Europa o Asia y es de ingresos altos
* - tome el valor 1 si el país pertenece a Asia pero no es de ingresos altos
* - tome el valor 0 para los países que no pertenecen a Asia
use "data/wb_paises.dta", clear // cargo de nuevo la base porque había eliminado a los países europeos
labelbook region income_group
gen eurasia_ing = 0
replace eurasia_ing = 1 if region == 1 | region == 2 | region == 6 // Condición particular (más chica)
replace eurasia_ing = 2 if (region == 1 | region == 2 | region == 6) & income_group == 4 // Condición general (más grande)
replace eurasia_ing = . if missing(region) | missing(income_group)
list country_name eurasia_ing  region income_group // chequeo

** 7. Crear una variable que concatene los valores de country_code y income_group
* Ver documentación de variable egen 
help egen
egen new_concat2 = concat(country_code income_group)

** 8. Crear una nueva variable con el comando recode, recodificando el índice 
* de gini en menor a 35, entre 35 y 45 y 45 y más, con las etiquetas bajo, 
* medio y alto para cada categoría respectivamente
recode indice_de_gini (0/35 = 1 Bajo) (35/45 = 2 Medio) (45/max = 3 Alto), gen(gini_rec)

** 9. ¿Qué valor tiene U
ruguay en esta variable? Mostrar usando el comando list
list gini_rec if country_name == "Uruguay"

** 10. Crear un gráfico de barras con la media y la mediana del acceso a electricidad
* según la variable de indice de gini recodificada creada en el paso 6
graph bar (mean) acceso_electricidad (median) acceso_electricidad, over(gini_rec)

** 11. Estimar un modelo de regresión cuya variable dependiente sea el pib per 
* cápita y las variables independientes gasto_educacion y la variable recodificada
* del indice de gini, como variable categórica
reg pib_pc gasto_educacion i.gini_rec
