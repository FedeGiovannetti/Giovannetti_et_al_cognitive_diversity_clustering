

datos.socio = read.csv("other data/datos_socio_soldati_PRE.csv")
datos.hacin = readxl::read_excel("other data/personas y habitaciones PICT 2014.xlsx")

datos.hacin = datos.hacin %>% 
  mutate(personas_habitacion = CANTPERSONAS/HABITACIONES) %>% 
  mutate(HacinamientoNES = case_when(
    
    personas_habitacion <= 2 ~ 9,
    personas_habitacion > 2 & personas_habitacion <= 4  ~ 6,    
    personas_habitacion > 4 & personas_habitacion <= 6  ~ 3,
    personas_habitacion > 6 ~ 0,   
  ))

cbq = read.csv("other data/cbq_corrected_PICT_2024_marzo.csv") %>% 
  select(username, SURGENCY, NEGATIVE_AFFECT, EFFORTFULL_CONTROL)%>%
  # filter(username %in% datos.reducidos$username) %>% 
  distinct(username, .keep_all = T)


datos.socio = datos.socio %>%  
  
  left_join(datos.hacin, by = c("username")) %>% 
  
  select(username, SEXO, EDAD_INICIO, EducacionMaterna, Biparental, EdadMaterna,
         EducacionNES, OcupacionNES, ViviendaNES, HacinamientoNES,
         PuntajeTotalNES) %>% 
  mutate(
    EducacionMaterna = case_when(
      EducacionMaterna <= 3 ~ "Low",
      EducacionMaterna > 3 & EducacionMaterna < 9 ~ "Mid",
      EducacionMaterna >= 9 ~ "High"
    ),
    Biparental = case_when(
      Biparental == 1 ~ "Biparental",
      Biparental == 0 ~ "Monoparental"
    ),
    Vivienda = case_when(
      ViviendaNES <= 9 ~ "Low",
      ViviendaNES >  9 ~ "High")
    ) %>%
  mutate(Biparental = as.factor(Biparental)) %>% 
  mutate(EducacionMaterna = as.factor(EducacionMaterna)) %>% 
  left_join(cbq, by = "username") %>% 
  rename(Sex = "SEXO") %>% 
  rename(Age = "EDAD_INICIO") %>% 
  rename('Maternal education' = "EducacionMaterna") %>% 
  rename('Family composition' = "Biparental") %>% 
  rename('Housing' = "Vivienda") %>% 
  rename('Maternal age' = "EdadMaterna") %>% 
  rename('NES' = "PuntajeTotalNES") %>% 
  rename(Surgency = "SURGENCY") %>% 
  rename('Negative affect' = "NEGATIVE_AFFECT") %>% 
  rename('Effortful control' = "EFFORTFULL_CONTROL") 
  


write.csv(datos.socio, "data/subject_information_PICT2014.csv", row.names = F)


#### Posible imputación de datos socio

# library(mice)
# 
# 
# 
# datos.para.imputar = datos.reducidos %>% 
#   left_join(datos.socio, by = "username") 
# # %>% 
# # select(-username)
# 
# 
# # Perform imputation using the mice function
# # imputed_data <- mice(datos.para.imputar, method = method, m = 5, maxit = 5, seed = 123)
# imputed_data <- mice(datos.para.imputar, m = 5, maxit = 5, seed = 123)
# 
# completed_data <- complete(imputed_data, action = 1)
# 
# imputed_data$imp$Biparental
# 
# colSums(is.na(datos.para.imputar))

cbq2017 = readxl::read_excel("Base CBQ Villa Soldati 2017.xlsx") %>% 
  select(-EDAD) %>% 
  rename(username = "CASO")

colnames(cbq2017) <- c("username", 1:36)
# 
cbq = read.csv("cbq_corrected_PICT_2024.csv", check.names = F) %>% 
  select(-SURGENCY, -NEGATIVE_AFFECT, -EFFORTFULL_CONTROL)
  
cbq = rbind(cbq, cbq2017)

cbq %>% 

  rowwise()%>%
  mutate(SURGENCY = mean(c(`1`,`4`, `7`, `10`,
                                    `13`,`16`, `19`, `22`,
                                    `25`, `28`, `31`, `34`), na.rm = T),
                  NEGATIVE_AFFECT = mean(c(`2`, `5`, `8`, `11`,
                                           `14`, `17`, `20`, `23`,
                                           `26`, `29`, `32`, `35`), na.rm = T),
                  EFFORTFULL_CONTROL = mean(c(`3`, `6`, `9`, `12`,
                                              `15`, `18`, `21`, `24`,
                                              `27`, `30`, `33`, `36`), na.rm = T)) -> cbq2

write.csv(cbq2, "cbq_corrected_PICT_2024_marzo.csv")









