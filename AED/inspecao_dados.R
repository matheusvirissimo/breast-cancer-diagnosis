# Inspeção inicial dos dados 
## Como os dados já possuem média, desvio padrão e pior caso
## iremos "ignorar"


df <- read.csv("database/brest-cancer.csv")
df$diagnosis <- factor(
  df$diagnosis,
  levels = c("B", "M"),
  labels = c("Benigno", "Maligno")
)

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

df_selecionado <- df[, colunas_wdbc]

## Medidas-resumo das variáveis numéricas preditoras
dados_numericos <- df_selecionado[
  , setdiff(names(df_selecionado), c("id", "diagnosis"))
]

resumo_estatistico <- data.frame(
  Media = sapply(dados_numericos, mean, na.rm = TRUE),
  Mediana = sapply(dados_numericos, median, na.rm = TRUE),
  Variancia = sapply(dados_numericos, var, na.rm = TRUE),
  Desvio_Padrao = sapply(dados_numericos, sd, na.rm = TRUE),
  Minimo = sapply(dados_numericos, min, na.rm = TRUE),
  Maximo = sapply(dados_numericos, max, na.rm = TRUE),
  Amplitude = sapply(dados_numericos, function(x) diff(range(x, na.rm = TRUE))),
  Q1 = sapply(dados_numericos, quantile, probs = 0.25, na.rm = TRUE),
  Q3 = sapply(dados_numericos, quantile, probs = 0.75, na.rm = TRUE),
  check.names = FALSE
)

print(round(resumo_estatistico, 4))

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

cat("\nResumo das variáveis preditoras:\n")
print(summary(df[, -1]))

# %%
# TUNING MANUAL, TREINAMENTO E AVALIAÇÃO FINAL

## a. Preparação dos Dados (Breast Cancer Wisconsin Diagnostic)
dados <- read.csv("database/brest-cancer.csv", stringsAsFactors = FALSE)
colunas_analise <- c(
  "diagnosis", # target
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

dados_modelo <- dados[, colunas_analise]
dados_modelo$diagnosis <- factor(
  dados_modelo$diagnosis,
  levels = c("B", "M"),
  labels = c("Benigno", "Maligno")
)

cat("\n--- INSPEÇÃO DOS DADOS ---\n")
cat("Arquivo: database/brest-cancer.csv\n")
cat("Linhas:", nrow(dados_modelo), "\n")
cat("Colunas usadas na análise:", ncol(dados_modelo), "\n\n")

cat("Primeiras observações:\n")
print(head(dados_modelo))

cat("\nEstrutura das colunas usadas:\n")
str(dados_modelo)

cat("\nFrequência do diagnóstico:\n")
freq_diagnostico <- table(dados_modelo$diagnosis)
print(cbind(
  "Frequência Absoluta" = as.vector(freq_diagnostico),
  "Frequência Relativa (%)" = round(prop.table(freq_diagnostico) * 100, 2)
))

cat("\nResumo das variáveis preditoras:\n")
print(summary(dados_modelo[, -1]))

if (!dir.exists("images")) {
  dir.create("images")
}

png("images/freq-diagnostico.png", width = 800, height = 600)
barplot(
  height = freq_diagnostico,
  col = c("#3f7f6f", "#d95f5f"),
  border = "#222222",
  main = "Distribuição dos diagnósticos de câncer de mama",
  xlab = "Diagnóstico",
  ylab = "Frequência absoluta",
  ylim = c(0, max(freq_diagnostico) * 1.1),
  las = 1
)
dev.off()

preditoras <- setdiff(colunas_analise, "diagnosis")
dados_preditoras <- dados_modelo[, preditoras]
dados_preditoras_padronizados <- as.data.frame(scale(dados_preditoras))

png("images/boxplot-normalizado.png", width = 1000, height = 700)
boxplot(
  dados_preditoras_padronizados,
  horizontal = FALSE,
  outline = TRUE,
  col = "#7aa6c2",
  main = "Distribuição padronizada das variáveis usadas na análise",
  xlab = "Variável analisada",
  ylab = "Z-score",
  las = 2,
  pch = 19
)
dev.off()
