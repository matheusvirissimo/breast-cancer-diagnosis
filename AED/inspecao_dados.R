# Inspeção inicial dos dados 
## Como os dados já possuem média, desvio padrão e pior caso
## iremos "ignorar"


df <- read.csv("database/brest-cancer.csv")

# %%
# 1 - Leitura rápida dos dados, organização e afins
# Estrutura dos dados
str(df)

# Visualização inicial
head(df)
head(is.na(df), n = 5)

# Dimensão 
cat(" Nº de linhas:",  dim(df)[1], "\n",
    "Nº de colunas:", dim(df)[2], "\n")

# Visualização compacta e completa
library(tidyverse)
glimpse(df)

library(summarytools)
dfSummary(df)

# %%
# 2 - Sumarização dos dados
## Ratifica-se que os próprios dados já possuem média, desvio padrão e "pior"

# Colunas que iremos usar na análise final
colunas_wdbc <- c(
  "id",
  "diagnosis",
  "radius_mean",
  "texture_mean",
  "perimeter_mean",
  "area_mean",
  "smoothness_mean",
  "compactness_mean",
  "concavity_mean",
  "concave_points_mean",
  "symmetry_mean",
  "fractal_dimension_mean"
)

## Média 
mean()
median()
var()
sd()

min()
max()
range()

quantile()

## Tabelas de frequência
cat(" # -------------------------------------------------------- #\n",
    "# Tabela de Frequências de Diagnóstico #\n",
    "# -------------------------------------------------------- #\n\n",
    
    paste("",
      capture.output(
        cbind(
          "Frequência Absoluta" = table(df$diagnosis),
          "Frequência Relativa (%)" = prop.table(table(df$diagnosis)) * 100
        )
      ),
      collapse = "\n"
    )
)


freq(df$diagnosis)

# library(datasets)
# teste <- df |> filter(diagnosis == "M")
# head(teste, n = 5)
# talvez usar o group_by para separar diagnóstico de M e B

