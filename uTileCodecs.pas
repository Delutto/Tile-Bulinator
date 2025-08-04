{***********************************************************************************}
{                                                                                   }
{   Unit: uTileCodecs                                                               }
{   Project: Tile Bulinator                                                         }
{   Description: This unit defines the various codecs for encoding and              }
{                decoding tile graphic data. It provides an abstract base class     }
{                and concrete implementations for linear, planar, direct color,     }
{                composite, and other special tile formats found in classic         }
{                consoles.                                                          }
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
unit uTileCodecs;

interface

uses
   System.SysUtils, System.Classes, System.Generics.Collections;

type
   // Enum for ordering in linear codecs.
   TLinearOrdering = (loInOrder, loReverseOrder);

   // Enum for endianness in direct color codecs.
   TEndianness = (enLittleEndian, enBigEndian);


   // TTileCodec: Abstract base class for all codecs. Defines the common interface for decoding and encoding an 8x8 pixel tile.
   TTileCodec = class abstract
   private
      FId: string;                 // Unique identifier for the codec.
      FDescription: string;        // User-friendly description of the codec.
      FBitsPerPixel: Integer;      // Number of bits used to represent a single pixel.
      FBytesPerRow: Integer;       // Number of bytes per row of 8 pixels.
      FTileSize: Integer;          // Size in bytes of one encoded tile.
      FPixels: TArray<Integer>;    // Array of 64 (8x8) decoded pixels.
   public
      constructor Create(const AId: string; ABitsPerPixel: Integer; const ADescription: string); virtual;

      // Main function to decode raw data into an array of pixels.
      function Decode(const AData: TBytes; AOffset, AStride: Integer): TArray<Integer>; virtual; abstract;

      // Main procedure to encode an array of pixels into raw data.
      procedure Encode(const APixels: TArray<Integer>; var AData: TBytes; AOffset, AStride: Integer); virtual; abstract;

      // Public properties to access codec information.
      property Id: string read FId;
      property Description: string read FDescription;
      property BitsPerPixel: Integer read FBitsPerPixel;
      property BytesPerRow: Integer read FBytesPerRow;
      property TileSize: Integer read FTileSize;
   end;


   // TLinearTileCodec: Implements linear (chunky) codecs, where pixels are stored sequentially.
   // Example systems: Game Boy Advance, NeoGeo Pocket.
   TLinearTileCodec = class(TTileCodec)
   private
      FOrdering: TLinearOrdering; // The order of pixels within a byte.
      FPixelsPerByte: Integer;    // How many pixels fit into a single byte.
      FPixelMask: Integer;        // Bitmask to isolate a single pixel's value.
      FStartPixel: Integer;       // Initial pixel index for processing a byte.
      FBoundary: Integer;         // Loop boundary condition.
      FStep: Integer;             // Loop step (-1 for in-order, 1 for reverse).
   public
      constructor Create(const AId: string; ABitsPerPixel: Integer; AOrdering: TLinearOrdering; const ADescription: string);
      function Decode(const AData: TBytes; AOffset, AStride: Integer): TArray<Integer>; override;
      procedure Encode(const APixels: TArray<Integer>; var AData: TBytes; AOffset, AStride: Integer); override;
   end;

   // TPlanarTileCodec: Implements planar codecs, where the bits of each pixel are separated into "bitplanes".
   // Example systems: NES, Master System, SNES.
   TPlanarTileCodec = class(TTileCodec)
   private
      FBpOffsets: TArray<Integer>; // Offsets for each bitplane within a tile row's data.
      class var FBitsToPixelsLookup: TArray<TArray<TArray<Byte>>>; // Optimization to speed up decoding.
      class constructor CreateClass;
   public
      constructor Create(const AId: string; const ABpOffsets: TArray<Integer>; const ADescription: string);
      function Decode(const AData: TBytes; AOffset, AStride: Integer): TArray<Integer>; override;
      procedure Encode(const APixels: TArray<Integer>; var AData: TBytes; AOffset, AStride: Integer); override;
   end;


   // TDirectColorTileCodec: Implements direct color codecs (15, 16, 24, 32bpp). Does not use a palette; the color is defined directly in the pixel data.
   // Example systems: N64, some GBA screens.
   TDirectColorTileCodec = class(TTileCodec)
   private
      FEndianness: TEndianness;                    // The byte order for multi-byte pixel data.
      FRMask, FGMask, FBMask, FAMask: Cardinal;    // Color component masks.
      FRShift, FGShift, FBShift, FAShift: Integer; // Pre-calculated bit shifts for color components.
      FBytesPerPixel: Integer;                     // Number of bytes for a single pixel.
      FStartShift: Integer;                        // Initial bit shift based on endianness.
      FShiftStep: Integer;                         // Shift step based on endianness.
      function GetMSB(AMask: Cardinal): Integer;   // Helper to find the most significant bit of a mask.
   public
      constructor Create(const AId: string; ABitsPerPixel: Integer; ARMask, AGMask, ABMask, AAMask: Cardinal; const ADescription: string);
      procedure SetEndianness(AEndianness: TEndianness);
      function Decode(const AData: TBytes; AOffset, AStride: Integer): TArray<Integer>; override;
      procedure Encode(const APixels: TArray<Integer>; var AData: TBytes; AOffset, AStride: Integer); override;
   end;

   // TCompositeTileCodec: A "meta-codec" that combines other codecs.
   // Useful for complex formats like the SNES 4bpp (which is composed of two 2bpp planes).
   TCompositeTileCodec = class(TTileCodec)
   private
      FCodecs: TArray<TTileCodec>; // Array of sub-codecs to be combined.
      FOwnsCodecs: Boolean;        // Flag indicating if this class is responsible for freeing the sub-codecs.
   public
      constructor Create(const AId: string; ABitsPerPixel: Integer; const ACodecs: TArray<TTileCodec>; const ADescription: string; AOwnsCodecs: Boolean = True);
      destructor Destroy; override;
      function Decode(const AData: TBytes; AOffset, AStride: Integer): TArray<Integer>; override;
      procedure Encode(const APixels: TArray<Integer>; var AData: TBytes; AOffset, AStride: Integer); override;
   end;

   // T3BPPLinearTileCodec: Specific codec for the 3bpp linear format.
   // The bit-shifting logic is complex and does not fit the standard TLinearTileCodec.
   T3BPPLinearTileCodec = class(TTileCodec)
   public
      constructor Create;
      function Decode(const AData: TBytes; AOffset, AStride: Integer): TArray<Integer>; override;
      procedure Encode(const APixels: TArray<Integer>; var AData: TBytes; AOffset, AStride: Integer); override;
   end;

   // T6BPPLinearTileCodec: Specific codec for the 6bpp linear format.
   // Also has custom bit-shifting logic.
   T6BPPLinearTileCodec = class(TTileCodec)
   public
     constructor Create;
     function Decode(const AData: TBytes; AOffset, AStride: Integer): TArray<Integer>; override;
     procedure Encode(const APixels: TArray<Integer>; var AData: TBytes; AOffset, AStride: Integer); override;
   end;

