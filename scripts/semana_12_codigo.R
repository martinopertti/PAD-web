
## ***************************************************************************
##   Semana 12: Estadística Inferencial     
##   Código de la presentación         
##   Programación para el análisis de datos    
##   Martín Opertti
## ***************************************************************************


## 0. Paquetes  ==============================================================

library(tidyverse)
library(broom)

## 1. Margen de error e intervalo de confianza  ============================

# Simulamos datos de resultados electorales

# Fijo semilla para reproducir los resultados
set.seed(7)

# Crear data poblacional
datos_votos <- sample(x = c("Partido A", "Partido B", "Partido C"),
                      size = 3000000, 
                      replace = TRUE, 
                      prob = c(.25, .35, .4)
)

datos_votos <- tibble(voto = datos_votos)

# Tabla resumen
datos_votos %>% 
  group_by(voto) %>%
  summarise(n = n()) %>% 
  mutate(per = n / sum(n))

# Extraigo una muestra de 1000 casos 
m_1000 <- sample_n(datos_votos, 1000)

# Ahora calculamos manualmente el margen de error e intervalo de confianza 
# para esta muestra
m_1000_sum <- m_1000 %>% 
  group_by(voto) %>% 
  summarise(n = n()) %>% 
  mutate(
    prop = n/sum(n), # Proporción de cada categoría
    moe = (qnorm(0.975) * sqrt(prop*(1-prop)/nrow(m_1000))), # margen de error al 95% confianza    ci_inf =  prop - moe, # Intervalo inferior
    ci_inf =  prop - moe, # Intervalo superior
    ci_sup =  prop + moe # Intervalo superior
  ) 

# Graficamos
ggplot(m_1000_sum, aes(x = voto, y = prop, color = voto)) +
  geom_point(size = 4) +
  geom_errorbar(aes(ymin = ci_inf, ymax = ci_sup), width = .2, lwd = .75) +
  theme_minimal(base_size = 16) +
  labs(title = "Estimación muestra puntual (N = 1000) con intervalo de confianza",
       x = "",
       y = "") +
  scale_color_brewer(palette = "Dark2") +
  theme(legend.position = "none")




## 2. Correlación  =========================================================

# Cargar datos de gapminder
gapminder <- gapminder::gapminder

# Correlación
cor(gapminder$lifeExp, gapminder$gdpPercap)

# Correlación con método específico
cor(gapminder$lifeExp, gapminder$gdpPercap, method = "spearman")

# Graficar correlación
ggplot(data = gapminder, aes(x = lifeExp, y = gdpPercap)) +
  geom_point(shape = 21, fill = '#73C6B6',  size = 3, alpha = .7) +
  geom_smooth(method = "lm", se = FALSE, color = "black") +
  geom_text(label = paste("Correlación:", round(cor(gapminder$lifeExp, gapminder$gdpPercap), 2)), x = 70, y = 100000) +
  theme_minimal() +
  labs(title = "Relación entre expectativa de vida y PBI per cápita",
       x = "PBI per cápita",
       y = "Expectativa de vida")



## 3. Pruebas de hipótesis  ===============================================

# Data gapminder para Americas y Europa
df_gap <- gapminder::gapminder %>% 
  filter(continent %in% c("Americas", "Europe")) %>% 
  mutate(continent = as.factor(as.character(continent)))

# Prueba t
prueba_t <- t.test(lifeExp ~ continent, data = df_gap)

prueba_t

# Limpiar resultados con la función tidy() del paquete broom
prueba_t <- broom::tidy(prueba_t)

prueba_t

# Ahora podemos transformarlo como cualquier dataframe
prueba_t %>% 
  rename(estimador = estimate) 

# Guardar en excel 
writexl::write_xlsx(prueba_t, "resultados_t.xlsx")



## 4. Modelos de regresión   ===============================================

## Modelo de regresión
reg <- lm(lifeExp ~ gdpPercap + pop + year + continent, data = gapminder)

summary(reg) # Con summary podemos ver los resultados


## Regresión logística

# Creo nueva variable
gapminder <- mutate(gapminder, 
                    lifeExp_rec = case_when(lifeExp > 70 ~ 1,
                                            TRUE ~ 0))

# Por más que tenga solo dos valores, es numérica
class(gapminder$lifeExp_rec)

# Para esto debo transformarla a factor
gapminder <- mutate(gapminder,
                    lifeExp_rec = as.factor(lifeExp_rec))

