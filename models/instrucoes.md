# Modelo escolhido - Random Forest

No caso do random forest: deverão ser implementados manualmente o processo de
reamostragem bootstrap, a construção de múltiplas árvores, a seleção aleatória de
subconjuntos de variáveis em cada divisão e a regra de agregação das predições. O
relatório deverá justificar o número d e árvores, o número de variáveis candidatas em
cada divisão e os critérios de parada adotados.

# Regras de implementação do modelo

Nesta etapa, a implementação computacional deverá ser desenvolvida de modo que o
algoritmo escolhido seja construído a partir de sua lógica matemática e computacional . Não
será permitido utilizar funções prontas de pacotes ou bibliotecas do R ou do Python que
implementem diretamente o modelo selecionado, seu treinamento, sua predição ou seu
processo automático de ajuste. O objetivo dessa exigência é garantir a compreensão do
funcionamento interno do método escolhido , e não apenas sua aplicação por meio de
comandos previamente disponíveis.

A programação manual deverá contemplar todas as etapas essenciais do algoritmo
escolhido. Isso inclui a preparação dos dados de entrada, a definição dos parâmetros iniciais
quando necessário, o procedimento de treinamento, a geração das predições para novas
observações e o cálculo das medidas de desempenho. O código deve rá demonstrar de forma
clara como o modelo é construído e como as decisões de classificação são obtidas.
Será permitido utilizar funções básicas da linguagem de programação escolhida para
operações matemáticas, manipulação de matrizes, leitura de arquivos, organização de tabelas
e construção de gráficos. Também será permitido utilizar pacotes auxiliares para importação
de dados, tratamento simples da base, visualização gráfica e divisão dos dados em treino e
teste, desde que esses pacotes não executem o algoritmo de classificação, o ajuste automático
do modelo ou o cálculo automático das métricas principais de avaliação. Além disso, deverão
ser apresentadas no código as funções criadas para cada etapa relevante do processo. Por
exemplo, no caso de um modelo baseado em distância, deverão aparecer as funções
responsáveis pelo cálculo da distância, pela seleção dos vizinhos e pela votação das classes.
No caso de modelos baseados em otimização, deverão aparecer as funções relacionadas à
função de custo, à atualização dos parâmetros e ao critério de parada. No caso de árvores,
deverão aparecer as funções relacionadas ao cálculo do critério de divisão, à criação dos nós
e às regras de parada. No caso de redes neurais, deverão aparecer as funções de propagação
direta, cálculo do erro, retropropagação e atualização dos pesos.
A implementação deverá ser suficientemente comentada para permitir a compreensão
do raciocínio computacional adotado. Os comentários não devem substituir a clareza do
código, mas devem auxiliar na identificação das principais etapas, das entradas e saídas das
funções, dos critérios de decisão e dos procedimentos de treinamento e predição. O código
também deverá estar organizado de forma reprodutível, permitindo que a análise seja
executada a partir da base de dados utilizada.

# Tuning manual do modelo

Nesta etapa, deverá ser realizado o ajuste manual dos hiperparâmetros do modelo
escolhido, apresentando de forma clara quais valores foram testados, qual critério foi utilizado
para comparação e qual configuração final foi selecionada. O tuning deverá ser entendido
como uma etapa metodológica obrigatória, e não apenas como uma tentativa informal de
melhorar os resultados. Portanto, a escolha dos hiperparâmetros deverá ser planejada,
documentada e justificada tecnicamente.
O processo de tuning deverá ser realizado utilizando apenas a amostra de treinamento
ou uma subdivisão interna da amostra de treinamento. A amostra de teste não deverá ser
utilizada para escolher hiperparâmetros, pois deverá permanecer reservada para a avaliação
final do dese mpenho preditivo. Poderá ser utilizada validação simples, validação cruzada
implementada manualmente ou outra estratégia compatível, desde que o procedimento seja
explicado e programado sem o uso de funções prontas de ajuste automático.
Os resultados do tuning deverão ser apresentados no relatório por meio de tabela,
gráfico ou descrição organizada que permita compreender o desempenho obtido para cada
combinação avaliada. A configuração final não deverá ser escolhida apenas com base no maior
valor de acurácia, especialmente em situações de desbalanceamento entre classes. Deverão ser
considerados também a adequação da métrica ao problema, a estabilidade dos resultados, o
risco de sobreajuste, a complexidade do modelo e a interpretabilidade da solução obtida.

### Regra adicional

O código deverá conter comentários suficientes para orientar a leitura e a execução.
Esses comentários deverão indicar as principais etapas da análise, como carregamento dos
dados, tratamento de valores ausentes, transformação de variáveis, separação entre treino e
teste, implementação manual do modelo, treinamento, tuning , predição e avaliação final. Os
comentários devem auxiliar a compreensão do raciocínio computacional, sem substituir a
necessidade de um código organizado e legível.