implementation

{ TTileCodec }
// Base constructor for all codecs.
constructor TTileCodec.Create(const AId: string; ABitsPerPixel: Integer; const ADescription: string);
begin
   inherited Create;

   FId := AId;
   FDescription := ADescription;
   FBitsPerPixel := ABitsPerPixel;
   FBytesPerRow := ABitsPerPixel;
   FTileSize := FBytesPerRow * 8; // Total bytes for an 8x8 tile.
   SetLength(FPixels, 64); // Allocate space for an 8x8 tile.
end;

{ TLinearTileCodec }
// Constructor for linear codecs.
constructor TLinearTileCodec.Create(const AId: string; ABitsPerPixel: Integer; AOrdering: TLinearOrdering; const ADescription: string);
begin
   inherited Create(AId, ABitsPerPixel, ADescription);

   FOrdering := AOrdering;
   FPixelsPerByte := 8 div FBitsPerPixel;
   FPixelMask := (1 shl FBitsPerPixel) - 1;

   // Set up parameters based on the pixel ordering within a byte.
   if FOrdering = loInOrder then
   begin
      // e.g., for 4bpp, pixels are ordered 1, 0 in a byte.
      FStartPixel := FPixelsPerByte - 1;
      FBoundary := -1;
      FStep := -1;
   end
   else // loReverseOrder
   begin
      // e.g., for 4bpp, pixels are ordered 0, 1 in a byte.
      FStartPixel := 0;
      FBoundary := FPixelsPerByte;
      FStep := 1;
   end;
