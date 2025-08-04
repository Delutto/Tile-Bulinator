{***********************************************************************************}
{                                                                                   }
{   Unit: uProject                                                                  }
{   Project: Tile Bulinator                                                         }
{   Description: Defines the data structures and management class for handling      }
{                project files, which store the state of an editing session.        }
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
unit uProject;

interface

uses
   System.SysUtils, System.Classes, System.Generics.Collections, System.IniFiles;

type
   // Enum to define the source of the master palette
   TPaletteSourceType = (  pstDefault,       // Default grayscale palette
                           pstRomOffset,     // Palette loaded from an offset in the ROM
                           pstExternalFile   // Palette loaded from an external file
                        );

type
   // Record to hold the state of a single open file within the project.
   TProjectFileInfo = record
      Path: String;                             // Full path to the ROM file.
      CodecID: String;                          // The unique ID of the selected tile codec.
      TilesPerRow: Integer;                     // Number of tiles in the viewer's width.
      TilesPerColumn: Integer;                  // Number of tiles in the viewer's height.
      VScrollPos: Integer;                      // The position of the vertical tile scroller.
      HScrollPos: Integer;                      // The position of the horizontal byte offset scroller.
      Zoom: Integer;                            // The current zoom level.
      IsTileGridVisible: Boolean;               // State of the tile grid visibility.
      IsPixelGridVisible: Boolean;              // State of the pixel grid visibility.
      MasterPaletteSource: TPaletteSourceType;  // The source of the master palette.
      MasterPaletteInfo: String;                // Stores ROM offset or file path for the master palette.
      ActivePaletteFile: String;                // Stores path if a custom active palette was loaded.
      ActivePaletteIndex: Integer;              // The starting index of the selected sub-palette.
      ActiveColorIndex: Integer;                // The index of the selected drawing color.
   end;

   // The main project management class.
   TProject = class
   private
      FIniFile: TIniFile; // Internal object for INI file operations.
   public
      Files: TList<TProjectFileInfo>; // A list of all open file states in the project.
      ActiveTabIndex: Integer; // The index of the tab that was active when the project was saved.

      constructor Create;
      destructor Destroy; override;

      procedure Clear; // Clears all project data.
      function LoadFromFile(const FileName: string): Boolean; // Loads project data from a specified .ini file.
      procedure SaveToFile(const FileName: string); // Saves the current project state to a specified .ini file.
   end;

implementation

{ TProject }

// Constructor for the TProject class.
constructor TProject.Create;
begin
   inherited;

   // Initialize the list to hold file information.
   Files := TList<TProjectFileInfo>.Create;
   ActiveTabIndex := -1;
   FIniFile := nil;
end;

// Destructor for the TProject class.
destructor TProject.Destroy;
begin
   Files.Free;
   FIniFile.Free;

   inherited;
end;

// Resets the project to an empty state.
procedure TProject.Clear;
begin
   Files.Clear;
   ActiveTabIndex := -1;
end;

// Loads the project state from a specified file.
function TProject.LoadFromFile(const FileName: string): Boolean;
var
   i: Integer;
   OpenFileCount: Integer;
   FileInfo: TProjectFileInfo;
begin
   Result := False;
   Clear;

   FIniFile := TIniFile.Create(FileName);
   try
      // Read general project settings.
      ActiveTabIndex := FIniFile.ReadInteger('Project', 'ActiveTab', 0);
      OpenFileCount := FIniFile.ReadInteger('Project', 'OpenFileCount', 0);

      // Loop through and read the settings for each file.
      for i := 0 to OpenFileCount - 1 do
      begin
      var Section := 'OpenFile' + IntToStr(i);
         FileInfo.Path := FIniFile.ReadString(Section, 'Path', '');
         FileInfo.CodecID := FIniFile.ReadString(Section, 'Codec', 'LN04');
         FileInfo.TilesPerRow := FIniFile.ReadInteger(Section, 'TilesPerRow', 16);
         FileInfo.TilesPerColumn := FIniFile.ReadInteger(Section, 'TilesPerColumn', 16);
         FileInfo.VScrollPos := FIniFile.ReadInteger(Section, 'VScrollPos', 0);
         FileInfo.HScrollPos := FIniFile.ReadInteger(Section, 'HScrollPos', 0);
         FileInfo.Zoom := FIniFile.ReadInteger(Section, 'Zoom', 4);
         FileInfo.IsTileGridVisible := FIniFile.ReadBool(Section, 'TileGrid', True);
         FileInfo.IsPixelGridVisible := FIniFile.ReadBool(Section, 'PixelGrid', False);
         FileInfo.MasterPaletteSource := TPaletteSourceType(FIniFile.ReadInteger(Section, 'MasterPaletteSource', Ord(pstDefault)));
         FileInfo.MasterPaletteInfo := FIniFile.ReadString(Section, 'MasterPaletteInfo', '');
         FileInfo.ActivePaletteFile := FIniFile.ReadString(Section, 'ActivePaletteFile', '');
         FileInfo.ActivePaletteIndex := FIniFile.ReadInteger(Section, 'ActivePaletteIndex', 0);
         FileInfo.ActiveColorIndex := FIniFile.ReadInteger(Section, 'ActiveColorIndex', 0);
         // Add the loaded file information to the list.
         Files.Add(FileInfo);
      end;
      Result := True;
   finally
      FIniFile.Free;
      FIniFile := nil;
   end;
end;

// Saves the current project state to a specified file.
procedure TProject.SaveToFile(const FileName: string);
var
   i: Integer;
   FileInfo: TProjectFileInfo;
begin
   FIniFile := TIniFile.Create(FileName);
   try
      // Write general project info under the [Project] section.
      FIniFile.WriteInteger('Project', 'ActiveTab', ActiveTabIndex);
      FIniFile.WriteInteger('Project', 'OpenFileCount', Files.Count);

      // Write a separate section for each open file.
      for i := 0 to Files.Count - 1 do
      begin
         var Section := 'OpenFile' + IntToStr(i);
         FileInfo := Files[i];
         FIniFile.WriteString(Section, 'Path', FileInfo.Path);
         FIniFile.WriteString(Section, 'Codec', FileInfo.CodecID);
         FIniFile.WriteInteger(Section, 'TilesPerRow', FileInfo.TilesPerRow);
         FIniFile.WriteInteger(Section, 'TilesPerColumn', FileInfo.TilesPerColumn);
         FIniFile.WriteInteger(Section, 'VScrollPos', FileInfo.VScrollPos);
         FIniFile.WriteInteger(Section, 'HScrollPos', FileInfo.HScrollPos);
         FIniFile.WriteInteger(Section, 'Zoom', FileInfo.Zoom);
         FIniFile.WriteBool(Section, 'TileGrid', FileInfo.IsTileGridVisible);
         FIniFile.WriteBool(Section, 'PixelGrid', FileInfo.IsPixelGridVisible);
         FIniFile.WriteInteger(Section, 'MasterPaletteSource', Ord(FileInfo.MasterPaletteSource));
         FIniFile.WriteString(Section, 'MasterPaletteInfo', FileInfo.MasterPaletteInfo);
         FIniFile.WriteString(Section, 'ActivePaletteFile', FileInfo.ActivePaletteFile);
         FIniFile.WriteInteger(Section, 'ActivePaletteIndex', FileInfo.ActivePaletteIndex);
         FIniFile.WriteInteger(Section, 'ActiveColorIndex', FileInfo.ActiveColorIndex);
      end;
   finally
      FIniFile.Free;
      FIniFile := nil;
   end;
end;

end.
