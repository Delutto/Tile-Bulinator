{***********************************************************************************}
{                                                                                   }
{   Unit: uColorCodecs                                                              }
{   Project: Tile Bulinator                                                         }
{   Description: This unit defines codecs for converting raw byte arrays,           }
{                typically from ROMs, into standard TColor palettes for display.    }
{                It provides a base class and implementations for common color      }
{                formats. Based on tmspec.xml from Tile Molester.                   }
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
unit uColorCodecs;

interface

uses
   Vcl.Graphics, System.SysUtils, Winapi.Windows;

type
   // TColorCodec: Base class for all color codecs.
   // Converts a byte array into an array of TColor.
   TColorCodec = class
   private
      FDescription: string; // User-friendly description of the color format.
   public
      constructor Create(const ADescription: string);
      // Converts raw data into a palette. Returns the number of colors read.
      function Decode(const AData: TBytes; var APalette: TArray<TColor>): Integer; virtual; abstract;
      property Description: string read FDescription;
   end;


   // T15BGRColorCodec: Codec for the 15-bit BGR format ($BBBBBGGGGGRRRRR).
   // Common in systems like SNES, Genesis, GBA, etc.
   T15BGRColorCodec = class(TColorCodec)
   public
      constructor Create;
      function Decode(const AData: TBytes; var APalette: TArray<TColor>): Integer; override;
   end;

   // T24RGBColorCodec: Codec for the 24-bit RGB format (8-8-8).
   // Common in PC files, such as BMPs.
   T24RGBColorCodec = class(TColorCodec)
   public
      constructor Create;
      function Decode(const AData: TBytes; var APalette: TArray<TColor>): Integer; override;
   end;

implementation

{ TColorCodec }
constructor TColorCodec.Create(const ADescription: string);
begin
   FDescription := ADescription;
end;

{ T15BGRColorCodec }
constructor T15BGRColorCodec.Create;
begin
   inherited Create('15-bit BGR (5-5-5)');
end;

function T15BGRColorCodec.Decode(const AData: TBytes; var APalette: TArray<TColor>): Integer;
var
   i, ColorValue, R, G, B: Integer;
begin
   // Each color uses 2 bytes (16 bits, but only 15 are used for color).
   Result := Length(AData) div 2;
   // Do not exceed the destination palette's size.
   if Result > Length(APalette) then
      Result := Length(APalette);

   for i := 0 to Result - 1 do
   begin
      // Read 2 bytes in Little Endian format to form a 16-bit word.
      ColorValue := AData[i * 2] or (AData[i * 2 + 1] shl 8);

      // Extract the 5-bit color components using bitmasks.
      R := (ColorValue and $001F);       // RRRRR
      G := (ColorValue and $03E0) shr 5;  // GGGGG
      B := (ColorValue and $7C00) shr 10; // BBBBB

      // Convert from 5-bit depth (0-31) to 8-bit depth (0-255) for proper display.
      R := (R * 255) div 31;
      G := (G * 255) div 31;
      B := (B * 255) div 31;

      // Create the TColor value.
      APalette[i] := RGB(R, G, B);
   end;
end;

{ T24RGBColorCodec }
constructor T24RGBColorCodec.Create;
begin
   inherited Create('24-bit RGB (8-8-8)');
end;

function T24RGBColorCodec.Decode(const AData: TBytes; var APalette: TArray<TColor>): Integer;
var
   i: Integer;
   R, G, B: Byte;
begin
   // Each color uses 3 bytes (R, G, B).
   Result := Length(AData) div 3;
   // Do not exceed the destination palette's size.
   if Result > Length(APalette) then
      Result := Length(APalette);

   for i := 0 to Result - 1 do
   begin
      // Read the 3 bytes in R, G, B order.
      R := AData[i * 3];
      G := AData[i * 3 + 1];
      B := AData[i * 3 + 2];

      // Create the TColor value directly from the 8-bit components.
      APalette[i] := RGB(R, G, B);
   end;
end;

end.