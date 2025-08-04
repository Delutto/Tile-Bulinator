# Tile Bulinator - L�mhleabhar �s�ideora

F�ilte go dt� an L�mhleabhar �s�ideora oifigi�il le haghaidh **Tile Bulinator**. Sol�thra�onn an treoir seo si�l tr�d mionsonraithe ar ghn�ithe agus ar fheidhmi�lachta� uile an fheidhmchl�ir.

## Cl�r na n�bhar
1.  [R�amhr�](#1-introduction)
2.  [An Pr�omh-Chomh�adan](#2-the-main-interface)
3.  [Ag Tos�: Comhaid & Tionscadail](#3-getting-started-files--projects)
    * [Comhad ROM a Oscailt](#opening-a-rom-file)
    * [Ag Obair le Tionscadail](#working-with-projects)
4.  [Amharc an Doicim�id](#4-the-document-view)
    * [Pain�al na Rialuithe](#controls-panel)
    * [Pain�al na nUirlis�](#tools-panel)
    * [Amhairc na bPail�ad](#palette-views)
    * [Amharc�n na dT�leanna](#the-tile-viewer)
5.  [Uirlis� Eagarth�ireachta go Mion](#5-editing-tools-in-detail)
6.  [Tagairt na Roghchl�r](#6-menu-reference)
    * [An Roghchl�r 'Comhad'](#file-menu)
    * [An Roghchl�r 'Eagar'](#edit-menu)
    * [An Roghchl�r 'Amharc'](#view-menu)
    * [An Roghchl�r 'Pail�ad'](#palette-menu)
    * [An Roghchl�r 'Tionscadal'](#project-menu)
    * [An Roghchl�r 'Socruithe'](#settings-menu)
7.  [Aicearra� M�archl�ir & Luiche](#7-keyboard--mouse-shortcuts)

---

## 1. R�amhr�

Is eagarth�ir grafaic� t�leanna casta � **Tile Bulinator** at� deartha chun sonra� grafaic� amha a fhaightear i ROManna cons�l clasaiceach a fheice�il agus a mhodhn�. Sol�thra�onn s� comh�adan cumhachtach agus iomasach do hace�laithe ROM agus do dh�ograiseoir� cluich� retro chun s�cmhainn� cluiche a fhiosr� agus a athr� go d�reach.

Tabharfaidh an l�mhleabhar seo treoir duit tr�na ghn�ithe cumhachtacha, � amharc bun�sach ar chomhaid go heagarth�ireacht ghrafaice chun cinn agus bainist�ocht pail�ad.

## 2. An Pr�omh-Chomh�adan

T� an phr�omhfhuinneog roinnte i roinnt pr�omhr�ims�:

![Forbhreathn� ar an bPr�omh-Chomh�adan](imgs/MainInterface_EN.png)
*(�omh�: Gabh�il sc�ile�in de phr�omhfhuinneog an fheidhmchl�ir le pr�omhr�ims� aibhsithe.)*

* **An Pr�omh-Roghchl�r**: Suite ag an mbarr, sol�thra�onn s� rochtain ar fheidhmeanna uile an fheidhmchl�ir, mar shampla oibr�ochta� comhaid, orduithe eagarth�ireachta, agus socruithe amhairc.
* **Limist�ar na nDoicim�ad**: Cuid l�rnach na fuinneoige ina n-oscla�tear comhaid ROM i gcluais�n�. L�ir�onn gach cluais�n amharc neamhsple�ch doicim�id.
* **An Barra St�dais**: Suite ag an mbun, taispe�nann s� faisn�is th�bhachtach mar chonair ioml�n an chomhaid oscailte, an seoladh agus na comhordan�id� faoin gc�rs�ir, agus an leibh�al z�m�la reatha.

## 3. Ag Tos�: Comhaid & Tionscadail

### Comhad ROM a Oscailt

Chun t�s a chur leis, n� m�r duit comhad ROM a oscailt.
1.  T�igh go **Comhad > Oscail** sa phr�omh-roghchl�r.
2.  Roghnaigh comhad ROM amh�in n� n�os m� � do r�omhaire.
3.  Oscl�far gach comhad roghnaithe i gcluais�n nua i Limist�ar na nDoicim�ad.

Nuair a oscla�tear comhad, l�d�iltear � isteach in **Amharc an Doicim�id**, arb � an pr�omh-sp�s oibre � don eagarth�ireacht ar fad.

### Ag Obair le Tionscadail

S�bh�lann **Tionscadal (`.tbproj`)** do sheisi�n oibre ioml�n. T� s� seo thar a bheith �s�ideach le haghaidh haceanna casta ina bhfuil t� ag obair le comhaid iolracha n� ina bhfuil socruithe amhairc an-sonrach agat.

St�r�lann comhad tionscadail:
* Liosta na gcomhad ROM go l�ir at� oscailte.
* Na socruithe sonracha do gach comhad: codec, pail�ad, z�m�il, su�omh scrollaigh, srl.
* An cluais�n gn�omhach a raibh t� ag obair air.

Is f�idir leat tionscadail a bhainisti� ag baint �s�ide as an roghchl�r **Tionscadal**. �s�id **Tionscadal > S�bh�il Tionscadal** chun do sheisi�n reatha a sh�bh�il agus **Tionscadal > Oscail Tionscadal** chun � a athbhun� n�os d�ana�.

## 4. Amharc an Doicim�id

T� Amharc an Doicim�id i ngach cluais�n, �it a dtarla�onn an dra�ocht ar fad. T� an t-amharc seo f�inchuimsitheach agus coinn�onn s� na socruithe go l�ir don chomhad at� � thaispe�int faoi l�thair.

![Amharc an Doicim�id](imgs/DocumentView_EN.png)
*(�omh�: Gabh�il sc�ile�in de chluais�n doicim�id aonair lena phain�il �ags�la aibhsithe.)*

### Pain�al na Rialuithe

Ligeann an pain�al seo duit sainmh�ni� a dh�anamh ar an gcaoi a nd�antar na sonra� amha �n ROM a l�irmh�ni� agus a thaispe�int.

* **Codec**: Seo an socr� is t�bhachta�. Ins�onn codec (giorr�ch�n ar Ionch�d�ir-D�ch�d�ir) don chl�r conas bearta amha an ROM a aistri� go picteil�n�. St�r�lann cons�il �ags�la grafaic� ar bheala� �ags�la (m.sh., pl�nach, l�neach). Caithfidh t� an codec ceart a roghn� don chluiche at� � chur in eagar agat. �ir�tear ar an liosta form�id� mar `4bpp planar, composite (2x2bpp)` don SNES n� `2bpp planar` don Game Boy.
* **T�leanna in aghaidh an R�/an Chol�in**: Riala�onn na bosca� casadh seo tois� an amharc�in t�leanna, rud a ligeann duit na t�leanna a shocr� ar bhealach a bhfuil ciall leis do na sonra� at� � bhfeice�il agat.
* **Form�id an Phail�id**: Roghna�onn s� an fhorm�id datha chun pail�id a lucht� �n ROM n� � chomhaid sheachtracha (m.sh., t� `15-bit BGR (5-5-5)` coitianta don SNES/GBA).

### Pain�al na nUirlis�

Anseo is f�idir leat d'uirlis eagarth�ireachta gn�omhach a roghn� agus claochluithe a dh�anamh ar do th�leanna.

![Pain�al na nUirlis�](imgs/Tools_EN.png)
*(�omh�: Gar-amharc ar phain�al na nUirlis�.)*

* **Uirlis� Eagarth�ireachta**: Pointeoir, Peann luaidhe, Buic�ad L�onta, Silead�ir, Ionada� Datha, Z�m�il, agus Bog. M�n�tear gach ceann acu go mion i roinn 5.
* **Cnaip� Claochlaithe**: Smeach go Cothrom�nach (`H`), Smeach go Ceartingearach (`V`), agus Rothlaigh (`R`). Baineann siad seo le roghn� t�leanna, n� leis an amharc ioml�n mura bhfuil aon rud roghnaithe.
* **Cnaip� Aistrithe**: Aistr�onn na cnaip� saighde na picteil�n� laistigh de gach t�l den roghn� (n� an t-amharc ioml�n) picteil�n amh�in sa treo roghnaithe.

### Amhairc na bPail�ad

�s�ideann Tile Bulinator c�ras pail�ad dh� leibh�al don tsol�bthacht is m�.

* **An Mh�istir-Phail�ad** (pain�al ar dheis): Taispe�nann s� an mh�istir-phail�ad ioml�n 256-dath. Is f�idir leat an pail�ad seo a l�d�il �n ROM (f�ach **An Roghchl�r 'Pail�ad'**) n� � chomhad seachtrach. M� chlice�lann t� ar an bpail�ad seo, roghna�tear fo-phail�ad le h�s�id le haghaidh eagarth�ireachta.
    ![An Mh�istir-Phail�ad](imgs/MasterPalette_EN.png)
    *(�omh�: Gar-amharc ar phain�al na M�istir-Phail�ide.)*
* **An Pail�ad Gn�omhach** (pain�al ar chl�): Seo an fo-phail�ad at� � �s�id faoi l�thair le haghaidh l�n�ochta. Cinntear a mh�id de r�ir ghiot�in-in aghaidh-an-phicteil�n an codec roghnaithe (m.sh., �s�idfidh codec 4bpp pail�ad gn�omhach 16-dath). M� chlice�lann t� ar dhath anseo, roghna�tear � le haghaidh l�n�ochta. Ligeann clice�il ar dheis ar dhath duit � a chur in eagar.
    ![An Pail�ad Gn�omhach](imgs/ActivePalette_EN.png)
    *(�omh�: Gar-amharc ar phain�al an Phail�id Ghn�omhaigh.)*

### Amharc�n na dT�leanna

Seo an pr�omhchanbh�s ina dtaispe�ntar agus ina gcuirtear na t�leanna d�ch�daithe in eagar.
![Amharc�n na dT�leanna](imgs/TileViewer_EN.png)
*(�omh�: Gar-amharc ar phain�al Amharc�n na dT�leanna.)*

* **Nasclean�int**: �s�id an barra scrollaigh ceartingearach chun bogadh tr�d an gcomhad t�l ar th�l, agus an barra scrollaigh cothrom�nach le haghaidh frith�ireamh beacht ar leibh�al an bhirt. Is f�idir leat roth na luiche a �s�id freisin chun scroll� go ceartingearach.
* **Z�m�il**: Is � an bealach is tap�la chun z�m�il n� **Ctrl** a choinne�il s�os agus **Roth na Luiche** a �s�id.
* **Eanga�**: Is f�idir leat eangach t�leanna 8x8 agus eangach picteil�n� 1x1 a scor�n� le haghaidh eagarth�ireacht bheacht tr�d an roghchl�r **Amharc**. N�l an eangach picteil�n� le feice�il ach amh�in ag leibh�il z�m�la n�os airde.

## 5. Uirlis� Eagarth�ireachta go Mion

Seo mar a �s�idtear gach uirlis � Phain�al na nUirlis�.

* ![](imgs/Tools_Pointer.png) **An tUirlis Pointeora**: Clice�il agus tarraing chun bloc dronuilleogach t�leanna a roghn�. Is f�idir an roghn� a �s�id ansin le haghaidh claochluithe, oibr�ochta� gearrtha/c�ipe�la, n� easp�rt�la.
* ![](imgs/Tools_Pencil.png) **An tUirlis Pinn Luaidhe**: Clice�il ar phicteil�n chun l�n�ocht a dh�anamh leis an dath at� roghnaithe faoi l�thair �n bPail�ad Gn�omhach. Is f�idir leat clice�il agus tarraingt freisin chun l�n�ocht a dh�anamh go lean�nach.
    > **Aicearra**: Coinnigh **Ctrl** s�os agus an uirlis seo gn�omhach chun aistri� go sealadach chuig an **Silead�ir**.
* ![](imgs/Tools_Bucket.png) **An tUirlis Buic�id L�onta**:
    * **Gn�thchlice�il**: D�anann s� "l�onadh domhanda". Faigheann s� gach picteil�n den dath clice�ilte at� nasctha ar fud an *limist�ir t�leanna infheicthe ioml�in* agus cuireann s� an dath gn�omhach ina n-ionad.
    * **Ctrl + Clice�il**: D�anann s� "l�onadh �iti�il". T� an l�onadh teoranta don t�l aonair 8x8 ar chlice�il t� air.
* ![](imgs/Tools_Eyedropper.png) **An tUirlis Silead�ra**: Clice�il ar aon phicteil�n san amharc�n t�leanna chun a dhath a roghn� agus � a dh�anamh mar an dath gn�omhach sna hamhairc pail�ad.
* ![](imgs/Tools_Replacer.png) **An tUirlis Ionada� Datha**: Cuireann s� dath eile in ionad datha. Clice�il ar phicteil�n; d�antar a dhath mar an dath "sprioc", agus cuirtear an dath l�n�ochta gn�omhach reatha in ionad gach c�s de.
    > **Aicearra**: Coinnigh **Shift** s�os agus t� ag clice�il chun an t-ionad� a dh�anamh *laistigh den roghn� reatha amh�in*.
* ![](imgs/Tools_Move.png) **An tUirlis Bogtha**: Ligeann s� duit roghn� t�leanna a bhogadh.
    1.  Ar dt�s, cruthaigh roghn� leis an **Uirlis Pointeora**.
    2.  Roghnaigh an **Uirlis Bogtha**.
    3.  Clice�il *laistigh* den roghn� agus tarraing go su�omh nua �.
    4.  Scaoil cnaipe na luiche chun na t�leanna a ligean anuas sa su�omh nua.
* ![](imgs/Tools_Zoom.png) **An tUirlis Z�m�la**:
    * **Clice�il ar chl�** ar an amharc�n t�leanna chun z�m�il isteach.
    * **Clice�il ar dheis** chun z�m�il amach.

## 6. Tagairt na Roghchl�r

### An Roghchl�r 'Comhad'

* **Oscail**: Oscla�onn s� comhad ROM amh�in n� n�os m�.
* **Oscail le D�ana�**: Liosta de na comhaid a oscla�odh le d�ana� le haghaidh rochtain thapa.
* **S�bh�il**: S�bh�lann s� na hathruithe ar an gcomhad ROM reatha.
* **S�bh�il Mar...**: S�bh�lann s� an comhad ROM reatha go su�omh nua.
* **S�bh�il Gach Rud**: S�bh�lann s� gach comhad modhnaithe at� oscailte faoi l�thair.
* **D�n**: D�nann s� an cluais�n reatha. Iarrfaidh s� ort s�bh�il m� t� athruithe neamhsh�bh�ilte ann.
* **D�n Gach Rud**: D�anann s� iarracht na cluais�n� oscailte go l�ir a dh�nadh.
* **Scoir**: D�nann s� an feidhmchl�r.

### An Roghchl�r 'Eagar'

* **Cealaigh/Athdh�an**: Feidhmi�lacht chaighde�nach cealaithe/athdh�anta do d'eagarth�ireacht.
* **Gearr/C�ipe�il/Greamaigh**: C�ipe�lann agus greama�onn s� bloic de shonra� t�leanna roghnaithe.
* **Easp�rt�il go PNG**: Easp�rt�lann s� an roghn� t�leanna reatha mar chomhad �omh� `.png`.
* **Iomp�rt�il � PNG**: Iomp�rt�lann s� comhad `.png`. D�antar an �omh� a thiont� ag baint �s�ide as an bpail�ad gn�omhach reatha agus greama�tear � ag su�omh an roghnaithe.
* **T�igh go...**: Oscla�onn s� an dial�g "T�igh go Frith�ireamh" chun l�im go seoladh sonrach sa chomhad.

### An Roghchl�r 'Amharc'

* **Eangach T�leanna**: Scor�na�onn s� infheictheacht na heanga� t�leanna 8x8.
* **Eangach Picteil�n�**: Scor�na�onn s� infheictheacht na heanga� picteil�n� 1x1.

### An Roghchl�r 'Pail�ad'

* **Luchtaigh an Mh�istir-Phail�ad �n ROM...**: Iarrann s� frith�ireamh, ansin d�anann s� iarracht pail�ad 256-dath a l�d�il �n seoladh sin sa ROM ag baint �s�ide as an bhForm�id Pail�id roghnaithe.
* **Luchtaigh an Mh�istir-Phail�ad � Chomhad...**: Luchta�onn s� m�istir-phail�ad � chomhad seachtrach (m.sh., comhad `.pal`).
* **Luchtaigh an Pail�ad Gn�omhach � Chomhad...**: Luchta�onn s� pail�ad beag go d�reach isteach san amharc Pail�ad Gn�omhach � chomhad `.tbpal`.
* **S�bh�il an Pail�ad Gn�omhach...**: S�bh�lann s� an Pail�ad Gn�omhach reatha go comhad `.tbpal`.

### An Roghchl�r 'Tionscadal'

* **Tionscadal Nua**: D�nann s� gach comhad agus tosa�onn s� seisi�n tionscadail nua, folamh.
* **Oscail Tionscadal...**: Oscla�onn s� comhad `.tbproj`, ag athbhun� na gcomhad s�bh�ilte go l�ir agus a gcuid socruithe.
* **Oscail Tionscadal le D�ana�**: Liosta de na tionscadail a oscla�odh le d�ana�.
* **S�bh�il Tionscadal / S�bh�il Tionscadal Mar...**: S�bh�lann s� staid reatha na gcluais�n� oscailte go l�ir agus a gcuid socruithe i gcomhad `.tbproj`.
* **D�n Tionscadal**: D�nann s� an tionscadal reatha (feidhmi�il mar an gc�anna le Tionscadal Nua).

### An Roghchl�r 'Socruithe'

* **Socruithe...**: Oscla�onn s� dial�g socruithe an fheidhmchl�ir, �it ar f�idir leat an teanga, na hamhairc r�amhshocraithe, agus cuma an roghnaithe a athr�.

## 7. Aicearra� M�archl�ir & Luiche

| Gn�omh | Aicearra | Comhth�acs |
| :--- | :--- | :--- |
| Z�m�il | `Ctrl` + `Roth na Luiche` | In Amharc�n na dT�leanna |
| Scroll� Ceartingearach | `Roth na Luiche` | In Amharc�n na dT�leanna |
| Silead�ir Sealadach | `Ctrl` + `Clice�il` | Nuair at� an Uirlis Pinn Luaidhe gn�omhach |
| L�onadh T�le �iti�il | `Ctrl` + `Clice�il` | Nuair at� an Uirlis Buic�id L�onta gn�omhach |
| Ionadaigh sa Roghn� | `Shift` + `Clice�il` | Nuair at� an tIonada� Datha gn�omhach |
| Cuir an Dath Gn�omhach in Eagar | `Clice�il ar dheis` ar dhath | In Amharc an Phail�id Ghn�omhaigh |

---
*Ghintear an l�mhleabhar seo le AI bunaithe ar ch�d foinse an fheidhmchl�ir. T� gach gn� faoi r�ir athraithe.*