end;

// Decodes raw data using the linear method.
function TLinearTileCodec.Decode(const AData: TBytes; AOffset, AStride: Integer): TArray<Integer>;
var
   i, k, m, b: Integer;
   LPos: Integer;
begin
   LPos := 0; // Linear position in the FPixels array (0-63).
   AStride := AStride * FBytesPerRow; // Calculate byte stride to the next tile row.

   for i := 0 to 7 do // For each of the 8 rows in the tile.
   begin
      for k := 0 to FBytesPerRow - 1 do // For each byte in the current row.
      begin
         b := AData[AOffset]; // Read the byte.
         Inc(AOffset);
         m := FStartPixel; // Start at the first pixel to process in the byte.
         while m <> FBoundary do // Loop through all pixels within the byte.
         begin
            // Isolate the pixel's value using shifting and masking.
            FPixels[LPos] := (b shr (FBitsPerPixel * m)) and FPixelMask;
            Inc(LPos);
            Inc(m, FStep); // Move to the next pixel index.
         end;
      end;
      Inc(AOffset, AStride); // Move offset to the start of the next row.
   end;
   Result := FPixels;
end;

// Encodes pixel data into the linear format.
procedure TLinearTileCodec.Encode(const APixels: TArray<Integer>; var AData: TBytes; AOffset, AStride: Integer);
var
   i, k, m: Integer;
   LPos: Integer;
   b: Byte;
begin
   LPos := 0; // Linear position in the source APixels array.
   AStride := AStride * FBytesPerRow; // Calculate byte stride to the next tile row.

   for i := 0 to 7 do // For each of the 8 rows.
   begin
      for k := 0 to FBytesPerRow - 1 do // For each byte to be written in the row.
      begin
         b := 0; // Reset the byte value.
         m := FStartPixel; // Start at the first pixel to pack.
         while m <> FBoundary do // Loop through all pixels that fit in this byte.
         begin
            // Pack the pixel's value into the byte.
            b := b or ((APixels[LPos] and FPixelMask) shl (m * FBitsPerPixel));
            Inc(LPos);
            Inc(m, FStep); // Move to the next pixel.
         end;
         AData[AOffset] := b; // Write the completed byte.
         Inc(AOffset);
      end;
      Inc(AOffset, AStride); // Move offset to the start of the next row.
   end;
end;

{ TPlanarTileCodec }

// Class constructor to pre-calculate the lookup table.
class constructor TPlanarTileCodec.CreateClass;
var
   i, j, k: Integer;
begin
   // This table allows direct mapping from a byte value to its pixel bits for a given bitplane.
   SetLength(FBitsToPixelsLookup, 8, 256, 8); // [bitplane, byteValue, pixelBit]
   for i := 0 to 7 do // bitplane index
   begin
      for j := 0 to 255 do // byte value
      begin
         for k := 7 downto 0 do // bit of the pixel
         begin
           // For a given bitplane 'i' and byte value 'j', find the value of the 'k'-th bit.
           FBitsToPixelsLookup[i, j, 7 - k] := ((j shr k) and 1) shl i;
         end;
      end;
   end;
