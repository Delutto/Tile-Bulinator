# Tile Bulinator - Manual de Usuario

Bienvenido al Manual de Usuario oficial de **Tile Bulinator**. Esta guía proporciona un recorrido detallado por todas las características y funcionalidades de la aplicación.

## Tabla de Contenidos
1.  [Introducción](#1-introduction)
2.  [La Interfaz Principal](#2-the-main-interface)
3.  [Primeros Pasos: Archivos y Proyectos](#3-getting-started-files--projects)
    * [Abriendo un Archivo ROM](#opening-a-rom-file)
    * [Trabajando con Proyectos](#working-with-projects)
4.  [La Vista de Documento](#4-the-document-view)
    * [Panel de Controles](#controls-panel)
    * [Panel de Herramientas](#tools-panel)
    * [Vistas de Paleta](#palette-views)
    * [El Visor de Tiles](#the-tile-viewer)
5.  [Herramientas de Edición en Detalle](#5-editing-tools-in-detail)
6.  [Referencia de Menús](#6-menu-reference)
    * [Menú Archivo](#file-menu)
    * [Menú Editar](#edit-menu)
    * [Menú Vista](#view-menu)
    * [Menú Paleta](#palette-menu)
    * [Menú Proyecto](#project-menu)
    * [Menú Ajustes](#settings-menu)
7.  [Atajos de Teclado y Ratón](#7-keyboard--mouse-shortcuts)

---

## 1. Introducción

**Tile Bulinator** es un editor de gráficos de tiles avanzado, diseñado para ver y modificar datos gráficos en bruto que se encuentran en las ROMs de consolas clásicas. Proporciona una interfaz potente e intuitiva para que los ROM hackers y los entusiastas de los juegos retro exploren ? alteren los recursos del juego directamente.

Este manual le guiará a través de sus potentes funciones, desde la visualización básica de archivos hasta la edición gráfica avanzada y la gestión de paletas.

## 2. La Interfaz Principal

La ventana principal se divide en varias áreas clave:

![Vista General de la Interfaz Principal](imgs/MainInterface_EN.png)
*(Imagen: Una captura de pantalla de la ventana principal de la aplicación con las áreas clave resaltadas.)*

* **Menú Principal**: Ubicado en la parte superior, proporciona acceso a todas las funciones de la aplicación, como operaciones de archivo, comandos de edición y ajustes de visualización.
* **Área de Documentos**: La parte central de la ventana donde se abren los archivos ROM en pestañas. Cada pestaña representa una vista de documento independiente.
* **Barra de Estado**: Ubicada en la parte inferior, muestra información importante como la ruta completa del archivo abierto, la dirección y las coordenadas bajo el cursor, y el nivel de zoom actual.

## 3. Primeros Pasos: Archivos y Proyectos

### Abriendo un Archivo ROM

Para comenzar, necesita abrir un archivo ROM.
1.  Vaya a **Archivo > Abrir** en el menú principal.
2.  Seleccione uno o más archivos ROM de su ordenador.
3.  Cada archivo seleccionado se abrirá en una nueva pestaña en el Área de Documentos.

Cuando se abre un archivo, se carga en una **Vista de Documento**, que es el espacio de trabajo principal para toda la edición.

### Trabajando con Proyectos

Un **Proyecto (`.tbproj`)** guarda toda su sesión de trabajo. Esto es increíblemente útil para hacks complejos en los que está trabajando con múltiples archivos o tiene configuraciones de vista muy específicas.

Un archivo de proyecto almacena:
* La lista de todos los archivos ROM abiertos.
* Los ajustes específicos para cada archivo: códec, paleta, zoom, posición de desplazamiento, etc.
* La pestaña activa en la que estaba trabajando.

Puede gestionar proyectos usando el menú **Proyecto**. Use **Proyecto > Guardar Proyecto** para guardar su sesión actual y **Proyecto > Abrir Proyecto** para restaurarla más tarde.

## 4. La Vista de Documento

Cada pestaña contiene una Vista de Documento, que es donde ocurre toda la magia. Esta vista es autónoma y contiene todos los ajustes para el archivo que se muestra actualmente.

![La Vista de Documento](imgs/DocumentView_EN.png)
*(Imagen: Una captura de pantalla de una sola pestaña de documento con sus diversos paneles resaltados.)*

### Panel de Controles

Este panel le permite definir cómo se interpretan y muestran los datos en bruto de la ROM.

* **Códec**: Este es el ajuste más importante. Un códec (abreviatura de Codificador-Decodificador) le dice al programa cómo traducir los bytes en bruto de la ROM a píxeles. Diferentes consolas almacenan los gráficos de diferentes maneras (p. ej., planar, lineal). Debe seleccionar el códec correcto para el juego que está editando. La lista incluye formatos como `4bpp planar, composite (2x2bpp)` para SNES o `2bpp planar` para Game Boy.
* **Tiles por Fila/Columna**: Estos campos numéricos controlan las dimensiones del visor de tiles, permitiéndole organizar los tiles de una manera que tenga sentido para los datos que está viendo.
* **Formato de Paleta**: Selecciona el formato de color para cargar paletas desde la ROM o archivos externos (p. ej., `15-bit BGR (5-5-5)` es común para SNES/GBA).

### Panel de Herramientas

Aquí puede seleccionar su herramienta de edición activa y realizar transformaciones en sus tiles.

![Panel de Herramientas](imgs/Tools_EN.png)
*(Imagen: Un primer plano del panel de Herramientas.)*

* **Herramientas de Edición**: Puntero, Lápiz, Bote de Pintura, Cuentagotas, Reemplazador de Color, Zoom y Mover. Cada una se explica en detalle en la sección 5.
* **Botones de Transformación**: Voltear Horizontalmente (`H`), Voltear Verticalmente (`V`) y Rotar (`R`). Se aplican a una selección de tiles, o a toda la vista si no hay nada seleccionado.
* **Botones de Desplazamiento**: Los botones de flecha desplazan los píxeles dentro de cada tile de la selección (o de toda la vista) un píxel en la dirección elegida.

### Vistas de Paleta

Tile Bulinator utiliza un sistema de paletas de dos niveles para una máxima flexibilidad.

* **Paleta Maestra** (panel derecho): Muestra la paleta maestra completa de 256 colores. Puede cargar esta paleta desde la ROM (ver **Menú Paleta**) o desde un archivo externo. Hacer clic en esta paleta selecciona una subpaleta para usar en la edición.
    ![Paleta Maestra](imgs/MasterPalette_EN.png)
    *(Imagen: Un primer plano del panel de la Paleta Maestra.)*
* **Paleta Activa** (panel izquierdo): Esta es la subpaleta que se está utilizando actualmente para dibujar. Su tamaño está determinado por los bits por píxel del códec seleccionado (p. ej., un códec de 4bpp usará una paleta activa de 16 colores). Hacer clic en un color aquí lo selecciona para dibujar. Hacer clic derecho en un color le permite editarlo.
    ![Paleta Activa](imgs/ActivePalette_EN.png)
    *(Imagen: Un primer plano del panel de la Paleta Activa.)*

### El Visor de Tiles

Este es el lienzo principal donde se muestran y editan los tiles decodificados.
![Visor de Tiles](imgs/TileViewer_EN.png)
*(Imagen: Un primer plano del panel del Visor de Tiles.)*

* **Navegación**: Use la barra de desplazamiento vertical para moverse a través del archivo tile por tile, y la barra de desplazamiento horizontal para un desplazamiento preciso a nivel de byte. También puede usar la rueda del ratón para desplazarse verticalmente.
* **Zoom**: La forma más rápida de hacer zoom es manteniendo **Ctrl** y usando la **Rueda del Ratón**.
* **Cuadrículas**: Puede activar una cuadrícula de tiles de 8x8 y una cuadrícula de píxeles de 1x1 para una edición precisa a través del menú **Vista**. La cuadrícula de píxeles solo es visible a niveles de zoom más altos.

## 5. Herramientas de Edición en Detalle

A continuación se explica cómo usar cada herramienta del Panel de Herramientas.

* ![](imgs/Tools_Pointer.png) **Herramienta Puntero**: Haga clic y arrastre para seleccionar un bloque rectangular de tiles. La selección puede usarse para transformaciones, operaciones de cortar/copiar o exportar.
* ![](imgs/Tools_Pencil.png) **Herramienta Lápiz**: Haga clic en un píxel para dibujar con el color actualmente seleccionado de la Paleta Activa. También puede hacer clic y arrastrar para dibujar de forma continua.
    > **Atajo**: Mantenga **Ctrl** mientras esta herramienta está activa para cambiar temporalmente al **Cuentagotas**.
* ![](imgs/Tools_Bucket.png) **Herramienta Bote de Pintura**:
    * **Clic Normal**: Realiza un "relleno global". Encuentra todos los píxeles del color en el que se hizo clic que están conectados a través de *toda el área de tiles visible* y los reemplaza con el color activo.
    * **Ctrl + Clic**: Realiza un "relleno local". El relleno se limita al único tile de 8x8 en el que hizo clic.
* ![](imgs/Tools_Eyedropper.png) **Herramienta Cuentagotas**: Haga clic en cualquier píxel en el visor de tiles para seleccionar su color y hacerlo el color activo en las vistas de paleta.
* ![](imgs/Tools_Replacer.png) **Herramienta Reemplazador de Color**: Reemplaza un color por otro. Haga clic en un píxel; su color se convierte en el color "objetivo", y todas las instancias de este son reemplazadas por el color de dibujo actualmente activo.
    > **Atajo**: Mantenga **Shift** mientras hace clic para realizar el reemplazo *solo dentro de la selección actual*.
* ![](imgs/Tools_Move.png) **Herramienta Mover**: Le permite mover una selección de tiles.
    1.  Primero, cree una selección con la **Herramienta Puntero**.
    2.  Seleccione la **Herramienta Mover**.
    3.  Haga clic *dentro* de la selección y arrástrela a una nueva ubicación.
    4.  Suelte el botón del ratón para dejar los tiles en la nueva posición.
* ![](imgs/Tools_Zoom.png) **Herramienta Zoom**:
    * **Clic izquierdo** en el visor de tiles para acercar (zoom in).
    * **Clic derecho** para alejar (zoom out).

## 6. Referencia de Menús

### Menú Archivo

* **Abrir**: Abre uno o más archivos ROM.
* **Abrir Recientes**: Una lista de archivos abiertos recientemente para un acceso rápido.
* **Guardar**: Guarda los cambios en el archivo ROM actual.
* **Guardar Como...**: Guarda el archivo ROM actual en una nueva ubicación.
* **Guardar Todo**: Guarda todos los archivos modificados que están abiertos actualmente.
* **Cerrar**: Cierra la pestaña actual. Le preguntará si desea guardar si hay cambios no guardados.
* **Cerrar Todo**: Intenta cerrar todas las pestañas abiertas.
* **Salir**: Cierra la aplicación.

### Menú Editar

* **Deshacer/Rehacer**: Funcionalidad estándar de deshacer/rehacer para sus ediciones.
* **Cortar/Copiar/Pegar**: Copia y pega bloques de datos de tiles seleccionados.
* **Exportar a PNG**: Exporta la selección de tiles actual como un archivo de imagen `.png`.
* **Importar de PNG**: Importa un archivo `.png`. La imagen se convierte usando la paleta activa actual y se pega en la ubicación de la selección.
* **Ir a...**: Abre el diálogo "Ir a Offset" para saltar a una dirección específica en el archivo.

### Menú Vista

* **Cuadrícula de Tiles**: Activa/desactiva la visibilidad de la cuadrícula de tiles de 8x8.
* **Cuadrícula de Píxeles**: Activa/desactiva la visibilidad de la cuadrícula de píxeles de 1x1.

### Menú Paleta

* **Cargar Paleta Maestra desde ROM...**: Pide un offset, luego intenta cargar una paleta de 256 colores desde esa dirección en la ROM usando el Formato de Paleta seleccionado.
* **Cargar Paleta Maestra desde Archivo...**: Carga una paleta maestra desde un archivo externo (p. ej., un archivo `.pal`).
* **Cargar Paleta Activa desde Archivo...**: Carga una paleta pequeña directamente en la vista de Paleta Activa desde un archivo `.tbpal`.
* **Guardar Paleta Activa...**: Guarda la Paleta Activa actual en un archivo `.tbpal`.

### Menú Proyecto

* **Nuevo Proyecto**: Cierra todos los archivos e inicia una nueva sesión de proyecto vacía.
* **Abrir Proyecto...**: Abre un archivo `.tbproj`, restaurando todos los archivos guardados y sus ajustes.
* **Abrir Proyecto Reciente**: Una lista de proyectos abiertos recientemente.
* **Guardar Proyecto / Guardar Proyecto Como...**: Guarda el estado actual de todas las pestañas abiertas y sus ajustes en un archivo `.tbproj`.
* **Cerrar Proyecto**: Cierra el proyecto actual (funcionalmente igual que Nuevo Proyecto).

### Menú Ajustes

* **Ajustes...**: Abre el diálogo de ajustes de la aplicación, donde puede cambiar el idioma, las vistas predeterminadas y la apariencia de la selección.

## 7. Atajos de Teclado y Ratón

| Acción | Atajo | Contexto |
| :--- | :--- | :--- |
| Zoom | `Ctrl` + `Rueda del Ratón` | En el Visor de Tiles |
| Desplazamiento Vertical | `Rueda del Ratón` | En el Visor de Tiles |
| Cuentagotas Temporal | `Ctrl` + `Clic` | Cuando la Herramienta Lápiz está activa |
| Relleno Local de Tile | `Ctrl` + `Clic` | Cuando la Herramienta Bote de Pintura está activa |
| Reemplazar en la Selección | `Shift` + `Clic` | Cuando el Reemplazador de Color está activo |
| Editar Color Activo | `Clic derecho` en un color | En la Vista de Paleta Activa |

---
*Este manual fue generado por IA basándose en el código fuente de la aplicación. Todas las características están sujetas a cambios.*