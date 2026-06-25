# Olhar para os hiperparametros de uma random forest

# 1. FUNÇÕES AUXILIARES E DE AVALIAÇÃO
## a) Critério de Impureza (Índice de Gini)
## Gini é o grau de impureza entre nós
calcular_gini <- function(y){
    if (length(y) == 0) 
        return(0)

    proporcoes <- table(y) / length(y)
    return(1 - sum(proporcoes^2))
}

# Códigos adaptados do kNN
## b) Matriz de Confusão 
plot_mc <- function(cm, titulo = "Matriz de Confusão"){
    cm_prop <- cm / sum(cm)
    image(
        x = 1:ncol(cm), 
        y = 1:nrow(cm), 
        z = t(cm[nrow(cm):1, ]), 
        axes = FALSE, 
        xlab = "Classe Predita", 
        ylab = "Classe Real", 
        main = titulo,
        col = hcl.colors(12, "Blues", rev = TRUE)
    )

    axis(1, at = 1:ncol(cm), labels = colnames(cm))
    axis(2, at = 1:nrow(cm), labels = rev(rownames(cm)))
    
    for (i in 1:nrow(cm)) {
        for (j in 1:ncol(cm)) {
        text(x = j, y = nrow(cm) - i + 1, 
            label = paste0(cm[i, j], "\n(", round(100 * cm_prop[i, j], 1), "%)"))
        }
    }
}

## c) Métricas de Desempenho 
metricas_class <- function(real, predito){
    # Garante que ambas as classes sejam fator e tenham os mesmos níveis
    real <- factor(real)
    predito <- factor(predito, levels = levels(real))

    # 1 - Matriz de confusão
    cm <- table(Real = real, Predito = predito)

    # 2 - N° total de observações
    n <- sum(cm)

    # 3 - Acurácia (global)
    acuracia <- sum(diag(cm)) / n

    # 4 - Erro de classificação
    erro <- 1 - acuracia
    
    # 5 - Métricas por classe
    classes <- rownames(cm)
    precisao <- numeric(length(classes))
    sensibilidade <- numeric(length(classes))
    especificidade <- numeric(length(classes))
    f1_score <- numeric(length(classes))

    names(precisao) <- classes
    names(sensibilidade) <- classes
    names(especificidade) <- classes
    names(f1_score) <- classes
    
    for (classe in classes) {
        vp <- cm[classe, classe]
        fp <- sum(cm[, classe]) - vp
        fn <- sum(cm[classe, ]) - vp
        vn <- n - vp - fp - fn
        
        precisao[classe] <- ifelse((vp + fp) == 0, NA, vp / (vp + fp))
        sensibilidade[classe] <- ifelse((vp + fn) == 0, NA, vp / (vp + fn))
        especificidade[classe] <- ifelse((vn + fp) == 0, NA, vn / (vn + fp))
        f1_score[classe] <- ifelse(
            is.na(precisao[classe]) | is.na(sensibilidade[classe]) | (precisao[classe] + sensibilidade[classe] == 0), 
            NA, 2 * precisao[classe] * sensibilidade[classe] / (precisao[classe] + sensibilidade[classe])
        )
    }
    
    # 6 - Métricas globais
    macro_precisao <- mean(precisao, na.rm = TRUE)
    macro_sensibilidade <- mean(sensibilidade, na.rm = TRUE)
    macro_especificadade <- mean(especificidade, na.rm = TRUE)
    macro_f1_score <- mean(f1_score, na.rm = TRUE)

    # 7 - Kappa de Cohen
    prop_observada <- acuracia
    prop_esperada <- sum(rowSums(cm) * colSums(cm)) / (n^2)
    kappa <- ifelse(
        (1 - prop_esperada) == 0, NA,
        (prop_observada - prop_esperada) / (1 - prop_esperada)
    )

    # 8 - Resultado (saida)
    resultado <- list(
        matriz_confusao = cm,
        acuracia = acuracia,
        erro = erro,
        precisao_por_classe = precisao,
        sensibilidade_por_classe = sensibilidade,
        especificidade_por_classe = especificidade,
        f1_por_classe = f1_score,
        macro_precisao = macro_precisao,
        macro_sensibilidade = macro_sensibilidade,
        macro_especificadade = macro_especificadade,
        macro_f1_score = macro_f1_score,
        kappa = kappa
    )

    return(resultado)
}

# 2. IMPLEMENTAÇÃO DA ÁRVORE DE DECISÃO (base da floreta rs)
## a) Procedimento para encontrar a melhor divisão em um nó 
find_best_split <- function(x_data, y_data, indices, m_try){
    p <- ncol(x_data)
    
    # Amostrar m_try variáveis sem reposição
    k_candidatas <- sample(1:p, size = m_try, replace = FALSE)
    
    delta_min <- Inf
    best_k <- NA
    best_s <- NA
    found <- FALSE
    
    # Busca pelas melhores regras de quebra
    for (k in k_candidatas){
        x_k <- x_data[indices, k]

        # Valores distintos ordenados
        u_k <- sort(unique(x_k)) 
        
        # Se não há variação, pule
        if (length(u_k) <= 1) next
        
        # Pontos médios
        s_k <- (u_k[-1] + u_k[-length(u_k)]) / 2
        
        for (s in s_k){
            # Divisão dos índices
            idx_L <- indices[x_k <= s]
            idx_R <- indices[x_k > s]
            
            # Cálculo do critério de impureza ponderado da divisão
            gini_L <- calcular_gini(y_data[idx_L])
            gini_R <- calcular_gini(y_data[idx_R])
            n_L <- length(idx_L)
            n_R <- length(idx_R)
            n_total <- length(indices)
            
            # Impureza = GINI
            delta <- (n_L / n_total) * gini_L + (n_R / n_total) * gini_R
            
            # Regra de atualização e desempate - critério de votação (simplificada, guarda a primeira ocorrência do mínimo)
            if (delta < delta_min){
                delta_min <- delta
                best_k <- k
                best_s <- s
                found <- TRUE
            }
        }
    }
    
    divisao_final = list(found = found, k = best_k, s = best_s)

    return(divisao_final)
}

