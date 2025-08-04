# Guia do Usuário: Tile Bulinator

## 1. Introdução

### 1.1. Propósito da Ferramenta

O **Tile Bulinator** é um editor de gráficos de tiles avançado, projetado especificamente para a visualização e modificação de dados gráficos brutos encontrados em ROMs de consoles antigos. Inspirado em ferramentas clássicas de ROM Hacking, o Tile Bulinator oferece uma interface moderna de múltiplos documentos, um robusto sistema de Desfazer/Refazer e um conjunto completo de ferramentas de edição, tornando-o a solução definitiva para artistas, tradutores e hackers de ROM que trabalham com a arquitetura gráfica de sistemas de 8 e 16 bits.

Sua arquitetura de codecs flexível permite a interpretação de uma vasta gama de formatos gráficos, desde os lineares simples até os planares mais complexos.

### 1.2. Interface Principal

O Tile Bulinator utiliza uma Interface de Múltiplos Documentos com Abas (TDI), permitindo que você abra e edite vários arquivos simultaneamente.

* **Menu Principal:** Localizado no topo, dá acesso a todas as funcionalidades de arquivo, edição, visualização e gerenciamento de paletas.
* **Área de Documentos:** A área central onde cada arquivo aberto é exibido em sua própria aba.
* **Barra de Status:** Localizada na parte inferior, exibe informações contextuais importantes, como o caminho do arquivo, a posição do cursor (endereço, tile, pixel) e o nível de zoom atual.

## 2. Gerenciamento de Arquivos (Menu "Arquivo")

O Tile Bulinator oferece um gerenciamento de arquivos completo, permitindo um fluxo de trabalho flexível com múltiplos documentos.

* **Abrir... (`Ctrl+O`):** Abre um ou múltiplos arquivos de ROM. Cada arquivo é carregado em uma nova aba.
* **Salvar (`Ctrl+S`):** Salva as alterações feitas no documento ativo. Se o arquivo nunca foi salvo, age como "Salvar Como...".
* **Salvar Como... (`Ctrl+Shift+S`):** Permite salvar o documento ativo com um novo nome ou em um novo local.
* **Salvar Todos (`Ctrl+Alt+S`):** Percorre todas as abas abertas e salva cada arquivo que foi modificado.
* **Fechar (`Ctrl+W`):** Fecha a aba do documento ativo. Se houver alterações não salvas, o programa perguntará se você deseja salvá-las.
* **Fechar Todos (`Ctrl+Shift+W`):** Tenta fechar todas as abas abertas, perguntando sobre cada arquivo modificado individualmente.
* **Sair:** Fecha a aplicação. Uma verificação de segurança é executada para prevenir a perda de alterações não salvas.

## 3. A Área de Trabalho do Documento

Cada aba de documento contém uma área de trabalho completa, dividida em três painéis principais.

### 3.1. Painel Esquerdo (Controles e Ferramentas)

* **Controles de Visualização:**
    * **Codec:** Permite selecionar o formato gráfico (ex: `4bpp planar`) para interpretar corretamente os dados da ROM.
    * **Dimensões:** Define a largura (`Colunas`) e altura (`Linhas`) da grade de tiles exibida na tela.

