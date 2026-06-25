source("models/random_forest.R")



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

preditoras <- setdiff(colunas_analise, "diagnosis")
dados_preditoras <- dados_modelo[, preditoras]

set.seed(42) 
indices_treino <- c()
classes_diagnostico <- levels(dados_modelo$diagnosis)

# Particionamento estratificado Holdout (70/30)
for (classe in classes_diagnostico) {
  indices_classes <- which(dados_modelo$diagnosis == classe)
  n_treino_classe <- floor(0.7 * length(indices_classes))
  indices_treino_classe <- sample(indices_classes, n_treino_classe)
  indices_treino <- c(indices_treino, indices_treino_classe)
}
indices_teste <- setdiff(1:nrow(dados_modelo), indices_treino)

x_train <- dados_modelo[indices_treino, preditoras]
y_train <- dados_modelo$diagnosis[indices_treino]
x_test <- dados_modelo[indices_teste, preditoras]
y_test <- dados_modelo$diagnosis[indices_teste]

cat("\nParticionamento estratificado Holdout (70/30):\n")
cat("Treino:", nrow(x_train), "observações\n")
print(table(y_train))
cat("Teste:", nrow(x_test), "observações\n")
print(table(y_test))

# b. tuning (Usando o erro OOB internamente para evitar vazamento de dados de teste)
cat("\n--- INICIANDO TUNING MANUAL ---\n")
grid_search <- expand.grid(
    B = c(10, 30),       # Número de árvores
    m_try = c(3, 4),     # Variáveis candidatas por divisão
    d_max = c(3, 5)      # Profundidade máxima
)
grid_search$OOB_Error <- NA

# Iterando sobre o grid de hiperparâmetros
for (i in 1:nrow(grid_search)){
    # Definimos semente para o resultado da busca ser replicável entre execuções
    set.seed(123) 
    modelo_temp <- rf_train(
        # Se quiser, posso comentar cada uma das variáveis
        x_train = x_train, 
        y_train = y_train, 
        B = grid_search$B[i], 
        m_try = grid_search$m_try[i], 
        d_max = grid_search$d_max[i], 
        n_min = 2
    )
    grid_search$OOB_Error[i] <- modelo_temp$err_oob
}

print("Resultados do Tuning (Ordenados pelo menor Erro OOB):")
grid_search <- grid_search[order(grid_search$OOB_Error), ]
print(head(grid_search, 5))

# Selecionando o melhor modelo baseado no Erro OOB
melhores_parametros <- grid_search[1, ]
cat(sprintf("\nMelhor Configuração Escolhida: B = %d, m_try = %d, d_max = %d (Erro OOB = %.4f)\n", 
            melhores_parametros$B, 
            melhores_parametros$m_try, 
            melhores_parametros$d_max, 
            melhores_parametros$OOB_Error))

# c. Treinamento Final com os melhores hiperparâmetros
cat("\n--- TREINANDO MODELO FINAL ---\n")
set.seed(2026)
modelo_final <- rf_train(
    x_train = x_train, 
    y_train = y_train, 
    B = melhores_parametros$B, 
    m_try = melhores_parametros$m_try, 
    d_max = melhores_parametros$d_max, 
    n_min = 2
)

# d. Avaliação no Conjunto de Teste Final
cat("\n--- AVALIAÇÃO NO TESTE ---\n")
predicoes_finais <- rf_predict(modelo_final, x_test)

desempenho <- metricas_class(real = y_test, predito = predicoes_finais)


cat("-- AVALIAÇÕES MACROS ---\n")
cat(sprintf("Acurácia no Teste: %.2f%%\n", desempenho$acuracia * 100))
cat(sprintf("Erro no Teste: %.2f%%\n", desempenho$erro * 100))
cat(sprintf("Precisão: %.2f%%\n", desempenho$macro_precisao * 100))
cat(sprintf("Sensibilidade: %.2f%%\n", desempenho$macro_sensibilidade * 100))
cat(sprintf("Especifidade: %.2f%%\n", desempenho$macro_especificadade * 100))
cat(sprintf("Macro F1-Score: %.4f\n", desempenho$macro_f1_score))
cat(sprintf("Kappa de Cohen: %.4f\n", desempenho$kappa))

cat("\n--- AVALIAÇÕES POR CLASSE ---\n")
cat(sprintf("Precisão: %.2f%%\n", desempenho$precisao_por_classe * 100))
cat(sprintf("Sensibilidade: %.2f%%\n", desempenho$sensibilidade_por_classe * 100))
cat(sprintf("Especificidade: %.2f%%\n", desempenho$especificidade_por_classe * 100))
cat(sprintf("Macro F1-Score: %.4f\n", desempenho$f1_por_classe))

# Plot da Matriz de Confusão
png("images/matriz-confusao-random-forest.png", width = 800, height = 600)
plot_mc(
  cm = desempenho$matriz_confusao, 
  titulo = paste0("Random Forest Manual \n Acurácia: ", round(desempenho$acuracia * 100, 2), "%")
)
dev.off()
