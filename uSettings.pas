{***********************************************************************************}
{                                                                                   }
{   Unit: uSettings                                                                 }
{   Project: Tile Bulinator                                                         }
{   Description: Provides a centralized class for managing, loading, and            }
{                saving all application settings from an INI file.                  }
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
unit uSettings;

interface

uses
   System.SysUtils, System.Classes, System.IniFiles, Vcl.Graphics, Vcl.Forms;

type
   // TSettingsManager is a singleton class that holds all user-configurable settings.
   // It is responsible for loading them from and saving them to a configuration file.
   TSettingsManager = class
   private
      FIniFile: TIniFile;     // The object for reading/writing the .cfg file.
      procedure SetDefaults;  // Sets the initial, hardcoded default values.
      procedure LoadSettings; // Loads settings from the file, overriding defaults.
   public
      // General Settings
      LanguageFile: String;
      DefaultCodecID: String;
      DefaultPaletteFormat: Integer;
      MaxRecentFiles: Integer;

      // Appearance Settings
      DefaultWindowState: TWindowState;
      DefaultSelectionBorderColor: TColor;
      DefaultSelectionBorderWidth: Integer;
      DefaultSelectionFillColor: TColor;
      DefaultSelectionFillStyle: TBrushStyle;

      // Control Settings
      DefaultTilesPerRow: Integer;
      DefaultTilesPerColumn: Integer;
      DefaultZoom: Integer;

      constructor Create;
      destructor Destroy; override;

      // Manually saves the current settings to the file.
      procedure SaveSettings;
   end;

var
   GSettings: TSettingsManager; // Global singleton instance, accessible from anywhere in the application.

implementation

{ TSettingsManager }

// Constructor for the settings manager.
constructor TSettingsManager.Create;
begin
   inherited;

   // Creates the INI file object, pointing to Settings.cfg in the 'data' subdirectory.
   FIniFile := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'data\Settings.cfg');
   // Establishes the hardcoded default values first.
   SetDefaults;
   // Loads any saved settings from the file, overriding the defaults if they exist.
   LoadSettings;
end;

// Destructor for the settings manager.
destructor TSettingsManager.Destroy;
begin
   SaveSettings; // Saves the current settings when the application closes.
   FIniFile.Free;

   inherited;
end;

// Sets the application's default values. These are used if the settings file or a specific key is not found.
procedure TSettingsManager.SetDefaults;
begin
   // General
   LanguageFile := 'English';
   DefaultCodecID := 'CP02'; // 4bpp planar, composite (2x2bpp)
   DefaultPaletteFormat := 0; // 15-bit BGR (5-5-5)
   MaxRecentFiles := 10;

   // Appearance
   DefaultWindowState := wsNormal;
   DefaultSelectionBorderColor := clBlue;
   DefaultSelectionBorderWidth := 1;
   DefaultSelectionFillColor := clHighlight;
   DefaultSelectionFillStyle := bsDiagCross;

   // Controls
   DefaultTilesPerRow := 16;
   DefaultTilesPerColumn := 16;
   DefaultZoom := 4;
end;

// Loads settings from the .cfg file.
procedure TSettingsManager.LoadSettings;
begin
   // General section
   LanguageFile := FIniFile.ReadString('General', 'Language', LanguageFile);
   DefaultCodecID := FIniFile.ReadString('General', 'DefaultCodec', DefaultCodecID);
   DefaultPaletteFormat := FIniFile.ReadInteger('General', 'DefaultPaletteFormat', DefaultPaletteFormat);
   MaxRecentFiles := FIniFile.ReadInteger('General', 'MaxRecentFiles', MaxRecentFiles);

   // Appearance section
   DefaultWindowState := TWindowState(FIniFile.ReadInteger('Appearance', 'DefaultWindowState', Ord(DefaultWindowState)));
   DefaultSelectionBorderColor := TColor(FIniFile.ReadInteger('Appearance', 'DefaultSelectionBorderColor', Integer(DefaultSelectionBorderColor)));
   DefaultSelectionBorderWidth := FIniFile.ReadInteger('Appearance', 'DefaultSelectionBorderWidth', DefaultSelectionBorderWidth);
   DefaultSelectionFillColor := TColor(FIniFile.ReadInteger('Appearance', 'DefaultSelectionFillColor', Integer(DefaultSelectionFillColor)));
   DefaultSelectionFillStyle := TBrushStyle(FIniFile.ReadInteger('Appearance', 'DefaultSelectionFillStyle', Ord(DefaultSelectionFillStyle)));

   // Controls section
   DefaultTilesPerRow := FIniFile.ReadInteger('Controls', 'DefaultTilesPerRow', DefaultTilesPerRow);
   DefaultTilesPerColumn := FIniFile.ReadInteger('Controls', 'DefaultTilesPerColumn', DefaultTilesPerColumn);
   DefaultZoom := FIniFile.ReadInteger('Controls', 'DefaultZoom', DefaultZoom);
end;

// Writes the current settings from the properties back to the .cfg file.
procedure TSettingsManager.SaveSettings;
begin
   // General section
   FIniFile.WriteString('General', 'Language', LanguageFile);
   FIniFile.WriteString('General', 'DefaultCodec', DefaultCodecID);
   FIniFile.WriteInteger('General', 'DefaultPaletteFormat', DefaultPaletteFormat);
   FIniFile.WriteInteger('General', 'MaxRecentFiles', MaxRecentFiles);

   // Appearance section
   FIniFile.WriteInteger('Appearance', 'DefaultWindowState', Ord(DefaultWindowState));
   FIniFile.WriteInteger('Appearance', 'DefaultSelectionBorderColor', Integer(DefaultSelectionBorderColor));
   FIniFile.WriteInteger('Appearance', 'DefaultSelectionBorderWidth', DefaultSelectionBorderWidth);
   FIniFile.WriteInteger('Appearance', 'DefaultSelectionFillColor', Integer(DefaultSelectionFillColor));
   FIniFile.WriteInteger('Appearance', 'DefaultSelectionFillStyle', Ord(DefaultSelectionFillStyle));

   // Controls section
   FIniFile.WriteInteger('Controls', 'DefaultTilesPerRow', DefaultTilesPerRow);
   FIniFile.WriteInteger('Controls', 'DefaultTilesPerColumn', DefaultTilesPerColumn);
   FIniFile.WriteInteger('Controls', 'DefaultZoom', DefaultZoom);
end;

// This block ensures the global GSettings object is created when the app starts...
initialization
   GSettings := TSettingsManager.Create;

// ...and destroyed when the app closes.
finalization
   GSettings.Free;

end.
