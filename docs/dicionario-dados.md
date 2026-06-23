# Dicionário de dados 

Aqui, vamos discorrer sobre o que cada uma das colunas dos nossos dados significam.
Para identificação, nossos dados possuem **32 atributos (colunas)** com **569 instâncias (linhas)**.


| **Atributo** | **Descrição** | **Tipo** |
| ------------ | ------------- | -------- |
| `id` | Número de identificação do paciente | Inteiro |
| `diagnosis` | Diagnóstico (M = Maligno, B = Benigno). Target do nosso projeto. | Categórico |
| `radius_mean` | Média das distâncias do centro aos pontos do perímetro | Categórico |
| `texture_mean` | Média da variação dos níveis de cinza | Numérico |
| `perimeter_mean` | Média do perímetro do tumor | Numérico |
| `area_mean` | Média da área do tumor | Numérico |
| `smoothness_mean` | Média da variação local nos comprimentos dos raios | Numérico |
| `compactness_mean` | Média de $\frac{perímetro^2}{área - 1.0}$ | Numérico |
| `concavity_mean` | Média da severidade das porções côncavas do contorno | Numérico |
| `concave_points_mean` | Média do número de porções côncavas do contorno | Numérico |
| `symmetry_mean` | Média da simetria | Numérico |
| `fractal_dimension_mean` | Média da "aproximação da linha costeira" - 1 | Numérico |
| `radius_se` | Erro padrão do raio | Numérico |
| `texture_se` | Erro padrão da textura | Numérico |
| `perimeter_se` | Erro padrão do perímetro | Numérico |
| `area_se` | Erro padrão da área | Numérico |
| `smoothness_se` | Erro padrão da suavidade | Numérico |
| `compactness_se` | Erro padrão da compacidade | Numérico |
| `concavity_se` | Erro padrão da concavidade | Numérico |
| `concave_points_se` | Erro padrão dos pontos côncavos | Numérico |
| `symmetry_se` | Erro padrão da simetria | Numérico |
| `fractal_dimension_se` | Erro padrão da dimensão fractal | Numérico |
| `radius_worst` | "Pior" ou maior valor médio do raio | Numérico |
| `texture_worst` | "Pior" ou maior valor médio da textura | Numérico |
| `perimeter_worst` | "Pior" ou maior valor médio do perímetro | Numérico |
| `area_worst` | "Pior" ou maior valor médio da área | Numérico |
| `smoothness_worst` | "Pior" ou maior valor médio da suavidade | Numérico |
| `compactness_worst` | "Pior" ou maior valor médio da compacidade | Numérico |
| `concavity_worst` | "Pior" ou maior valor médio da concavidade | Numérico |
| `concave_points_worst` | "Pior" ou maior valor médio dos pontos côncavos | Numérico |
| `symmetry_worst` | "Pior" ou maior valor médio da simetria | Numérico |
| `fractal_dimension_worst` | "Pior" ou maior valor médio da dimensão fractal | Numérico |

