# Tile Bulinator - Benutzerhandbuch

Willkommen zum offiziellen Benutzerhandbuch f�r **Tile Bulinator**. Diese Anleitung bietet eine detaillierte exemplarische Vorgehensweise f�r alle Features und Funktionalit�ten der Anwendung.

## Inhaltsverzeichnis
1.  [Einleitung](#1-introduction)
2.  [Die Benutzeroberfl�che](#2-the-main-interface)
3.  [Erste Schritte: Dateien & Projekte](#3-getting-started-files--projects)
    * [Eine ROM-Datei �ffnen](#opening-a-rom-file)
    * [Arbeiten mit Projekten](#working-with-projects)
4.  [Die Dokumentenansicht](#4-the-document-view)
    * [Bedienfeld](#controls-panel)
    * [Werkzeugleiste](#tools-panel)
    * [Palettenansichten](#palette-views)
    * [Der Kachel-Viewer](#the-tile-viewer)
5.  [Die Bearbeitungswerkzeuge im Detail](#5-editing-tools-in-detail)
6.  [Men�referenz](#6-menu-reference)
    * [Men� Datei](#file-menu)
    * [Men� Bearbeiten](#edit-menu)
    * [Men� Ansicht](#view-menu)
    * [Men� Palette](#palette-menu)
    * [Men� Projekt](#project-menu)
    * [Men� Einstellungen](#settings-menu)
7.  [Tastatur- und Maus-K�rzel](#7-keyboard--mouse-shortcuts)

---

## 1. Einleitung

**Tile Bulinator** ist ein fortschrittlicher Editor f�r Kachelgrafiken, der zum Anzeigen und �ndern von rohen Grafikdaten aus klassischen Konsolen-ROMs entwickelt wurde. Er bietet eine leistungsstarke und intuitive Benutzeroberfl�che f�r ROM-Hacker und Retro-Gaming-Enthusiasten, um Spiel-Assets direkt zu erkunden und zu ver�ndern.

Dieses Handbuch f�hrt Sie durch seine leistungsstarken Funktionen, von der einfachen Dateiansicht bis hin zur fortgeschrittenen Grafikbearbeitung und Palettenverwaltung.

## 2. Die Benutzeroberfl�che

Das Hauptfenster ist in mehrere Schl�sselbereiche unterteilt:

![�bersicht der Benutzeroberfl�che](imgs/MainInterface_EN.png)
*(Bild: Ein Screenshot des Hauptanwendungsfensters mit hervorgehobenen Schl�sselbereichen.)*

* **Hauptmen�**: Befindet sich oben und bietet Zugriff auf alle Anwendungsfunktionen wie Dateioperationen, Bearbeitungsbefehle und Ansichtseinstellungen.
* **Dokumentenbereich**: Der zentrale Teil des Fensters, in dem ROM-Dateien in Registerkarten ge�ffnet werden. Jede Registerkarte stellt eine unabh�ngige Dokumentenansicht dar.
* **Statusleiste**: Befindet sich unten und zeigt wichtige Informationen wie den vollst�ndigen Pfad der ge�ffneten Datei, die Adresse und Koordinaten unter dem Cursor sowie die aktuelle Zoomstufe an.

## 3. Erste Schritte: Dateien & Projekte

### Eine ROM-Datei �ffnen

Um zu beginnen, m�ssen Sie eine ROM-Datei �ffnen.
1.  Gehen Sie im Hauptmen� auf **Datei > �ffnen**.
2.  W�hlen Sie eine oder mehrere ROM-Dateien von Ihrem Computer aus.
3.  Jede ausgew�hlte Datei wird in einer neuen Registerkarte im Dokumentenbereich ge�ffnet.

Wenn eine Datei ge�ffnet wird, wird sie in eine **Dokumentenansicht** geladen, die der Hauptarbeitsbereich f�r die gesamte Bearbeitung ist.

### Arbeiten mit Projekten

Ein **Projekt (`.tbproj`)** speichert Ihre gesamte Arbeitsbereich-Sitzung. Dies ist unglaublich n�tzlich f�r komplexe Hacks, bei denen Sie mit mehreren Dateien arbeiten oder sehr spezifische Ansichtseinstellungen haben.

Eine Projektdatei speichert:
* Die Liste aller ge�ffneten ROM-Dateien.
* Die spezifischen Einstellungen f�r jede Datei: Codec, Palette, Zoom, Scroll-Position usw.
* Die aktive Registerkarte, an der Sie gearbeitet haben.

Sie k�nnen Projekte �ber das Men� **Projekt** verwalten. Verwenden Sie **Projekt > Projekt speichern**, um Ihre aktuelle Sitzung zu speichern, und **Projekt > Projekt �ffnen**, um sie sp�ter wiederherzustellen.

## 4. Die Dokumentenansicht

Jede Registerkarte enth�lt eine Dokumentenansicht, in der die ganze Magie geschieht. Diese Ansicht ist in sich geschlossen und enth�lt alle Einstellungen f�r die aktuell angezeigte Datei.

![Die Dokumentenansicht](imgs/DocumentView_EN.png)
*(Bild: Ein Screenshot einer einzelnen Dokumentenregisterkarte mit ihren verschiedenen hervorgehobenen Panels.)*

### Bedienfeld

Dieses Panel erm�glicht es Ihnen zu definieren, wie die Rohdaten aus dem ROM interpretiert und angezeigt werden.

* **Codec**: Dies ist die wichtigste Einstellung. Ein Codec (kurz f�r Coder-Decoder) teilt dem Programm mit, wie die rohen Bytes des ROMs in Pixel �bersetzt werden sollen. Verschiedene Konsolen speichern Grafiken auf unterschiedliche Weise (z.B. planar, linear). Sie m�ssen den richtigen Codec f�r das Spiel ausw�hlen, das Sie bearbeiten. Die Liste enth�lt Formate wie `4bpp planar, composite (2x2bpp)` f�r SNES oder `2bpp planar` f�r Game Boy.
* **Kacheln pro Zeile/Spalte**: Diese Drehfelder steuern die Abmessungen des Kachel-Viewers, sodass Sie die Kacheln so anordnen k�nnen, wie es f�r die angezeigten Daten sinnvoll ist.
* **Palettenformat**: W�hlt das Farbformat zum Laden von Paletten aus der ROM oder externen Dateien aus (z.B. ist `15-bit BGR (5-5-5)` f�r SNES/GBA �blich).

### Werkzeugleiste

Hier k�nnen Sie Ihr aktives Bearbeitungswerkzeug ausw�hlen und Transformationen an Ihren Kacheln durchf�hren.

![Werkzeugleiste](imgs/Tools_EN.png)
*(Bild: Eine Nahaufnahme der Werkzeugleiste.)*

* **Bearbeitungswerkzeuge**: Zeiger, Stift, F�lleimer, Pipette, Farb-Ersetzer, Zoom und Verschieben. Jedes wird in Abschnitt 5 detailliert erkl�rt.
* **Transformationsschaltfl�chen**: Horizontal spiegeln (`H`), Vertikal spiegeln (`V`) und Drehen (`R`). Diese gelten f�r eine Auswahl von Kacheln oder die gesamte Ansicht, wenn nichts ausgew�hlt ist.
* **Verschiebungsschaltfl�chen**: Die Pfeiltasten verschieben die Pixel innerhalb jeder Kachel der Auswahl (oder der gesamten Ansicht) um ein Pixel in die gew�hlte Richtung.

### Palettenansichten

Tile Bulinator verwendet ein zweistufiges Palettensystem f�r maximale Flexibilit�t.

* **Master-Palette** (rechtes Panel): Zeigt die vollst�ndige 256-Farben-Master-Palette. Sie k�nnen diese Palette aus der ROM (siehe **Men� Palette**) oder einer externen Datei laden. Ein Klick auf diese Palette w�hlt eine Unterpalette zur Bearbeitung aus.
    ![Master-Palette](imgs/MasterPalette_EN.png)
    *(Bild: Eine Nahaufnahme des Master-Paletten-Panels.)*
* **Aktive Palette** (linkes Panel): Dies ist die Unterpalette, die aktuell zum Zeichnen verwendet wird. Ihre Gr��e wird durch die Bits-pro-Pixel des ausgew�hlten Codecs bestimmt (z.B. verwendet ein 4bpp-Codec eine 16-Farben-Aktiv-Palette). Ein Klick auf eine Farbe hier w�hlt sie zum Zeichnen aus. Ein Rechtsklick auf eine Farbe erm�glicht es Ihnen, sie zu bearbeiten.
    ![Aktive Palette](imgs/ActivePalette_EN.png)
    *(Bild: Eine Nahaufnahme des Panels der aktiven Palette.)*

### Der Kachel-Viewer

Dies ist die Hauptleinwand, auf der die dekodierten Kacheln angezeigt und bearbeitet werden.
![Der Kachel-Viewer](imgs/TileViewer_EN.png)
*(Bild: Eine Nahaufnahme des Kachel-Viewer-Panels.)*

* **Navigation**: Verwenden Sie die vertikale Bildlaufleiste, um sich Kachel f�r Kachel durch die Datei zu bewegen, und die horizontale Bildlaufleiste f�r eine fein abgestimmte Verschiebung auf Byte-Ebene. Sie k�nnen auch das Mausrad verwenden, um vertikal zu scrollen.
* **Zoomen**: Der schnellste Weg zum Zoomen ist, **Strg** gedr�ckt zu halten und das **Mausrad** zu verwenden.
* **Gitter**: Sie k�nnen ein 8x8-Kachelgitter und ein 1x1-Pixelgitter f�r eine pr�zise Bearbeitung �ber das Men� **Ansicht** umschalten. Das Pixelgitter ist nur bei h�heren Zoomstufen sichtbar.

## 5. Die Bearbeitungswerkzeuge im Detail

Hier erfahren Sie, wie Sie jedes Werkzeug aus der Werkzeugleiste verwenden.

* ![](imgs/Tools_Pointer.png) **Zeiger-Werkzeug**: Klicken und ziehen Sie, um einen rechteckigen Block von Kacheln auszuw�hlen. Die Auswahl kann dann f�r Transformationen, Ausschneide-/Kopiervorg�nge oder den Export verwendet werden.
* ![](imgs/Tools_Pencil.png) **Stift-Werkzeug**: Klicken Sie auf ein Pixel, um mit der aktuell ausgew�hlten Farbe aus der Aktiven Palette zu zeichnen. Sie k�nnen auch klicken und ziehen, um kontinuierlich zu zeichnen.
    > **K�rzel**: Halten Sie **Strg** gedr�ckt, w�hrend dieses Werkzeug aktiv ist, um vor�bergehend zur **Pipette** zu wechseln.
* ![](imgs/Tools_Bucket.png) **F�lleimer-Werkzeug**:
    * **Normaler Klick**: F�hrt eine "globale F�llung" durch. Es findet alle Pixel der angeklickten Farbe, die �ber den *gesamten sichtbaren Kachelbereich* verbunden sind, und ersetzt sie durch die aktive Farbe.
    * **Strg + Klick**: F�hrt eine "lokale F�llung" durch. Die F�llung ist auf die einzelne 8x8-Kachel beschr�nkt, auf die Sie geklickt haben.
* ![](imgs/Tools_Eyedropper.png) **Pipetten-Werkzeug**: Klicken Sie auf ein beliebiges Pixel im Kachel-Viewer, um dessen Farbe auszuw�hlen und sie zur aktiven Farbe in den Palettenansichten zu machen.
* ![](imgs/Tools_Replacer.png) **Farb-Ersetzer-Werkzeug**: Ersetzt eine Farbe durch eine andere. Klicken Sie auf ein Pixel; seine Farbe wird zur "Zielfarbe", und alle Vorkommen davon werden durch die aktuell aktive Zeichenfarbe ersetzt.
    > **K�rzel**: Halten Sie **Umschalt** gedr�ckt, w�hrend Sie klicken, um die Ersetzung *nur innerhalb der aktuellen Auswahl* durchzuf�hren.
* ![](imgs/Tools_Move.png) **Verschieben-Werkzeug**: Erm�glicht es Ihnen, eine Auswahl von Kacheln zu verschieben.
    1.  Erstellen Sie zuerst eine Auswahl mit dem **Zeiger-Werkzeug**.
    2.  W�hlen Sie das **Verschieben-Werkzeug**.
    3.  Klicken Sie *innerhalb* der Auswahl und ziehen Sie sie an einen neuen Ort.
    4.  Lassen Sie die Maustaste los, um die Kacheln an der neuen Position abzulegen.
* ![](imgs/Tools_Zoom.png) **Zoom-Werkzeug**:
    * **Linksklick** auf den Kachel-Viewer zum Vergr��ern (Zoom in).
    * **Rechtsklick** zum Verkleinern (Zoom out).

## 6. Men�referenz

### Men� Datei

* **�ffnen**: �ffnet eine oder mehrere ROM-Dateien.
* **Zuletzt ge�ffnet**: Eine Liste der zuletzt ge�ffneten Dateien f�r den schnellen Zugriff.
* **Speichern**: Speichert die �nderungen an der aktuellen ROM-Datei.
* **Speichern unter...**: Speichert die aktuelle ROM-Datei an einem neuen Ort.
* **Alles speichern**: Speichert alle ge�nderten Dateien, die derzeit ge�ffnet sind.
* **Schlie�en**: Schlie�t die aktuelle Registerkarte. Fordert zum Speichern auf, wenn nicht gespeicherte �nderungen vorhanden sind.
* **Alles schlie�en**: Versucht, alle ge�ffneten Registerkarten zu schlie�en.
* **Beenden**: Schlie�t die Anwendung.

### Men� Bearbeiten

* **R�ckg�ngig/Wiederholen**: Standardm��ige R�ckg�ngig/Wiederholen-Funktionalit�t f�r Ihre Bearbeitungen.
* **Ausschneiden/Kopieren/Einf�gen**: Kopiert und f�gt Bl�cke ausgew�hlter Kacheldaten ein.
* **Als PNG exportieren**: Exportiert die aktuelle Kachelauswahl als `.png`-Bilddatei.
* **Aus PNG importieren**: Importiert eine `.png`-Datei. Das Bild wird unter Verwendung der aktuell aktiven Palette konvertiert und an der Position der Auswahl eingef�gt.
* **Gehe zu...**: �ffnet den Dialog "Gehe zu Offset", um zu einer bestimmten Adresse in der Datei zu springen.

### Men� Ansicht

* **Kachel-Gitter**: Schaltet die Sichtbarkeit des 8x8-Kachel-Gitters um.
* **Pixel-Gitter**: Schaltet die Sichtbarkeit des 1x1-Pixel-Gitters um.

### Men� Palette

* **Master-Palette aus ROM laden...**: Fordert einen Offset an und versucht dann, eine 256-Farben-Palette von dieser Adresse in der ROM unter Verwendung des ausgew�hlten Palettenformats zu laden.
* **Master-Palette aus Datei laden...**: L�dt eine Master-Palette aus einer externen Datei (z.B. einer `.pal`-Datei).
* **Aktive Palette aus Datei laden...**: L�dt eine kleine Palette direkt aus einer `.tbpal`-Datei in die Ansicht der aktiven Palette.
* **Aktive Palette speichern...**: Speichert die aktuelle aktive Palette in einer `.tbpal`-Datei.

### Men� Projekt

* **Neues Projekt**: Schlie�t alle Dateien und startet eine neue, leere Projektsitzung.
* **Projekt �ffnen...**: �ffnet eine `.tbproj`-Datei und stellt alle gespeicherten Dateien und deren Einstellungen wieder her.
* **Zuletzt ge�ffnetes Projekt**: Eine Liste der zuletzt ge�ffneten Projekte.
* **Projekt speichern / Projekt speichern unter...**: Speichert den aktuellen Zustand aller ge�ffneten Registerkarten und deren Einstellungen in einer `.tbproj`-Datei.
* **Projekt schlie�en**: Schlie�t das aktuelle Projekt (funktional identisch mit Neues Projekt).

### Men� Einstellungen

* **Einstellungen...**: �ffnet den Einstellungsdialog der Anwendung, in dem Sie die Sprache, Standardansichten und das Erscheinungsbild der Auswahl �ndern k�nnen.

## 7. Tastatur- und Maus-K�rzel

| Aktion | K�rzel | Kontext |
| :--- | :--- | :--- |
| Zoom | `Strg` + `Mausrad` | Im Kachel-Viewer |
| Vertikales Scrollen | `Mausrad` | Im Kachel-Viewer |
| Tempor�re Pipette | `Strg` + `Klick` | Wenn das Stift-Werkzeug aktiv ist |
| Lokale Kachelf�llung | `Strg` + `Klick` | Wenn das F�lleimer-Werkzeug aktiv ist |
| In Auswahl ersetzen | `Umschalt` + `Klick` | Wenn der Farb-Ersetzer aktiv ist |
| Aktive Farbe bearbeiten | `Rechtsklick` auf eine Farbe | In der Ansicht der aktiven Palette |

---
*Dieses Handbuch wurde von einer KI auf Basis des Quellcodes der Anwendung generiert. Alle Funktionen k�nnen sich �ndern.*