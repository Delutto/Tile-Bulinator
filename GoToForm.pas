{***********************************************************************************}
{                                                                                   }
{   Unit: GoToForm                                                                  }
{   Project: Tile Bulinator                                                         }
{   Description: This unit defines the "Go to Offset" dialog form. It allows        }
{                the user to input a memory offset in various formats               }
{                (hexadecimal, decimal) and modes (absolute, relative) to           }
{                navigate within the loaded file.                                   }
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
unit GoToForm;

interface

uses
   Winapi.Windows, Winapi.Messages,
   System.SysUtils, System.Variants, System.Classes,
   Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
   uLocalization, uSettings;

type
   // Defines the "Go To" dialog form.
   TGoToForm = class(TForm)
      edtOffset: TEdit;
      rgBase: TRadioGroup;
      rgMode: TRadioGroup;
      btnOK: TButton;
      btnCancel: TButton;
      lblOffset: TLabel;
      procedure edtOffsetChange(Sender: TObject); // Event handler to validate user input in real-time.
      procedure rgBaseClick(Sender: TObject); // Event handler to reset the input field when the number base changes.
      procedure FormCreate(Sender: TObject);
   private
      { Private declarations }
      FCurrentOffset: Int64; // The current offset in the main view.
      FTargetOffset: Int64;  // The calculated target offset to navigate to.
      FMaxOffset: Int64;     // The maximum valid offset (e.g., file size - 1).
      function ParseInput: Boolean; // Parses and validates the user's input, calculating the final offset.
   public
      { Public declarations }
      // Class function to create, show, and handle the dialog's execution.
      class function Execute(ACurrentOffset, AMaxOffset: Int64; out ATargetOffset: Int64; ACaption: String = ''): Boolean;
   end;

implementation

{$R *.dfm}

// Public class function to display the dialog and return the result.
class function TGoToForm.Execute(ACurrentOffset, AMaxOffset: Int64; out ATargetOffset: Int64; ACaption: String = ''): Boolean;
var
   Form: TGoToForm;
begin
   // Create an instance of the form.
   Form := TGoToForm.Create(Application);
   try
      // Set a custom caption if provided, otherwise use the default.
      if ACaption <> '' then
         Form.Caption := ACaption
      else
         Form.Caption := LOC.Get('TGoToForm', 'GoToForm_Caption', 'Go to Offset');

      // Initialize internal fields with values from the caller.
      Form.FCurrentOffset := ACurrentOffset;
      Form.FMaxOffset := AMaxOffset;

      // Show the form modally and check if the user clicked OK.
      if Form.ShowModal = mrOk then
      begin
         // If OK was clicked, parse the input.
         if Form.ParseInput then
         begin
            // If parsing is successful, set the output parameter and return True.
            ATargetOffset := Form.FTargetOffset;
            Result := True;
         end
         else
         begin
            // If parsing fails, show an error message and return False.
            ShowMessage(LOC.Get('Messages', 'InvalidOffset', 'The offset value is invalid.'));
            Result := False;
         end;
      end
      else
        // If the user cancelled, return False.
        Result := False;
   finally
      // Ensure the form is always freed from memory.
      Form.Free;
   end;
end;

procedure TGoToForm.FormCreate(Sender: TObject);
begin
   LOC.LoadLanguage(GSettings.LanguageFile);
   LOC.TranslateComponent(Self);
end;

// Event handler for the offset edit box to filter invalid characters.
procedure TGoToForm.edtOffsetChange(Sender: TObject);
var
   OriginalText: string;
   FilteredText: string;
   i: Integer;
   CursorPos: Integer;
   ValidChars: Set of Char;
begin
   OriginalText := edtOffset.Text;
   FilteredText := '';

   // Define the set of valid characters based on the selected number base.
   case rgBase.ItemIndex of
      0: ValidChars := ['0'..'9', 'A'..'F', 'a'..'f', '$']; // Auto (dec or hex with $)
      1: ValidChars := ['0'..'9'];                      // Decimal
      2: ValidChars := ['0'..'9', 'A'..'F', 'a'..'f'];  // Hexadecimal
   end;

   // Filter the text, keeping only the valid characters.
   for i := 1 to Length(OriginalText) do
   begin
      // For Auto mode, the '$' is only allowed as the first character.
      if (OriginalText[i] = '$') and (i > 1) and (rgBase.ItemIndex = 0) then
         Continue;

      if UpCase(OriginalText[i]) In ValidChars then
         FilteredText := FilteredText + UpCase(OriginalText[i]);
   end;

   // If the text was modified (invalid character removed), update the TEdit control.
   if OriginalText <> FilteredText then
   begin
      CursorPos := edtOffset.SelStart; // Save the cursor position.
      edtOffset.Text := FilteredText;
      // Restore the cursor position, adjusting if necessary.
      if CursorPos > Length(FilteredText) + 1 then
         edtOffset.SelStart := Length(FilteredText)
      else if CursorPos > 0 then
         edtOffset.SelStart := CursorPos - 1
      else
         edtOffset.SelStart := 0;
   end;
end;

// Parses the user input string to calculate and validate the target offset.
function TGoToForm.ParseInput: Boolean;
var
   UserInput: string;
   ParsedValue: Int64;
begin
   Result := False;
   UserInput := Trim(edtOffset.Text);
   // Exit if the input is empty or just a '$' prefix.
   if (UserInput = '') or (UserInput = '$') then
      Exit;

   try
      // Convert the input string to a number based on the selected base.
      case rgBase.ItemIndex of
         0: // Auto-detect base
         begin
            if UserInput.Chars[0] = '$' then
               // If it starts with '$', treat as hexadecimal.
               ParsedValue := StrToInt('$' + Copy(UserInput, 2, Length(UserInput)))
            else
               // Otherwise, treat as decimal.
               ParsedValue := StrToInt(UserInput);
         end;
         1: ParsedValue := StrToInt(UserInput); // Decimal
         2: ParsedValue := StrToInt('$' + UserInput); // Hexadecimal
      end;

      // Calculate the final offset based on the selected mode (Absolute, Relative, etc.).
      case rgMode.ItemIndex of
         0: FTargetOffset := ParsedValue; // Absolute
         1: FTargetOffset := FCurrentOffset + ParsedValue; // Relative to current position
         2: FTargetOffset := FMaxOffset - ParsedValue; // Relative to the end
      end;

      // Validate if the final result is within the file's boundaries.
      if (FTargetOffset >= 0) and (FTargetOffset <= FMaxOffset) then
         Result := True;
   except on E: EConvertError do
      // If a conversion error occurs (e.g., invalid number), the function returns False.
      Result := False;
   end;
end;

// Event handler for clicking on the number base radio group.
procedure TGoToForm.rgBaseClick(Sender: TObject);
begin
   // When the base is changed, clear the text field to force the user to re-enter the value in the correct format. This improves usability.
   edtOffset.Text := '0';
   edtOffset.SetFocus;
end;

end.