# Input

* **1:** $\mathcal{D}_{\text{train}} = \{(\mathbf{x}_j, y_j)\}_{j=1}^{n_{\text{train}}}$, com $\mathbf{x}_j \in \mathbb{R}^p$ e $y_j \in \{1, \dots, C\}$; $\mathcal{D}_{\text{test}} = \{\tilde{\mathbf{x}}_i\}_{i=1}^{n_{\text{test}}}$, com $\tilde{\mathbf{x}}_i \in \mathbb{R}^p$
* **2:** $\mathcal{I}(\cdot)$ (critério de impureza);
* **3:** $d_{\text{max}}$ (profundidade máxima);
* **4:** $n_{\text{min}}$ (mínimo de observações por nó)
* **5:** $B$ (número de árvores);
* **6:** $n_{\text{boot}}$ (tamanho da amostra bootstrap);
* **7:** $m_{\text{try}}$ (número de variáveis candidatas por divisão)
* **8:** $\mathcal{R}$ (regra de desempate)
* **9:** $L : \{1, \dots, C\} \times \{1, \dots, C\} \rightarrow \mathbb{R}_+$ (função de perda para o conjunto OOB)
* **10:** $C$ (número de classes)


---

# Execução

* **11:** Inicialize a floresta $\mathcal{F} = \{T_b\}_{b=1}^B$
* **12:** Inicialize conjuntos OOB: $\mathcal{O}_1, \dots, \mathcal{O}_B \leftarrow \emptyset$
* **13:**

### Função de crescimento da árvore

* **14:** **procedure** $\text{GrowTree}(\mathcal{J}, d, \mathcal{D})$
* **15:** **if** $d \geqslant d_{\max}$ **ou** $|\mathcal{J}| < n_{\min}$ **ou** $|\{y_j : j \in \mathcal{J}\}| = 1$ **then**
* **16:** Defina o nó como folha e atribua $\hat{y} \leftarrow \arg \max_{c \in \{1, \dots, C\}} \sum_{j \in \mathcal{J}} \mathbb{I}(y_j = c)$ (em $\mathcal{D}$)
* **17:** **return**
* **18:** **end if**
* **19:** Amostre sem reposição $\mathcal{K} \subset \{1, \dots, p\}$ com $|\mathcal{K}| = m_{\text{try}}$
* **20:** Inicialize $\Delta_{\min} \leftarrow +\infty$, $\text{found} \leftarrow \text{FALSE}$ e conjunto de ótimos $\mathcal{C} \leftarrow \emptyset$
* **21:** **for all** $k \in \mathcal{K}$ **do**
* **22:**   $\mathcal{U}_k \leftarrow$ valores distintos ordenados de $\{x_{jk} : j \in \mathcal{J}\}$ (em $\mathcal{D}$)
* **23:**   **if** $|\mathcal{U}_k| \leqslant 1$ **then**
* **24:**       **continue**
* **25:**   **end if**
* **26:**   $\mathcal{S}_k \leftarrow \left\{ \frac{u_m + u_{m+1}}{2} : u_m, u_{m+1} \in \mathcal{U}_k \text{ consecutivos}, m = 1, \dots, |\mathcal{U}_k| - 1 \right\}$
* **27:**   **for all** $s \in \mathcal{S}_k$ **do**
* **28:**       $\mathcal{J}_L \leftarrow \{j \in \mathcal{J} : x_{jk} \leqslant s\}$, $\mathcal{J}_R \leftarrow \{j \in \mathcal{J} : x_{jk} > s\}$ (em $\mathcal{D}$)
* **29:**       **if** $|\mathcal{J}_L| < n_{\min}$ **ou** $|\mathcal{J}_R| < n_{\min}$ **then**
* **30:**           **continue**
* **31:**       **end if**
* **32:**       $\Delta \leftarrow \mathcal{I}(\mathcal{J}_L; \mathcal{D}) + \mathcal{I}(\mathcal{J}_R; \mathcal{D})$
* **33:**       **if** $\Delta < \Delta_{\min}$ **then**
* **34:**           $\Delta_{\min} \leftarrow \Delta$, $\mathcal{C} \leftarrow \{(k, s)\}$, $\text{found} \leftarrow \text{TRUE}$
* **35:**       **else if** $\Delta = \Delta_{\min}$ **then**
* **36:**           $\mathcal{C} \leftarrow \mathcal{C} \cup \{(k, s)\}$
* **37:**       **end if**
* **38:**   **end for**
* **39:** **end for**
* **40:** **if** $\text{found} = \text{FALSE}$ **then**
* **41:**   Defina o nó como folha e atribua $\hat{y} \leftarrow \arg \max_{c \in \{1, \dots, C\}} \sum_{j \in \mathcal{J}} \mathbb{I}(y_j = c)$ (em $\mathcal{D}$)
* **42:**   **return**
* **43:** **end if**
* **44:** Selecione $(k^*, s^*) \leftarrow \mathcal{R}(\mathcal{C})$
* **45:** Defina $\mathcal{J}_L \leftarrow \{j \in \mathcal{J} : x_{jk^*} \leqslant s^*\}$ e $\mathcal{J}_R \leftarrow \{j \in \mathcal{J} : x_{jk^*} > s^*\}$ (em $\mathcal{D}$)
* **46:** Crie o nó interno com regra $x_{k^*} \leqslant s^*$ e associe os filhos aos subconjuntos $(\mathcal{J}_L, \mathcal{J}_R)$
* **47:** **call** $\text{GrowTree}(\mathcal{J}_L, d + 1, \mathcal{D})$ e $\text{GrowTree}(\mathcal{J}_R, d + 1, \mathcal{D})$
* **48:** **end procedure**
* **49:**

