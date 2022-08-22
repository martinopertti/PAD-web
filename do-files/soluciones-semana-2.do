
*****************************************************************************
** Soluciones ejercicio - Semana 2
*****************************************************************************


**** Cargar datos -----------------------------------------------------------
cd "C:/Users/marti/Dropbox/cursos/Programación para el análisis de datos/clases" 
use "data/wb_paises.dta"

** 1. Listar el nombre, grupo de ingreso y poblacion total los países de la región "South Asia"
list country_name income_group pob_total if region == 6

** 2. Crear una tabla que con el número de observaciones y la media la variable pob_ciudad por region
table region, c(n pob_ciudad mean pob_ciudad)

** 3. Asignar etiqueta a variable a las variables pob_total, pob_hombres y pob_mujeres
label variable pob_total "Población total del país"
label variable pob_hombres "Población de hombres"
label variable pob_mujeres "Población de mujeres"

** 4. El siguiente código genera una variable que indica si el grupo de ingreso del pais
* (income group) es alto o bajo (recodificando de 4 a 2 categorías). La nueva variable,
* income_group_rec toma el valor 1 si es de bajo ingreso y valor 2 si es de alto ingreso
* Crear y asignar etiqueta de valores a la variable income group
generate income_group_rec = 1
replace income_group_rec = 2 if income_group == 3 | income_group == 4

label define income_group_rec 1 "Ingresos bajos" 2 "Ingresos altos", replace
label values income_group_rec income_group_rec

** 5. Con el comando labelbook chequear que las etiquetas hayan quedado asignadas correctamente
labelbook income_group_rec

** 6. Chequear si hay más valores perdidos en gasto_salud o gasto_militar
misstable summarize gasto_salud gasto_militar

** 7. Listar los países que no tienen datos de pbi
list country_name if missing(pib)

** 8. Resumir (usando summarize) para todas las variables que empiecen con pob_*
summarize pob_*

** 9. Resumir (usando summarize) la variable de pbi según region, usando bysort
bysort region: summarize pob_total

** 10. Guardar base modificada. La base debe llamarse "base_" y tu nombre, ej
* "base_juan"
save "base_martin.dta", replace

** 11. Abrir la base recién guardada y chequear que esté la variable income_group_rec
use "wb_paises_edit.dta", clear
ta income_group_rec










