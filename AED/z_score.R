# Variáveis a serem padronizadas
## As variáveis
## escolhidas foram radius_mean, texture_mean, smoothness_mean,
## concave_points_mean e symmetry_mean, por apresentarem informações
## relevantes e representarem diferentes aspectos morfológicos dos tumores
## mamários.

# Z = \frac{X - {media}_X}{{desvio_padrao}_X}
z_score <- function(x){
    return((x - mean(x)) / (sd(x)))
}
