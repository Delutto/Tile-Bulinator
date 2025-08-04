# Tile Bulinator - User Manual

Welcome to the official User Manual for **Tile Bulinator**. This guide provides a detailed walkthrough of all the features and functionalities of the application.

## Table of Contents
1.  [Introduction](#1-introduction)
2.  [The Main Interface](#2-the-main-interface)
3.  [Getting Started: Files & Projects](#3-getting-started-files--projects)
    * [Opening a ROM File](#opening-a-rom-file)
    * [Working with Projects](#working-with-projects)
4.  [The Document View](#4-the-document-view)
    * [Controls Panel](#controls-panel)
    * [Tools Panel](#tools-panel)
    * [Palette Views](#palette-views)
    * [The Tile Viewer](#the-tile-viewer)
5.  [Editing Tools in Detail](#5-editing-tools-in-detail)
6.  [Menu Reference](#6-menu-reference)
    * [File Menu](#file-menu)
    * [Edit Menu](#edit-menu)
    * [View Menu](#view-menu)
    * [Palette Menu](#palette-menu)
    * [Project Menu](#project-menu)
    * [Settings Menu](#settings-menu)
7.  [Keyboard & Mouse Shortcuts](#7-keyboard--mouse-shortcuts)

---

## 1. Introduction

**Tile Bulinator** is an advanced tile graphics editor designed for viewing and modifying raw graphic data found in classic console ROMs. It provides a powerful and intuitive interface for ROM hackers and retro game enthusiasts to explore and alter game assets directly.

This manual will guide you through its powerful features, from basic file viewing to advanced graphic editing and palette management.

## 2. The Main Interface

The main window is divided into several key areas:

![Main Interface Overview](imgs/MainInterface_EN.png)
*(Image: A screenshot of the main application window with key areas highlighted.)*

* **Main Menu**: Located at the top, it provides access to all application functions, such as file operations, editing commands, and view settings.
* **Document Area**: The central part of the window where ROM files are opened in tabs. Each tab represents an independent document view.
* **Status Bar**: Located at the bottom, it displays important information like the full path of the open file, the address and coordinates under the cursor, and the current zoom level.

## 3. Getting Started: Files & Projects

### Opening a ROM File

To begin, you need to open a ROM file.
1.  Go to **File > Open** in the main menu.
2.  Select one or more ROM files from your computer.
3.  Each selected file will open in a new tab in the Document Area.

When a file is opened, it is loaded into a **Document View**, which is the main workspace for all editing.

### Working with Projects

A **Project (`.tbproj`)** saves your entire workspace session. This is incredibly useful for complex hacks where you are working with multiple files or have very specific view settings.

A project file stores:
* The list of all open ROM files.
* The specific settings for each file: codec, palette, zoom, scroll position, etc.
* The active tab you were working on.

You can manage projects using the **Project** menu. Use **Project > Save Project** to save your current session and **Project > Open Project** to restore it later.

## 4. The Document View

Each tab contains a Document View, which is where all the magic happens. This view is self-contained and holds all the settings for the currently displayed file.

![The Document View](imgs/DocumentView_EN.png)
*(Image: A screenshot of a single document tab with its various panels highlighted.)*

### Controls Panel

This panel allows you to define how the raw data from the ROM is interpreted and displayed.

* **Codec**: This is the most important setting. A codec (short for Coder-Decoder) tells the program how to translate the raw bytes of the ROM into pixels. Different consoles store graphics in different ways (e.g., planar, linear). You must select the correct codec for the game you are editing. The list includes formats like `4bpp planar, composite (2x2bpp)` for SNES or `2bpp planar` for Game Boy.
* **Tiles per Row/Column**: These spin boxes control the dimensions of the tile viewer, allowing you to arrange the tiles in a way that makes sense for the data you are viewing.
* **Palette Format**: Selects the color format for loading palettes from the ROM or external files (e.g., `15-bit BGR (5-5-5)` is common for SNES/GBA).

### Tools Panel

Here you can select your active editing tool and perform transformations on your tiles.

![Tools Panel](imgs/Tools_EN.png)
*(Image: A close-up of the Tools panel.)*

* **Editing Tools**: Pointer, Pencil, Fill Bucket, Eyedropper, Color Replacer, Zoom, and Move tools. Each is explained in detail in section 5.
* **Transform Buttons**: Flip Horizontal (`H`), Flip Vertical (`V`), and Rotate (`R`). These apply to a selection of tiles, or the entire view if nothing is selected.
* **Shift Buttons**: The arrow buttons shift the pixels within each tile of the selection (or the whole view) by one pixel in the chosen direction.

### Palette Views

Tile Bulinator uses a two-level palette system for maximum flexibility.

* **Master Palette** (right panel): This shows the full 256-color master palette. You can load this palette from the ROM (see **Palette Menu**) or an external file. Clicking on this palette selects a sub-palette to use for editing.
![Master Palette](imgs/MasterPalette_EN.png)
*(Image: A close-up of the Master Palette panel.)*
* **Active Palette** (left panel): This is the sub-palette currently being used for drawing. Its size is determined by the selected codec's bits-per-pixel (e.g., a 4bpp codec will use a 16-color active palette). Clicking a color here selects it for drawing. Right-clicking a color allows you to edit it.
![Active Palette](imgs/ActivePalette_EN.png)
*(Image: A close-up of the Active Palette panel.)*

### The Tile Viewer

This is the main canvas where the decoded tiles are displayed and edited.
![Active Palette](imgs/TileViewer_EN.png)
*(Image: A close-up of the The Tile Viewer panel.)*

* **Navigation**: Use the vertical scrollbar to move through the file tile-by-tile, and the horizontal scrollbar for fine-tuned byte-level offsetting. You can also use the mouse wheel to scroll vertically.
* **Zooming**: The fastest way to zoom is by holding **Ctrl** and using the **Mouse Wheel**.
* **Grids**: You can toggle an 8x8 tile grid and a 1x1 pixel grid for precise editing via the **View** menu. The pixel grid is only visible at higher zoom levels.

## 5. Editing Tools in Detail

Here is how to use each tool from the Tools Panel.

* ![](imgs/Tools_Pointer.png) **Pointer Tool**: Click and drag to select a rectangular block of tiles. The selection can then be used for transformations, copy/cut operations, or exporting.
* ![](imgs/Tools_Pencil.png) **Pencil Tool**: Click on a pixel to draw with the currently selected color from the Active Palette. You can also click and drag to draw continuously.
    > **Shortcut**: Hold **Ctrl** while this tool is active to temporarily switch to the **Eyedropper**.
* ![](imgs/Tools_Bucket.png) **Fill Bucket Tool**:
    * **Normal Click**: Performs a "global fill". It finds all pixels of the clicked color that are connected across the *entire visible tile area* and replaces them with the active color.
    * **Ctrl + Click**: Performs a "local fill". The fill is constrained to the single 8x8 tile you clicked in.
* ![](imgs/Tools_Eyedropper.png) **Eyedropper Tool**: Click on any pixel in the tile viewer to select its color and make it the active color in the palette views.
* ![](imgs/Tools_Replacer.png) **Color Replacer Tool**: Replaces a color with another. Click on a pixel; its color becomes the "target" color, and all instances of it are replaced by the currently active drawing color.
    > **Shortcut**: Hold **Shift** while clicking to perform the replacement *only within the current selection*.
* ![](imgs/Tools_Move.png) **Move Tool**: Allows you to move a selection of tiles.
    1.  First, create a selection with the **Pointer Tool**.
    2.  Select the **Move Tool**.
    3.  Click *inside* the selection and drag it to a new location.
    4.  Release the mouse button to drop the tiles in the new position.
* ![](imgs/Tools_Zoom.png) **Zoom Tool**:
    * **Left-click** on the tile viewer to zoom in.
    * **Right-click** to zoom out.

## 6. Menu Reference

### File Menu

* **Open**: Opens one or more ROM files.
* **Open Recent**: A list of recently opened files for quick access.
* **Save**: Saves the changes to the current ROM file.
* **Save As...**: Saves the current ROM file to a new location.
* **Save All**: Saves all modified files that are currently open.
* **Close**: Closes the current tab. Will prompt to save if there are unsaved changes.
* **Close All**: Attempts to close all open tabs.
* **Exit**: Closes the application.

### Edit Menu

* **Undo/Redo**: Standard undo/redo functionality for your edits.
* **Cut/Copy/Paste**: Copies and pastes blocks of selected tile data.
* **Export to PNG**: Exports the current tile selection as a `.png` image file.
* **Import from PNG**: Imports a `.png` file. The image is converted using the currently active palette and pasted at the location of the selection.
* **Go To...**: Opens the "Go to Offset" dialog to jump to a specific address in the file.

### View Menu

* **Tile Grid**: Toggles the visibility of the 8x8 tile grid.
* **Pixel Grid**: Toggles the visibility of the 1x1 pixel grid.

### Palette Menu

* **Load Master Palette from ROM...**: Prompts for an offset, then attempts to load a 256-color palette from that address in the ROM using the selected Palette Format.
* **Load Master Palette from File...**: Loads a master palette from an external file (e.g., a `.pal` file).
* **Load Active Palette from File...**: Loads a small palette directly into the Active Palette view from a `.tbpal` file.
* **Save Active Palette...**: Saves the current Active Palette to a `.tbpal` file.

### Project Menu

* **New Project**: Closes all files and starts a new, empty project session.
* **Open Project...**: Opens a `.tbproj` file, restoring all saved files and their settings.
* **Open Recent Project**: A list of recently opened projects.
* **Save Project / Save Project As...**: Saves the current state of all open tabs and their settings into a `.tbproj` file.
* **Close Project**: Closes the current project (functionally the same as New Project).

### Settings Menu

* **Settings...**: Opens the application settings dialog, where you can change the language, default views, and selection appearance.

## 7. Keyboard & Mouse Shortcuts

| Action | Shortcut | Context |
| :--- | :--- | :--- |
| Zoom | `Ctrl` + `Mouse Wheel` | In the Tile Viewer |
| Vertical Scroll | `Mouse Wheel` | In the Tile Viewer |
| Temporary Eyedropper | `Ctrl` + `Click` | When Pencil Tool is active |
| Local Tile Fill | `Ctrl` + `Click` | When Fill Bucket Tool is active |
| Replace in Selection | `Shift` + `Click` | When Color Replacer is active |
| Edit Active Color | `Right-click` on a color | In the Active Palette View |

---
*This manual was generated based on the application source code. All features are subject to change.*