end;

// Constructor for planar codecs.
constructor TPlanarTileCodec.Create(const AId: string; const ABpOffsets: TArray<Integer>; const ADescription: string);
begin
   // The BitsPerPixel is the number of bitplanes.
   inherited Create(AId, Length(ABpOffsets), ADescription);

   FBpOffsets := ABpOffsets;
end;

// Decodes raw data using the planar method.
function TPlanarTileCodec.Decode(const AData: TBytes; AOffset, AStride: Integer): TArray<Integer>;
var
   i, j, k, p: Integer;
   LPos: Integer;
   bp: TArray<Byte>; // Array to hold the bytes for each bitplane of the current row.
begin
   LPos := 0;
   SetLength(bp, FBitsPerPixel);
   AStride := (AStride + 1) * FBytesPerRow; // Calculate stride including tile data size.

   for i := 0 to 7 do // For each of the 8 rows.
   begin
      // Get the bytes for each bitplane of the current row.
      for j := 0 to FBitsPerPixel - 1 do
      begin
         bp[j] := AData[AOffset + FBpOffsets[j]];
      end;

      // Assemble the pixels for the row.
      for j := 0 to 7 do // For each of the 8 pixels in the row.
      begin
         p := 0; // Reset the current pixel value.
         // Combine bits from each bitplane to form the final pixel value.
         for k := 0 to FBitsPerPixel - 1 do
         begin
            p := p or FBitsToPixelsLookup[k, bp[k], j];
         end;
         FPixels[LPos] := p;
         Inc(LPos);
      end;
      Inc(AOffset, AStride); // Move to the next row of tile data.
   end;
   Result := FPixels;
end;

// Encodes pixel data into the planar format.
procedure TPlanarTileCodec.Encode(const APixels: TArray<Integer>; var AData: TBytes; AOffset, AStride: Integer);
var
   i, j, k, p: Integer;
   LPos: Integer;
begin
   LPos := 0;
   AStride := (AStride + 1) * FBytesPerRow;

   for i := 0 to 7 do // For each of the 8 rows.
   begin
      // Zero out the bitplane bytes for the current row.
      for j := 0 to FBitsPerPixel - 1 do
         AData[AOffset + FBpOffsets[j]] := 0;

      // Encode each pixel in the row.
      for j := 0 to 7 do // For each of the 8 pixels.
      begin
         p := APixels[LPos]; // Get the pixel color index.
         for k := 0 to FBitsPerPixel - 1 do // For each bitplane.
            // Distribute the bits of the pixel color index into their respective bitplanes.
            AData[AOffset + FBpOffsets[k]] := AData[AOffset + FBpOffsets[k]] or (((p shr k) and 1) shl (7 - j));

         Inc(LPos);
      end;
      Inc(AOffset, AStride); // Move to the next row of tile data.
   end;
end;

{ TDirectColorTileCodec }
// Constructor for direct color codecs.
constructor TDirectColorTileCodec.Create(const AId: string; ABitsPerPixel: Integer; ARMask, AGMask, ABMask, AAMask: Cardinal; const ADescription: string);
begin
   if (ABitsPerPixel mod 8) <> 0 then
      ABitsPerPixel := ((ABitsPerPixel div 8) + 1) * 8;

   inherited Create(AId, ABitsPerPixel, ADescription);

   FBytesPerPixel := FBitsPerPixel div 8;
   FRMask := ARMask;
   FGMask := AGMask;
   FBMask := ABMask;
   FAMask := AAMask;

   // Calculate the shifts to convert the source color format to standard 32-bit ARGB ($AARRGGBB).
   FRShift := 23 - GetMSB(FRMask); // Red component (bits 16-23)
   FGShift := 15 - GetMSB(FGMask); // Green component (bits 8-15)
   FBShift := 7 - GetMSB(FBMask);  // Blue component (bits 0-7)
   FAShift := 31 - GetMSB(FAMask); // Alpha component (bits 24-31)

   SetEndianness(enLittleEndian); // Default to Little Endian.
