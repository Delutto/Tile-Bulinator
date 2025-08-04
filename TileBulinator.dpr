program TileBulinator;

uses
  Vcl.Forms,
  uLocalization in 'uLocalization.pas',
  uTileCodecs in 'uTileCodecs.pas',
  uCodecManager in 'uCodecManager.pas',
  uMainForm in 'uMainForm.pas' {MainForm},
  uColorCodecs in 'uColorCodecs.pas',
  Vcl.Themes,
  Vcl.Styles,
  uDocumentFrame in 'uDocumentFrame.pas' {DocumentFrame: TFrame},
  GoToForm in 'GoToForm.pas' {GoToForm},
  UndoSystem in 'UndoSystem.pas',
  uProject in 'uProject.pas',
  uSettings in 'uSettings.pas',
  uSettingsForm in 'uSettingsForm.pas' {SettingsForm},
  uAboutForm in 'uAboutForm.pas' {AboutForm};

{$R *.res}

begin
   Application.Initialize;
   Application.MainFormOnTaskbar := True;
   Application.Title := 'Tile Bulinator 0.9.1 by Delutto';
   TStyleManager.TrySetStyle('Carbon');
   Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TSettingsForm, SettingsForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.Run;

end.
