
*****************************************************************************
** Código de la clase - Semana 3
*****************************************************************************


**** Cargar datos ----------------------------------------------------------

cd "C:/Users/marti/Dropbox/cursos/Programación para el análisis de datos/clases" 
use "data/wb_paises.dta", clear



**** Limpiar datos ---------------------------------------------------------

** Ordenar datos
sort country_name

sort region, stable

sort region country_name

gsort - country_name

** Ordenar columnas
order country_name region, first

order country_code, after(country_name)

** Filtar observaciones
* Variables numéricas
keep if tasa_desempleo > 5 & tasa_desempleo <= 11.2
list country_name tasa_desempleo // chequeo

* Variables numéricas con etiquetas
keep if region == 5 | region == 3
tab region // chequeo

* Variables de texto o cadena
keep if country_name == "Uruguay" | country_name == "Argentina"
list country_name // chequeo


**** Crear variables --------------------------------------------------------

use "data/wb_paises.dta", clear

** A partir de expresiones genéricas
* Logaritmo de PIB
generate log_pib = log(pib)

* Poblacion total en habitantes a millones
generate poblacion_total_m = pob_total/1000000

* Total de área no selvática
gen area_no_selvatica = area_total - area_selvatica

* % de área selvatica
gen area_selvatica_per = (area_selvatica * 100) / area_total

* Porporción
gen area_selvatica_prop = area_selvatica / area_total


** A partir de valores específicos

* Crear variable nueva a partir de variable de cadena
gen mercosur = 0 // Primero creo variable con el valor 0 para todos
replace mercosur = 1 if country_name == "Argentina" // Recodificar cada país
replace mercosur = 1 if country_name == "Brasil"  
replace mercosur = 1 if country_name == "Paraguay"  
replace mercosur = 1 if country_name == "Uruguay"

list country_name if mercosur == 1 // Chequeo
list country_name mercosur if country_name == "Argentina"

* Cuidado con los missings (países con más de 3 millones de habitantes)
gen pob_m3 = 0
replace pob_m3 = 1 if pob_total >= 3000000
// Qué pasa con Eritrea que no tiene valor para población?
list country_name pob_total pob_m3 if missing(pob_total)
replace pob_m3 = . if missing(pob_total) // Si no incluyo esta línea Eritrea, 
// el país que no tiene datos de población va a quedar codificado como 1 
// cuando en realidad debe ser missing
list country_name pob_total pob_m3 if missing(pob_total) // Ahora sí

* Crear variable nueva a parti de variable numérica
gen td_rec = 0
replace td_rec =  1 if tasa_desempleo < 10
replace td_rec =  2 if tasa_desempleo >= 10 & tasa_desempleo < 15 
replace td_rec =  3 if tasa_desempleo >= 15
replace td_rec = . if missing(tasa_desempleo)
list country_name tasa_desempleo td_rec if td_rec == 3 // Chequeo

* Crear variable a partir de más de una variable
* Dummy que indique qué países tienen un crecimiento poblacional mayor al 2% y
* un acceso a la electricidad menor al 90%
gen crec_ele = 0
replace crec_ele = 1 if pob_crecimiento > 2 & acceso_electricidad < 90
replace crec_ele = . if missing(pob_crecimiento) | missing(acceso_electricidad)
list country_name crec_ele pob_crecimiento acceso_electricidad  if crec_ele == 1

** Condiciones no excluyentes:
*Crear una variable que:
* - tome el valor 2 si el gasto en educación y en salud es mayor a 6%
* - tome el valor 1 si el gasto en una de estas dos variables es mayor al 6% pero no en la otra
* - tome el valor 0 si el gasto en ambas variables es menor a 6%
* - sea missing si tenemos valores perdidos en alguna de estas dos variables.
gen var_ej = 0
replace var_ej = 1 if gasto_salud > 6 | gasto_educacion > 6 // general
replace var_ej = 2 if gasto_salud > 6 & gasto_educacion > 6 // particular
replace var_ej = . if missing(gasto_salud) | missing(gasto_educacion)
list country_name var_ej gasto_salud gasto_educacion // Chequeo

** Utilizando egen 
egen promedio_gasto = rowmean(gasto_salud gasto_educacion gasto_militar)

egen td_rec_2 = cut(tasa_desempleo), at(0, 10, 15, 30) label

egen pob_total_rank = rank(pob_total)
gsort -pob_total_rank // chequeo
list country_name pob_total_rank pob_total // chequeo

** Utilizando recode

* Recodificar valores específicos dentro de la misma variable
ta region
recode region (5 = 3) (6 = 1)
ta region

* Recodificar valores específicos, generando una nueva variable
recode region (2 = 1) (5 = 4), gen(region_rec)
ta region_rec

* Recodificar intervalos generando variable nueva
drop td_rec
recode tasa_desempleo (0/5 = 1) (6/10 = 2) (11/15 = 3) (15/max = 4), gen(td_rec)

* Recodificar intervalos generando variable nueva con etiqueta
drop td_rec_2
recode tasa_desempleo (0/5 = 1 Baja) (5/10 = 2 Media) (10/15 = 3 Alta) (15/max = 4 Muy_alta), gen(td_rec_2)
sort tasa_desempleo
list tasa_desempleo td_rec_2

**** Gráficos -------------------------------------------------------------

** Histogramas

* Histograma simple
hist tasa_desempleo

* Histograma con procentaje (en lugar de densidad)
hist tasa_desempleo, percent

* Histograma con frecuencia
hist tasa_desempleo, frequency

* Histograma con título
hist tasa_desempleo, percent title("Tasa de desempleo en 2018")

*Histograma por región
hist tasa_desempleo, percent by(region)

** Gráficos de dispersión
graph twoway scatter pib_pc co2_pc

* Funciona solo con scatter también
scatter pib_pc co2_pc

* Agregar etiquetas de variables para los ejes y título
label variable pib_pc "PIB per cápita"
label variable co2_pc "Emisiones de CO2 per cápita"
scatter pib_pc co2_pc, ///
 title("Relación entre PIB per cápita y CO2 per cápita")

* Agregar etiqueta para puntos
scatter pib_pc co2_pc, ///
 title("Relación entre PIB per cápita y CO2 per cápita") ///
 mlabel(country_code) 

** Gráficos de barras

* Media de variable númerica según categoría de otra variable
graph bar pib_pc, over(region) ///
 title("Media de PIB per cápita según región") 

* Barras horizontales para mejorar la visualización
graph hbar pib_pc, over(region) ///
 title("Media de PIB per cápita según región") 

* Agregar medias, medianas y máxima
graph hbar (mean) pib_pc (median) pib_pc (max) pib_pc, over(region) ///
 title("Media de PIB per cápita según región") 

* Cambiar tema
graph hbar (mean) pib_pc (median) pib_pc (max) pib_pc, over(region) ///
 title("Media de PIB per cápita según región") scheme(economist)

** Exportar gráficos

* Exportar como gph (formato Stata)
graph save "graficos/ejemplo"

* Exportar como png
graph export "graficos/ejemplo.png"

* Exportar como pdf
graph export "graficos/ejemplo.pdf" 


**** Estadística inferencial ----------------------------------------------
 
** Prueba t para ver si hay diferencias de co2_pc por ingresos altos o bajos

* Primero recodificamos la variable
recode income_group (1/2=1 Bajos) (3/4=2 Altos), gen(income_group_2)

* Prueba t
ttest co2_pc, by(income_group_2)

** Regresión lineal
reg co2_pc pib_pc i.region

 
 
 
 
 

 