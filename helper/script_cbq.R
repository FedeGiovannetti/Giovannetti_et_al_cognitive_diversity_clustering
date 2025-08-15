library(dplyr)

cbq <- read.csv("CBQ_2018_limpia.csv")

colnames(cbq)  <- c("username", "birth", "date", "date", as.character(1:36))

cbq[,5:40] <- as.integer(unlist(cbq[,5:40]))



cbq%>%
  select(-date)%>%
  # group_by(username)%>%
  rowwise()%>%
  mutate(suma_EFFORT = sum(c(`3`, `6`, `9`, `12`,
                             `15`, `18`, `21`, `24`,
                             `27`, `30`, `33`, `36`, na.rm = F)),
         SURGENCY = mean(c(`1`,`4`, `7`, `10`,
                        `13`,`16`, `19`, `22`,
                        `25`, `28`, `31`, `34`), na.rm = T),
         NEGATIVE_AFFECT = mean(c(`2`, `5`, `8`, `11`,
                                  `14`, `17`, `20`, `23`,
                                  `26`, `29`, `32`, `35`), na.rm = T),
         EFFORTFULL_CONTROL = mean(c(`3`, `6`, `9`, `12`,
                                    `15`, `18`, `21`, `24`,
                                    `27`, `30`, `33`, `36`, na.rm = T))) -> cbq



write.csv(cbq, "CBQ_2017_limpio.csv")

cbq%>%
  select(username, SURGENCY, NEGATIVE_AFFECT, EFFORTFULL_CONTROL) -> cbq_1

sueño <- read.csv("sueño_2017_limpia.csv")

sueño%>%
  select(username, escala_inicio_mantenimiento, escala_respiracion, escala_somnolencia) -> sueño

data <- left_join(cbq_1, sueño)

pairs.panels(data[2:7])
