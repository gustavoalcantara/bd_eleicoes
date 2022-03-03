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
) -> dadoseidhm

hist(idhm$idhm_2010)

library(tidyverse)
idhm %>% 
  mutate(classificacao_idhm=case_when(
    idhm_2010<=0.699~'medio',
    idhm_2010>=0.700 & idhm_2010<0.799~'alto',
    idhm_2010>=0.800~'muito alto')) ->idhm

unique(idhm$classificacao_idhm)

#atualizacao 1/3

read.csv('dados_idhm.csv') -> x
dplyr::mutate(x,
              classificacao_idhm =
    dplyr::case_when(
    idhm_2010<=0.699~'medio',
    idhm_2010>=0.700 & idhm_2010<0.799~'alto',
    idhm_2010>=0.800~'muito alto')) -> x

#teste grafico
dplyr::filter(x,
              turno==2) |>
  dplyr::group_by(id_municipio)|>
  ggplot2::ggplot(aes(x=idhm_2010,
                      y=porcentagem,
                      color=resultado))+
  geom_point()+
  geom_smooth()



#Tabela classificação IDHM
library(stringr)
stringr::str_replace(x$resultado, "eleito", "Eleito") -> x
stringr::str_replace(x$resultado, "nao eleito", "Nao Eleito")


library(tidyverse)
dplyr::filter(x,
              turno==2) ->y

dplyr::mutate(y,
              classificacao_idhm=case_when(
                idhm_2010<=0.699~'Medio',
                idhm_2010>=0.700 & idhm_2010<0.799~'Alto',
                idhm_2010>=0.800~'Muito Alto')|>
  dplyr::mutate(
  Resultado = case_when(
    resultado=='eleito'~'Eleito',
    resultado=='nao eleito'~'Nao Eleito'
  )
)

#Grafico 1
dplyr::filter(x,
              turno==1) |>
  dplyr::group_by(id_municipio)|>
  ggplot2::ggplot(aes(x=reorder(sigla_partido, porcentagem, 
                                FUN=median), y=porcentagem,
                      fill=classificacao_idhm))+
  geom_boxplot()+
  scale_fill_discrete(name='IDHM',breaks=c('Medio', 'Alto', 'Muito Alto'))+
  coord_flip()+
  labs(title="Votação Presidencial em SP no 1º Turno e IDHM (2010)",
       x = "Partidos", y = "Porcentagem de Votos")

graphics.off()


#Grafico 3
dplyr::filter(x,
              turno==2) |>
  dplyr::group_by(id_municipio)|>
  ggplot2::ggplot(aes(x=idhm_2010,
                      y=porcentagem,
                      color=resultado))+
  geom_point()+
  geom_smooth()+
  scale_color_discrete(labels=c("Bolsonaro", "Fernando Haddad"))+
  labs(title="Relação entre IDHM e Porcentagem de Votos em SP",
       x = "IDHM",
       y = "Porcentagem de Votos",
       colour = 'Candidato:')+
  theme(legend.position = 'bottom')
