# Tile Bulinator - Manuel de l'utilisateur

Bienvenue dans le manuel de l'utilisateur officiel de **Tile Bulinator**. Ce guide fournit une pr�sentation d�taill�e de toutes les fonctionnalit�s de l'application.

## Table des mati�res
1.  [Introduction](#1-introduction)
2.  [L'interface principale](#2-the-main-interface)
3.  [Pour commencer : Fichiers et Projets](#3-getting-started-files--projects)
    * [Ouvrir un fichier ROM](#opening-a-rom-file)
    * [Travailler avec des projets](#working-with-projects)
4.  [La vue de document](#4-the-document-view)
    * [Panneau de contr�les](#controls-panel)
    * [Panneau d'outils](#tools-panel)
    * [Vues de la palette](#palette-views)
    * [Le visualiseur de tuiles](#the-tile-viewer)
5.  [Les outils d'�dition en d�tail](#5-editing-tools-in-detail)
6.  [R�f�rence des menus](#6-menu-reference)
    * [Menu Fichier](#file-menu)
    * [Menu �dition](#edit-menu)
    * [Menu Affichage](#view-menu)
    * [Menu Palette](#palette-menu)
    * [Menu Projet](#project-menu)
    * [Menu Param�tres](#settings-menu)
7.  [Raccourcis clavier et souris](#7-keyboard--mouse-shortcuts)

---

## 1. Introduction

**Tile Bulinator** est un �diteur de graphiques de tuiles (tiles) avanc�, con�u pour visualiser et modifier les donn�es graphiques brutes trouv�es dans les ROM de consoles classiques. Il fournit une interface puissante et intuitive pour les hackers de ROM et les passionn�s de jeux r�tro afin d'explorer et de modifier directement les ressources du jeu.

Ce manuel vous guidera � travers ses fonctionnalit�s puissantes, de la visualisation de base des fichiers � l'�dition graphique avanc�e et � la gestion des palettes.

## 2. L'interface principale

La fen�tre principale est divis�e en plusieurs zones cl�s :

![Aper�u de l'interface principale](imgs/MainInterface_EN.png)
*(Image : Une capture d'�cran de la fen�tre principale de l'application avec les zones cl�s mises en �vidence.)*

* **Menu principal** : Situ� en haut, il donne acc�s � toutes les fonctions de l'application, telles que les op�rations sur les fichiers, les commandes d'�dition et les param�tres d'affichage.
* **Zone de document** : La partie centrale de la fen�tre o� les fichiers ROM sont ouverts dans des onglets. Chaque onglet repr�sente une vue de document ind�pendante.
* **Barre d'�tat** : Situ�e en bas, elle affiche des informations importantes comme le chemin complet du fichier ouvert, l'adresse et les coordonn�es sous le curseur, et le niveau de zoom actuel.

## 3. Pour commencer : Fichiers et Projets

### Ouvrir un fichier ROM

Pour commencer, vous devez ouvrir un fichier ROM.
1.  Allez dans **Fichier > Ouvrir** dans le menu principal.
2.  S�lectionnez un ou plusieurs fichiers ROM sur votre ordinateur.
3.  Chaque fichier s�lectionn� s'ouvrira dans un nouvel onglet dans la zone de document.

Lorsqu'un fichier est ouvert, il est charg� dans une **Vue de document**, qui est l'espace de travail principal pour toute l'�dition.

### Travailler avec des projets

Un **Projet (`.tbproj`)** enregistre l'ensemble de votre session de travail. C'est incroyablement utile pour les hacks complexes o� vous travaillez avec plusieurs fichiers ou avez des param�tres de vue tr�s sp�cifiques.

Un fichier de projet stocke :
* La liste de tous les fichiers ROM ouverts.
* Les param�tres sp�cifiques pour chaque fichier : codec, palette, zoom, position de d�filement, etc.
* L'onglet actif sur lequel vous travailliez.

Vous pouvez g�rer les projets � l'aide du menu **Projet**. Utilisez **Projet > Enregistrer le projet** pour enregistrer votre session en cours et **Projet > Ouvrir le projet** pour la restaurer plus tard.

## 4. La vue de document

Chaque onglet contient une Vue de document, c'est l� que toute la magie op�re. Cette vue est autonome et contient tous les param�tres du fichier actuellement affich�.

![La vue de document](imgs/DocumentView_EN.png)
*(Image : Une capture d'�cran d'un seul onglet de document avec ses diff�rents panneaux mis en �vidence.)*

### Panneau de contr�les

Ce panneau vous permet de d�finir comment les donn�es brutes de la ROM sont interpr�t�es et affich�es.

* **Codec** : C'est le param�tre le plus important. Un codec (abr�viation de Codeur-D�codeur) indique au programme comment traduire les octets bruts de la ROM en pixels. Diff�rentes consoles stockent les graphiques de diff�rentes mani�res (par exemple, planaire, lin�aire). Vous devez s�lectionner le bon codec pour le jeu que vous modifiez. La liste comprend des formats comme `4bpp planar, composite (2x2bpp)` pour la SNES ou `2bpp planar` pour le Game Boy.
* **Tuiles par Ligne/Colonne** : Ces bo�tes de s�lection contr�lent les dimensions du visualiseur de tuiles, vous permettant d'agencer les tuiles d'une mani�re qui a du sens pour les donn�es que vous visualisez.
* **Format de la palette** : S�lectionne le format de couleur pour charger les palettes depuis la ROM ou des fichiers externes (par exemple, `15-bit BGR (5-5-5)` est courant pour la SNES/GBA).

### Panneau d'outils

Ici, vous pouvez s�lectionner votre outil d'�dition actif et effectuer des transformations sur vos tuiles.

![Panneau d'outils](imgs/Tools_EN.png)
*(Image : Un gros plan du panneau d'outils.)*

* **Outils d'�dition** : Pointeur, Crayon, Pot de peinture, Pipette, Rempla�ant de couleur, Zoom et D�placer. Chacun est expliqu� en d�tail dans la section 5.
* **Boutons de transformation** : Retourner Horizontalement (`H`), Retourner Verticalement (`V`) et Pivoter (`R`). Ceux-ci s'appliquent � une s�lection de tuiles, ou � l'ensemble de la vue si rien n'est s�lectionn�.
* **Boutons de d�calage** : Les boutons fl�ch�s d�calent les pixels � l'int�rieur de chaque tuile de la s�lection (ou de l'ensemble de la vue) d'un pixel dans la direction choisie.

### Vues de la palette

Tile Bulinator utilise un syst�me de palette � deux niveaux pour une flexibilit� maximale.

* **Palette ma�tresse** (panneau de droite) : Affiche la palette ma�tresse compl�te de 256 couleurs. Vous pouvez charger cette palette depuis la ROM (voir **Menu Palette**) ou un fichier externe. Cliquer sur cette palette s�lectionne une sous-palette � utiliser pour l'�dition.
    ![Palette ma�tresse](imgs/MasterPalette_EN.png)
    *(Image : Un gros plan du panneau de la Palette ma�tresse.)*
* **Palette active** (panneau de gauche) : C'est la sous-palette actuellement utilis�e pour le dessin. Sa taille est d�termin�e par les bits par pixel du codec s�lectionn� (par exemple, un codec 4bpp utilisera une palette active de 16 couleurs). Cliquer sur une couleur ici la s�lectionne pour le dessin. Un clic droit sur une couleur vous permet de la modifier.
    ![Palette active](imgs/ActivePalette_EN.png)
    *(Image : Un gros plan du panneau de la Palette active.)*

### Le visualiseur de tuiles

C'est la toile principale o� les tuiles d�cod�es sont affich�es et modifi�es.
![Le visualiseur de tuiles](imgs/TileViewer_EN.png)
*(Image : Un gros plan du panneau du Visualiseur de tuiles.)*

* **Navigation** : Utilisez la barre de d�filement verticale pour vous d�placer dans le fichier tuile par tuile, et la barre de d�filement horizontale pour un d�calage pr�cis au niveau de l'octet. Vous pouvez �galement utiliser la molette de la souris pour faire d�filer verticalement.
* **Zoom** : Le moyen le plus rapide de zoomer est de maintenir **Ctrl** et d'utiliser la **Molette de la souris**.
* **Grilles** : Vous pouvez basculer une grille de tuiles de 8x8 et une grille de pixels de 1x1 pour une �dition pr�cise via le menu **Affichage**. La grille de pixels n'est visible qu'� des niveaux de zoom plus �lev�s.

## 5. Les outils d'�dition en d�tail

Voici comment utiliser chaque outil du panneau d'outils.

* ![](imgs/Tools_Pointer.png) **Outil Pointeur** : Cliquez et faites glisser pour s�lectionner un bloc rectangulaire de tuiles. La s�lection peut ensuite �tre utilis�e pour des transformations, des op�rations de couper/copier ou d'exportation.
* ![](imgs/Tools_Pencil.png) **Outil Crayon** : Cliquez sur un pixel pour dessiner avec la couleur actuellement s�lectionn�e dans la palette active. Vous pouvez �galement cliquer et faire glisser pour dessiner en continu.
    > **Raccourci** : Maintenez **Ctrl** pendant que cet outil est actif pour passer temporairement � la **Pipette**.
* ![](imgs/Tools_Bucket.png) **Outil Pot de peinture** :
    * **Clic normal** : Effectue un "remplissage global". Il trouve tous les pixels de la couleur cliqu�e qui sont connect�s sur *l'ensemble de la zone de tuiles visible* et les remplace par la couleur active.
    * **Ctrl + Clic** : Effectue un "remplissage local". Le remplissage est limit� � la seule tuile de 8x8 sur laquelle vous avez cliqu�.
* ![](imgs/Tools_Eyedropper.png) **Outil Pipette** : Cliquez sur n'importe quel pixel dans le visualiseur de tuiles pour s�lectionner sa couleur et en faire la couleur active dans les vues de la palette.
* ![](imgs/Tools_Replacer.png) **Outil Rempla�ant de couleur** : Remplace une couleur par une autre. Cliquez sur un pixel ; sa couleur devient la couleur "cible", et toutes ses instances sont remplac�es par la couleur de dessin actuellement active.
    > **Raccourci** : Maintenez **Maj** en cliquant pour effectuer le remplacement *uniquement dans la s�lection actuelle*.
* ![](imgs/Tools_Move.png) **Outil D�placer** : Vous permet de d�placer une s�lection de tuiles.
    1.  D'abord, cr�ez une s�lection avec l'**Outil Pointeur**.
    2.  S�lectionnez l'**Outil D�placer**.
    3.  Cliquez *� l'int�rieur* de la s�lection et faites-la glisser vers un nouvel emplacement.
    4.  Rel�chez le bouton de la souris pour d�poser les tuiles dans la nouvelle position.
* ![](imgs/Tools_Zoom.png) **Outil Zoom** :
    * **Clic gauche** sur le visualiseur de tuiles pour zoomer en avant.
    * **Clic droit** pour zoomer en arri�re.

## 6. R�f�rence des menus

### Menu Fichier

* **Ouvrir** : Ouvre un ou plusieurs fichiers ROM.
* **Ouvrir r�cent** : Une liste des fichiers r�cemment ouverts pour un acc�s rapide.
* **Enregistrer** : Enregistre les modifications apport�es au fichier ROM actuel.
* **Enregistrer sous...** : Enregistre le fichier ROM actuel dans un nouvel emplacement.
* **Tout enregistrer** : Enregistre tous les fichiers modifi�s actuellement ouverts.
* **Fermer** : Ferme l'onglet actuel. Demandera d'enregistrer s'il y a des modifications non enregistr�es.
* **Tout fermer** : Tente de fermer tous les onglets ouverts.
* **Quitter** : Ferme l'application.

### Menu �dition

* **Annuler/R�tablir** : Fonctionnalit� standard d'annulation/r�tablissement pour vos modifications.
* **Couper/Copier/Coller** : Copie et colle des blocs de donn�es de tuiles s�lectionn�es.
* **Exporter en PNG** : Exporte la s�lection de tuiles actuelle sous forme de fichier image `.png`.
* **Importer depuis PNG** : Importe un fichier `.png`. L'image est convertie � l'aide de la palette active actuelle et coll�e � l'emplacement de la s�lection.
* **Aller �...** : Ouvre la bo�te de dialogue "Aller � l'offset" pour sauter � une adresse sp�cifique dans le fichier.

### Menu Affichage

* **Grille de tuiles** : Active/d�sactive la visibilit� de la grille de tuiles 8x8.
* **Grille de pixels** : Active/d�sactive la visibilit� de la grille de pixels 1x1.

### Menu Palette

* **Charger la palette ma�tresse depuis la ROM...** : Demande un offset, puis tente de charger une palette de 256 couleurs � partir de cette adresse dans la ROM en utilisant le format de palette s�lectionn�.
* **Charger la palette ma�tresse depuis un fichier...** : Charge une palette ma�tresse � partir d'un fichier externe (par exemple, un fichier `.pal`).
* **Charger la palette active depuis un fichier...** : Charge une petite palette directement dans la vue de la palette active � partir d'un fichier `.tbpal`.
* **Enregistrer la palette active...** : Enregistre la palette active actuelle dans un fichier `.tbpal`.

### Menu Projet

* **Nouveau projet** : Ferme tous les fichiers ? d�marre une nouvelle session de projet vide.
* **Ouvrir le projet...** : Ouvre un fichier `.tbproj`, restaurant tous les fichiers enregistr�s et leurs param�tres.
* **Ouvrir un projet r�cent** : Une liste des projets r�cemment ouverts.
* **Enregistrer le projet / Enregistrer le projet sous...** : Enregistre l'�tat actuel de tous les onglets ouverts et leurs param�tres dans un fichier `.tbproj`.
* **Fermer le projet** : Ferme le projet actuel (fonctionnellement identique � Nouveau projet).

### Menu Param�tres

* **Param�tres...** : Ouvre la bo�te de dialogue des param�tres de l'application, o� vous pouvez changer la langue, les vues par d�faut et l'apparence de la s�lection.

## 7. Raccourcis clavier et souris

| Action | Raccourci | Contexte |
| :--- | :--- | :--- |
| Zoom | `Ctrl` + `Molette de la souris` | Dans le visualiseur de tuiles |
| D�filement vertical | `Molette de la souris` | Dans le visualiseur de tuiles |
| Pipette temporaire | `Ctrl` + `Clic` | Lorsque l'outil Crayon est actif |
| Remplissage de tuile local | `Ctrl` + `Clic` | Lorsque l'outil Pot de peinture est actif |
| Remplacer dans la s�lection | `Maj` + `Clic` | Lorsque le Rempla�ant de couleur est actif |
| Modifier la couleur active | `Clic droit` sur une couleur | Dans la vue de la palette active |

---
*Ce manuel a �t� g�n�r� par IA sur la base du code source de l'application. Toutes les fonctionnalit�s sont sujettes � modification.*