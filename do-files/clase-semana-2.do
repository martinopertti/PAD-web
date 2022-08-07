
*****************************************************************************
** Código de la clase - Semana 2
*****************************************************************************


**** Primeros pasos ---------------------------------------------------------

** Esto es una anotación. No será corrido en el código

** Hay varias formas de cargar datos en Stata, algunas de ellas:

* - Abrir haciendo click en una base de datos en formato .dta (no recomendado)

* - Utilizando la función use y la ubicación completa de la base podemos leerla
use "C:/Users/marti/Dropbox/cursos/Programación para el análisis de datos/clases/data/wb_paises.dta"
clear

* - Podemos fijar primero el directorio de trabajo con cd y luego simplemente
* el nombre del archivo luego del comando use. Esta es la versión recomendada
cd "C:/Users/marti/Dropbox/cursos/Programación para el análisis de datos/clases/data" 
use "wb_paises.dta"


**** Primeros comandos basicos  ---------------------------------------------

* Breve resumen de variables
summarize pob_mujeres pob_hombres pob_total

* Tablas
tabulate region income_group 

* Media
mean pob_total


**** Importar desde otros formatos ------------------------------------------

import delimited "wb_paises.csv"
import excel "wb_paises.xlsx", firstrow
clear // Limpio la memoria


**** Explorar datos ---------------------------------------------------------

* Cargo nuevamente la base
use "wb_paises_edit.dta"

** List para listar valores de variables
list if region == 5 // Listar países de Norteamerica
list country_name pob_total pob_mujeres pob_hombres if region == 5 // Listar países de Norteamerica variables específicas

** Con table podemos crear tablas más flexibles
* Tabla por región con la media de tres variables
table region, c(mean pob_total mean pob_mujeres mean pob_hombres)
* Tabla por region con distintos estadísticos de una misma variable
table region, c(n tasa_desempleo mean tasa_desempleo sd tasa_desempleo min tasa_desempleo max tasa_desempleo) 
* Tabla por región y grupo de ingreso con la media de una tercer variable
table region income_group, c(mean tasa_desempleo)
* Podemos agregar totales con row y column
table region income_group, c(mean tasa_desempleo) row 
table region income_group, c(mean tasa_desempleo) column 
table region income_group, c(mean tasa_desempleo) row column



**** Etiquetas y variables --------------------------------------------------

* Asignar etiqueta a variable
label variable pob_total "Población total del país"

* Crear nueva variable (si el país tiene al menos 10 millones de habitantes)
generate pais_10m = 0 
replace pais_10m = 1 if pob_total >= 10000000
ta pais_10m

* Primero creo las etiquetas de los valores con el nombre "pais_10m"
label define pais_10m 0 "Menos de 10M habitantes" 1 "Más de 10M habitantes", replace

* Luego pego las etiquetas de los valores a la variable
label values pais_10m pais_10m

* Asigno también etiqueta a la variable (descripción)
label variable pais_10m "Si el país tiene una población mayor o menor a 10 millones de habitantes"

* Chequeo que haya quedado bien
tabulate pais_10m
tabulate pais_10m, nola
labelbook pais_10m



**** Datos perdidos ---------------------------------------------------------

* Usando misstable podemos chequear las observaciones perdidas por variable
misstable summarize 

* Chequear que observaciones tienen datos perdidos
list country_name if missing(income_group)

* Con tabulate, podemos poner la opción missing para ver los datos perdidos
tabulate income_group
tabulate income_group, missing

* Generar variable nueva con datos perdidos
generate tasa_desempleo_rec = .
replace tasa_desempleo_rec = 1 if tasa_desempleo >= 10
replace tasa_desempleo_rec = 0 if tasa_desempleo < 10
tabulate tasa_desempleo_rec, missing

* Tener cuidado reemplzar missing por missing
replace tasa_desempleo_rec = . if tasa_desempleo == .
tabulate tasa_desempleo_rec, missing


**** Guardar datos ----------------------------------------------------------

* Guardamos usando el comando save (solo pongo el nombre de la nueva base porque
* ya fijé el directorio usando cd al principo del do-file
save "wb_paises_edit.dta", replace

* Chequeo que se haya guardado bien
use "wb_paises_edit.dta", clear
ta tasa_desempleo_rec


**** Sintáxis ---------------------------------------------------------------

* Abreviación de summarize
sum pob_mujeres pob_hombres pob_total 

* Resumir todas las variables que comeinzan con pob_
summarize pob_*

* Aplicar función a un subconjunto de los datos
summarize pob_total if region == 3

* Agregar opciones al final
summarize pob_total, detail

* Comando según otra variable
sort income_group
by income_group: summarize pob_total

* Más cómodo usar bysort:
bysort income_group: summarize pob_total

