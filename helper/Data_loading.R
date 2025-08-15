library(tidyverse)
library(knitr)
source("functions/data_retrieve.R")

  read_multiple_data_github(c("ANT", "STROOP", "CORSI", "TOL", "KBIT"), "processed", "PRE", 
                            git_pat = "secreto")
  # read_multiple_data(local_folder = "C:/Users/slipina/Desktop/Fede/Datos_PICT_2014" ,c("ANT", "STROOP", "CORSI", "TOL", "KBIT"), "processed", "PRE")
  
  write.csv(ANT, "ANT_PRE_PICT2014_processed.csv", row.names = F)
  write.csv(STROOP, "STROOP_PRE_PICT2014_processed.csv", row.names = F)
  write.csv(CORSI, "CORSI_PRE_PICT2014_processed.csv", row.names = F)
  write.csv(KBIT, "KBIT_PRE_PICT2014_processed.csv", row.names = F)
  write.csv(TOL, "TOL_PRE_PICT2014_processed.csv", row.names = F)


  