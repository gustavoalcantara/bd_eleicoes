#Preparando o Ambiente
rm(list = ls())
gc(reset = TRUE)
graphics.off()

#Inicio da Jornada
library(bigrquery)
library(basedosdados)
library(DBI)
con <- bigrquery::dbConnect(
  bigquery(),
  billing ='basedosdados-elections',
  project='basedosdados'
)

#Mudando para o meu projeto no Google Cloud
set_billing_id("basedosdados-elections")

#Download dos dados
query <- bdplyr("br_tse_eleicoes.resultados_candidato_municipio")
df <- bd_collect(query)
dplyr::glimpse(df) #verificar se tá ok

# Limpeza dos dados e atribuição de Objeto
library(tidyverse)
df %>%
  select(ano,
         turno,
         sigla_uf,
         sigla_partido,
         id_municipio,
         votos,
         resultado,
         cargo) %>% 
  filter(sigla_uf=="SP", ano==2018, cargo=='presidente') %>%
  group_by(id_municipio) %>% 
  mutate(porcentagem = votos/sum(votos)*100) -> ele_pr_sp_2018 

  
  




