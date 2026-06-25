# boxplot
# plot 
# hist
df <- read.csv("database/brest-cancer.csv")

# Boxplot - verificar outliers 
colunas_selecionadas <- c(
  "radius_mean", # normalizar
  "texture_mean", # normalizar
  "perimeter_mean", # normalizar
  "area_mean", # normalizar
  "smoothness_mean",
  "compactness_mean",
  "concavity_mean",
  "concave_points_mean",
  "symmetry_mean",
  "fractal_dimension_mean"
)

library(dplyr)
df_boxplot <- df |> select(colunas_selecionadas)

head(df_boxplot)

# NÃO PRECISA DE NORMALIZAÇÃO - 
png("images/boxplot-sem-normalizacao.png", width = 800, height = 600)
boxplot(
    x = df_boxplot,
    horizontal = FALSE, 
    varwidth = TRUE,
    outline = TRUE,
    col = "#ff5252", 
    main = "Distribuição das médias de raio, textura, suavidade, simetria e concavidade do tumor (sem normalização)", 
    xlab = "Variável analisada",
    ylab = "Valores das médias", 
    pch = 19,
    whiskcol = "gray40"
)
dev.off()

# Boxplot com normalização - melhor visualização dos dados
source("AED/z_score.R")
df_normalizado <- as.data.frame(lapply(df_boxplot, z_score))

png("images/boxplot-normalizado.png", width = 800, height = 600)
boxplot(
    x = df_normalizado,
    horizontal = FALSE, 
    varwidth = TRUE,
    outline = TRUE,
    col = "#ff5252", 
    main = "Distribuição das médias de raio, textura, suavidade, simetria e concavidade do tumor (sem normalização)", 
    xlab = "Variável analisada",
    ylab = "Valores das médias", 
    pch = 19,
    whiskcol = "gray40"
)
dev.off()

# Gráfico de barras - distribuição de frequências categóricas
freq_diag <- table(df$diagnosis)

png("images/freq-diagnostico.png", width = 800, height = 600)
barplot(height = freq_diag,
        col    = c("#555dfd", "#fe5353"),
        names.arg = c("Beningo", "Maligno"),
        border = "#000000",
        main   = "Distribuição dos diagnósticos de câncer de mama",
        xlab   = "Número de casos",
        ylab   = "Frequência Absoluta",
        ylim   = c(0, max(freq_diag)),
        las    = 1)
dev.off()
