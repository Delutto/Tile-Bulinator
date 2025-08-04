unit uAboutForm;

interface

uses
   Winapi.Windows, Winapi.Messages, ShellAPI,
   System.SysUtils, System.Variants, System.Classes,
   Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
   uLocalization, uSettings, Vcl.Imaging.pngimage;

type
   TAboutForm = class(TForm)
      imgLogo: TImage;
      lblAppName: TLabel;
      lblVersion: TLabel;
      lblCopyright: TLabel;
      btnOK: TButton;
      memDescription: TMemo;
      lblGitHub: TLinkLabel;
      procedure FormCreate(Sender: TObject);
    procedure lblGitHubLinkClick(Sender: TObject; const Link: string; LinkType: TSysLinkType);
   private
      { Private declarations }
   public
      { Public declarations }
   end;

var
   AboutForm: TAboutForm;

implementation

{$R *.dfm}

function GetAppVersion: string;
var
  VerSize: DWORD;
  VerHandle: DWORD;
  VerBuf: Pointer;
  VerValue: PVSFixedFileInfo;
  VerLen: UINT;
begin
   Result := '';
   VerSize := GetFileVersionInfoSize(PChar(ParamStr(0)), VerHandle);
   if VerSize = 0 then
      Exit;

   GetMem(VerBuf, VerSize);
   try
      if GetFileVersionInfo(PChar(ParamStr(0)), 0, VerSize, VerBuf) then
      begin
         if VerQueryValue(VerBuf, '\', Pointer(VerValue), VerLen) then
         begin
            Result := Format( '%d.%d.%d.%d',
                              [HiWord(VerValue.dwFileVersionMS),
                              LoWord(VerValue.dwFileVersionMS),
                              HiWord(VerValue.dwFileVersionLS),
                              LoWord(VerValue.dwFileVersionLS)]);
         end;
      end;
   finally
      FreeMem(VerBuf);
   end;
end;

procedure TAboutForm.FormCreate(Sender: TObject);
begin
   // Carrega o idioma e traduz os componentes do formulário.
   LOC.LoadLanguage(GSettings.LanguageFile);
   LOC.TranslateComponent(Self);

   // Workaround for form caption
   Self.Caption := LOC.Get('TAboutForm', 'AboutForm_Caption');

   // Popula os labels com as constantes globais.
   lblAppName.Caption := 'Tile Bulinator';
   lblVersion.Caption := LOC.Get('TAboutForm', 'lblVersion_Caption', 'Version') + ' ' + GetAppVersion;
   lblCopyright.Caption := 'Copyright © 2025 Delutto';

   // Popula a descrição a partir do arquivo de localização.
   memDescription.Text := LOC.Get('TAboutForm', 'memDescription_Text', '');
end;

procedure TAboutForm.lblGitHubLinkClick(Sender: TObject; const Link: string; LinkType: TSysLinkType);
begin
   ShellExecute(Application.Handle, 'open', PWideChar(Trim(Link)), nil, nil, 0);
end;

end.