end;

// Decodes raw data using the direct color method.
function TDirectColorTileCodec.Decode(const AData: TBytes; AOffset, AStride: Integer): TArray<Integer>;
var
   i, j, k: Integer;
   v, r, g, b, a, s: Cardinal;
   LPos: Integer;
begin
   LPos := 0;
   AStride := AStride * FBytesPerRow;

   for i := 0 to 7 do // For each of the 8 rows.
   begin
      for j := 0 to 7 do // For each of the 8 pixels in the row.
      begin
         // Assemble the pixel value from bytes, respecting endianness.
         s := FStartShift;
         v := 0;
         for k := 0 to FBytesPerPixel - 1 do
         begin
            v := v or (AData[AOffset] shl s);
            Inc(AOffset);
            Inc(s, FShiftStep);
         end;

         // Decode Red component.
         r := v and FRMask;
         if FRShift < 0 then r := r shr -FRShift else r := r shl FRShift;

         // Decode Green component.
         g := v and FGMask;
         if FGShift < 0 then g := g shr -FGShift else g := g shl FGShift;

         // Decode Blue component.
         b := v and FBMask;
         if FBShift < 0 then b := b shr -FBShift else b := b shl FBShift;

         // Decode Alpha component.
         a := v and FAMask;
         if FAShift < 0 then a := a shr -FAShift else a := a shl FAShift;

         // Final pixel in TAlphaColor format ($AARRGGBB).
         FPixels[LPos] := a or r or g or b;
         Inc(LPos);
      end;
      Inc(AOffset, AStride);
   end;
   Result := FPixels;
end;

// Encodes pixel data into the direct color format.
procedure TDirectColorTileCodec.Encode(const APixels: TArray<Integer>; var AData: TBytes; AOffset, AStride: Integer);
var
   i, j, k: Integer;
   v, r, g, b, a, s, argb: Cardinal;
   LPos: Integer;
begin
   LPos := 0;
   AStride := AStride * FBytesPerRow;
   for i := 0 to 7 do // For each row.
   begin
      for j := 0 to 7 do // For each pixel.
      begin
         argb := APixels[LPos];
         Inc(LPos);

         // Encode Red component.
         r := argb;
         if FRShift < 0 then r := r shl -FRShift else r := r shr FRShift;
         r := r and FRMask;

         // Encode Green component.
         g := argb;
         if FGShift < 0 then g := g shl -FGShift else g := g shr FGShift;
         g := g and FGMask;

         // Encode Blue component.
         b := argb;
         if FBShift < 0 then b := b shl -FBShift else b := b shr FBShift;
         b := b and FBMask;

         // Encode Alpha component.
         a := argb;
         if FAShift < 0 then a := a shl -FAShift else a := a shr FAShift;
         a := a and FAMask;

         // Final combined value.
         v := a or r or g or b;
         s := FStartShift;
         // Write the bytes of the final value, respecting endianness.
         for k := 0 to FBytesPerPixel - 1 do
         begin
            AData[AOffset] := (v shr s);
            Inc(AOffset);
            Inc(s, FShiftStep);
         end;
      end;
      Inc(AOffset, AStride);
   end;
end;

// Finds the position of the most significant bit (MSB) in a mask.
function TDirectColorTileCodec.GetMSB(AMask: Cardinal): Integer;
var
   i: Integer;
begin
   if AMask = 0 then
      Exit(-1);
   for i := 31 downto 0 do
   begin
      if (AMask and (1 shl 31)) <> 0 then
         Exit(i);
      AMask := AMask shl 1;
   end;
   Result := -1;
end;

