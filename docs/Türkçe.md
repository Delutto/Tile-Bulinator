# Tile Bulinator - Kullanici Kilavuzu

**Tile Bulinator**'in resmi Kullanici Kilavuzu'na hos geldiniz. Bu kilavuz, uygulamanin t�m �zellikleri ve islevleri hakkinda ayrintili bir yol haritasi sunmaktadir.

## I�indekiler
1.  [Giris](#1-introduction)
2.  [Ana Aray�z](#2-the-main-interface)
3.  [Baslarken: Dosyalar ve Projeler](#3-getting-started-files--projects)
    * [Bir ROM Dosyasi A�ma](#opening-a-rom-file)
    * [Projelerle �alisma](#working-with-projects)
4.  [Belge G�r�n�m�](#4-the-document-view)
    * [Kontrol Paneli](#controls-panel)
    * [Ara�lar Paneli](#tools-panel)
    * [Palet G�r�n�mleri](#palette-views)
    * [D�seme G�r�nt�leyici](#the-tile-viewer)
5.  [D�zenleme Ara�lari Detayli Anlatim](#5-editing-tools-in-detail)
6.  [Men� Referansi](#6-menu-reference)
    * [Dosya Men�s�](#file-menu)
    * [D�zen Men�s�](#edit-menu)
    * [G�r�n�m Men�s�](#view-menu)
    * [Palet Men�s�](#palette-menu)
    * [Proje Men�s�](#project-menu)
    * [Ayarlar Men�s�](#settings-menu)
7.  [Klavye ve Fare Kisayollari](#7-keyboard--mouse-shortcuts)

---

## 1. Giris

**Tile Bulinator**, klasik konsol ROM'larinda bulunan ham grafik verilerini g�r�nt�lemek ve degistirmek i�in tasarlanmis gelismis bir d�seme (tile) grafik d�zenleyicisidir. ROM hacker'lari ve retro oyun meraklilarinin oyun varliklarini dogrudan kesfetmeleri ve degistirmeleri i�in g��l� ve sezgisel bir aray�z saglar.

Bu kilavuz, temel dosya g�r�nt�lemeden gelismis grafik d�zenleme ve palet y�netimine kadar g��l� �zellikleri boyunca size rehberlik edecektir.

## 2. Ana Aray�z

Ana pencere birka� ana alana ayrilmistir:

![Ana Aray�z Genel Bakis](imgs/MainInterface_EN.png)
*(Resim: Anahtar alanlari vurgulanmis ana uygulama penceresinin bir ekran g�r�nt�s�.)*

* **Ana Men�**: �stte yer alir ve dosya islemleri, d�zenleme komutlari ve g�r�n�m ayarlari gibi t�m uygulama islevlerine erisim saglar.
* **Belge Alani**: ROM dosyalarinin sekmeler halinde a�ildigi pencerenin merkezi kismidir. Her sekme bagimsiz bir belge g�r�n�m�n� temsil eder.
* **Durum �ubugu**: Altta yer alir ve a�ik dosyanin tam yolu, imlecin altindaki adres ve koordinatlar ve mevcut yakinlastirma seviyesi gibi �nemli bilgileri g�r�nt�ler.

## 3. Baslarken: Dosyalar ve Projeler

### Bir ROM Dosyasi A�ma

Baslamak i�in bir ROM dosyasi a�maniz gerekir.
1.  Ana men�den **Dosya > A�**'a gidin.
2.  Bilgisayarinizdan bir veya daha fazla ROM dosyasi se�in.
3.  Se�ilen her dosya, Belge Alani'nda yeni bir sekmede a�ilacaktir.

Bir dosya a�ildiginda, t�m d�zenleme islemleri i�in ana �alisma alani olan bir **Belge G�r�n�m�**'ne y�klenir.

### Projelerle �alisma

Bir **Proje (`.tbproj`)** t�m �alisma alani oturumunuzu kaydeder. Bu, birden fazla dosyayla �alistiginiz veya �ok �zel g�r�n�m ayarlarina sahip oldugunuz karmasik hack'ler i�in inanilmaz derecede kullanislidir.

Bir proje dosyasi sunlari saklar:
* A�ik olan t�m ROM dosyalarinin listesi.
* Her dosya i�in �zel ayarlar: codec, palet, yakinlastirma, kaydirma konumu vb.
* �zerinde �alistiginiz aktif sekme.

Projeleri **Proje** men�s�n� kullanarak y�netebilirsiniz. Mevcut oturumunuzu kaydetmek i�in **Proje > Projeyi Kaydet**'i ve daha sonra geri y�klemek i�in **Proje > Projeyi A�**'i kullanin.

## 4. Belge G�r�n�m�

Her sekme, t�m sihrin ger�eklestigi bir Belge G�r�n�m� i�erir. Bu g�r�n�m kendi kendine yeterlidir ve o anda g�r�nt�lenen dosya i�in t�m ayarlari tutar.

![Belge G�r�n�m�](imgs/DocumentView_EN.png)
*(Resim: �esitli panelleri vurgulanmis tek bir belge sekmesinin ekran g�r�nt�s�.)*

### Kontrol Paneli

Bu panel, ROM'dan gelen ham verilerin nasil yorumlanacagini ve g�r�nt�lenecegini tanimlamaniza olanak tanir.

* **Codec**: Bu en �nemli ayardir. Bir codec (Kodlayici-Kod ��z�c�'n�n kisaltmasi), programa ROM'un ham baytlarini piksellere nasil �evirecegini s�yler. Farkli konsollar grafikleri farkli sekillerde saklar (�r. d�zlemsel, dogrusal). D�zenlediginiz oyun i�in dogru codec'i se�melisiniz. Liste, SNES i�in `4bpp planar, composite (2x2bpp)` veya Game Boy i�in `2bpp planar` gibi formatlari i�erir.
* **Satir/S�tun Basina D�seme**: Bu d�nd�rme kutulari, d�seme g�r�nt�leyicinin boyutlarini kontrol ederek, d�semeleri g�r�nt�lediginiz veriler i�in anlamli bir sekilde d�zenlemenize olanak tanir.
* **Palet Formati**: ROM'dan veya harici dosyalardan palet y�klemek i�in renk formatini se�er (�r. `15-bit BGR (5-5-5)` SNES/GBA i�in yaygindir).

### Ara�lar Paneli

Burada aktif d�zenleme aracinizi se�ebilir ve d�semeleriniz �zerinde d�n�s�mler ger�eklestirebilirsiniz.

![Ara�lar Paneli](imgs/Tools_EN.png)
*(Resim: Ara�lar panelinin yakin �ekimi.)*

* **D�zenleme Ara�lari**: Isaret�i, Kalem, Boya Kovasi, Damlalik, Renk Degistirici, Yakinlastirma ve Tasima. Her biri b�l�m 5'te ayrintili olarak a�iklanmistir.
* **D�n�s�m D�gmeleri**: Yatay �evir (`H`), Dikey �evir (`V`) ve D�nd�r (`R`). Bunlar bir d�seme se�imine veya hi�bir sey se�ilmemisse t�m g�r�n�me uygulanir.
* **Kaydirma D�gmeleri**: Ok d�gmeleri, se�imdeki (veya t�m g�r�n�mdeki) her d�semenin i�indeki pikselleri se�ilen y�nde bir piksel kaydirir.

### Palet G�r�n�mleri

Tile Bulinator, maksimum esneklik i�in iki seviyeli bir palet sistemi kullanir.

* **Ana Palet** (sag panel): Tam 256 renkli ana paleti g�sterir. Bu paleti ROM'dan (**Palet Men�s�**'ne bakin) veya harici bir dosyadan y�kleyebilirsiniz. Bu palete tiklamak, d�zenleme i�in kullanilacak bir alt palet se�er.
    ![Ana Palet](imgs/MasterPalette_EN.png)
    *(Resim: Ana Palet panelinin yakin �ekimi.)*
* **Aktif Palet** (sol panel): Bu, su anda �izim i�in kullanilan alt palettir. Boyutu, se�ilen codec'in piksel basina bit sayisina g�re belirlenir (�r. 4bpp bir codec 16 renkli bir aktif palet kullanacaktir). Buradaki bir renge tiklamak, onu �izim i�in se�er. Bir renge sag tiklamak, onu d�zenlemenizi saglar.
    ![Aktif Palet](imgs/ActivePalette_EN.png)
    *(Resim: Aktif Palet panelinin yakin �ekimi.)*

### D�seme G�r�nt�leyici

Burasi, kodlari ��z�lm�s d�semelerin g�r�nt�lendigi ve d�zenlendigi ana tuvaldir.
![D�seme G�r�nt�leyici](imgs/TileViewer_EN.png)
*(Resim: D�seme G�r�nt�leyici panelinin yakin �ekimi.)*

* **Gezinme**: Dosya i�inde d�seme d�seme ilerlemek i�in dikey kaydirma �ubugunu ve ince ayarli, bayt seviyesinde kaydirma i�in yatay kaydirma �ubugunu kullanin. Dikey olarak kaydirmak i�in fare tekerlegini de kullanabilirsiniz.
* **Yakinlastirma**: Yakinlastirmanin en hizli yolu **Ctrl** tusunu basili tutup **Fare Tekerlegini** kullanmaktir.
* **Izgaralar**: **G�r�n�m** men�s� araciligiyla hassas d�zenleme i�in 8x8 d�seme izgarasini ve 1x1 piksel izgarasini a�ip kapatabilirsiniz. Piksel izgarasi yalnizca daha y�ksek yakinlastirma seviyelerinde g�r�n�r.

## 5. D�zenleme Ara�lari Detayli Anlatim

Iste Ara�lar Paneli'ndeki her bir aracin nasil kullanilacagi.

* ![](imgs/Tools_Pointer.png) **Isaret�i Araci**: Dikd�rtgen bir d�seme blogu se�mek i�in tiklayin ve s�r�kleyin. Se�im daha sonra d�n�s�mler, kes/kopyala islemleri veya disa aktarma i�in kullanilabilir.
* ![](imgs/Tools_Pencil.png) **Kalem Araci**: Aktif Palet'ten o an se�ili olan renkle �izmek i�in bir piksele tiklayin. S�rekli �izmek i�in tiklayip s�r�kleyebilirsiniz.
    > **Kisayol**: Bu ara� etkinken **Ctrl** tusunu basili tutarak ge�ici olarak **Damlalik**'a ge�in.
* ![](imgs/Tools_Bucket.png) **Boya Kovasi Araci**:
    * **Normal Tiklama**: "Genel doldurma" yapar. Tiklanan rengin *g�r�n�r t�m d�seme alani boyunca* bagli olan t�m piksellerini bulur ve bunlari aktif renkle degistirir.
    * **Ctrl + Tiklama**: "Yerel doldurma" yapar. Doldurma, tikladiginiz tek 8x8 d�semeyle sinirlidir.
* ![](imgs/Tools_Eyedropper.png) **Damlalik Araci**: Rengini se�mek ve palet g�r�n�mlerinde aktif renk yapmak i�in d�seme g�r�nt�leyicideki herhangi bir piksele tiklayin.
* ![](imgs/Tools_Replacer.png) **Renk Degistirici Araci**: Bir rengi digeriyle degistirir. Bir piksele tiklayin; rengi "hedef" renk olur ve t�m �rnekleri o anki aktif �izim rengiyle degistirilir.
    > **Kisayol**: Degistirme islemini *yalnizca mevcut se�im i�inde* ger�eklestirmek i�in tiklarken **Shift** tusunu basili tutun.
* ![](imgs/Tools_Move.png) **Tasima Araci**: Bir d�seme se�imini tasimaniza olanak tanir.
    1.  �nce **Isaret�i Araci** ile bir se�im olusturun.
    2.  **Tasima Araci**'ni se�in.
    3.  Se�imin *i�ine* tiklayin ve yeni bir konuma s�r�kleyin.
    4.  D�semeleri yeni konumuna birakmak i�in fare d�gmesini serbest birakin.
* ![](imgs/Tools_Zoom.png) **Yakinlastirma Araci**:
    * **Sol tiklama** ile d�seme g�r�nt�leyicide yakinlastirin.
    * **Sag tiklama** ile uzaklastirin.

## 6. Men� Referansi

### Dosya Men�s�

* **A�**: Bir veya daha fazla ROM dosyasi a�ar.
* **Son Kullanilanlari A�**: Hizli erisim i�in son a�ilan dosyalarin bir listesi.
* **Kaydet**: Degisiklikleri mevcut ROM dosyasina kaydeder.
* **Farkli Kaydet...**: Mevcut ROM dosyasini yeni bir konuma kaydeder.
* **T�m�n� Kaydet**: O anda a�ik olan t�m degistirilmis dosyalari kaydeder.
* **Kapat**: Mevcut sekmeyi kapatir. Kaydedilmemis degisiklikler varsa kaydetmek i�in sorar.
* **T�m�n� Kapat**: A�ik olan t�m sekmeleri kapatmaya �alisir.
* **�ikis**: Uygulamayi kapatir.

### D�zen Men�s�

* **Geri Al/Yinele**: D�zenlemeleriniz i�in standart geri alma/yineleme islevselligi.
* **Kes/Kopyala/Yapistir**: Se�ilen d�seme veri bloklarini kopyalar ve yapistirir.
* **PNG olarak Disa Aktar**: Mevcut d�seme se�imini bir `.png` resim dosyasi olarak disa aktarir.
* **PNG'den I�e Aktar**: Bir `.png` dosyasini i�e aktarir. G�r�nt�, o anki aktif palet kullanilarak d�n�st�r�l�r ve se�imin konumuna yapistirilir.
* **Git...**: Dosyada belirli bir adrese atlamak i�in "Adrese Git" iletisim kutusunu a�ar.

### G�r�n�m Men�s�

* **D�seme Izgarasi**: 8x8 d�seme izgarasinin g�r�n�rl�g�n� a�ar/kapatir.
* **Piksel Izgarasi**: 1x1 piksel izgarasinin g�r�n�rl�g�n� a�ar/kapatir.

### Palet Men�s�

* **ROM'dan Ana Palet Y�kle...**: Bir adres ister, ardindan se�ilen Palet Formatini kullanarak ROM'daki o adresten 256 renkli bir palet y�klemeye �alisir.
* **Dosyadan Ana Palet Y�kle...**: Harici bir dosyadan (�r. bir `.pal` dosyasi) bir ana palet y�kler.
* **Dosyadan Aktif Palet Y�kle...**: Bir `.tbpal` dosyasindan dogrudan Aktif Palet g�r�n�m�ne k���k bir palet y�kler.
* **Aktif Paleti Kaydet...**: Mevcut Aktif Paleti bir `.tbpal` dosyasina kaydeder.

### Proje Men�s�

* **Yeni Proje**: T�m dosyalari kapatir ve yeni, bos bir proje oturumu baslatir.
* **Proje A�...**: Bir `.tbproj` dosyasi a�arak kaydedilmis t�m dosyalari ve ayarlarini geri y�kler.
* **Son Projeyi A�**: Son a�ilan projelerin bir listesi.
* **Projeyi Kaydet / Projeyi Farkli Kaydet...**: A�ik olan t�m sekmelerin ve ayarlarinin mevcut durumunu bir `.tbproj` dosyasina kaydeder.
* **Projeyi Kapat**: Mevcut projeyi kapatir (islevsel olarak Yeni Proje ile aynidir).

### Ayarlar Men�s�

* **Ayarlar...**: Dil, varsayilan g�r�n�mler ve se�im g�r�n�m�n� degistirebileceginiz uygulama ayarlari iletisim kutusunu a�ar.

## 7. Klavye ve Fare Kisayollari

| Eylem | Kisayol | Baglam |
| :--- | :--- | :--- |
| Yakinlastirma | `Ctrl` + `Fare Tekerlegi` | D�seme G�r�nt�leyicide |
| Dikey Kaydirma | `Fare Tekerlegi` | D�seme G�r�nt�leyicide |
| Ge�ici Damlalik | `Ctrl` + `Tiklama` | Kalem Araci etkinken |
| Yerel D�seme Doldurma | `Ctrl` + `Tiklama` | Boya Kovasi Araci etkinken |
| Se�im I�inde Degistir | `Shift` + `Tiklama` | Renk Degistirici etkinken |
| Aktif Rengi D�zenle | Bir renge `Sag tiklama` | Aktif Palet G�r�n�m�nde |

---
*Bu kilavuz, uygulama kaynak koduna dayali olarak AI tarafindan olusturulmustur. T�m �zellikler degisebilir.*