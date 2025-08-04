{***********************************************************************************}
{                                                                                   }
{   Unit: uCodecManager                                                             }
{   Project: Tile Bulinator                                                         }
{   Description: Provides a global singleton manager (GCodecManager) for all        }
{                available tile codecs. This class is responsible for               }
{                registering, storing, retrieving, and freeing all TTileCodec       }
{                instances used by the application.                                 }
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
unit uCodecManager;

interface

uses
   System.SysUtils, System.Generics.Collections, uTileCodecs;

type
   // TCodecManager is a central repository for managing all TTileCodec instances.
   TCodecManager = class
   private
      // Internal procedure to create and register all built-in codecs.
      procedure RegisterCodecs;
   public
      // The dictionary that stores all codecs, mapping a string ID to the codec object.
      Codecs: TDictionary<string, TTileCodec>;
      constructor Create;
      destructor Destroy; override;
      // Retrieves a codec by its unique string identifier.
      function GetCodec(const AId: string): TTileCodec;
      // Adds a new codec instance to the manager.
      procedure AddCodec(ACodec: TTileCodec);
   end;

var
   // Global singleton instance of the codec manager, accessible throughout the application.
   GCodecManager: TCodecManager;

implementation

{ TCodecManager }

// Constructor for the codec manager.
constructor TCodecManager.Create;
begin
   // Initializes the dictionary to hold the codecs.
   Codecs := TDictionary<string, TTileCodec>.Create;
   // Populates the dictionary with all the predefined codecs.
   RegisterCodecs;
end;

// Destructor for the codec manager.
destructor TCodecManager.Destroy;
var
   LCodec: TTileCodec;
begin
   // Frees each codec instance stored in the dictionary to prevent memory leaks.
   for LCodec in Codecs.Values do
      LCodec.Free;
   // Frees the dictionary itself.
   Codecs.Free;

   inherited;
end;

// Adds a codec to the manager's dictionary.
procedure TCodecManager.AddCodec(ACodec: TTileCodec);
begin
   // Checks if the codec is valid and if its ID is not already registered.
   if (ACodec <> nil) and not Codecs.ContainsKey(ACodec.Id) then
      Codecs.Add(ACodec.Id, ACodec)
   else
      // Prevents a memory leak if the codec already exists or is nil. The newly created, but unused, codec instance is freed.
      ACodec.Free;
end;

// Safely retrieves a codec by its ID. Returns nil if not found.
function TCodecManager.GetCodec(const AId: string): TTileCodec;
begin
   // Tries to get the value; if the key doesn't exist, Result will be nil.
   Codecs.TryGetValue(AId, Result);
end;

// Creates instances of all supported codecs and adds them to the manager.
procedure TCodecManager.RegisterCodecs;
begin
   // Register Linear Codecs
   AddCodec(TLinearTileCodec.Create('LN00', 1, loInOrder, '1bpp linear'));
   AddCodec(TLinearTileCodec.Create('LN01', 1, loReverseOrder, '1bpp linear, reverse-order'));
   AddCodec(TLinearTileCodec.Create('LN02', 2, loInOrder, '2bpp linear'));
   AddCodec(TLinearTileCodec.Create('LN03', 2, loReverseOrder, '2bpp linear, reverse-order'));
   AddCodec(TLinearTileCodec.Create('LN04', 4, loInOrder, '4bpp linear'));
   AddCodec(TLinearTileCodec.Create('LN05', 4, loReverseOrder, '4bpp linear, reverse-order'));
   AddCodec(TLinearTileCodec.Create('LN06', 8, loInOrder, '8bpp linear'));

   // Register Planar Codecs
   AddCodec(TPlanarTileCodec.Create('PL00', [0], '1bpp planar'));
   AddCodec(TPlanarTileCodec.Create('PL01', [0, 1], '2bpp planar')); // e.g., Game Boy
   AddCodec(TPlanarTileCodec.Create('PL02', [0, 1, 2], '3bpp planar'));
   AddCodec(TPlanarTileCodec.Create('PL03', [0, 1, 2, 3], '4bpp planar')); // e.g., Master System
   // ... and so on for 5, 6, 7, 8bpp etc.

   // Register Composite Codecs
   // Example: SNES 4bpp, which is composed of two 2bpp planar codecs.
   AddCodec(TCompositeTileCodec.Create('CP02', 4, [TPlanarTileCodec.Create('PL01', [0, 1], ''), TPlanarTileCodec.Create('PL01', [0, 1], '')],
                                       '4bpp planar, composite (2x2bpp)'));

   { TODO : Register Direct Color Codecs - currently disabled }
   //AddCodec(TDirectColorTileCodec.Create('DC01', 15, $001F, $03E0, $7C00, 0, '15bpp BGR (555)'));
   //AddCodec(TDirectColorTileCodec.Create('DC08', 24, $FF0000, $00FF00, $0000FF, 0, '24bpp RGB (888)'));
   //AddCodec(TDirectColorTileCodec.Create('DC10', 32, $00FF0000, $0000FF00, $000000FF, $FF000000, '32bpp ARGB (8888)'));
end;

// The initialization section of the unit is executed when the program starts.
initialization
   // Creates the single global instance of the codec manager.
   GCodecManager := TCodecManager.Create;

// The finalization section is executed when the program terminates.
finalization
   // Frees the global codec manager, ensuring all its resources are released.
   GCodecManager.Free;

end.