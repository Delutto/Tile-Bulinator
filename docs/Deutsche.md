# Tile Bulinator - Benutzerhandbuch

Willkommen zum offiziellen Benutzerhandbuch für **Tile Bulinator**. Diese Anleitung bietet eine detaillierte exemplarische Vorgehensweise für alle Features und Funktionalitäten der Anwendung.

## Inhaltsverzeichnis
1.  [Einleitung](#1-introduction)
2.  [Die Benutzeroberfläche](#2-the-main-interface)
3.  [Erste Schritte: Dateien & Projekte](#3-getting-started-files--projects)
    * [Eine ROM-Datei öffnen](#opening-a-rom-file)
    * [Arbeiten mit Projekten](#working-with-projects)
4.  [Die Dokumentenansicht](#4-the-document-view)
    * [Bedienfeld](#controls-panel)
    * [Werkzeugleiste](#tools-panel)
    * [Palettenansichten](#palette-views)
    * [Der Kachel-Viewer](#the-tile-viewer)
5.  [Die Bearbeitungswerkzeuge im Detail](#5-editing-tools-in-detail)
6.  [Menüreferenz](#6-menu-reference)
    * [Menü Datei](#file-menu)
    * [Menü Bearbeiten](#edit-menu)
    * [Menü Ansicht](#view-menu)
    * [Menü Palette](#palette-menu)
    * [Menü Projekt](#project-menu)
    * [Menü Einstellungen](#settings-menu)
7.  [Tastatur- und Maus-Kürzel](#7-keyboard--mouse-shortcuts)

---

## 1. Einleitung

**Tile Bulinator** ist ein fortschrittlicher Editor für Kachelgrafiken, der zum Anzeigen und Ändern von rohen Grafikdaten aus klassischen Konsolen-ROMs entwickelt wurde. Er bietet eine leistungsstarke und intuitive Benutzeroberfläche für ROM-Hacker und Retro-Gaming-Enthusiasten, um Spiel-Assets direkt zu erkunden und zu verändern.

Dieses Handbuch führt Sie durch seine leistungsstarken Funktionen, von der einfachen Dateiansicht bis hin zur fortgeschrittenen Grafikbearbeitung und Palettenverwaltung.

## 2. Die Benutzeroberfläche

Das Hauptfenster ist in mehrere Schlüsselbereiche unterteilt:

![Übersicht der Benutzeroberfläche](imgs/MainInterface_EN.png)
*(Bild: Ein Screenshot des Hauptanwendungsfensters mit hervorgehobenen Schlüsselbereichen.)*

* **Hauptmenü**: Befindet sich oben und bietet Zugriff auf alle Anwendungsfunktionen wie Dateioperationen, Bearbeitungsbefehle und Ansichtseinstellungen.
* **Dokumentenbereich**: Der zentrale Teil des Fensters, in dem ROM-Dateien in Registerkarten geöffnet werden. Jede Registerkarte stellt eine unabhängige Dokumentenansicht dar.
* **Statusleiste**: Befindet sich unten und zeigt wichtige Informationen wie den vollständigen Pfad der geöffneten Datei, die Adresse und Koordinaten unter dem Cursor sowie die aktuelle Zoomstufe an.

## 3. Erste Schritte: Dateien & Projekte

### Eine ROM-Datei öffnen

Um zu beginnen, müssen Sie eine ROM-Datei öffnen.
1.  Gehen Sie im Hauptmenü auf **Datei > Öffnen**.
2.  Wählen Sie eine oder mehrere ROM-Dateien von Ihrem Computer aus.
3.  Jede ausgewählte Datei wird in einer neuen Registerkarte im Dokumentenbereich geöffnet.

Wenn eine Datei geöffnet wird, wird sie in eine **Dokumentenansicht** geladen, die der Hauptarbeitsbereich für die gesamte Bearbeitung ist.

### Arbeiten mit Projekten

Ein **Projekt (`.tbproj`)** speichert Ihre gesamte Arbeitsbereich-Sitzung. Dies ist unglaublich nützlich für komplexe Hacks, bei denen Sie mit mehreren Dateien arbeiten oder sehr spezifische Ansichtseinstellungen haben.

Eine Projektdatei speichert:
* Die Liste aller geöffneten ROM-Dateien.
* Die spezifischen Einstellungen für jede Datei: Codec, Palette, Zoom, Scroll-Position usw.
* Die aktive Registerkarte, an der Sie gearbeitet haben.

Sie können Projekte über das Menü **Projekt** verwalten. Verwenden Sie **Projekt > Projekt speichern**, um Ihre aktuelle Sitzung zu speichern, und **Projekt > Projekt öffnen**, um sie später wiederherzustellen.

## 4. Die Dokumentenansicht

Jede Registerkarte enthält eine Dokumentenansicht, in der die ganze Magie geschieht. Diese Ansicht ist in sich geschlossen und enthält alle Einstellungen für die aktuell angezeigte Datei.

![Die Dokumentenansicht](imgs/DocumentView_EN.png)
*(Bild: Ein Screenshot einer einzelnen Dokumentenregisterkarte mit ihren verschiedenen hervorgehobenen Panels.)*

### Bedienfeld

Dieses Panel ermöglicht es Ihnen zu definieren, wie die Rohdaten aus dem ROM interpretiert und angezeigt werden.

* **Codec**: Dies ist die wichtigste Einstellung. Ein Codec (kurz für Coder-Decoder) teilt dem Programm mit, wie die rohen Bytes des ROMs in Pixel übersetzt werden sollen. Verschiedene Konsolen speichern Grafiken auf unterschiedliche Weise (z.B. planar, linear). Sie müssen den richtigen Codec für das Spiel auswählen, das Sie bearbeiten. Die Liste enthält Formate wie `4bpp planar, composite (2x2bpp)` für SNES oder `2bpp planar` für Game Boy.
* **Kacheln pro Zeile/Spalte**: Diese Drehfelder steuern die Abmessungen des Kachel-Viewers, sodass Sie die Kacheln so anordnen können, wie es für die angezeigten Daten sinnvoll ist.
* **Palettenformat**: Wählt das Farbformat zum Laden von Paletten aus der ROM oder externen Dateien aus (z.B. ist `15-bit BGR (5-5-5)` für SNES/GBA üblich).

### Werkzeugleiste

Hier können Sie Ihr aktives Bearbeitungswerkzeug auswählen und Transformationen an Ihren Kacheln durchführen.

![Werkzeugleiste](imgs/Tools_EN.png)                                                                                 
*(Bild: Eine Nahaufnahme der Werkzeugleiste.)*

* **Bearbeitungswerkzeuge**: Zeiger, Stift, Fülleimer, Pipette, Farb-Ersetzer, Zoom und Verschieben. Jedes wird in Abschnitt 5 detailliert erklärt.
* **Transformationsschaltflächen**: Horizontal spiegeln (`H`), Vertikal spiegeln (`V`) und Drehen (`R`). Diese gelten für eine Auswahl von Kacheln oder die gesamte Ansicht, wenn nichts ausgewählt ist.
* **Verschiebungsschaltflächen**: Die Pfeiltasten verschieben die Pixel innerhalb jeder Kachel der Auswahl (oder der gesamten Ansicht) um ein Pixel in die gewählte Richtung.

### Palettenansichten

Tile Bulinator verwendet ein zweistufiges Palettensystem für maximale Flexibilität.

* **Master-Palette** (rechtes Panel): Zeigt die vollständige 256-Farben-Master-Palette. Sie können diese Palette aus der ROM (siehe **Menü Palette**) oder einer externen Datei laden. Ein Klick auf diese Palette wählt eine Unterpalette zur Bearbeitung aus.

    ![Master-Palette](imgs/MasterPalette_EN.png)                                                                                 
    *(Bild: Eine Nahaufnahme des Master-Paletten-Panels.)*
* **Aktive Palette** (linkes Panel): Dies ist die Unterpalette, die aktuell zum Zeichnen verwendet wird. Ihre Größe wird durch die Bits-pro-Pixel des ausgewählten Codecs bestimmt (z.B. verwendet ein 4bpp-Codec eine 16-Farben-Aktiv-Palette). Ein Klick auf eine Farbe hier wählt sie zum Zeichnen aus. Ein Rechtsklick auf eine Farbe ermöglicht es Ihnen, sie zu bearbeiten.

    ![Aktive Palette](imgs/ActivePalette_EN.png)                                                                                                  
    *(Bild: Eine Nahaufnahme des Panels der aktiven Palette.)*

### Der Kachel-Viewer

Dies ist die Hauptleinwand, auf der die dekodierten Kacheln angezeigt und bearbeitet werden.

![Der Kachel-Viewer](imgs/TileViewer_EN.png)                                                                                             
*(Bild: Eine Nahaufnahme des Kachel-Viewer-Panels.)*

* **Navigation**: Verwenden Sie die vertikale Bildlaufleiste, um sich Kachel für Kachel durch die Datei zu bewegen, und die horizontale Bildlaufleiste für eine fein abgestimmte Verschiebung auf Byte-Ebene. Sie können auch das Mausrad verwenden, um vertikal zu scrollen.
* **Zoomen**: Der schnellste Weg zum Zoomen ist, **Strg** gedrückt zu halten und das **Mausrad** zu verwenden.
* **Gitter**: Sie können ein 8x8-Kachelgitter und ein 1x1-Pixelgitter für eine präzise Bearbeitung über das Menü **Ansicht** umschalten. Das Pixelgitter ist nur bei höheren Zoomstufen sichtbar.

## 5. Die Bearbeitungswerkzeuge im Detail

Hier erfahren Sie, wie Sie jedes Werkzeug aus der Werkzeugleiste verwenden.

* ![](imgs/Tools_Pointer.png) **Zeiger-Werkzeug**: Klicken und ziehen Sie, um einen rechteckigen Block von Kacheln auszuwählen. Die Auswahl kann dann für Transformationen, Ausschneide-/Kopiervorgänge oder den Export verwendet werden.
* ![](imgs/Tools_Pencil.png) **Stift-Werkzeug**: Klicken Sie auf ein Pixel, um mit der aktuell ausgewählten Farbe aus der Aktiven Palette zu zeichnen. Sie können auch klicken und ziehen, um kontinuierlich zu zeichnen.
    > **Kürzel**: Halten Sie **Strg** gedrückt, während dieses Werkzeug aktiv ist, um vorübergehend zur **Pipette** zu wechseln.
* ![](imgs/Tools_Bucket.png) **Fülleimer-Werkzeug**:
    * **Normaler Klick**: Führt eine "globale Füllung" durch. Es findet alle Pixel der angeklickten Farbe, die über den *gesamten sichtbaren Kachelbereich* verbunden sind, und ersetzt sie durch die aktive Farbe.
    * **Strg + Klick**: Führt eine "lokale Füllung" durch. Die Füllung ist auf die einzelne 8x8-Kachel beschränkt, auf die Sie geklickt haben.
* ![](imgs/Tools_Eyedropper.png) **Pipetten-Werkzeug**: Klicken Sie auf ein beliebiges Pixel im Kachel-Viewer, um dessen Farbe auszuwählen und sie zur aktiven Farbe in den Palettenansichten zu machen.
* ![](imgs/Tools_Replacer.png) **Farb-Ersetzer-Werkzeug**: Ersetzt eine Farbe durch eine andere. Klicken Sie auf ein Pixel; seine Farbe wird zur "Zielfarbe", und alle Vorkommen davon werden durch die aktuell aktive Zeichenfarbe ersetzt.
    > **Kürzel**: Halten Sie **Umschalt** gedrückt, während Sie klicken, um die Ersetzung *nur innerhalb der aktuellen Auswahl* durchzuführen.
* ![](imgs/Tools_Move.png) **Verschieben-Werkzeug**: Ermöglicht es Ihnen, eine Auswahl von Kacheln zu verschieben.
    1.  Erstellen Sie zuerst eine Auswahl mit dem **Zeiger-Werkzeug**.
    2.  Wählen Sie das **Verschieben-Werkzeug**.
    3.  Klicken Sie *innerhalb* der Auswahl und ziehen Sie sie an einen neuen Ort.
    4.  Lassen Sie die Maustaste los, um die Kacheln an der neuen Position abzulegen.
* ![](imgs/Tools_Zoom.png) **Zoom-Werkzeug**:
    * **Linksklick** auf den Kachel-Viewer zum Vergrößern (Zoom in).
    * **Rechtsklick** zum Verkleinern (Zoom out).

## 6. Menüreferenz

### Menü Datei

* **Öffnen**: Öffnet eine oder mehrere ROM-Dateien.
* **Zuletzt geöffnet**: Eine Liste der zuletzt geöffneten Dateien für den schnellen Zugriff.
* **Speichern**: Speichert die Änderungen an der aktuellen ROM-Datei.
* **Speichern unter...**: Speichert die aktuelle ROM-Datei an einem neuen Ort.
* **Alles speichern**: Speichert alle geänderten Dateien, die derzeit geöffnet sind.
* **Schließen**: Schließt die aktuelle Registerkarte. Fordert zum Speichern auf, wenn nicht gespeicherte Änderungen vorhanden sind.
* **Alles schließen**: Versucht, alle geöffneten Registerkarten zu schließen.
* **Beenden**: Schließt die Anwendung.

### Menü Bearbeiten

* **Rückgängig/Wiederholen**: Standardmäßige Rückgängig/Wiederholen-Funktionalität für Ihre Bearbeitungen.
* **Ausschneiden/Kopieren/Einfügen**: Kopiert und fügt Blöcke ausgewählter Kacheldaten ein.
* **Als PNG exportieren**: Exportiert die aktuelle Kachelauswahl als `.png`-Bilddatei.
* **Aus PNG importieren**: Importiert eine `.png`-Datei. Das Bild wird unter Verwendung der aktuell aktiven Palette konvertiert und an der Position der Auswahl eingefügt.
* **Gehe zu...**: Öffnet den Dialog "Gehe zu Offset", um zu einer bestimmten Adresse in der Datei zu springen.

### Menü Ansicht

* **Kachel-Gitter**: Schaltet die Sichtbarkeit des 8x8-Kachel-Gitters um.
* **Pixel-Gitter**: Schaltet die Sichtbarkeit des 1x1-Pixel-Gitters um.

### Menü Palette

* **Master-Palette aus ROM laden...**: Fordert einen Offset an und versucht dann, eine 256-Farben-Palette von dieser Adresse in der ROM unter Verwendung des ausgewählten Palettenformats zu laden.
* **Master-Palette aus Datei laden...**: Lädt eine Master-Palette aus einer externen Datei (z.B. einer `.pal`-Datei).
* **Aktive Palette aus Datei laden...**: Lädt eine kleine Palette direkt aus einer `.tbpal`-Datei in die Ansicht der aktiven Palette.
* **Aktive Palette speichern...**: Speichert die aktuelle aktive Palette in einer `.tbpal`-Datei.

### Menü Projekt

* **Neues Projekt**: Schließt alle Dateien und startet eine neue, leere Projektsitzung.
* **Projekt öffnen...**: Öffnet eine `.tbproj`-Datei und stellt alle gespeicherten Dateien und deren Einstellungen wieder her.
* **Zuletzt geöffnetes Projekt**: Eine Liste der zuletzt geöffneten Projekte.
* **Projekt speichern / Projekt speichern unter...**: Speichert den aktuellen Zustand aller geöffneten Registerkarten und deren Einstellungen in einer `.tbproj`-Datei.
* **Projekt schließen**: Schließt das aktuelle Projekt (funktional identisch mit Neues Projekt).

### Menü Einstellungen

* **Einstellungen...**: Öffnet den Einstellungsdialog der Anwendung, in dem Sie die Sprache, Standardansichten und das Erscheinungsbild der Auswahl ändern können.

## 7. Tastatur- und Maus-Kürzel

| Aktion | Kürzel | Kontext |
| :--- | :--- | :--- |
| Zoom | `Strg` + `Mausrad` | Im Kachel-Viewer |
| Vertikales Scrollen | `Mausrad` | Im Kachel-Viewer |
| Temporäre Pipette | `Strg` + `Klick` | Wenn das Stift-Werkzeug aktiv ist |
| Lokale Kachelfüllung | `Strg` + `Klick` | Wenn das Fülleimer-Werkzeug aktiv ist |
| In Auswahl ersetzen | `Umschalt` + `Klick` | Wenn der Farb-Ersetzer aktiv ist |
| Aktive Farbe bearbeiten | `Rechtsklick` auf eine Farbe | In der Ansicht der aktiven Palette |

---

*Dieses Handbuch wurde von einer KI auf Basis des Quellcodes der Anwendung generiert. Alle Funktionen können sich ändern.*
