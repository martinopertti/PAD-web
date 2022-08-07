
*****************************************************************************
** Ejercicio - Semana 2
*****************************************************************************


**** Cargar datos -----------------------------------------------------------
cd "C:/Users/marti/Dropbox/cursos/Programación para el análisis de datos/clases/data" 
use "wb_paises.dta"

** 1. Listar el nombre, grupo de ingreso y poblacion total los países de la región "South Asia"

** 2. Crear una tabla que con el número de observaciones y la media la variable pob_ciudad por region

** 3. Asignar etiqueta a variable a las variables pob_total, pob_hombres y pob_mujeres

** 4. El siguiente código genera una variable que indica si el grupo de ingreso del pais
* (income group) es alto o bajo (recodificando de 4 a 2 categorías). La nueva variable,
* income_group_rec toma el valor 1 si es de bajo ingreso y valor 2 si es de alto ingreso
* Crear y asignar etiqueta de valores a la variable income group
generate income_group_rec = 1
replace income_group_rec = 2 if income_group == 3 | income_group == 4

** 5. Con el comando labelbook chequear que las etiquetas hayan quedado asignadas correctamente

** 6. Chequear si hay más valores perdidos en gasto_salud o gasto_militar

** 7. Listar los países que no tienen datos de pbi

** 8. Resumir (usando summarize) para todas las variables que empiecen con pob_*

** 9. Resumir (usando summarize) la variable de pbi según region, usando bysort

** 10. Guardar base modificada. La base debe llamarse "base_" y tu nombre, ej
* "base_juan"

** 11. Abrir la base recién guardada y chequear que esté la variable income_group_rec










