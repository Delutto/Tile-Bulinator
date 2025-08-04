# Tile Bulinator - Manual de Usuario

Bienvenido al Manual de Usuario oficial de **Tile Bulinator**. Esta gu�a proporciona un recorrido detallado por todas las caracter�sticas y funcionalidades de la aplicaci�n.

## Tabla de Contenidos
1.  [Introducci�n](#1-introduction)
2.  [La Interfaz Principal](#2-the-main-interface)
3.  [Primeros Pasos: Archivos y Proyectos](#3-getting-started-files--projects)
    * [Abriendo un Archivo ROM](#opening-a-rom-file)
    * [Trabajando con Proyectos](#working-with-projects)
4.  [La Vista de Documento](#4-the-document-view)
    * [Panel de Controles](#controls-panel)
    * [Panel de Herramientas](#tools-panel)
    * [Vistas de Paleta](#palette-views)
    * [El Visor de Tiles](#the-tile-viewer)
5.  [Herramientas de Edici�n en Detalle](#5-editing-tools-in-detail)
6.  [Referencia de Men�s](#6-menu-reference)
    * [Men� Archivo](#file-menu)
    * [Men� Editar](#edit-menu)
    * [Men� Vista](#view-menu)
    * [Men� Paleta](#palette-menu)
    * [Men� Proyecto](#project-menu)
    * [Men� Ajustes](#settings-menu)
7.  [Atajos de Teclado y Rat�n](#7-keyboard--mouse-shortcuts)

---

## 1. Introducci�n

**Tile Bulinator** es un editor de gr�ficos de tiles avanzado, dise�ado para ver y modificar datos gr�ficos en bruto que se encuentran en las ROMs de consolas cl�sicas. Proporciona una interfaz potente e intuitiva para que los ROM hackers y los entusiastas de los juegos retro exploren ? alteren los recursos del juego directamente.

Este manual le guiar� a trav�s de sus potentes funciones, desde la visualizaci�n b�sica de archivos hasta la edici�n gr�fica avanzada y la gesti�n de paletas.

## 2. La Interfaz Principal

La ventana principal se divide en varias �reas clave:

![Vista General de la Interfaz Principal](imgs/MainInterface_EN.png)
*(Imagen: Una captura de pantalla de la ventana principal de la aplicaci�n con las �reas clave resaltadas.)*

* **Men� Principal**: Ubicado en la parte superior, proporciona acceso a todas las funciones de la aplicaci�n, como operaciones de archivo, comandos de edici�n y ajustes de visualizaci�n.
* **�rea de Documentos**: La parte central de la ventana donde se abren los archivos ROM en pesta�as. Cada pesta�a representa una vista de documento independiente.
* **Barra de Estado**: Ubicada en la parte inferior, muestra informaci�n importante como la ruta completa del archivo abierto, la direcci�n y las coordenadas bajo el cursor, y el nivel de zoom actual.

## 3. Primeros Pasos: Archivos y Proyectos

### Abriendo un Archivo ROM

Para comenzar, necesita abrir un archivo ROM.
1.  Vaya a **Archivo > Abrir** en el men� principal.
2.  Seleccione uno o m�s archivos ROM de su ordenador.
3.  Cada archivo seleccionado se abrir� en una nueva pesta�a en el �rea de Documentos.

Cuando se abre un archivo, se carga en una **Vista de Documento**, que es el espacio de trabajo principal para toda la edici�n.

### Trabajando con Proyectos

Un **Proyecto (`.tbproj`)** guarda toda su sesi�n de trabajo. Esto es incre�blemente �til para hacks complejos en los que est� trabajando con m�ltiples archivos o tiene configuraciones de vista muy espec�ficas.

Un archivo de proyecto almacena:
* La lista de todos los archivos ROM abiertos.
* Los ajustes espec�ficos para cada archivo: c�dec, paleta, zoom, posici�n de desplazamiento, etc.
* La pesta�a activa en la que estaba trabajando.

Puede gestionar proyectos usando el men� **Proyecto**. Use **Proyecto > Guardar Proyecto** para guardar su sesi�n actual y **Proyecto > Abrir Proyecto** para restaurarla m�s tarde.

## 4. La Vista de Documento

Cada pesta�a contiene una Vista de Documento, que es donde ocurre toda la magia. Esta vista es aut�noma y contiene todos los ajustes para el archivo que se muestra actualmente.

![La Vista de Documento](imgs/DocumentView_EN.png)
*(Imagen: Una captura de pantalla de una sola pesta�a de documento con sus diversos paneles resaltados.)*

### Panel de Controles

Este panel le permite definir c�mo se interpretan y muestran los datos en bruto de la ROM.

* **C�dec**: Este es el ajuste m�s importante. Un c�dec (abreviatura de Codificador-Decodificador) le dice al programa c�mo traducir los bytes en bruto de la ROM a p�xeles. Diferentes consolas almacenan los gr�ficos de diferentes maneras (p. ej., planar, lineal). Debe seleccionar el c�dec correcto para el juego que est� editando. La lista incluye formatos como `4bpp planar, composite (2x2bpp)` para SNES o `2bpp planar` para Game Boy.
* **Tiles por Fila/Columna**: Estos campos num�ricos controlan las dimensiones del visor de tiles, permiti�ndole organizar los tiles de una manera que tenga sentido para los datos que est� viendo.
* **Formato de Paleta**: Selecciona el formato de color para cargar paletas desde la ROM o archivos externos (p. ej., `15-bit BGR (5-5-5)` es com�n para SNES/GBA).

### Panel de Herramientas

Aqu� puede seleccionar su herramienta de edici�n activa y realizar transformaciones en sus tiles.

![Panel de Herramientas](imgs/Tools_EN.png)
*(Imagen: Un primer plano del panel de Herramientas.)*

* **Herramientas de Edici�n**: Puntero, L�piz, Bote de Pintura, Cuentagotas, Reemplazador de Color, Zoom y Mover. Cada una se explica en detalle en la secci�n 5.
* **Botones de Transformaci�n**: Voltear Horizontalmente (`H`), Voltear Verticalmente (`V`) y Rotar (`R`). Se aplican a una selecci�n de tiles, o a toda la vista si no hay nada seleccionado.
* **Botones de Desplazamiento**: Los botones de flecha desplazan los p�xeles dentro de cada tile de la selecci�n (o de toda la vista) un p�xel en la direcci�n elegida.

### Vistas de Paleta

Tile Bulinator utiliza un sistema de paletas de dos niveles para una m�xima flexibilidad.

* **Paleta Maestra** (panel derecho): Muestra la paleta maestra completa de 256 colores. Puede cargar esta paleta desde la ROM (ver **Men� Paleta**) o desde un archivo externo. Hacer clic en esta paleta selecciona una subpaleta para usar en la edici�n.
    ![Paleta Maestra](imgs/MasterPalette_EN.png)
    *(Imagen: Un primer plano del panel de la Paleta Maestra.)*
* **Paleta Activa** (panel izquierdo): Esta es la subpaleta que se est� utilizando actualmente para dibujar. Su tama�o est� determinado por los bits por p�xel del c�dec seleccionado (p. ej., un c�dec de 4bpp usar� una paleta activa de 16 colores). Hacer clic en un color aqu� lo selecciona para dibujar. Hacer clic derecho en un color le permite editarlo.
    ![Paleta Activa](imgs/ActivePalette_EN.png)
    *(Imagen: Un primer plano del panel de la Paleta Activa.)*

### El Visor de Tiles

Este es el lienzo principal donde se muestran y editan los tiles decodificados.
![Visor de Tiles](imgs/TileViewer_EN.png)
*(Imagen: Un primer plano del panel del Visor de Tiles.)*

* **Navegaci�n**: Use la barra de desplazamiento vertical para moverse a trav�s del archivo tile por tile, y la barra de desplazamiento horizontal para un desplazamiento preciso a nivel de byte. Tambi�n puede usar la rueda del rat�n para desplazarse verticalmente.
* **Zoom**: La forma m�s r�pida de hacer zoom es manteniendo **Ctrl** y usando la **Rueda del Rat�n**.
* **Cuadr�culas**: Puede activar una cuadr�cula de tiles de 8x8 y una cuadr�cula de p�xeles de 1x1 para una edici�n precisa a trav�s del men� **Vista**. La cuadr�cula de p�xeles solo es visible a niveles de zoom m�s altos.

## 5. Herramientas de Edici�n en Detalle

A continuaci�n se explica c�mo usar cada herramienta del Panel de Herramientas.

* ![](imgs/Tools_Pointer.png) **Herramienta Puntero**: Haga clic y arrastre para seleccionar un bloque rectangular de tiles. La selecci�n puede usarse para transformaciones, operaciones de cortar/copiar o exportar.
* ![](imgs/Tools_Pencil.png) **Herramienta L�piz**: Haga clic en un p�xel para dibujar con el color actualmente seleccionado de la Paleta Activa. Tambi�n puede hacer clic y arrastrar para dibujar de forma continua.
    > **Atajo**: Mantenga **Ctrl** mientras esta herramienta est� activa para cambiar temporalmente al **Cuentagotas**.
* ![](imgs/Tools_Bucket.png) **Herramienta Bote de Pintura**:
    * **Clic Normal**: Realiza un "relleno global". Encuentra todos los p�xeles del color en el que se hizo clic que est�n conectados a trav�s de *toda el �rea de tiles visible* y los reemplaza con el color activo.
    * **Ctrl + Clic**: Realiza un "relleno local". El relleno se limita al �nico tile de 8x8 en el que hizo clic.
* ![](imgs/Tools_Eyedropper.png) **Herramienta Cuentagotas**: Haga clic en cualquier p�xel en el visor de tiles para seleccionar su color y hacerlo el color activo en las vistas de paleta.
* ![](imgs/Tools_Replacer.png) **Herramienta Reemplazador de Color**: Reemplaza un color por otro. Haga clic en un p�xel; su color se convierte en el color "objetivo", y todas las instancias de este son reemplazadas por el color de dibujo actualmente activo.
    > **Atajo**: Mantenga **Shift** mientras hace clic para realizar el reemplazo *solo dentro de la selecci�n actual*.
* ![](imgs/Tools_Move.png) **Herramienta Mover**: Le permite mover una selecci�n de tiles.
    1.  Primero, cree una selecci�n con la **Herramienta Puntero**.
    2.  Seleccione la **Herramienta Mover**.
    3.  Haga clic *dentro* de la selecci�n y arr�strela a una nueva ubicaci�n.
    4.  Suelte el bot�n del rat�n para dejar los tiles en la nueva posici�n.
* ![](imgs/Tools_Zoom.png) **Herramienta Zoom**:
    * **Clic izquierdo** en el visor de tiles para acercar (zoom in).
    * **Clic derecho** para alejar (zoom out).

## 6. Referencia de Men�s

### Men� Archivo

* **Abrir**: Abre uno o m�s archivos ROM.
* **Abrir Recientes**: Una lista de archivos abiertos recientemente para un acceso r�pido.
* **Guardar**: Guarda los cambios en el archivo ROM actual.
* **Guardar Como...**: Guarda el archivo ROM actual en una nueva ubicaci�n.
* **Guardar Todo**: Guarda todos los archivos modificados que est�n abiertos actualmente.
* **Cerrar**: Cierra la pesta�a actual. Le preguntar� si desea guardar si hay cambios no guardados.
* **Cerrar Todo**: Intenta cerrar todas las pesta�as abiertas.
* **Salir**: Cierra la aplicaci�n.

### Men� Editar

* **Deshacer/Rehacer**: Funcionalidad est�ndar de deshacer/rehacer para sus ediciones.
* **Cortar/Copiar/Pegar**: Copia y pega bloques de datos de tiles seleccionados.
* **Exportar a PNG**: Exporta la selecci�n de tiles actual como un archivo de imagen `.png`.
* **Importar de PNG**: Importa un archivo `.png`. La imagen se convierte usando la paleta activa actual y se pega en la ubicaci�n de la selecci�n.
* **Ir a...**: Abre el di�logo "Ir a Offset" para saltar a una direcci�n espec�fica en el archivo.

### Men� Vista

* **Cuadr�cula de Tiles**: Activa/desactiva la visibilidad de la cuadr�cula de tiles de 8x8.
* **Cuadr�cula de P�xeles**: Activa/desactiva la visibilidad de la cuadr�cula de p�xeles de 1x1.

### Men� Paleta

* **Cargar Paleta Maestra desde ROM...**: Pide un offset, luego intenta cargar una paleta de 256 colores desde esa direcci�n en la ROM usando el Formato de Paleta seleccionado.
* **Cargar Paleta Maestra desde Archivo...**: Carga una paleta maestra desde un archivo externo (p. ej., un archivo `.pal`).
* **Cargar Paleta Activa desde Archivo...**: Carga una paleta peque�a directamente en la vista de Paleta Activa desde un archivo `.tbpal`.
* **Guardar Paleta Activa...**: Guarda la Paleta Activa actual en un archivo `.tbpal`.

### Men� Proyecto

* **Nuevo Proyecto**: Cierra todos los archivos e inicia una nueva sesi�n de proyecto vac�a.
* **Abrir Proyecto...**: Abre un archivo `.tbproj`, restaurando todos los archivos guardados y sus ajustes.
* **Abrir Proyecto Reciente**: Una lista de proyectos abiertos recientemente.
* **Guardar Proyecto / Guardar Proyecto Como...**: Guarda el estado actual de todas las pesta�as abiertas y sus ajustes en un archivo `.tbproj`.
* **Cerrar Proyecto**: Cierra el proyecto actual (funcionalmente igual que Nuevo Proyecto).

### Men� Ajustes

* **Ajustes...**: Abre el di�logo de ajustes de la aplicaci�n, donde puede cambiar el idioma, las vistas predeterminadas y la apariencia de la selecci�n.

## 7. Atajos de Teclado y Rat�n

| Acci�n | Atajo | Contexto |
| :--- | :--- | :--- |
| Zoom | `Ctrl` + `Rueda del Rat�n` | En el Visor de Tiles |
| Desplazamiento Vertical | `Rueda del Rat�n` | En el Visor de Tiles |
| Cuentagotas Temporal | `Ctrl` + `Clic` | Cuando la Herramienta L�piz est� activa |
| Relleno Local de Tile | `Ctrl` + `Clic` | Cuando la Herramienta Bote de Pintura est� activa |
| Reemplazar en la Selecci�n | `Shift` + `Clic` | Cuando el Reemplazador de Color est� activo |
| Editar Color Activo | `Clic derecho` en un color | En la Vista de Paleta Activa |

---
*Este manual fue generado por IA bas�ndose en el c�digo fuente de la aplicaci�n. Todas las caracter�sticas est�n sujetas a cambios.*