class(gapminder$lifeExp_rec)

# Modelo
reg_logit <- glm(lifeExp_rec ~ gdpPercap + pop + year + continent,
                 data = gapminder,
                 family = binomial(link = "logit"))
summary(reg_logit)

## Cambiar categoría de referencia de un factor
gapminder <- mutate(gapminder,
                    continent = relevel(continent, ref = "Americas"))

reg_logit_2 <- glm(lifeExp_rec ~ gdpPercap + pop + year + continent,
                   family = binomial(link = "logit"),
                   data = gapminder)

summary(reg_logit_2)

# Pasar resultos a formato tidyverse
coef <- tidy(reg, conf.int = TRUE) 

coef

# También para la regresión logística
coef_log2 <- tidy(reg_logit_2, conf.int = TRUE) %>%
  mutate_if(is.numeric, ~ round(., 4))

coef_log2

# Si utilizamos fijamos exponentiate = TRUE dentro de tidy() en una regresión 
#  logística obtenemos los odds ratios
coef_log3 <- tidy(reg_logit_2, 
                  exponentiate = TRUE,
                  conf.int = TRUE) %>%
  mutate_if(is.numeric, ~ round(., 5))

coef_log3

# Con glance() también del paquete broom podemos obtener un tibble de una fila
# con estadísticas de bondad del modelo
glance(reg_logit_2)


## 5. Visualizar coeficientes   ===========================================

# Modelo con un solo predictor (continentes)
r_logit_1 <- glm(lifeExp_rec ~ continent,
                 family = binomial(link = "logit"),
                 data = gapminder)

coef_l_1 <- broom::tidy(r_logit_1, conf.int = TRUE) 

coef_l_1

# Grafico con geom_pointrange()
ggplot(coef_l_1, aes(x = estimate, y = term)) +
  geom_pointrange(aes(xmin = conf.low, xmax = conf.high)) +
  labs(title = "Factores explicativos de la expectativa de vida",
       subtitle = "Coeficientes de regresión de lineal",
       caption = "Data: Gapminder")


# Quitamos el intercepto y agregamos línea vertical en 0
ggplot(coef_l_1 %>% 
         filter(term != "(Intercept)"), aes(x = estimate, y = term)) +
  geom_pointrange(aes(xmin = conf.low, xmax = conf.high)) +
  geom_vline(xintercept = 0, linetype = "dashed") +
  labs(title = "Factores explicativos de la expectativa de vida",
       subtitle = "Coeficientes de regresión de lineal (excluye intercepto)",
       caption = "Data: Gapminder")



## 6. Visualización para comparar mdoelos  ================================

# Solo continente
r_logit_1 <- glm(lifeExp_rec ~ continent,
                 family = binomial(link = "logit"),
                 data = gapminder)

coef_l_1 <- tidy(r_logit_1, conf.int = TRUE) 

# Continente + gdp
r_logit_2 <- glm(lifeExp_rec ~ continent + gdpPercap,
                 family = binomial(link = "logit"),
                 data = gapminder)

coef_l_2 <- tidy(r_logit_2, conf.int = TRUE)

# Primero variable que identifique cada dataframe
coef_l_1 <- mutate(coef_l_1, modelo = "Modelo 1")
coef_l_2 <- mutate(coef_l_2, modelo = "Modelo 2")

# Unimos los resultados de ambos modelos
coef_l_merge <- rbind(coef_l_1, coef_l_2)

coef_l_merge

# Graficar dos modelos
coef_l_merge %>% 
  filter(term != "(Intercept)") %>% 
  ggplot(aes(x = estimate, y = term, color = modelo)) +
  geom_pointrange(aes(xmin = conf.low, xmax = conf.high)) +
  geom_vline(xintercept = 0, linetype = "dashed") +
  labs(title = "Comparación modelos",
       subtitle = "Coeficientes de regresión logística (excluye intercepto)",
       caption = "Data: Gapminder")


# Graficar dos modelos
coef_l_merge %>% 
  filter(term != "(Intercept)") %>% 
  ggplot(aes(x = estimate, y = term, color = modelo)) +
  geom_pointrange(aes(xmin = conf.low, xmax = conf.high)) +
  geom_vline(xintercept = 0, linetype = "dashed") +
  labs(title = "Comparación modelos",
       subtitle = "Coeficientes de regresión logística (excluye intercepto)",
       caption = "Data: Gapminder") +
  facet_wrap(~ modelo)





