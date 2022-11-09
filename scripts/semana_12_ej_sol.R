
## *************************************************************************
##   Semana 12: Estadística Inferencial
##   Solución de ejercicios             
##   Programación para el análisis de datos
##   Martín Opertti
## *************************************************************************

## Data de encuestas de las elecciones 2016 en EEUU del paquete dslabs, 
# de FiveThirtyEight. Pueden consultar la documentación aquí: 
# https://www.rdocumentation.org/packages/dslabs/versions/0.7.3/topics/polls_us_election_2016

library(dslabs)
data <- polls_us_election_2016 %>% 
  tibble()

data



## 1. Calcular la correlación entre el voto crudo y ajustado a Clinton
cor(data$rawpoll_clinton, data$adjpoll_clinton)


## 2. Graficar la correlación
ggplot(data = data, aes(x = rawpoll_clinton, y = adjpoll_clinton)) +
  geom_point(shape = 21, fill = '#73C6B6',  size = 3, alpha = .7) +
  geom_smooth(method = "lm", se = FALSE, color = "black") +
  geom_text(label = paste("Correlación:", round(cor(gapminder$lifeExp, gapminder$gdpPercap), 2)), x = 70, y = 100000) +
  theme_minimal() +
  labs(title = "Relación entre voto crudo y ajustado a Clinton",
       x = "Voto crudo",
       y = "Voto ajustado")


## 3. Crear un gráfico de boxplot con la intención de voto ajustada a trump
# para las encuestadores de grado A- y las de grado C-
data_ac <- data %>% 
  filter(grade %in% c("A-", "C-")) 

data_ac %>%
  ggplot(aes(x = grade, y = adjpoll_trump)) +
  geom_boxplot(aes(fill = grade), outlier.shape = NA, lwd=1, alpha=0.5) +
  geom_jitter(aes(color = grade), size = 2, alpha = 0.4) +
  scale_color_brewer(palette = "Dark2") +
  scale_fill_brewer(palette = "Dark2") +
  theme(legend.position = "none")


## 4. Agregar una línea horizontal con el parámetro de voto que obtuvo Trump
## (46.1) con la función geom_hline()

data_ac %>%
  ggplot(aes(x = grade, y = adjpoll_trump)) +
  geom_boxplot(aes(fill = grade), outlier.shape = NA, lwd=1, alpha=0.5) +
  geom_jitter(aes(color = grade), size = 2, alpha = 0.4) +
  geom_hline(yintercept = 46.7, linetype = "dashed", size = 1) +
  scale_color_brewer(palette = "Dark2") +
  scale_fill_brewer(palette = "Dark2") +
  theme(legend.position = "none")


## 5. Realizar una prueba t para ver si hay diferencias estadísticamente
# signfiicativas entre las encuestadoras de grado A- vs las de grado C-

prueba_t <- t.test(adjpoll_trump ~ grade, data = data_ac)

prueba_t


## 6. Pasar los resultados a un tibble y exportar a un excel

prueba_t <- broom::tidy(prueba_t)

writexl::write_xlsx(prueba_t, "resultados_t.xlsx")


## 7. Estimemos un modelo de regresión para ver si el tamaño
# muestral es relevante en la precisión de las encuestadoras. 

## 7.0. Para ello primero calculemos el valor absoluto de la diferencia entre  
# la intención de voto a Trump en cada encuesta y su % final que obtuvo en 2016 (46.1%)
data <- data %>% 
  mutate(margen = abs(46.1 - rawpoll_trump))

range(data$margen) # Diferencias entre 0.1 y 17.3

# Calculemos también los días que faltan para la elección (electin day es
# el proxy)
data <- data %>% 
  mutate(dias_ele = as.numeric(as.Date("2016-11-08") - enddate))

# 7.1. Estimar modelo (VD = margen, VI = sample size y dias_ele)
reg <- lm(margen ~ samplesize + dias_ele, data = data)
summary(reg) # COn summary podemos ver los resultados

# 7.2. Pasar resultados a formato tidy
coef <- tidy(reg, conf.int = TRUE)
print(coef)

# 7.3. Graficar coeficientes (sin el intercepto)

coef %>% 
  filter(term != "(Intercept)") %>% 
  ggplot(aes(x = estimate, y = term)) +
  xlim(-0.015, 0.015) +
  geom_vline(xintercept = 0, linetype = "dashed") +
  geom_pointrange(aes(xmin = conf.low, xmax = conf.high)) +
  labs(title = "¿Cuánto influye el tamaño de la muestra en la precisión de la encuesta?",
       subtitle = "Coeficientes de modelo de regresión lineal",
       caption = "Data: FiveThirtyEight")


