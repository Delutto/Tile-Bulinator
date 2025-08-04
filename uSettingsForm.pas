{***********************************************************************************}
{                                                                                   }
{   Unit: uSettingsForm                                                             }
{   Project: Tile Bulinator                                                         }
{   Description: Implements the settings dialog form, allowing the user to          }
{                configure various aspects of the application. It interacts         }
{                with the global TSettingsManager to load and save settings.        }
{                                                                                   }
{***********************************************************************************}
{                                                                               		}
{   MIT License                                                                 		}
{                                                                               		}
{   Copyright (c) 2025 Delutto                              								}
{                                                                               		}
{   Permission is hereby granted, free of charge, to any person obtaining a copy 	}
{   of this software and associated documentation files (the "Software"), to deal	}
{   in the Software without restriction, including without limitation the rights 	}
{   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell    	}
{   copies of the Software, and to permit persons to whom the Software is        	}
{   furnished to do so, subject to the following conditions:                     	}
{                                                                                	}
{   The above copyright notice and this permission notice shall be included in all	}
{   copies or substantial portions of the Software.                             		}
{                                                                               		}
{   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  		}
{   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,    		}
{   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 		}
{   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER      		}
{   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 	}
{   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 	}
{   SOFTWARE.                                                                   		}
{                                                                               		}
{***********************************************************************************}
unit uSettingsForm;

interface

uses
   Winapi.Windows, Winapi.Messages,
   System.SysUtils, System.Variants, System.Classes, System.IOUtils, System.TypInfo,
   Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Samples.Spin,
   uSettings, uCodecManager, uTileCodecs, uColorCodecs, uLocalization;

type
   TSettingsForm = class(TForm)
      pgcSettings: TPageControl;
      tsGeneral: TTabSheet;
      tsAppearance: TTabSheet;
      btnOK: TButton;
      btnCancel: TButton;
      btnApply: TButton;
      lblLanguage: TLabel;
      cbxLanguage: TComboBox;
      lblDefaultCodec: TLabel;
      cbxDefaultCodec: TComboBox;
      grpSelection: TGroupBox;
      lblBorderColor: TLabel;
      clbBorderColor: TColorBox;
      lblFillColor: TLabel;
      clbFillColor: TColorBox;
      lblDefaultPaletteFormat: TLabel;
      cbxDefaultPaletteFormat: TComboBox;
      lblMaxRecentFiles: TLabel;
      seMaxRecentFiles: TSpinEdit;
      lblWindowState: TLabel;
      cbxWindowState: TComboBox;
      lblBorderWidth: TLabel;
      seBorderWidth: TSpinEdit;
      lblFillStyle: TLabel;
      cbxFillStyle: TComboBox;
      tsControls: TTabSheet;
      grpDefaultView: TGroupBox;
      lblDefaultDimension: TLabel;
      seTilesPerRow: TSpinEdit;
      lblX: TLabel;
      seTilesPerColumn: TSpinEdit;
      lblDefaultZoom: TLabel;
      seDefaultZoom: TSpinEdit;
      procedure FormCreate(Sender: TObject);
      procedure btnApplyClick(Sender: TObject);
      procedure btnOKClick(Sender: TObject);
   private
      // Loads settings from the global GSettings object into the form's controls.
      procedure LoadFormSettings;
      // Saves the values from the form's controls into the global GSettings object.
      procedure SaveFormSettings;
   public
      { Public declarations }
   end;

var
   SettingsForm: TSettingsForm;

implementation

{$R *.dfm}

// Executed when the form is first created.
procedure TSettingsForm.FormCreate(Sender: TObject);
var
   Codec: TTileCodec;
   SR: TSearchRec;
   Style: TBrushStyle;
