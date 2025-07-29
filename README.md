![](TileBulinator.png)

# User Guide: Tile Bulinator

## 1. Introduction

### 1.1. Purpose of the Tool

**Tile Bulinator** is an advanced tile graphics editor, specifically designed for viewing and modifying raw graphical data found in old console ROMs. Inspired by classic ROM Hacking tools, Tile Bulinator offers a modern multi-document interface, a robust Undo/Redo system, and a full suite of editing tools, making it the definitive solution for artists, translators, and ROM hackers working with the graphical architecture of 8 and 16-bit systems.

Its flexible codec architecture allows for the interpretation of a wide range of graphical formats, from simple linear to the most complex planar ones.

### 1.2. Main Interface

Tile Bulinator uses a Tabbed Document Interface (TDI), allowing you to open and edit multiple files simultaneously.

* **Main Menu:** Located at the top, it provides access to all file, edit, view, and palette management functionalities.
* **Document Area:** The central area where each open file is displayed in its own tab.
* **Status Bar:** Located at the bottom, it displays important contextual information, such as the file path, cursor position (address, tile, pixel), and the current zoom level.

## 2. File Management (File Menu)

Tile Bulinator offers complete file management, allowing for a flexible workflow with multiple documents.

* **Open... (`Ctrl+O`):** Opens one or more ROM files. Each file is loaded into a new tab.
* **Save (`Ctrl+S`):** Saves the changes made to the active document. If the file has never been saved, it acts as "Save As...".
* **Save As... (`Ctrl+Shift+S`):** Allows saving the active document with a new name or in a new location.
* **Save All (`Ctrl+Alt+S`):** Goes through all open tabs and saves every file that has been modified.
* **Close (`Ctrl+W`):** Closes the active document's tab. If there are unsaved changes, the program will ask if you want to save them.
* **Close All (`Ctrl+Shift+W`):** Attempts to close all open tabs, asking individually about each modified file.
* **Exit:** Closes the application. A security check is performed to prevent the loss of unsaved changes.

## 3. The Document Workspace

Each document tab contains a complete workspace, divided into three main panels.

### 3.1. Left Panel (Controls and Tools)

* **View Controls:**
    * **Codec:** Allows you to select the graphical format (e.g., `4bpp planar`) to correctly interpret the ROM data.
    * **Dimensions:** Defines the width (`Columns`) and height (`Rows`) of the tile grid displayed on the screen.
* **Tools:** The toolbox for editing. Only one tool can be active at a time.
    * **Pointer (Selection):** Allows selecting one or multiple tiles. Click and drag to create a rectangular selection.
    * **Pencil:** Pixel-by-pixel drawing tool.
        * **Shortcut:** Hold `CTRL` to temporarily activate the **Eyedropper**.
    * **Paint Bucket:** Fills a contiguous area of color.
        * **Normal Click:** Global fill, crossing tile boundaries.
        * **`CTRL` + Click:** Local fill, limited to the clicked tile.
    * **Eyedropper:** Picks a color from the tile viewer and sets it as the active color.
    * **Color Replacer:** Replaces one color with another.
        * **Normal Click:** Acts on the entire visible area.
        * **`SHIFT` + Click:** Acts only within the selected area.
    * **Transform (H, V, R):** Action buttons to **Flip Horizontally**, **Flip Vertically**, and **Rotate 90°**. They act on the selection or, in its absence, on the entire visible area.
    * **Shift (Arrows):** Action buttons to shift the pixels of each tile in the target area by 1 pixel in the chosen direction.
    * **Zoom:** Interactive zoom tool.
        * **Left Click:** Zooms in.
        * **Right Click:** Zooms out.
    * **Move:** Allows moving the content of a selection. Click within a selection, drag, and release at the new location.
* **Active Palette:**
    * Displays the sub-palette (e.g., 16 colors) being used to render the tiles.
    * **Left Click:** Selects the active color for drawing.
    * **Right Click:** Opens a dialog to edit the selected color.

### 3.2. Central Panel (Tile Viewer)

The main editing area, where graphics are displayed and manipulated.

* **Vertical Scrollbar:** Navigates through the ROM in "pages" of tiles.
* **Horizontal Scrollbar:** Adjusts the byte offset, for misaligned data.
* **Mouse Wheel:**
    * **Normal:** Navigates vertically through the tiles.
    * **`CTRL` + Mouse Wheel:** Controls the zoom.

### 3.3. Right Panel (Master Palette)

* **Format:** Selects the color format (e.g., `15-bit BGR`) to interpret palette data.
* **Master Palette:** Displays 256 colors. Acts as a "color bank".
    * **Left Click:** Selects a sub-palette (with the size defined by the tile Codec) and loads it into the **Active Palette**. A yellow highlight shows the preview of the selection.

## 4. Advanced Features (Menus)

### 4.1. Edit Menu

* **Undo (`Ctrl+Z`) / Redo (`Ctrl+Y`):** A robust and "atomic" system. Complex operations like "Paste", "Import PNG", or "Global Paint Bucket" are undone/redone in a single step.
* **Cut (`Ctrl+X`) / Copy (`Ctrl+C`) / Paste (`Ctrl+V`):** Standard clipboard tools that operate on the tile selection.
* **Export/Import PNG:** Saves or loads the tile selection as a PNG image. The import intelligently converts the PNG colors to the closest color in the Active Palette.
* **Go to Offset... (`Ctrl+G`):** Opens an advanced dialog to navigate to an address, with options for base (Decimal/Hexadecimal/Automatic) and mode (Absolute/Relative to the current position/Relative to the end of the ROM).

### 4.2. View Menu

* **Tile Grid:** Toggles a grid that delineates the tile borders.
* **Pixel Grid:** Toggles a fine, dotted grid that delineates each pixel. Visible only at high zoom levels.

### 4.3. Palette Menu

* **Load Master Palette...:** Loads a 256-color palette from a file.
* **Load Master Palette from ROM...:** Opens the "Go to..." dialog to load the palette directly from an offset in the ROM.
* **Load Active Palette...:** Loads a palette file (`.tbpal`) directly into the Active Palette.
* **Save Active Palette...:** Saves the colors from the current Active Palette to a file (`.tbpal`).
