# Tile Bulinator - Manual d'usuari

Benvingut al Manual d'usuari oficial de **Tile Bulinator**. Aquesta guia proporciona un recorregut detallat per totes les característiques i funcionalitats de l'aplicació.

## Índex
1.  [Introducció](#1-introduction)
2.  [La interfície principal](#2-the-main-interface)
3.  [Primers passos: Fitxers i Projectes](#3-getting-started-files--projects)
    * [Obrir un fitxer ROM](#opening-a-rom-file)
    * [Treballar amb projectes](#working-with-projects)
4.  [La vista de document](#4-the-document-view)
    * [Tauler de controls](#controls-panel)
    * [Tauler d'eines](#tools-panel)
    * [Vistes de paleta](#palette-views)
    * [El visor de rajoles](#the-tile-viewer)
5.  [Eines d'edició en detall](#5-editing-tools-in-detail)
6.  [Referència dels menús](#6-menu-reference)
    * [Menú Fitxer](#file-menu)
    * [Menú Edita](#edit-menu)
    * [Menú Visualitza](#view-menu)
    * [Menú Paleta](#palette-menu)
    * [Menú Projecte](#project-menu)
    * [Menú Configuració](#settings-menu)
7.  [Dreceres de teclat i ratolí](#7-keyboard--mouse-shortcuts)

---

## 1. Introducció

**Tile Bulinator** és un editor de gràfics de rajoles (tiles) avançat, dissenyat per a visualitzar i modificar dades gràfiques en brut que es troben a les ROM de consoles clàssiques. Proporciona una interfície potent i intuïtiva perquè els hackers de ROM i els entusiastes dels jocs retro explorin i alterin els recursos del joc directament.

Aquest manual us guiarà a través de les seves potents funcions, des de la visualització bàsica de fitxers fins a l'edició gràfica avançada i la gestió de paletes.

## 2. La interfície principal

La finestra principal està dividida en diverses àrees clau:

![Visió general de la interfície principal](imgs/MainInterface_EN.png)
*(Imatge: Una captura de pantalla de la finestra principal de l'aplicació amb les àrees clau ressaltades.)*

* **Menú principal**: Situat a la part superior, proporciona accés a totes les funcions de l'aplicació, com ara operacions de fitxers, ordres d'edició i configuracions de visualització.
* **Àrea de documents**: La part central de la finestra on s'obren els fitxers ROM en pestanyes. Cada pestanya representa una vista de document independent.
* **Barra d'estat**: Situada a la part inferior, mostra informació important com el camí complet del fitxer obert, l'adreça i les coordenades sota el cursor, i el nivell de zoom actual.

## 3. Primers passos: Fitxers i Projectes

### Obrir un fitxer ROM

Per començar, heu d'obrir un fitxer ROM.
1.  Aneu a **Fitxer > Obre** al menú principal.
2.  Seleccioneu un o més fitxers ROM del vostre ordinador.
3.  Cada fitxer seleccionat s'obrirà en una nova pestanya a l'Àrea de documents.

Quan s'obre un fitxer, es carrega en una **Vista de document**, que és l'espai de treball principal per a tota l'edició.

### Treballar amb projectes

Un **Projecte (`.tbproj`)** desa tota la vostra sessió de l'espai de treball. Això és increïblement útil per a hacks complexos on esteu treballant amb múltiples fitxers o teniu configuracions de visualització molt específiques.

Un fitxer de projecte emmagatzema:
* La llista de tots els fitxers ROM oberts.
* La configuració específica per a cada fitxer: còdec, paleta, zoom, posició de desplaçament, etc.
* La pestanya activa en què estàveu treballant.

Podeu gestionar projectes mitjançant el menú **Projecte**. Utilitzeu **Projecte > Desa el projecte** per desar la vostra sessió actual i **Projecte > Obre el projecte** per restaurar-la més tard.

## 4. La vista de document

Cada pestanya conté una Vista de document, que és on passa tota la màgia. Aquesta vista és autònoma i conté tota la configuració del fitxer que es mostra actualment.

![La vista de document](imgs/DocumentView_EN.png)
*(Imatge: Una captura de pantalla d'una sola pestanya de document amb els seus diversos taulers ressaltats.)*

### Tauler de controls

Aquest tauler us permet definir com s'interpreten i es mostren les dades en brut de la ROM.

* **Còdec**: Aquesta és la configuració més important. Un còdec (abreviatura de Codificador-Descodificador) indica al programa com traduir els bytes en brut de la ROM a píxels. Les diferents consoles emmagatzemen els gràfics de maneres diferents (p. ex., planar, lineal). Heu de seleccionar el còdec correcte per al joc que esteu editant. La llista inclou formats com `4bpp planar, composite (2x2bpp)` per a SNES o `2bpp planar` per a Game Boy.
* **Rajoles per fila/columna**: Aquestes caselles numèriques controlen les dimensions del visor de rajoles, permetent-vos organitzar les rajoles d'una manera que tingui sentit per a les dades que esteu visualitzant.
* **Format de la paleta**: Selecciona el format de color per carregar paletes des de la ROM o fitxers externs (p. ex., `15-bit BGR (5-5-5)` és comú per a SNES/GBA).

### Tauler d'eines

Aquí podeu seleccionar la vostra eina d'edició activa i realitzar transformacions a les vostres rajoles.

![Tauler d'eines](imgs/Tools_EN.png)                                                                                                                
*(Imatge: Un primer pla del tauler d'eines.)*

* **Eines d'edició**: Punter, Llapis, Galleda d'ompliment, Comptagotes, Reemplaçador de color, Zoom i Mou. Cadascuna s'explica en detall a la secció 5.
* **Botons de transformació**: Inverteix horitzontalment (`H`), Inverteix verticalment (`V`) i Gira (`R`). S'apliquen a una selecció de rajoles, o a tota la vista si no hi ha res seleccionat.
* **Botons de desplaçament**: Els botons de fletxa desplacen els píxels dins de cada rajola de la selecció (o de tota la vista) un píxel en la direcció escollida.

### Vistes de paleta

Tile Bulinator utilitza un sistema de paletes de dos nivells per a una màxima flexibilitat.

* **Paleta mestra** (tauler dret): Mostra la paleta mestra completa de 256 colors. Podeu carregar aquesta paleta des de la ROM (vegeu el **Menú Paleta**) o un fitxer extern. En fer clic en aquesta paleta se selecciona una subpaleta per utilitzar-la en l'edició.

    ![Paleta mestra](imgs/MasterPalette_EN.png)                                                                                 
    *(Imatge: Un primer pla del tauler de la Paleta mestra.)*
* **Paleta activa** (tauler esquerre): Aquesta és la subpaleta que s'està utilitzant actualment per dibuixar. La seva mida ve determinada pels bits per píxel del còdec seleccionat (p. ex., un còdec de 4bpp utilitzarà una paleta activa de 16 colors). En fer clic en un color aquí se'l selecciona per dibuixar. En fer clic amb el botó dret en un color podeu editar-lo.

    ![Paleta activa](imgs/ActivePalette_EN.png)                                                                                                 
    *(Imatge: Un primer pla del tauler de la Paleta activa.)*

### El visor de rajoles

Aquest és el llenç principal on es mostren i s'editen les rajoles descodificades.

![El visor de rajoles](imgs/TileViewer_EN.png)                                                                                                                      
*(Imatge: Un primer pla del tauler del Visor de rajoles.)*

* **Navegació**: Utilitzeu la barra de desplaçament vertical per moure-us pel fitxer rajola a rajola, i la barra de desplaçament horitzontal per a un desplaçament afinat a nivell de byte. També podeu utilitzar la roda del ratolí per desplaçar-vos verticalment.
* **Zoom**: La manera més ràpida de fer zoom és mantenint premut **Ctrl** i utilitzant la **Roda del ratolí**.
* **Graelles**: Podeu activar i desactivar una graella de rajoles de 8x8 i una graella de píxels d'1x1 per a una edició precisa mitjançant el menú **Visualitza**. La graella de píxels només és visible a nivells de zoom més alts.

## 5. Eines d'edició en detall

Aquí s'explica com utilitzar cada eina del Tauler d'eines.

* ![](imgs/Tools_Pointer.png) **Eina Punter**: Feu clic i arrossegueu per seleccionar un bloc rectangular de rajoles. La selecció es pot utilitzar per a transformacions, operacions de tallar/copiar o exportar.
* ![](imgs/Tools_Pencil.png) **Eina Llapis**: Feu clic en un píxel per dibuixar amb el color seleccionat actualment de la Paleta activa. També podeu fer clic i arrossegar per dibuixar contínuament.
    > **Drecera**: Mantingueu premut **Ctrl** mentre aquesta eina estigui activa per canviar temporalment a l'eina **Comptagotes**.
* ![](imgs/Tools_Bucket.png) **Eina Galleda d'ompliment**:
    * **Clic normal**: Realitza un "ompliment global". Troba tots els píxels del color clicat que estan connectats a través de *tota l'àrea de rajoles visible* i els substitueix pel color actiu.
    * **Ctrl + Clic**: Realitza un "ompliment local". L'ompliment es limita a la única rajola de 8x8 en què heu fet clic.
* ![](imgs/Tools_Eyedropper.png) **Eina Comptagotes**: Feu clic a qualsevol píxel del visor de rajoles per seleccionar el seu color i fer-lo el color actiu a les vistes de paleta.
* ![](imgs/Tools_Replacer.png) **Eina Reemplaçador de color**: Reemplaça un color per un altre. Feu clic en un píxel; el seu color es converteix en el color "objectiu", i totes les seves instàncies se substitueixen pel color de dibuix actiu actualment.
    > **Drecera**: Mantingueu premut **Shift** mentre feu clic per realitzar el reemplaçament *només dins de la selecció actual*.
* ![](imgs/Tools_Move.png) **Eina Mou**: Permet moure una selecció de rajoles.
    1.  Primer, creeu una selecció amb l'**Eina Punter**.
    2.  Seleccioneu l'**Eina Mou**.
    3.  Feu clic *dins* de la selecció i arrossegueu-la a una nova ubicació.
    4.  Deixeu anar el botó del ratolí per deixar anar les rajoles a la nova posició.
* ![](imgs/Tools_Zoom.png) **Eina Zoom**:
    * **Feu clic amb el botó esquerre** al visor de rajoles per apropar la imatge (zoom in).
    * **Feu clic amb el botó dret** per allunyar la imatge (zoom out).

## 6. Referència dels menús

### Menú Fitxer

* **Obre**: Obre un o més fitxers ROM.
* **Obre recents**: Una llista de fitxers oberts recentment per a un accés ràpid.
* **Desa**: Desa els canvis al fitxer ROM actual.
* **Desa com...**: Desa el fitxer ROM actual a una nova ubicació.
* **Desa-ho tot**: Desa tots els fitxers modificats que estan oberts actualment.
* **Tanca**: Tanca la pestanya actual. Us demanarà si voleu desar si hi ha canvis no desats.
* **Tanca-ho tot**: Intenta tancar totes les pestanyes obertes.
* **Surt**: Tanca l'aplicació.

### Menú Edita

* **Desfés/Refés**: Funcionalitat estàndard de desfer/refer per a les vostres edicions.
* **Talla/Copia/Enganxa**: Copia i enganxa blocs de dades de rajoles seleccionades.
* **Exporta a PNG**: Exporta la selecció de rajoles actual com a fitxer d'imatge `.png`.
* **Importa des de PNG**: Importa un fitxer `.png`. La imatge es converteix utilitzant la paleta activa actual i s'enganxa a la ubicació de la selecció.
* **Vés a...**: Obre el diàleg "Vés a l'adreça" per saltar a una adreça específica del fitxer.

### Menú Visualitza

* **Graella de rajoles**: Activa o desactiva la visibilitat de la graella de rajoles de 8x8.
* **Graella de píxels**: Activa o desactiva la visibilitat de la graella de píxels d'1x1.

### Menú Paleta

* **Carrega la paleta mestra des de la ROM...**: Demana una adreça, i després intenta carregar una paleta de 256 colors des d'aquesta adreça a la ROM utilitzant el Format de paleta seleccionat.
* **Carrega la paleta mestra des d'un fitxer...**: Carrega una paleta mestra des d'un fitxer extern (p. ex., un fitxer `.pal`).
* **Carrega la paleta activa des d'un fitxer...**: Carrega una petita paleta directament a la vista de Paleta activa des d'un fitxer `.tbpal`.
* **Desa la paleta activa...**: Desa la Paleta activa actual a un fitxer `.tbpal`.

### Menú Projecte

* **Projecte nou**: Tanca tots els fitxers i inicia una nova sessió de projecte buida.
* **Obre el projecte...**: Obre un fitxer `.tbproj`, restaurant tots els fitxers desats i la seva configuració.
* **Obre un projecte recent**: Una llista de projectes oberts recentment.
* **Desa el projecte / Desa el projecte com...**: Desa l'estat actual de totes les pestanyes obertes i la seva configuració en un fitxer `.tbproj`.
* **Tanca el projecte**: Tanca el projecte actual (funcionalment és el mateix que Projecte nou).

### Menú Configuració

* **Configuració...**: Obre el diàleg de configuració de l'aplicació, on podeu canviar l'idioma, les vistes per defecte i l'aparença de la selecció.

## 7. Dreceres de teclat i ratolí

| Acció | Drecera | Context |
| :--- | :--- | :--- |
| Zoom | `Ctrl` + `Roda del ratolí` | Al Visor de rajoles |
| Desplaçament vertical | `Roda del ratolí` | Al Visor de rajoles |
| Comptagotes temporal | `Ctrl` + `Clic` | Quan l'Eina Llapis està activa |
| Ompliment de rajola local | `Ctrl` + `Clic` | Quan l'Eina Galleda d'ompliment està activa |
| Reemplaça a la selecció | `Shift` + `Clic` | Quan el Reemplaçador de color està actiu |
| Edita el color actiu | `Clic amb el botó dret` en un color | A la Vista de paleta activa |

---

*Aquest manual ha estat generat per IA basant-se en el codi font de l'aplicació. Totes les característiques estan subjectes a canvis.*