* **Ferramentas:** A caixa de ferramentas para edição. Apenas uma ferramenta pode estar ativa por vez.
    * **Ponteiro (Seleção):** Permite selecionar um ou múltiplos tiles. Clique e arraste para criar uma seleção retangular.
    * **Lápis:** Ferramenta de desenho pixel a pixel.
        * **Atalho:** Segure `CTRL` para ativar temporariamente o **Conta-gotas**.
    * **Balde de Tinta:** Preenche uma área de cor contígua.
        * **Clique Normal:** Preenchimento global, atravessando as fronteiras dos tiles.
        * **`CTRL` + Clique:** Preenchimento local, limitado ao tile clicado.
    * **Conta-gotas:** Captura uma cor do visualizador de tiles e a define como cor ativa.
    * **Substituto de Cor:** Substitui uma cor por outra.
        * **Clique Normal:** Age em toda a área visível.
        * **`SHIFT` + Clique:** Age apenas dentro da área selecionada.
    * **Transformar (H, V, R):** Botões de ação para **Inverter Horizontalmente**, **Inverter Verticalmente** e **Girar 90°**. Agem sobre a seleção ou, na ausência dela, sobre toda a área visível.
    * **Deslocar (Setas):** Botões de ação para deslocar os pixels de cada tile na área de atuação em 1 pixel na direção escolhida.
    * **Zoom:** Ferramenta interativa de zoom.
        * **Clique Esquerdo:** Aumenta o zoom.
        * **Clique Direito:** Diminui o zoom.
    * **Mover:** Permite mover o conteúdo de uma seleção. Clique dentro da seleção, arraste e solte no novo local.

* **Paleta Ativa:**
    * Exibe a sub-paleta de cores (ex: 16 cores) que está sendo usada para renderizar os tiles.
    * **Clique Esquerdo:** Seleciona a cor ativa para desenho.
    * **Clique Direito:** Abre um diálogo para editar a cor selecionada.

### 3.2. Painel Central (Visualizador de Tiles)

A área de edição principal, onde os gráficos são exibidos e manipulados.

* **Scrollbar Vertical:** Navega pela ROM em "páginas" de tiles.
* **Scrollbar Horizontal:** Ajusta o offset de bytes, para dados desalinhados.
* **Roda do Mouse:**
    * **Normal:** Navega verticalmente pelos tiles.
    * **`CTRL` + Roda do Mouse:** Controla o zoom.

### 3.3. Painel Direito (Paleta Master)

* **Formato:** Seleciona o formato de cor (ex: `15-bit BGR`) para interpretar os dados de paleta.
* **Paleta Master:** Exibe 256 cores. Atua como um "banco de paletas".
    * **Clique Esquerdo:** Seleciona uma sub-paleta (com o tamanho definido pelo Codec de tile) e a carrega na **Paleta Ativa**. Um destaque amarelo mostra a pré-seleção.

## 4. Funcionalidades Avançadas (Menus)

### 4.1. Menu "Editar"

* **Desfazer (`Ctrl+Z`) / Refazer (`Ctrl+Y`):** Sistema robusto e "atômico". Operações complexas como "Colar", "Importar PNG" ou "Balde de Tinta Global" são desfeitas/refeitas em um único passo.
* **Recortar (`Ctrl+X`) / Copiar (`Ctrl+C`) / Colar (`Ctrl+V`):** Ferramentas de clipboard padrão que operam sobre a seleção de tiles.
* **Exportar/Importar PNG:** Salva ou carrega a seleção de tiles como uma imagem PNG. A importação converte de forma inteligente as cores do PNG para a cor mais próxima na Paleta Ativa.
* **Ir para Offset... (`Ctrl+G`):** Abre um diálogo avançado para navegar para um endereço, com opções de base (Decimal/Hexadecimal/Automático) e modo (Absoluto/Relativo à posição atual/Relativo ao fim da ROM).

### 4.2. Menu "Exibir"

* **Grade de Tiles:** Ativa/desativa uma grade que delineia as bordas dos tiles.
* **Grade de Pixels:** Ativa/desativa uma grade fina e pontilhada que delineia cada pixel. Visível apenas em zoom alto.

### 4.3. Menu "Paleta"

* **Carregar Paleta Master...:** Carrega uma paleta de 256 cores de um arquivo.
* **Carregar Paleta Master da ROM...:** Abre o diálogo "Ir para..." para carregar a paleta diretamente de um offset na ROM.
* **Carregar Paleta Ativa...:** Carrega um arquivo de paleta (`.tbpal`) diretamente para a Paleta Ativa.
* **Salvar Paleta Ativa...:** Salva as cores da Paleta Ativa em um arquivo (`.tbpal`).