## b) Função recursiva de crescimento da árvore (GrowTree)
grow_tree <- function(x_data, y_data, indices, depth, d_max, n_min, m_try){
    y_subset <- y_data[indices]
    
    # critérios de Parada
    is_pure <- length(unique(y_subset)) == 1
    if (depth >= d_max || length(indices) < n_min || is_pure){
        # retorna Nó Folha
        classe_majoritaria <- names(which.max(table(y_subset)))
        return(list(is_leaf = TRUE, prediction = classe_majoritaria))
    }
    
    # Buscar melhor quebra
    split_info <- find_best_split(x_data, y_data, indices, m_try)
    
    # se não achou/tem quebra válida, força folha
    if (!split_info$found){
        classe_majoritaria <- names(which.max(table(y_subset)))
        return(list(is_leaf = TRUE, prediction = classe_majoritaria))
    }
    
    # criar nó interno e realizar chamadas recursivas
    idx_L <- indices[x_data[indices, split_info$k] <= split_info$s]
    idx_R <- indices[x_data[indices, split_info$k] > split_info$s]
    
    # Retorna a estrutura em lista conectando a árvore
    return(list(
        is_leaf = FALSE,
        split_var = split_info$k,
        split_val = split_info$s,
        left = grow_tree(x_data, y_data, idx_L, depth + 1, d_max, n_min, m_try),
        right = grow_tree(x_data, y_data, idx_R, depth + 1, d_max, n_min, m_try)
    ))
}

## c) Função de predição de UMA árvore (PredictTree)
predict_tree_single <- function(tree, x_row){
  current_node <- tree

  # até encontrar uma folha
  while (!current_node$is_leaf) {
    # regra de decisão
    if (x_row[current_node$split_var] <= current_node$split_val){
      current_node <- current_node$left
    }else{
      current_node <- current_node$right
    }
  }
  return(current_node$prediction)
}

# 3. IMPLEMENTAÇÃO DO RANDOM FOREST (propriamente dito)

## a) Treinamento do RF e Erro OOB
rf_train <- function(
    x_train, 
    y_train, 
    B = 100, 
    d_max = 5, 
    n_min = 2, 
    m_try = NULL
){
    n_train <- nrow(x_train)
    classes <- levels(factor(y_train))
    
    # padrão para m_try de classificação: sqrt(p)
    if (is.null(m_try)) m_try <- max(1, floor(sqrt(ncol(x_train))))
    
    # Inicialização da Floresta
    floresta <- vector("list", B)
    
    # Matriz para guardar as predições OOB
    # Guardamos as contagens de votos para cada classe de cada observação
    oob_votes <- matrix(0, nrow = n_train, ncol = length(classes))
    colnames(oob_votes) <- classes
    oob_counts <- numeric(n_train)
    
    cat("Treinando Floresta (", B, " árvores)...\n", sep = "")
    
    # loop principal de construção 
    for (b in 1:B){
        # amostragem bootstrap
        indices_boot <- sample(1:n_train, size = n_train, replace = TRUE)
        
        # observações OOB (Out-of-Bag)
        indices_oob <- setdiff(1:n_train, unique(indices_boot))
        
        # crescimento da árvore usando apenas a amostra Bootstrap
        floresta[[b]] <- grow_tree(
            x_train, 
            y_train, 
            indices = indices_boot, 
            depth = 0, 
            d_max = d_max, 
            n_min = n_min, 
            m_try = m_try
        )
        
        # acumulo de predições OOB
        for (i in indices_oob){
            pred_oob <- predict_tree_single(floresta[[b]], as.numeric(x_train[i, ]))
            oob_votes[i, pred_oob] <- oob_votes[i, pred_oob] + 1
            oob_counts[i] <- oob_counts[i] + 1
        }
    }
    
    # calcular erro OOB agregado (função de perda: taxa de erro - misclassification)
    oob_predictions <- rep(NA, n_train)
    valid_oob_indices <- which(oob_counts > 0)
    
    for (i in valid_oob_indices) {
        oob_predictions[i] <- names(which.max(oob_votes[i, ]))
    }
    
    erros <- sum(oob_predictions[valid_oob_indices] != as.character(y_train[valid_oob_indices]))
    err_oob <- erros / length(valid_oob_indices)
    
    # OUTPUT
    return(list(
        floresta = floresta,
        B = B, d_max = d_max, 
        m_try = m_try,
        err_oob = err_oob,
        classes = classes
    ))
}

## b) Predição do RF (PredictRF)
rf_predict <- function(modelo_rf, x_test) {
    n_test <- nrow(x_test)
    B <- modelo_rf$B
    floresta <- modelo_rf$floresta
    
    predicoes_teste <- character(n_test)
    
    for (i in 1:n_test) {
        votos <- character(B)
        x_row <- as.numeric(x_test[i, ])
        
        # agrega a predição de cada árvore para a observação em voga
        for (b in 1:B) {
        votos[b] <- predict_tree_single(floresta[[b]], x_row)
        }
        
        # votação majoritária
        predicoes_teste[i] <- names(which.max(table(votos)))
    }
    
    return(factor(predicoes_teste, levels = modelo_rf$classes))
}