// Sets the endianness and calculates related shift parameters.
procedure TDirectColorTileCodec.SetEndianness(AEndianness: TEndianness);
begin
   FEndianness := AEndianness;
   if FEndianness = enLittleEndian then
   begin
      FStartShift := 0;
      FShiftStep := 8;
   end
   else // enBigEndian
   begin
      FStartShift := (FBytesPerPixel - 1) * 8;
      FShiftStep := -8;
   end;
end;

{ TCompositeTileCodec }

// Constructor for composite codecs.
constructor TCompositeTileCodec.Create(const AId: string; ABitsPerPixel: Integer; const ACodecs: TArray<TTileCodec>; const ADescription: string; AOwnsCodecs: Boolean);
begin
   inherited Create(AId, ABitsPerPixel, ADescription);
   FCodecs := ACodecs;
   FOwnsCodecs := AOwnsCodecs;
end;

// Destructor for composite codecs, frees sub-codecs if owned.
destructor TCompositeTileCodec.Destroy;
var
   LCodec: TTileCodec;
begin
   if FOwnsCodecs then
   begin
      for LCodec in FCodecs do
         LCodec.Free;
   end;

   inherited;
end;

// Decodes by applying each sub-codec in sequence and combining the results.
function TCompositeTileCodec.Decode(const AData: TBytes; AOffset, AStride: Integer): TArray<Integer>;
var
   i, j: Integer;
   LShift: Integer;
   LTilePixels: TArray<Integer>;
begin
   // If there are no sub-codecs, return a blank tile.
   if Length(FCodecs) = 0 then
   begin
      FillChar(FPixels[0], Length(FPixels) * SizeOf(Integer), 0);
      Exit(FPixels);
   end;

   // Decode the first sub-tile.
   System.Move(FCodecs[0].Decode(AData, AOffset, AStride)[0], FPixels[0], Length(FPixels) * SizeOf(Integer));

   // Decode the remaining sub-tiles and composite them.
   LShift := FCodecs[0].BitsPerPixel;
   for i := 1 to High(FCodecs) do
   begin
      AOffset := AOffset + (AStride + 1) * FCodecs[i - 1].TileSize;
      LTilePixels := FCodecs[i].Decode(AData, AOffset, AStride);
      // Combine the new pixels with the existing ones by shifting and ORing.
      for j := 0 to 63 do
         FPixels[j] := FPixels[j] or (LTilePixels[j] shl LShift);
      Inc(LShift, FCodecs[i].BitsPerPixel);
   end;
   Result := FPixels;
end;

// Encodes by splitting the pixel data and applying each sub-codec.
procedure TCompositeTileCodec.Encode(const APixels: TArray<Integer>; var AData: TBytes; AOffset, AStride: Integer);
var
   i, j: Integer;
   LShift: Integer;
   LTilePixels: TArray<Integer>;
begin
   if Length(FCodecs) = 0 then
      Exit;

   // Create a working copy of the pixel data.
   SetLength(LTilePixels, 64);
   System.Move(APixels[0], LTilePixels[0], 64 * SizeOf(Integer));

   // Encode the first sub-tile.
   FCodecs[0].Encode(LTilePixels, AData, AOffset, AStride);

   // Encode the remaining sub-tiles.
   LShift := FCodecs[0].BitsPerPixel;
   for i := 1 to High(FCodecs) do
   begin
      AOffset := AOffset + (AStride + 1) * FCodecs[i - 1].TileSize;
      // Shift pixels to the right to isolate the bits for this plane.
      for j := 0 to 63 do
         LTilePixels[j] := LTilePixels[j] shr LShift;

      FCodecs[i].Encode(LTilePixels, AData, AOffset, AStride);
      Inc(LShift, FCodecs[i].BitsPerPixel);
   end;
end;

{ T3BPPLinearTileCodec }

// Constructor for the custom 3bpp linear codec.
constructor T3BPPLinearTileCodec.Create;
begin
   inherited Create('LN98', 3, '3bpp linear');
end;

