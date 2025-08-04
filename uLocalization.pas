{***********************************************************************************}
{                                                                                   }
{   Unit: uLocalization                                                             }
{   Project: Tile Bulinator                                                         }
{   Description: Provides a centralized system for managing and applying            }
{                multi-language translations from INI files.                        }
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
unit uLocalization;

interface

uses
   System.SysUtils, System.Classes, System.IniFiles, System.TypInfo,
   Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Menus;

type
   TLocalizationManager = class
   private
      FTranslations: TIniFile;
      FCurrentLanguage: String;
      // Helper function to find the owner Form or Frame of a component
      function GetOwnerFormOrFrameName(AComponent: TComponent): String;
   public
      constructor Create;
      destructor Destroy; override;
      procedure LoadLanguage(const LanguageFileName: String);
      function Get(const Section, Key: String; const Default: String = ''): String;
      procedure TranslateComponent(Component: TComponent);
   end;

var
   LOC: TLocalizationManager;

implementation

{ TLocalizationManager }
constructor TLocalizationManager.Create;
begin
   inherited;

   FTranslations := nil;
   FCurrentLanguage := 'English'; // Default language
end;

destructor TLocalizationManager.Destroy;
begin
   FTranslations.Free;

   inherited;
end;

procedure TLocalizationManager.LoadLanguage(const LanguageFileName: string);
var
   IniPath: string;
begin
   IniPath := ExtractFilePath(ParamStr(0)) + 'data\lang\' + LanguageFileName + '.ini';
   if Assigned(FTranslations) then
      FTranslations.Free;

   if FileExists(IniPath) then
   begin
      FTranslations := TIniFile.Create(IniPath);
      FCurrentLanguage := LanguageFileName;
   end
   else
   begin
      FTranslations := TIniFile.Create(''); // Create an empty object to avoid nil checks
      FCurrentLanguage := 'English';
   end;
end;

function TLocalizationManager.Get(const Section, Key: string; const Default: string = ''): string;
begin
   if Assigned(FTranslations) then
      Result := FTranslations.ReadString(Section, Key, Default)
   else
      Result := Default;
   Result := StringReplace(Result, '\n', sLineBreak, [rfReplaceAll]);
end;

function TLocalizationManager.GetOwnerFormOrFrameName(AComponent: TComponent): String;
var
   OwnerComponent: TComponent;
begin
   OwnerComponent := AComponent;
   while Assigned(OwnerComponent) do
   begin
      // Check if the component is a Form or a Frame
      if (OwnerComponent is TCustomForm) or (OwnerComponent is TFrame) then
         Exit(OwnerComponent.ClassName);
      // Move up in the ownership chain
      OwnerComponent := OwnerComponent.Owner;
   end;
   Result := ''; // Return empty if no owner form/frame is found
end;

procedure TLocalizationManager.TranslateComponent(Component: TComponent);
var
   i: Integer;
   SectionName, DefaultValue, NewValue: string;
begin
   if not Assigned(Component) or not Assigned(FTranslations) then
      Exit;

   SectionName := GetOwnerFormOrFrameName(Component);
   // If we couldn't find an owner form/frame (e.g. for the Application component), use the component's own class name as a fallback.
   if SectionName = '' then
      SectionName := Component.ClassName;

   // Translate 'Caption' property using RTTI
   if IsPublishedProp(Component, 'Caption') and (GetPropInfo(Component, 'Caption').PropType^.Kind = tkUString) then
   begin
      DefaultValue := GetStrProp(Component, 'Caption');
      NewValue := Get(SectionName, Component.Name + '_Caption', DefaultValue);
      if NewValue <> DefaultValue then
         SetStrProp(Component, 'Caption', NewValue);
   end;

   // Translate 'Hint' property using RTTI
   if IsPublishedProp(Component, 'Hint') and (GetPropInfo(Component, 'Hint').PropType^.Kind = tkUString) then
   begin
      DefaultValue := GetStrProp(Component, 'Hint');
      NewValue := Get(SectionName, Component.Name + '_Hint', DefaultValue);
      if NewValue <> DefaultValue then
         SetStrProp(Component, 'Hint', NewValue);
   end;

   // Translate 'Title' property (for Dialogs) using RTTI
   if IsPublishedProp(Component, 'Title') and (GetPropInfo(Component, 'Title').PropType^.Kind = tkUString) then
   begin
      DefaultValue := GetStrProp(Component, 'Title');
      NewValue := Get(SectionName, Component.Name + '_Title', DefaultValue);
      if NewValue <> DefaultValue then
         SetStrProp(Component, 'Title', NewValue);
   end;

   // Translate Items property
   if (Component is TCustomComboBox) then
   begin
      for i := 0 to (Component as TCustomComboBox).Items.Count - 1 do
         (Component as TCustomComboBox).Items[i] := Get(SectionName, Component.Name + '_Item' + IntToStr(i), (Component as TCustomComboBox).Items[i]);
   end
   else if (Component is TRadioGroup) then
   begin
      for i := 0 to (Component as TRadioGroup).Items.Count - 1 do
         (Component as TRadioGroup).Items[i] := Get(SectionName, Component.Name + '_Item' + IntToStr(i), (Component as TRadioGroup).Items[i]);
   end;

   // Recursively translate child components
   for i := 0 to Component.ComponentCount - 1 do
      TranslateComponent(Component.Components[i]);

   // Specific case for Main Menu items and their children
   if (Component is TMenuItem) then
   begin
      for i := 0 to (Component as TMenuItem).Count - 1 do
         TranslateComponent((Component as TMenuItem).Items[i]);
   end
   // Check the main menu of a form
   else if (Component is TForm) and Assigned((Component as TForm).Menu) then
   begin
      for i := 0 to (Component as TForm).Menu.Items.Count - 1 do
         TranslateComponent((Component as TForm).Menu.Items[i]);
   end;
end;

initialization
   LOC := TLocalizationManager.Create;

finalization
   LOC.Free;

end.
