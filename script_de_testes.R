rm(list=ls())
graphics.off()
gc(reset = TRUE)
getwd()
#Leitura do d.f de IDHM
idhm <- readxl::read_xlsx(
    "C:/Users/User/Desktop/Gustavo/base_dos_dados/idhm_sp.xlsx")

#Salvando o Csv
write.csv(idhm, "idhm_sp.csv", row.names = TRUE)

#Rename das Variaveis
dplyr::rename(x, id_municipio = 'Cod IBGE' ) -> idhm

#Join dos dados
dplyr::left_join(dados, 
                 idhm, 
                 by='id_municipio'
) -> dados_idhm

hist(idhm$idhm_2010)

library(tidyverse)
idhm %>% 
  mutate(classificacao_idhm=case_when(
    idhm_2010<=0.699~'medio',
    idhm_2010>=0.700 & idhm_2010<0.799~'alto',
    idhm_2010>=0.800~'muito alto')) ->idhm

unique(idhm$classificacao_idhm)