// Decodes the specific 3bpp format.
function T3BPPLinearTileCodec.Decode(const AData: TBytes; AOffset, AStride: Integer): TArray<Integer>;
var
   i, b1, b2, b3: Integer;
   LPos: Integer;
begin
   LPos := 0;
   AStride := AStride * FBytesPerRow;
   for i := 0 to 7 do // For each row (which is 3 bytes long).
   begin
      b1 := AData[AOffset]; Inc(AOffset); // byte 1: p0 p0 p0 p1 p1 p1 p2 p2
      b2 := AData[AOffset]; Inc(AOffset); // byte 2: p2 p3 p3 p3 p4 p4 p4 p5
      b3 := AData[AOffset]; Inc(AOffset); // byte 3: p5 p5 p6 p6 p6 p7 p7 p7

      // Unpack 8 pixels from 3 bytes.
      FPixels[LPos] := (b1 shr 5) and 7; Inc(LPos); // Pixel 0
      FPixels[LPos] := (b1 shr 2) and 7; Inc(LPos); // Pixel 1
      FPixels[LPos] := ((b1 and 3) shl 1) or ((b2 shr 7) and 1); Inc(LPos); // Pixel 2
      FPixels[LPos] := (b2 shr 4) and 7; Inc(LPos); // Pixel 3
      FPixels[LPos] := (b2 shr 1) and 7; Inc(LPos); // Pixel 4
      FPixels[LPos] := ((b2 and 1) shl 2) or ((b3 shr 6) and 3); Inc(LPos); // Pixel 5
      FPixels[LPos] := (b3 shr 3) and 7; Inc(LPos); // Pixel 6
      FPixels[LPos] := b3 and 7; Inc(LPos); // Pixel 7
      Inc(AOffset, AStride);
   end;
   Result := FPixels;
end;

// Encodes into the specific 3bpp format.
procedure T3BPPLinearTileCodec.Encode(const APixels: TArray<Integer>; var AData: TBytes; AOffset, AStride: Integer);
var
   i, b1, b2, b3: Integer;
   LPos: Integer;
begin
   LPos := 0;
   AStride := AStride * FBytesPerRow;
   for i := 0 to 7 do // For each row.
   begin
      // Pack 8 pixels into 3 bytes.
      b1 := (APixels[LPos] and 7) shl 5; Inc(LPos); // Pixel 0
      b1 := b1 or ((APixels[LPos] and 7) shl 2); Inc(LPos); // Pixel 1
      b1 := b1 or ((APixels[LPos] and 6) shr 1); // Upper 2 bits of Pixel 2
      b2 := (APixels[LPos] and 1) shl 7; Inc(LPos); // Lower 1 bit of Pixel 2
      b2 := b2 or ((APixels[LPos] and 7) shl 4); Inc(LPos); // Pixel 3
      b2 := b2 or ((APixels[LPos] and 7) shl 1); Inc(LPos); // Pixel 4
      b2 := b2 or ((APixels[LPos] and 4) shr 2); // Upper 1 bit of Pixel 5
      b3 := (APixels[LPos] and 3) shl 6; Inc(LPos); // Lower 2 bits of Pixel 5
      b3 := b3 or ((APixels[LPos] and 7) shl 3); Inc(LPos); // Pixel 6
      b3 := b3 or (APixels[LPos] and 7); Inc(LPos); // Pixel 7

      AData[AOffset] := b1; Inc(AOffset);
      AData[AOffset] := b2; Inc(AOffset);
      AData[AOffset] := b3; Inc(AOffset);
      Inc(AOffset, AStride);
   end;
end;

{ T6BPPLinearTileCodec }

// Constructor for the custom 6bpp linear codec.
constructor T6BPPLinearTileCodec.Create;
begin
   inherited Create('LN99', 6, '6bpp linear, reverse-order');
end;

// Decodes the specific 6bpp format.
function T6BPPLinearTileCodec.Decode(const AData: TBytes; AOffset, AStride: Integer): TArray<Integer>;
var
   i, b1, b2, b3, b4, b5, b6: Integer;
   LPos: Integer;
