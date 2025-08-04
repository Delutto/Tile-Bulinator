# Tile Bulinator - Manual d'usuari

Benvingut al Manual d'usuari oficial de **Tile Bulinator**. Aquesta guia proporciona un recorregut detallat per totes les caracter�stiques i funcionalitats de l'aplicaci�.

## �ndex
1.  [Introducci�](#1-introduction)
2.  [La interf�cie principal](#2-the-main-interface)
3.  [Primers passos: Fitxers i Projectes](#3-getting-started-files--projects)
    * [Obrir un fitxer ROM](#opening-a-rom-file)
    * [Treballar amb projectes](#working-with-projects)
4.  [La vista de document](#4-the-document-view)
    * [Tauler de controls](#controls-panel)
    * [Tauler d'eines](#tools-panel)
    * [Vistes de paleta](#palette-views)
    * [El visor de rajoles](#the-tile-viewer)
5.  [Eines d'edici� en detall](#5-editing-tools-in-detail)
6.  [Refer�ncia dels men�s](#6-menu-reference)
    * [Men� Fitxer](#file-menu)
    * [Men� Edita](#edit-menu)
    * [Men� Visualitza](#view-menu)
    * [Men� Paleta](#palette-menu)
    * [Men� Projecte](#project-menu)
    * [Men� Configuraci�](#settings-menu)
7.  [Dreceres de teclat i ratol�](#7-keyboard--mouse-shortcuts)

---

## 1. Introducci�

**Tile Bulinator** �s un editor de gr�fics de rajoles (tiles) avan�at, dissenyat per a visualitzar i modificar dades gr�fiques en brut que es troben a les ROM de consoles cl�ssiques. Proporciona una interf�cie potent i intu�tiva perqu� els hackers de ROM i els entusiastes dels jocs retro explorin i alterin els recursos del joc directament.

Aquest manual us guiar� a trav�s de les seves potents funcions, des de la visualitzaci� b�sica de fitxers fins a l'edici� gr�fica avan�ada i la gesti� de paletes.

## 2. La interf�cie principal

La finestra principal est� dividida en diverses �rees clau:

![Visi� general de la interf�cie principal](imgs/MainInterface_EN.png)
*(Imatge: Una captura de pantalla de la finestra principal de l'aplicaci� amb les �rees clau ressaltades.)*

* **Men� principal**: Situat a la part superior, proporciona acc�s a totes les funcions de l'aplicaci�, com ara operacions de fitxers, ordres d'edici� i configuracions de visualitzaci�.
* **�rea de documents**: La part central de la finestra on s'obren els fitxers ROM en pestanyes. Cada pestanya representa una vista de document independent.
* **Barra d'estat**: Situada a la part inferior, mostra informaci� important com el cam� complet del fitxer obert, l'adre�a i les coordenades sota el cursor, i el nivell de zoom actual.

## 3. Primers passos: Fitxers i Projectes

### Obrir un fitxer ROM

Per comen�ar, heu d'obrir un fitxer ROM.
1.  Aneu a **Fitxer > Obre** al men� principal.
2.  Seleccioneu un o m�s fitxers ROM del vostre ordinador.
3.  Cada fitxer seleccionat s'obrir� en una nova pestanya a l'�rea de documents.

Quan s'obre un fitxer, es carrega en una **Vista de document**, que �s l'espai de treball principal per a tota l'edici�.

### Treballar amb projectes

Un **Projecte (`.tbproj`)** desa tota la vostra sessi� de l'espai de treball. Aix� �s incre�blement �til per a hacks complexos on esteu treballant amb m�ltiples fitxers o teniu configuracions de visualitzaci� molt espec�fiques.

Un fitxer de projecte emmagatzema:
* La llista de tots els fitxers ROM oberts.
* La configuraci� espec�fica per a cada fitxer: c�dec, paleta, zoom, posici� de despla�ament, etc.
* La pestanya activa en qu� est�veu treballant.

Podeu gestionar projectes mitjan�ant el men� **Projecte**. Utilitzeu **Projecte > Desa el projecte** per desar la vostra sessi� actual i **Projecte > Obre el projecte** per restaurar-la m�s tard.

## 4. La vista de document

Cada pestanya cont� una Vista de document, que �s on passa tota la m�gia. Aquesta vista �s aut�noma i cont� tota la configuraci� del fitxer que es mostra actualment.

![La vista de document](imgs/DocumentView_EN.png)
*(Imatge: Una captura de pantalla d'una sola pestanya de document amb els seus diversos taulers ressaltats.)*

### Tauler de controls

Aquest tauler us permet definir com s'interpreten i es mostren les dades en brut de la ROM.

* **C�dec**: Aquesta �s la configuraci� m�s important. Un c�dec (abreviatura de Codificador-Descodificador) indica al programa com traduir els bytes en brut de la ROM a p�xels. Les diferents consoles emmagatzemen els gr�fics de maneres diferents (p. ex., planar, lineal). Heu de seleccionar el c�dec correcte per al joc que esteu editant. La llista inclou formats com `4bpp planar, composite (2x2bpp)` per a SNES o `2bpp planar` per a Game Boy.
* **Rajoles per fila/columna**: Aquestes caselles num�riques controlen les dimensions del visor de rajoles, permetent-vos organitzar les rajoles d'una manera que tingui sentit per a les dades que esteu visualitzant.
* **Format de la paleta**: Selecciona el format de color per carregar paletes des de la ROM o fitxers externs (p. ex., `15-bit BGR (5-5-5)` �s com� per a SNES/GBA).

### Tauler d'eines

Aqu� podeu seleccionar la vostra eina d'edici� activa i realitzar transformacions a les vostres rajoles.

![Tauler d'eines](imgs/Tools_EN.png)
*(Imatge: Un primer pla del tauler d'eines.)*

* **Eines d'edici�**: Punter, Llapis, Galleda d'ompliment, Comptagotes, Reempla�ador de color, Zoom i Mou. Cadascuna s'explica en detall a la secci� 5.
* **Botons de transformaci�**: Inverteix horitzontalment (`H`), Inverteix verticalment (`V`) i Gira (`R`). S'apliquen a una selecci� de rajoles, o a tota la vista si no hi ha res seleccionat.
* **Botons de despla�ament**: Els botons de fletxa desplacen els p�xels dins de cada rajola de la selecci� (o de tota la vista) un p�xel en la direcci� escollida.

### Vistes de paleta

Tile Bulinator utilitza un sistema de paletes de dos nivells per a una m�xima flexibilitat.

* **Paleta mestra** (tauler dret): Mostra la paleta mestra completa de 256 colors. Podeu carregar aquesta paleta des de la ROM (vegeu el **Men� Paleta**) o un fitxer extern. En fer clic en aquesta paleta se selecciona una subpaleta per utilitzar-la en l'edici�.
    ![Paleta mestra](imgs/MasterPalette_EN.png)
    *(Imatge: Un primer pla del tauler de la Paleta mestra.)*
* **Paleta activa** (tauler esquerre): Aquesta �s la subpaleta que s'est� utilitzant actualment per dibuixar. La seva mida ve determinada pels bits per p�xel del c�dec seleccionat (p. ex., un c�dec de 4bpp utilitzar� una paleta activa de 16 colors). En fer clic en un color aqu� se'l selecciona per dibuixar. En fer clic amb el bot� dret en un color podeu editar-lo.
    ![Paleta activa](imgs/ActivePalette_EN.png)
    *(Imatge: Un primer pla del tauler de la Paleta activa.)*

### El visor de rajoles

Aquest �s el llen� principal on es mostren i s'editen les rajoles descodificades.
![El visor de rajoles](imgs/TileViewer_EN.png)
*(Imatge: Un primer pla del tauler del Visor de rajoles.)*

* **Navegaci�**: Utilitzeu la barra de despla�ament vertical per moure-us pel fitxer rajola a rajola, i la barra de despla�ament horitzontal per a un despla�ament afinat a nivell de byte. Tamb� podeu utilitzar la roda del ratol� per despla�ar-vos verticalment.
* **Zoom**: La manera m�s r�pida de fer zoom �s mantenint premut **Ctrl** i utilitzant la **Roda del ratol�**.
* **Graelles**: Podeu activar i desactivar una graella de rajoles de 8x8 i una graella de p�xels d'1x1 per a una edici� precisa mitjan�ant el men� **Visualitza**. La graella de p�xels nom�s �s visible a nivells de zoom m�s alts.

## 5. Eines d'edici� en detall

Aqu� s'explica com utilitzar cada eina del Tauler d'eines.

* ![](imgs/Tools_Pointer.png) **Eina Punter**: Feu clic i arrossegueu per seleccionar un bloc rectangular de rajoles. La selecci� es pot utilitzar per a transformacions, operacions de tallar/copiar o exportar.
* ![](imgs/Tools_Pencil.png) **Eina Llapis**: Feu clic en un p�xel per dibuixar amb el color seleccionat actualment de la Paleta activa. Tamb� podeu fer clic i arrossegar per dibuixar cont�nuament.
    > **Drecera**: Mantingueu premut **Ctrl** mentre aquesta eina estigui activa per canviar temporalment a l'eina **Comptagotes**.
* ![](imgs/Tools_Bucket.png) **Eina Galleda d'ompliment**:
    * **Clic normal**: Realitza un "ompliment global". Troba tots els p�xels del color clicat que estan connectats a trav�s de *tota l'�rea de rajoles visible* i els substitueix pel color actiu.
    * **Ctrl + Clic**: Realitza un "ompliment local". L'ompliment es limita a la �nica rajola de 8x8 en qu� heu fet clic.
* ![](imgs/Tools_Eyedropper.png) **Eina Comptagotes**: Feu clic a qualsevol p�xel del visor de rajoles per seleccionar el seu color i fer-lo el color actiu a les vistes de paleta.
* ![](imgs/Tools_Replacer.png) **Eina Reempla�ador de color**: Reempla�a un color per un altre. Feu clic en un p�xel; el seu color es converteix en el color "objectiu", i totes les seves inst�ncies se substitueixen pel color de dibuix actiu actualment.
    > **Drecera**: Mantingueu premut **Shift** mentre feu clic per realitzar el reempla�ament *nom�s dins de la selecci� actual*.
* ![](imgs/Tools_Move.png) **Eina Mou**: Permet moure una selecci� de rajoles.
    1.  Primer, creeu una selecci� amb l'**Eina Punter**.
    2.  Seleccioneu l'**Eina Mou**.
    3.  Feu clic *dins* de la selecci� i arrossegueu-la a una nova ubicaci�.
    4.  Deixeu anar el bot� del ratol� per deixar anar les rajoles a la nova posici�.
* ![](imgs/Tools_Zoom.png) **Eina Zoom**:
    * **Feu clic amb el bot� esquerre** al visor de rajoles per apropar la imatge (zoom in).
    * **Feu clic amb el bot� dret** per allunyar la imatge (zoom out).

## 6. Refer�ncia dels men�s

### Men� Fitxer

* **Obre**: Obre un o m�s fitxers ROM.
* **Obre recents**: Una llista de fitxers oberts recentment per a un acc�s r�pid.
* **Desa**: Desa els canvis al fitxer ROM actual.
* **Desa com...**: Desa el fitxer ROM actual a una nova ubicaci�.
* **Desa-ho tot**: Desa tots els fitxers modificats que estan oberts actualment.
* **Tanca**: Tanca la pestanya actual. Us demanar� si voleu desar si hi ha canvis no desats.
* **Tanca-ho tot**: Intenta tancar totes les pestanyes obertes.
* **Surt**: Tanca l'aplicaci�.

### Men� Edita

* **Desf�s/Ref�s**: Funcionalitat est�ndard de desfer/refer per a les vostres edicions.
* **Talla/Copia/Enganxa**: Copia i enganxa blocs de dades de rajoles seleccionades.
* **Exporta a PNG**: Exporta la selecci� de rajoles actual com a fitxer d'imatge `.png`.
* **Importa des de PNG**: Importa un fitxer `.png`. La imatge es converteix utilitzant la paleta activa actual i s'enganxa a la ubicaci� de la selecci�.
* **V�s a...**: Obre el di�leg "V�s a l'adre�a" per saltar a una adre�a espec�fica del fitxer.

### Men� Visualitza

* **Graella de rajoles**: Activa o desactiva la visibilitat de la graella de rajoles de 8x8.
* **Graella de p�xels**: Activa o desactiva la visibilitat de la graella de p�xels d'1x1.

### Men� Paleta

* **Carrega la paleta mestra des de la ROM...**: Demana una adre�a, i despr�s intenta carregar una paleta de 256 colors des d'aquesta adre�a a la ROM utilitzant el Format de paleta seleccionat.
* **Carrega la paleta mestra des d'un fitxer...**: Carrega una paleta mestra des d'un fitxer extern (p. ex., un fitxer `.pal`).
* **Carrega la paleta activa des d'un fitxer...**: Carrega una petita paleta directament a la vista de Paleta activa des d'un fitxer `.tbpal`.
* **Desa la paleta activa...**: Desa la Paleta activa actual a un fitxer `.tbpal`.

### Men� Projecte

* **Projecte nou**: Tanca tots els fitxers i inicia una nova sessi� de projecte buida.
* **Obre el projecte...**: Obre un fitxer `.tbproj`, restaurant tots els fitxers desats i la seva configuraci�.
* **Obre un projecte recent**: Una llista de projectes oberts recentment.
* **Desa el projecte / Desa el projecte com...**: Desa l'estat actual de totes les pestanyes obertes i la seva configuraci� en un fitxer `.tbproj`.
* **Tanca el projecte**: Tanca el projecte actual (funcionalment �s el mateix que Projecte nou).

### Men� Configuraci�

* **Configuraci�...**: Obre el di�leg de configuraci� de l'aplicaci�, on podeu canviar l'idioma, les vistes per defecte i l'aparen�a de la selecci�.

## 7. Dreceres de teclat i ratol�

| Acci� | Drecera | Context |
| :--- | :--- | :--- |
| Zoom | `Ctrl` + `Roda del ratol�` | Al Visor de rajoles |
| Despla�ament vertical | `Roda del ratol�` | Al Visor de rajoles |
| Comptagotes temporal | `Ctrl` + `Clic` | Quan l'Eina Llapis est� activa |
| Ompliment de rajola local | `Ctrl` + `Clic` | Quan l'Eina Galleda d'ompliment est� activa |
| Reempla�a a la selecci� | `Shift` + `Clic` | Quan el Reempla�ador de color est� actiu |
| Edita el color actiu | `Clic amb el bot� dret` en un color | A la Vista de paleta activa |

---
*Aquest manual ha estat generat per IA basant-se en el codi font de l'aplicaci�. Totes les caracter�stiques estan subjectes a canvis.*