### Função de predição

* **50:** **procedure** $\text{PredictTree}(T, \tilde{\mathbf{x}})$
* **51:**   Inicialize o nó atual como a raiz de $T$
* **52:**   **while** nó atual não é folha **do**
* **53:**       Leia a regra de divisão $(k, s)$ armazenada no nó atual
* **54:**       **if** $\tilde{x}_k \leqslant s$ **then**
* **55:**           Atualize o nó atual para o subnó correspondente ao subconjunto esquerdo
* **56:**       **else**
* **57:**           Atualize o nó atual para o subnó correspondente ao subconjunto direito
* **58:**       **end if**
* **59:**   **end while**
* **60:**   **return** rótulo predito $\hat{y}$ armazenado na folha
* **61:** **end procedure**
* **62:**
* **63:** **procedure** $\text{PredictRF}(\mathcal{F}, \tilde{\mathbf{x}})$
* **64:**   Calcule $\hat{y}^{(b)} \leftarrow \text{PredictTree}(T_b, \tilde{\mathbf{x}})$ para todo $b = 1, \dots, B$
* **65:**   **return** $\hat{y}_{\text{RF}}(\tilde{\mathbf{x}}) \leftarrow \arg \max_{c \in \{1, \dots, C\}} \sum_{b=1}^B \mathbb{I}(\hat{y}^{(b)} = c)$
* **66:** **end procedure**

---

### Treinamento e Erro OOB

* **67:**
* **68:** **for** $b = 1, \dots, B$ **do**
* **69:**   Amostre com reposição índices $j_1^{(b)}, \dots, j_{n_{\text{boot}}}^{(b)}$ de $\{1, \dots, n_{\text{train}}\}$
* **70:**   Defina bootstrap $\mathcal{D}^{(b)} = \{(\mathbf{x}_{j_r^{(b)}}, y_{j_r^{(b)}})\}_{r=1}^{n_{\text{boot}}}$
* **71:**   Defina OOB $\mathcal{O}_b \leftarrow \{1, \dots, n_{\text{train}}\} \setminus \{j_1^{(b)}, \dots, j_{n_{\text{boot}}}^{(b)}\}$
* **72:**   Defina $\mathcal{J}_0^{(b)} = \{1, \dots, n_{\text{boot}}\}$ (índices internos de $\mathcal{D}^{(b)}$)
* **73:**   Construa a árvore $T_b$ a partir da raiz (em $\mathcal{D}^{(b)}$): $\text{GrowTree}(\mathcal{J}_0^{(b)}, 0, \mathcal{D}^{(b)})$
* **74:** **end for**
* **75:**
* **76:** Defina a floresta $\mathcal{F} \leftarrow \{T_b\}_{b=1}^B$
* **77:**
* **78:** Predição no conjunto de teste $\mathcal{D}_{\text{test}}$
* **79:** Inicialize $\hat{\mathbf{Y}} \in \{1, \dots, C\}^{n_{\text{test}}}$
* **80:** **for** $i = 1, \dots, n_{\text{test}}$ **do**
* **81:**   $\hat{\mathbf{Y}}[i] \leftarrow \text{PredictRF}(\mathcal{F}, \tilde{\mathbf{x}}_i)$
* **82:** **end for**
* **83:**
* **84:** Erro out-of-bag (OOB)
* **85:** Inicialize acumuladores $S_{ic} \leftarrow 0$ para $i = 1, \dots, n_{\text{train}}$ e $c = 1, \dots, C$ e contagens $C_i \leftarrow 0$ para $i = 1, \dots, n_{\text{train}}$
* **86:** **for** $b = 1, \dots, B$ **do**
* **87:**   **for all** $i \in \mathcal{O}_b$ **do**
* **88:**       Seja $\hat{y}_i^{(b)} \leftarrow \text{PredictTree}(T_b, \mathbf{x}_i)$
* **89:**       $S_{i\hat{y}_i^{(b)}} \leftarrow S_{i\hat{y}_i^{(b)}} + 1$
* **90:**       $C_i \leftarrow C_i + 1$
* **91:**   **end for**
* **92:** **end for**
* **93:** Defina $\hat{y}_i^{\text{OOB}} \leftarrow \arg \max_{c \in \{1, \dots, C\}} S_{ic}$
* **94:** Calcule $\text{Err}_{\text{OOB}} \leftarrow \frac{1}{|\{i: C_i > 0\}|} \sum_{i: C_i > 0} L(y_i, \hat{y}_i^{\text{OOB}})$

---

# Output

**95:** Vetor de predições: $\mathbf{\hat{Y}} \in \{1, \dots, C\}^{n_{\text{test}}}$;

**96:** Erro OOB: $\text{Err}_{\text{OOB}}$