begin
   LPos := 0;
   AStride := AStride * FBytesPerRow;
   for i := 0 to 7 do // For each row (which is 6 bytes long).
   begin
      // The byte read order is reversed
      b6 := AData[AOffset]; Inc(AOffset); // byte 1
      b5 := AData[AOffset]; Inc(AOffset); // byte 2
      b4 := AData[AOffset]; Inc(AOffset); // byte 3
      b3 := AData[AOffset]; Inc(AOffset); // byte 4
      b2 := AData[AOffset]; Inc(AOffset); // byte 5
      b1 := AData[AOffset]; Inc(AOffset); // byte 6

      // Unpack 8 pixels from 6 bytes.
      FPixels[LPos] := (b1 shr 2) and 63; Inc(LPos); // Pixel 0
      FPixels[LPos] := ((b1 and 3) shl 4) or ((b2 shr 4) and 15); Inc(LPos); // Pixel 1
      FPixels[LPos] := ((b2 and 15) shl 2) or ((b3 shr 6) and 3); Inc(LPos); // Pixel 2
      FPixels[LPos] := b3 and 63; Inc(LPos); // Pixel 3
      FPixels[LPos] := (b4 shr 2) and 63; Inc(LPos); // Pixel 4
      FPixels[LPos] := ((b4 and 3) shl 4) or ((b5 shr 4) and 15); Inc(LPos); // Pixel 5
      FPixels[LPos] := ((b5 and 15) shl 2) or ((b6 shr 6) and 3); Inc(LPos); // Pixel 6
      FPixels[LPos] := b6 and 63; Inc(LPos); // Pixel 7

      Inc(AOffset, AStride);
   end;
   Result := FPixels;
end;

// Encodes into the specific 6bpp format.
procedure T6BPPLinearTileCodec.Encode(const APixels: TArray<Integer>; var AData: TBytes; AOffset, AStride: Integer);
var
   i, b1, b2, b3, b4, b5, b6: Integer;
   LPos: Integer;
begin
   LPos := 0;
   AStride := AStride * FBytesPerRow;
   for i := 0 to 7 do // For each row.
   begin
      // Pack 8 pixels into 6 bytes.
      b1 := (APixels[LPos] and 63) shl 2;           // Upper 6 bits of Pixel 0
      b1 := b1 or ((APixels[LPos + 1] and 48) shr 4); // Upper 2 bits of Pixel 1
      b2 := (APixels[LPos + 1] and 15) shl 4;        // Lower 4 bits of Pixel 1
      b2 := b2 or ((APixels[LPos + 2] and 60) shr 2); // Upper 4 bits of Pixel 2
      b3 := (APixels[LPos + 2] and 3) shl 6;         // Lower 2 bits of Pixel 2
      b3 := b3 or (APixels[LPos + 3] and 63);        // All 6 bits of Pixel 3

      b4 := (APixels[LPos + 4] and 63) shl 2;
      b4 := b4 or ((APixels[LPos + 5] and 48) shr 4);
      b5 := (APixels[LPos + 5] and 15) shl 4;
      b5 := b5 or ((APixels[LPos + 6] and 60) shr 2);
      b6 := (APixels[LPos + 6] and 3) shl 6;
      b6 := b6 or (APixels[LPos + 7] and 63);
      LPos := LPos + 8; // Advance past the 8 pixels processed.

      // The byte write order is reversed to match the decode logic.
      AData[AOffset] := b6; Inc(AOffset);
      AData[AOffset] := b5; Inc(AOffset);
      AData[AOffset] := b4; Inc(AOffset);
      AData[AOffset] := b3; Inc(AOffset);
      AData[AOffset] := b2; Inc(AOffset);
      AData[AOffset] := b1; Inc(AOffset);

      Inc(AOffset, AStride);
   end;
end;

end.