begin
   // First, apply the current language to the settings form itself.
   LOC.LoadLanguage(GSettings.LanguageFile);
   LOC.TranslateComponent(Self);

   // Populate the Language combobox by finding all .ini files in the lang directory.
   cbxLanguage.Items.Clear;
   var LangPath := ExtractFilePath(ParamStr(0)) + 'data\lang\';
   if FindFirst(LangPath + '*.ini', faAnyFile, SR) = 0 then
   begin
      repeat
         cbxLanguage.Items.Add(TPath.GetFileNameWithoutExtension(SR.Name));
      until FindNext(SR) <> 0;
      FindClose(SR);
   end;

   // Populate the Codec combobox from the global codec manager.
   cbxDefaultCodec.Items.Clear;
   for Codec in GCodecManager.Codecs.Values do
      cbxDefaultCodec.Items.AddObject(Codec.Description, Codec);

   // Populate the Palette Format combobox (currently hardcoded).
   cbxDefaultPaletteFormat.Items.Add('15-bit BGR (5-5-5)');
   cbxDefaultPaletteFormat.Items.Add('24-bit RGB (8-8-8)');

   // Populate the Window State combobox.
   cbxWindowState.Items.Add(LOC.Get('TSettingsForm', 'wsNormal'));
   cbxWindowState.Items.Add(LOC.Get('TSettingsForm', 'wsMinimized'));
   cbxWindowState.Items.Add(LOC.Get('TSettingsForm', 'wsMaximized'));

   // Populate the Fill Style combobox dynamically.
   for Style := Low(TBrushStyle) to High(TBrushStyle) do
      cbxFillStyle.Items.Add(GetEnumName(TypeInfo(TBrushStyle), Ord(Style)));

   // Workaround for form caption
   Self.Caption := LOC.Get('TSettingsForm', 'SettingsForm_Caption');

   // Load the current settings into the UI controls.
   LoadFormSettings;
end;

// Loads all current settings from the GSettings manager into the form's UI controls.
procedure TSettingsForm.LoadFormSettings;
var
   i: Integer;
begin
   // General Tab
   cbxLanguage.ItemIndex := cbxLanguage.Items.IndexOf(GSettings.LanguageFile);
   for i := 0 to cbxDefaultCodec.Items.Count - 1 do
   begin
      if (cbxDefaultCodec.Items.Objects[i] as TTileCodec).Id = GSettings.DefaultCodecID then
      begin
         cbxDefaultCodec.ItemIndex := i;
         Break;
      end;
   end;
   cbxDefaultPaletteFormat.ItemIndex := GSettings.DefaultPaletteFormat;
   seMaxRecentFiles.Value := GSettings.MaxRecentFiles;

   // Appearance Tab
   cbxWindowState.ItemIndex := Ord(GSettings.DefaultWindowState);
   clbBorderColor.Selected := GSettings.DefaultSelectionBorderColor;
   seBorderWidth.Value := GSettings.DefaultSelectionBorderWidth;
   clbFillColor.Selected := GSettings.DefaultSelectionFillColor;
   cbxFillStyle.ItemIndex := Ord(GSettings.DefaultSelectionFillStyle);

   // Controls Tab
   seTilesPerRow.Value := GSettings.DefaultTilesPerRow;
   seTilesPerColumn.Value := GSettings.DefaultTilesPerColumn;
   seDefaultZoom.Value := GSettings.DefaultZoom;
end;

// Saves all values from the UI controls back to the GSettings manager.
procedure TSettingsForm.SaveFormSettings;
begin
   // General Tab
   if cbxLanguage.ItemIndex > -1 then
      GSettings.LanguageFile := cbxLanguage.Text;
   if cbxDefaultCodec.ItemIndex > -1 then
      GSettings.DefaultCodecID := (cbxDefaultCodec.Items.Objects[cbxDefaultCodec.ItemIndex] as TTileCodec).Id;
   if cbxDefaultPaletteFormat.ItemIndex > -1 then
      GSettings.DefaultPaletteFormat := cbxDefaultPaletteFormat.ItemIndex;
   GSettings.MaxRecentFiles := seMaxRecentFiles.Value;

   // Appearance Tab
   GSettings.DefaultWindowState := TWindowState(cbxWindowState.ItemIndex);
   GSettings.DefaultSelectionBorderColor := clbBorderColor.Selected;
   GSettings.DefaultSelectionBorderWidth := seBorderWidth.Value;
   GSettings.DefaultSelectionFillColor := clbFillColor.Selected;
   GSettings.DefaultSelectionFillStyle := TBrushStyle(cbxFillStyle.ItemIndex);

   // Controls Tab
   GSettings.DefaultTilesPerRow := seTilesPerRow.Value;
   GSettings.DefaultTilesPerColumn := seTilesPerColumn.Value;
   GSettings.DefaultZoom := seDefaultZoom.Value;

   // Persist all changes to the INI file.
   GSettings.SaveSettings;
end;

// Handles the 'Apply' button click.
procedure TSettingsForm.btnApplyClick(Sender: TObject);
begin
     SaveFormSettings;
     { TODO : Add a broadcast message to notify open windows about the settings change. }
end;

// Handles the 'OK' button click.
procedure TSettingsForm.btnOKClick(Sender: TObject);
begin
   SaveFormSettings;
end;

end.
