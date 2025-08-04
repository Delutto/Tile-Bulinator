{***********************************************************************************}
{                                                                                   }
{   Unit: uDocumentFrame                                                            }
{   Project: Tile Bulinator                                                         }
{   Description: This unit defines the core document view frame. It manages the     }
{                entire state of a single opened file, including the ROM data,      }
{                palettes, codecs, and view settings. It handles all user           }
{                interactions such as drawing, selecting, undo/redo, clipboard      }
{                operations, and UI control events. It is the central piece of      }
{                the MDI (Multiple Document Interface) architecture.                }
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
unit uDocumentFrame;

interface

uses
   Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.Types, System.Math, System.Generics.Collections,
   Vcl.Imaging.pngimage, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Grids, Vcl.Menus,
   Vcl.Samples.Spin, Vcl.Buttons,
   uTileCodecs, uCodecManager, uColorCodecs, GoToForm, System.ImageList, Vcl.ImgList, UndoSystem, uLocalization, uProject, uSettings;

type
   // Enumeration of all available editing tools.
   TTool = (tlPointer, tlPencil, tlFillBucket, tlEyedropper, tlColorReplacer, tlShift, tlZoom, tlMove);

type
   TDocumentFrame = class(TFrame)
      // VCL Component Declarations
      pnlControls: TPanel;
      grpControles: TGroupBox;
      lblCodec: TLabel;
      lblTilesLinha: TLabel;
      lblBy: TLabel;
      cbxCodecs: TComboBox;
      seTilesPerRow: TSpinEdit;
      seTilesPerColumn: TSpinEdit;
      grpFerramentas: TGroupBox;
      btnPointerTool: TSpeedButton;
      btnPencilTool: TSpeedButton;
      btnFillBucketTool: TSpeedButton;
      btnEyedropperTool: TSpeedButton;
      btnColorReplacerTool: TSpeedButton;
      btnZoomTool: TSpeedButton;
      btnMoveTool: TSpeedButton;
      btnFlipH: TSpeedButton;
      btnFlipV: TSpeedButton;
      btnRotate: TSpeedButton;
      btnShiftUp: TSpeedButton;
      btnShiftDown: TSpeedButton;
      btnShiftLeft: TSpeedButton;
      btnShiftRight: TSpeedButton;
      lblFormatoPaleta: TLabel;
      cbxPaletteFormats: TComboBox;
      grpPaletaAtiva: TGroupBox;
      pbActivePalette: TPaintBox;
      pnlRight: TPanel;
      grpMasterPalette: TGroupBox;
      pbPalette: TPaintBox;
      pnlClient: TPanel;
      grpTiles: TGroupBox;
      pbTileViewer: TPaintBox;
      sbOffset: TScrollBar;
      vsbTileScroller: TScrollBar;
      imglTools: TImageList;

      // Event Handlers for UI Components
      procedure UpdateHexViewer;
      procedure cbxCodecsChange(Sender: TObject);
      procedure seTilesPerRowChange(Sender: TObject);
      procedure seTilesPerColumnChange(Sender: TObject);
      procedure ToolButtonClick(Sender: TObject);
      procedure TransformButtonClick(Sender: TObject);
      procedure ShiftButtonClick(Sender: TObject);
      procedure cbxPaletteFormatsChange(Sender: TObject);
      procedure pbActivePaletteMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
      procedure pbActivePalettePaint(Sender: TObject);
      procedure pbPaletteMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
      procedure pbPaletteMouseLeave(Sender: TObject);
      procedure pbPaletteMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
      procedure pbPalettePaint(Sender: TObject);
      procedure pbTileViewerMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
      procedure pbTileViewerMouseLeave(Sender: TObject);
      procedure pbTileViewerMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
      procedure pbTileViewerMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
      procedure pbTileViewerPaint(Sender: TObject);
      procedure sbOffsetScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
      procedure vsbTileScrollerScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
      procedure pbTileViewerMouseEnter(Sender: TObject);
   private
      { Shared Components from MainForm - Injected to avoid re-creating common dialogs }
      FOpenDialog: TOpenDialog;
      FSaveDialog: TSaveDialog;
      FOpenPaletteDialog: TOpenDialog;
      FColorDialog: TColorDialog;
      FStatusBar: TStatusBar;

      { Document State - Core data and settings for the currently opened file }
      NewROM: Boolean;                        // Flag to indicate if a ROM was just loaded, to trigger initial palette load.
      FRomData: TBytes;                       // The raw byte data of the loaded file.
      FCurrentCodec: TTileCodec;              // The currently selected tile codec for encoding/decoding.
      FCurrentPalette: TArray<TColor>;        // The full 256-color master palette.
      FActivePalette: TArray<TColor>;         // The active sub-palette, derived from the master palette.
      FActivePaletteStartIndex: Integer;      // The starting index in the master palette for the current active sub-palette.
      FColorCodecs: TObjectList<TColorCodec>; // List of available color codecs for palette decoding.
      FCurrentColorCodec: TColorCodec;        // The currently selected color codec.
      FCurrentFileName: string;               // The full path of the loaded file.
      FModified: Boolean;                     // Flag indicating if the file has unsaved changes.

      { View State - Settings related to how the data is displayed }
      FTileBitmap: TBitmap;                   // The off-screen buffer used to render the tile viewer, for performance.
      FZoom: Integer;                         // The current zoom level for the tile viewer.
      FTilesPerRow: Integer;                  // The number of tiles to display per row in the viewer.
      FTilesPerColumn: Integer;               // The number of tiles to display per column in the viewer.
      FOnStateChange: TNotifyEvent;           // Event fired to notify the MainForm of state changes (e.g., modified status, undo/redo availability).
      FIsTileGridVisible: Boolean;            // Toggles the visibility of the 8x8 tile grid.
      FIsPixelGridVisible: Boolean;           // Toggles the visibility of the 1x1 pixel grid.

      { Tool State - Variables related to the currently active tool and user interaction }
      FCurrentTool: TTool;                    // The currently selected tool from the TTool enum.
      FCurrentColorIndex: Integer;            // The index of the selected color within the FActivePalette.
      FSelectionRect: TRect;                  // The current selection area, in tile coordinates.
      FIsDragging: Boolean;                   // Flag indicating if a mouse drag operation is in progress.
      FDragStartPoint: TPoint;                // The starting point of a drag operation, in tile coordinates.
      FHoverStartIndex: Integer;              // The starting index of the sub-palette being hovered over in the master palette.

      { Move Tool State - Specific variables for the 'Move' tool operation }
      FMoveSelectionBitmap: TBitmap;          // A temporary bitmap that holds the visual data of the selection being moved.
      FMoveOriginalRect: TRect;               // The original position of the selection before the move started.
      FMoveActionGroup: TUndoActionGroup;     // An undo group to store the two parts of the move operation (clear and paste).
      FDragStartPixel: TPoint;                // (Not currently used) Could be for pixel-perfect dragging.
      FModifiedTileAddr: Int64;               // (Not currently used) Could be for tracking a single modified tile.

      { Clipboard State }
      FCopiedTiles: TTileClipboardData;       // Holds the data for the last copy/cut operation.

      { Undo/Redo Stacks - Lists that manage the history of user actions }
      FUndoStack: TObjectList<TUndoableAction>;
      FRedoStack: TObjectList<TUndoableAction>;

      { Palette State Tracking }
      FMasterPaletteSource: TPaletteSourceType;
      FMasterPaletteInfo: string;
      FActivePaletteFile: string;

      { Private Methods - Internal logic for managing state and UI }
      procedure SetModified(AValue: Boolean);
      procedure UpdateAllViews;
      procedure UpdateTileViewer;
      procedure UpdateVerticalScrollerRange;
      procedure GenerateDefaultPalette;
      procedure PopulateCodecs;
      procedure PopulateColorCodecs;
      procedure DeselectTiles;
      procedure UpdateToolCursor;
      function FindClosestColorIndex(AColor: TColor): Integer;
      procedure PickColorAt(X, Y: Integer);
      procedure FloodFillTile(var ATilePixels: TArray<Integer>; AStartX, AStartY, AReplacementIndex: Integer);
      procedure CreateVirtualPixelMap(out AMap: TArray<Integer>; out AMapWidth, AMapHeight: Integer);
      procedure CreateVirtualPixelMapFromSelection(out AMap: TArray<Integer>; out AMapWidth, AMapHeight: Integer);
      procedure ApplyChangesFromPixelMap(const AOldMap, ANewMap: TArray<Integer>; AMapWidth, AMapHeight, AStartTileIndex, ABlockWidthInTiles: Integer);
      procedure PerformGlobalFill(AStartX, AStartY: Integer);
      procedure FlipHorizontal(var APixels: TArray<Integer>; AWidth, AHeight: Integer);
      procedure FlipVertical(var APixels: TArray<Integer>; AWidth, AHeight: Integer);
      procedure Rotate90Clockwise(var APixels: TArray<Integer>; var AWidth, AHeight: Integer);
      procedure ShiftPixels(var APixels: TArray<Integer>; ADeltaX, ADeltaY: Integer);
      procedure ChangeZoom(ADelta: Integer);
      procedure AddUndoAction(AOffset: Int64; const AOldData, ANewData: TBytes; ABlockWidth: Integer);
      procedure DoGoToOffset(AOffset: Int64);
      procedure NotifyStateChange;
      procedure UpdateActivePaletteFromMaster;
   public
      { Public Interface for MainForm - Methods called by the main form to interact with the document }
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;

      // Input Handling
      procedure DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
      procedure HandleKeyDown(var Key: Word; Shift: TShiftState);
      procedure HandleKeyUp(var Key: Word; Shift: TShiftState);

      // File Operations
      function LoadFromFile(const AFileName: string): Boolean;
      procedure SaveToFile(const AFileName: string);
      procedure Save;
      procedure SaveAs;
      procedure GoToOffset;

      // Project Operations
      procedure GetCurrentSettings(var Settings: TProjectFileInfo);
      procedure ApplyProjectSettings(const Settings: TProjectFileInfo);

      // Edit Operations
      procedure Undo;
      procedure Redo;
      procedure CopySelection;
      procedure CutSelection;
      procedure PasteSelection;

      // Import/Export
      procedure ExportSelectionToPNG;
      procedure ImportPNGToSelection;

      // Palette Operations
      procedure LoadMasterPalette;
      procedure LoadActivePalette;
      procedure SaveActivePalette;
      procedure LoadMasterPaletteFromROM;
      procedure UpdatePaletteFromROM(Offset: Integer = 0);

      // View Options
      procedure ToggleTileGrid;
      procedure TogglePixelGrid;

      // UI State
      procedure UpdateMenuState(AUndoItem, ARedoItem, ACutItem, ACopyItem, APasteItem, AExportPNGItem, AImportPNGItem: TMenuItem; ATileGridItem, APixelGridItem: TMenuItem);

      { Properties }
      property FileName: string read FCurrentFileName;
      property IsModified: Boolean read FModified;
      property IsTileGridVisible: Boolean read FIsTileGridVisible write FIsTileGridVisible;
      property IsPixelGridVisible: Boolean read FIsPixelGridVisible write FIsPixelGridVisible;
      property OnStateChange: TNotifyEvent read FOnStateChange write FOnStateChange;

      { Shared Component Setters - Allows the MainForm to inject its shared components }
      property OpenDialog: TOpenDialog write FOpenDialog;
      property SaveDialog: TSaveDialog write FSaveDialog;
      property OpenPaletteDialog: TOpenDialog write FOpenPaletteDialog;
      property ColorDialog: TColorDialog write FColorDialog;
      property StatusBar: TStatusBar write FStatusBar;
      property Zoom: Integer read FZoom;
   end;

implementation

uses
   System.IOUtils;

{$R *.dfm}

{ TDocumentFrame }

constructor TDocumentFrame.Create(AOwner: TComponent);
begin
   inherited;

   LOC.LoadLanguage(GSettings.LanguageFile);
   LOC.TranslateComponent(Self);

   // STATE INITIALIZATION
   FUndoStack := TObjectList<TUndoableAction>.Create(True);
   FRedoStack := TObjectList<TUndoableAction>.Create(True);
   FTileBitmap := TBitmap.Create;
   FColorCodecs := TObjectList<TColorCodec>.Create(True);
   FIsDragging := False;
   FSelectionRect := TRect.Empty;
   FHoverStartIndex := -1;
   FActivePaletteStartIndex := 0;
   FOnStateChange := nil;
   FIsTileGridVisible := True;
   FIsPixelGridVisible := False;
   FCurrentColorIndex := 0;

   // UI CONTROLS INITIALIZATION
   FTilesPerRow := GSettings.DefaultTilesPerRow;
   seTilesPerRow.Value := FTilesPerRow;
   FTilesPerColumn := GSettings.DefaultTilesPerColumn;
   seTilesPerColumn.Value := FTilesPerColumn;
   FZoom := GSettings.DefaultZoom;

   GenerateDefaultPalette;
   PopulateCodecs;
   PopulateColorCodecs;

   // Set initial defaults settings on UI controls
   var DefaultCodec := GCodecManager.GetCodec(GSettings.DefaultCodecID);
   if Assigned(DefaultCodec) then
      cbxCodecs.ItemIndex := cbxCodecs.Items.IndexOfObject(DefaultCodec)
   else if cbxCodecs.Items.Count > 0 then
      cbxCodecs.ItemIndex := 0;

   if cbxPaletteFormats.Items.Count >= GSettings.DefaultPaletteFormat then
      cbxPaletteFormats.ItemIndex := GSettings.DefaultPaletteFormat;

   // Set initial active objects
   FCurrentCodec := TTileCodec(cbxCodecs.Items.Objects[cbxCodecs.ItemIndex]);
   FCurrentColorCodec := TColorCodec(cbxPaletteFormats.Items.Objects[cbxPaletteFormats.ItemIndex]);
   FCurrentTool := tlPointer;
   UpdateToolCursor;
end;

destructor TDocumentFrame.Destroy;
begin
   // Free all owned objects
   FUndoStack.Free;
   FRedoStack.Free;
   FTileBitmap.Free;
   FColorCodecs.Free;

   inherited;
end;

function TDocumentFrame.LoadFromFile(const AFileName: string): Boolean;
begin
   try
      // Read all bytes from the specified file.
      FRomData := TFile.ReadAllBytes(AFileName);
      FCurrentFileName := AFileName;
      SetModified(False);
      if Assigned(FStatusBar) then
         FStatusBar.Panels[0].Text := AFileName;

      // Clear the undo/redo stacks for the new file.
      FUndoStack.Clear;
      FRedoStack.Clear;

      // Configure the horizontal offset scrollbar.
      sbOffset.Max := Length(FRomData) - 1;
      sbOffset.Position := 0;

      // Set a flag indicating the palette needs to be read from the new ROM on the first update.
      NewROM := True;

      // Update UI components based on the new data.
      UpdateVerticalScrollerRange;
      UpdateAllViews;
      // Select the first sub-palette by default.
      pbPaletteMouseDown(nil, mbLeft, [], 0, 0);

      Result := True;
   except on E: Exception do
   begin
      ShowMessage(LOC.Get('Messages', 'ErrorReadingFile', 'Error reading file: ') + E.Message);
      Result := False;
   end;
   end;
end;

procedure TDocumentFrame.SaveToFile(const AFileName: string);
begin
   try
      // Write the in-memory FRomData back to a file.
      TFile.WriteAllBytes(AFileName, FRomData);
      FCurrentFileName := AFileName; // Update the current filename.
      SetModified(False);           // Mark as saved and update the UI caption via OnStateChange.
   except on E: Exception do
      ShowMessage(LOC.Get('Messages', 'ErrorSavingFile', 'Error saving file: ') + E.Message);
   end;
end;

// --- PUBLIC ACTION METHODS (CALLED BY MAINFORM) ---

procedure TDocumentFrame.CopySelection;
var
   SelectionWidth, SelectionHeight, TotalTiles, BytesToCopy: Integer;
   ViewStartTile, SelectionStartTile, CurrentTileInRom: Integer;
   SourceAddr, DestIndexInClipboard: Int64;
   x, y: Integer;
begin
   // 1. Validations: Ensure there's a selection, a codec, and data to copy.
   if IsRectEmpty(FSelectionRect) or not Assigned(FCurrentCodec) or (Length(FRomData) = 0) then
      Exit;

   // 2. Get selection dimensions.
   SelectionWidth := FSelectionRect.Width;
   SelectionHeight := FSelectionRect.Height;
   TotalTiles := SelectionWidth * SelectionHeight;
   BytesToCopy := TotalTiles * FCurrentCodec.TileSize;

   // 3. Prepare the clipboard data structure.
   FCopiedTiles.Width := SelectionWidth;
   FCopiedTiles.Height := SelectionHeight;
   SetLength(FCopiedTiles.TileData, BytesToCopy);

   // 4. Calculate the index of the first tile in the selection relative to the start of the ROM data.
   ViewStartTile := vsbTileScroller.Position * FTilesPerRow;
   SelectionStartTile := ViewStartTile + (FSelectionRect.Top * FTilesPerRow) + FSelectionRect.Left;

   // 5. Copy the data, tile by tile, row by row.
   for y := 0 to SelectionHeight - 1 do
   begin
      for x := 0 to SelectionWidth - 1 do
      begin
         // Address of the source tile in the ROM data array.
         CurrentTileInRom := SelectionStartTile + (y * FTilesPerRow) + x;
         SourceAddr := (CurrentTileInRom * FCurrentCodec.TileSize) + sbOffset.Position;

         // Destination position in our clipboard data array.
         DestIndexInClipboard := (y * SelectionWidth + x) * FCurrentCodec.TileSize;

         // Copy the bytes for one tile.
         if (SourceAddr + FCurrentCodec.TileSize) <= Length(FRomData) then
            System.Move(FRomData[SourceAddr], FCopiedTiles.TileData[DestIndexInClipboard], FCurrentCodec.TileSize);
      end;
   end;

   // 6. Enable the "Paste" menu option.
   NotifyStateChange;
end;

procedure TDocumentFrame.CutSelection;
var
   TargetRect: TRect;
   ActionGroup: TUndoActionGroup;
   BlankTile, OldData: TBytes;
   BlankPixels: TArray<Integer>;
   TileSize, StartTile, TileIndex, x, y: Integer;
   Addr: Int64;
begin
   // Initial validation: must have a selection.
   if IsRectEmpty(FSelectionRect) or not Assigned(FCurrentCodec) or (Length(FRomData) = 0) then
      Exit;

   // --- PART 1: COPY ---
   // Simply call the existing Copy function.
   Self.CopySelection;

   // --- PART 2: ERASE (Fill with blank tiles) ---

   // 1. Prepare a "blank" tile (all pixels with index 0).
   TileSize := FCurrentCodec.TileSize;
   SetLength(BlankPixels, 64); // An array of 64 integers is initialized with zeros.
   SetLength(BlankTile, TileSize);
   FCurrentCodec.Encode(BlankPixels, BlankTile, 0, 0);

   // 2. Prepare an undo group for the erase operation.
   ActionGroup := TUndoActionGroup.Create;
   FUndoStack.Add(ActionGroup);

   // 3. Iterate over the selection, clearing each tile and recording the action.
   TargetRect := FSelectionRect;
   StartTile := vsbTileScroller.Position * FTilesPerRow;

   for y := TargetRect.Top to TargetRect.Bottom - 1 do
   begin
      for x := TargetRect.Left to TargetRect.Right - 1 do
      begin
         TileIndex := StartTile + (y * FTilesPerRow) + x;
         Addr := (TileIndex * TileSize) + sbOffset.Position;

         if Addr + TileSize <= Length(FRomData) then
         begin
            // a. Save the old data for the Undo action.
            SetLength(OldData, TileSize);
            System.Move(FRomData[Addr], OldData[0], TileSize);

            // b. Write the blank tile into the ROM data.
            System.Move(BlankTile[0], FRomData[Addr], TileSize);

            // c. Add the "erase" action to the undo group.
            ActionGroup.Add(TUndoAction.Create(Addr, OldData, BlankTile, 1, TileSize, FTilesPerRow));
         end;
      end;
   end;

   // 4. Finalize the operation and update the screen.
   if ActionGroup.Count > 0 then
   begin
      SetModified(True);
      FRedoStack.Clear;
      UpdateTileViewer;
   end
   else // If nothing was done, remove the empty undo group.
   begin
      FUndoStack.Remove(ActionGroup);
      ActionGroup.Free;
   end;

   // 6. Enable the Paste menu option.
   NotifyStateChange;
end;

procedure TDocumentFrame.ExportSelectionToPNG;
var
   SelectionWidth, SelectionHeight, ImageWidth, ImageHeight: Integer;
   ViewStartTile, SelectionStartTile, CurrentTileInRom, PixelIndex: Integer;
   x, y, px, py: Integer;
   SourceAddr: Int64;
   OutputBitmap: TBitmap;
   PNG: TPNGObject;
   DecodedPixels: TArray<Integer>;
   DestRect: TRect;
begin
   // 1. Validations.
   if IsRectEmpty(FSelectionRect) or not Assigned(FCurrentCodec) or (Length(FActivePalette) = 0) then
   begin
      ShowMessage(LOC.Get('Messages', 'NoValidSelectionExport', 'No valid selection to export.'));
      Exit;
   end;

   // 2. Configure and show the save dialog.
   FSaveDialog.Filter := LOC.Get('Messages', 'PNGImageFilter', 'PNG Image (*.png)|*.png');
   FSaveDialog.DefaultExt := 'png';
   if not FSaveDialog.Execute then
      Exit;

   // 3. Prepare the output Bitmap.
   SelectionWidth := FSelectionRect.Width;
   SelectionHeight := FSelectionRect.Height;
   ImageWidth := SelectionWidth * 8;
   ImageHeight := SelectionHeight * 8;
   OutputBitmap := TBitmap.Create;
   try
      OutputBitmap.SetSize(ImageWidth, ImageHeight);

      // 4. Draw each tile from the selection onto the output Bitmap.
      ViewStartTile := vsbTileScroller.Position * FTilesPerRow;
      SelectionStartTile := ViewStartTile + (FSelectionRect.Top * FTilesPerRow) + FSelectionRect.Left;

      for y := 0 to SelectionHeight - 1 do
      begin
         for x := 0 to SelectionWidth - 1 do
         begin
            CurrentTileInRom := SelectionStartTile + (y * FTilesPerRow) + x;
            SourceAddr := (CurrentTileInRom * FCurrentCodec.TileSize) + sbOffset.Position;

            if (SourceAddr + FCurrentCodec.TileSize) <= Length(FRomData) then
            begin
               // Decode the tile data to get pixel indices.
               DecodedPixels := FCurrentCodec.Decode(FRomData, SourceAddr, 0);
               PixelIndex := 0;
               // Draw the tile pixel by pixel using the active palette.
               for py := 0 to 7 do
               begin
                  for px := 0 to 7 do
                  begin
                     if DecodedPixels[PixelIndex] < Length(FActivePalette) then
                        OutputBitmap.Canvas.Pixels[x * 8 + px, y * 8 + py] := FActivePalette[DecodedPixels[PixelIndex]];
                     Inc(PixelIndex);
                  end;
               end;
            end;
         end;
      end;

      // 5. Save the Bitmap as a PNG file.
      PNG := TPNGObject.Create;
      try
         PNG.Assign(OutputBitmap);
         PNG.SaveToFile(FSaveDialog.FileName);
      finally
         PNG.Free;
      end;
   finally
      OutputBitmap.Free;
   end;
end;

procedure TDocumentFrame.GoToOffset;
var
   TargetOffset: Int64;
   CurrentOffset: Int64;
begin
   if Length(FRomData) = 0 then
   begin
      ShowMessage(LOC.Get('Messages', 'NoFileLoaded', 'No file loaded.'));
      Exit;
   end;

   // The current offset is calculated from the start of the visible tile area.
   CurrentOffset := (vsbTileScroller.Position * FTilesPerRow * FCurrentCodec.TileSize) + sbOffset.Position;

   // Call our GoTo form as a class function.
   if TGoToForm.Execute(CurrentOffset, Length(FRomData) - 1, TargetOffset) then
   begin
      // If the user confirmed and the input was valid, navigate to the offset.
      DoGoToOffset(TargetOffset);
   end;
end;

procedure TDocumentFrame.HandleKeyDown(var Key: Word; Shift: TShiftState);
var
  PaintBoxRect: TRect;
begin
   // If CTRL is pressed and the active tool is the Pencil, temporarily switch to Eyedropper mode.
   if (Key = VK_CONTROL) and (FCurrentTool = tlPencil) then
   begin
      // 1. Get the PaintBox rectangle in SCREEN coordinates.
      PaintBoxRect := pbTileViewer.ClientToScreen(pbTileViewer.ClientRect);

      // 2. Check if the global mouse cursor is within that rectangle.
      if PtInRect(PaintBoxRect, Mouse.CursorPos) then
      begin
         // Only change the cursor if it's not already the hand point.
         if Screen.Cursor <> crHandPoint then
            Screen.Cursor := crHandPoint;
      end;
   end;
end;

procedure TDocumentFrame.HandleKeyUp(var Key: Word; Shift: TShiftState);
begin
   // When CTRL is released, restore the correct cursor for the current tool.
   if Key = VK_CONTROL then
   begin
      UpdateToolCursor;
   end;
end;

procedure TDocumentFrame.ImportPNGToSelection;
var
   PNG: TPNGObject;
   ImportedBitmap: TBitmap;
   DecodedPixels: TArray<Integer>;
   ImportWidthInTiles, ImportHeightInTiles: Integer;
   ViewStartTile, SelectionStartTile, CurrentTileInRom, TileSize, TotalTiles: Integer;
   x, y, px, py: Integer;
   DestAddr, DestIndexInBlock: Int64;
   PixelColor: TColor;
   BigOldData, BigNewData, EncodedTile: TBytes;
   SelectionStartAddr: Int64;
begin
   // 1. Initial Validation: Selection is needed to define the starting point.
   if IsRectEmpty(FSelectionRect) or not Assigned(FCurrentCodec) then
   begin
      ShowMessage(LOC.Get('Messages', 'SelectStartCellImport', 'Please select a starting cell to import the image.'));
      Exit;
   end;

   // 2. Open Dialog.
   FOpenDialog.Filter := LOC.Get('Messages', 'PNGImageFilter', 'PNG Image (*.png)|*.png');
   if not FOpenDialog.Execute then
      Exit;

   // 3. Load Image.
   PNG := TPNGObject.Create;
   ImportedBitmap := TBitmap.Create;
   try
      PNG.LoadFromFile(FOpenDialog.FileName);
      ImportedBitmap.Assign(PNG);

      // 4. NEW VALIDATION: Check if image dimensions are multiples of 8.
      if (ImportedBitmap.Width mod 8 <> 0) or (ImportedBitmap.Height mod 8 <> 0) then
      begin
      ShowMessage(Format(LOC.Get('Messages', 'ImageDimensionsMustBeMultipleOf8', 'Image dimensions (%dx%d) must be multiples of 8 to be imported as tiles.'),
                  [ImportedBitmap.Width, ImportedBitmap.Height]));
      Exit;
      end;

      // 5. Prepare Data Structures (based on IMAGE dimensions).
      TileSize := FCurrentCodec.TileSize;
      ImportWidthInTiles := ImportedBitmap.Width div 8;
      ImportHeightInTiles := ImportedBitmap.Height div 8;
      TotalTiles := ImportWidthInTiles * ImportHeightInTiles;

      SetLength(BigOldData, TotalTiles * TileSize); // To store all old data for one undo action.
      SetLength(BigNewData, TotalTiles * TileSize); // To store all new data for one redo action.
      SetLength(DecodedPixels, 64);
      SetLength(EncodedTile, TileSize);

      // The import starting point is the top-left of the current selection.
      ViewStartTile := vsbTileScroller.Position * FTilesPerRow;
      SelectionStartTile := ViewStartTile + (FSelectionRect.Top * FTilesPerRow) + FSelectionRect.Left;
      SelectionStartAddr := (SelectionStartTile * TileSize) + sbOffset.Position;

      // 6. Process Image (Main loop, based on IMAGE dimensions).
      for y := 0 to ImportHeightInTiles - 1 do
      begin
         for x := 0 to ImportWidthInTiles - 1 do
         begin
            CurrentTileInRom := SelectionStartTile + (y * FTilesPerRow) + x;
            DestAddr := (CurrentTileInRom * TileSize) + sbOffset.Position;
            DestIndexInBlock := (y * ImportWidthInTiles + x) * TileSize;

            if (DestAddr + TileSize) <= Length(FRomData) then
            begin
               // Save old data.
               System.Move(FRomData[DestAddr], BigOldData[DestIndexInBlock], TileSize);
               // For each tile in the image...
               for py := 0 to 7 do
                  for px := 0 to 7 do
                  begin
                     //...get the color of each pixel and find the closest match in our active palette.
                     PixelColor := ImportedBitmap.Canvas.Pixels[x * 8 + px, y * 8 + py];
                     DecodedPixels[py * 8 + px] := FindClosestColorIndex(PixelColor);
                  end;
               // Encode the new tile data.
               FCurrentCodec.Encode(DecodedPixels, EncodedTile, 0, 0);
               // Write the new tile to the ROM data and save it for the undo action.
               System.Move(EncodedTile[0], FRomData[DestAddr], TileSize);
               System.Move(EncodedTile[0], BigNewData[DestIndexInBlock], TileSize);
            end;
         end;
      end;

      // 7. Register a single atomic Undo Action (with IMAGE width).
      AddUndoAction(SelectionStartAddr, BigOldData, BigNewData, ImportWidthInTiles);

      // 8. Finalize and Update.
      SetModified(True);
      UpdateTileViewer;
   finally
      ImportedBitmap.Free;
      PNG.Free;
   end;
end;

procedure TDocumentFrame.LoadActivePalette;
var
   PaletteData: TBytes;
   i, ColorsToLoad: Integer;
begin
   FOpenPaletteDialog.Filter := LOC.Get('Messages', 'PaletteDialogFilter', 'Tile Bulinator Palette (*.tbpal)|*.tbpal|All Files (*.*)|*.*');
   FOpenPaletteDialog.FilterIndex := 1;

   if FOpenPaletteDialog.Execute then
   begin
      try
         PaletteData := TFile.ReadAllBytes(FOpenPaletteDialog.FileName);
         // The number of colors is the file size divided by 3 (R,G,B).
         ColorsToLoad := Length(PaletteData) div 3;

         // Resize the active palette and fill it.
         SetLength(FActivePalette, ColorsToLoad);
         for i := 0 to ColorsToLoad - 1 do
            FActivePalette[i] := RGB(PaletteData[i * 3], PaletteData[i * 3 + 1], PaletteData[i * 3 + 2]);

//         for i := 0 to High(FActivePalette) do
//         begin
//            if (FActivePaletteStartIndex + i) < Length(FCurrentPalette) then
//               FCurrentPalette[FActivePaletteStartIndex + i] := FActivePalette[i];
//         end;

         // Tracks the palette's state
         FActivePaletteFile := FOpenPaletteDialog.FileName;

         // Mark as modified and update everything.
         SetModified(True);
         pbActivePalette.Invalidate;
         UpdateTileViewer;
      except on E: Exception do
         ShowMessage(LOC.Get('Messages', 'ErrorLoadingPaletteFile', 'Error loading palette file: ') + E.Message);
      end;
   end;
end;

procedure TDocumentFrame.LoadMasterPalette;
var
   LPaletteData: TBytes;
begin
   FOpenPaletteDialog.FilterIndex := 2;
   if not Assigned(FCurrentColorCodec) then
   begin
      ShowMessage(LOC.Get('Messages', 'SelectPaletteFormatFirst', 'Please select a palette data format first.'));
      Exit;
   end;
   if FOpenPaletteDialog.Execute then
   begin
      try
         // Read raw palette data from a file and decode it using the selected color codec.
         LPaletteData := TFile.ReadAllBytes(FOpenPaletteDialog.FileName);
         FCurrentColorCodec.Decode(LPaletteData, FCurrentPalette);

         // Tracks the palette's state
         FMasterPaletteSource := pstExternalFile;
         FMasterPaletteInfo := FOpenPaletteDialog.FileName;
         FActivePaletteFile := '';

         UpdateAllViews;
      except on E: Exception do
         ShowMessage(LOC.Get('Messages', 'ErrorLoadingPaletteFile', 'Error loading palette file: ' + E.Message));
      end;
   end;
end;

procedure TDocumentFrame.LoadMasterPaletteFromROM;
var
   TargetOffset: Int64;
   CurrentOffset: Int64;
begin
   if Length(FRomData) = 0 then
   begin
      ShowMessage(LOC.Get('Messages', 'NoFileLoaded', 'No file loaded.'));
      Exit;
   end;

   CurrentOffset := (vsbTileScroller.Position * FTilesPerRow * FCurrentCodec.TileSize) + sbOffset.Position;

   // Use the GoToForm to ask the user for an offset.
   if TGoToForm.Execute(CurrentOffset, Length(FRomData) - 1, TargetOffset, LOC.Get('Messages', 'LoadMasterPaletteFromROM_Caption', 'Load Master Palette from ROM')) then
   begin
      // If valid, load the palette from that offset.
      UpdatePaletteFromROM(TargetOffset);
   end;
end;

procedure TDocumentFrame.NotifyStateChange;
begin
   // Fires the event to let the MainForm know it needs to update its state (e.g., menu items, window caption).
   if Assigned(FOnStateChange) then
      FOnStateChange(Self);
end;

procedure TDocumentFrame.PasteSelection;
var
   PasteStartTile, ViewStartTile, DestTileInRom: Integer;
   SourceIndexInClipboard, DestAddr, PasteStartAddr: Int64;
   x, y, SelectionWidth, SelectionHeight: Integer;
   OldDataBlock, NewDataBlock: TBytes;
   TotalTiles, TileSize, DestIndexInBlock: Integer;
begin
   // 1. Validations.
   if (Length(FCopiedTiles.TileData) = 0) or IsRectEmpty(FSelectionRect) or not Assigned(FCurrentCodec) then
      Exit;

   TileSize := FCurrentCodec.TileSize;
   SelectionWidth := FCopiedTiles.Width;
   SelectionHeight := FCopiedTiles.Height;
   TotalTiles := SelectionWidth * SelectionHeight;

   // 1. Prepare two large arrays to hold all old and new data for a single undo action.
   SetLength(OldDataBlock, TotalTiles * TileSize);
   SetLength(NewDataBlock, TotalTiles * TileSize);

   // Calculate the starting address for the paste operation.
   ViewStartTile := vsbTileScroller.Position * FTilesPerRow;
   PasteStartTile := ViewStartTile + (FSelectionRect.Top * FTilesPerRow) + FSelectionRect.Left;
   PasteStartAddr := (PasteStartTile * TileSize) + sbOffset.Position;

   // 2. Fill the OldDataBlock and NewDataBlock arrays and paste into the ROM data simultaneously.
   for y := 0 to SelectionHeight - 1 do
   begin
      for x := 0 to SelectionWidth - 1 do
      begin
         SourceIndexInClipboard := (y * SelectionWidth + x) * TileSize;
         DestTileInRom := PasteStartTile + (y * FTilesPerRow) + x;
         DestAddr := (DestTileInRom * TileSize) + sbOffset.Position;
         DestIndexInBlock := (y * SelectionWidth + x) * TileSize;

         if (DestAddr + TileSize) <= Length(FRomData) then
         begin
         // Save the old data to our large array.
         System.Move(FRomData[DestAddr], OldDataBlock[DestIndexInBlock], TileSize);
         // Save the new data to our large array.
         System.Move(FCopiedTiles.TileData[SourceIndexInClipboard], NewDataBlock[DestIndexInBlock], TileSize);
         // Perform the actual paste into the ROM data.
         System.Move(NewDataBlock[DestIndexInBlock], FRomData[DestAddr], TileSize);
         end;
      end;
   end;

   // 3. Add A SINGLE undo action for the entire block.
   AddUndoAction(PasteStartAddr, OldDataBlock, NewDataBlock, SelectionWidth);

   SetModified(True);
   UpdateTileViewer;
end;

procedure TDocumentFrame.Redo;
var
   Action: TUndoableAction;
   SingleAction: TUndoAction;
   ActionGroup: TUndoActionGroup;
   i, x, y, SourceIndexInBlock: Integer;
   DestAddr: Int64;
   BlockHeight: Integer;
begin
   if FRedoStack.Count = 0 then
      Exit;

   // 1. Get the last action from the redo stack.
   Action := FRedoStack.Last;
   FRedoStack.Extract(Action);

   // 2. Handle group actions (from Fill Bucket, etc.).
   if Action is TUndoActionGroup then
   begin
      ActionGroup := Action as TUndoActionGroup;
      // Iterate through the group's actions IN FORWARD ORDER to redo them.
      for i := 0 to ActionGroup.Count - 1 do
      begin
         SingleAction := ActionGroup.Actions[i];
         System.Move(SingleAction.NewData[0], FRomData[SingleAction.Offset], Length(SingleAction.NewData));
      end;
   end
   // Handle selection changes.
   else if Action is TSelectionChangeAction then
   begin
      // Redo the selection change.
      FSelectionRect := (Action as TSelectionChangeAction).NewSelection;
      pbTileViewer.Invalidate;
   end
   // 3. Handle single actions (from Pencil, Paste, Import, etc.).
   else if Action is TUndoAction then
   begin
      SingleAction := Action as TUndoAction;
      // Check if the action represents a block or a single tile.
      if (SingleAction.BlockWidth > 1) or (Length(SingleAction.NewData) > SingleAction.TileSize) then
      begin
         // Logic to redo a block.
         BlockHeight := Length(SingleAction.NewData) div (SingleAction.BlockWidth * SingleAction.TileSize);
         for y := 0 to BlockHeight - 1 do
         begin
            for x := 0 to SingleAction.BlockWidth - 1 do
            begin
               SourceIndexInBlock := (y * SingleAction.BlockWidth + x) * SingleAction.TileSize;
               DestAddr := SingleAction.Offset + (y * SingleAction.TilesPerRow * SingleAction.TileSize) + (x * SingleAction.TileSize);

               if (DestAddr + SingleAction.TileSize) <= Length(FRomData) then
                  System.Move(SingleAction.NewData[SourceIndexInBlock], FRomData[DestAddr], SingleAction.TileSize);
            end;
         end;
      end
      else
      begin
         // Logic to redo a single tile.
         System.Move(SingleAction.NewData[0], FRomData[SingleAction.Offset], Length(SingleAction.NewData));
      end;
   end;

   // 4. Move the action back to the undo stack.
   FUndoStack.Add(Action);

   // 5. Update UI.
   SetModified(True);
   UpdateAllViews;
   NotifyStateChange;
end;

procedure TDocumentFrame.Save;
begin
   // If the file already has a name, save directly.
   if FCurrentFileName <> '' then
      SaveToFile(FCurrentFileName)
   else // Otherwise, act as "Save As...".
      Self.SaveAs;
end;

procedure TDocumentFrame.SaveAs;
begin
   // Show the dialog for the user to choose a name and location.
   FSaveDialog.Filter := LOC.Get('Messages', 'SaveDialogFilter', 'All Files (*.*)|*.*');
   FSaveDialog.DefaultExt := '';
   if FSaveDialog.Execute then
   begin
      SaveToFile(FSaveDialog.FileName);
   end;
end;

procedure TDocumentFrame.SaveActivePalette;
var
   PaletteData: TBytes;
   i: Integer;
   ColorRGB: TColor;
begin
   if Length(FActivePalette) = 0 then
   begin
      ShowMessage(LOC.Get('Messages', 'NoActivePaletteToSave', 'There is no active palette to save.'));
      Exit;
   end;

   FSaveDialog.Filter := LOC.Get('Messages', 'PaletteDialogFilter', 'Tile Bulinator Palette (*.tbpal)|*.tbpal|All Files (*.*)|*.*');
   FSaveDialog.DefaultExt := 'tbpal';
   if FSaveDialog.Execute then
   begin
      // Prepare the byte array. Each color will be saved as 3 bytes (R, G, B).
      SetLength(PaletteData, Length(FActivePalette) * 3);
      for i := 0 to High(FActivePalette) do
      begin
         ColorRGB := FActivePalette[i];
         PaletteData[i * 3]     := GetRValue(ColorRGB);
         PaletteData[i * 3 + 1] := GetGValue(ColorRGB);
         PaletteData[i * 3 + 2] := GetBValue(ColorRGB);
      end;

      // Save the bytes to the file.
      try
         TFile.WriteAllBytes(FSaveDialog.FileName, PaletteData);
      except on E: Exception do
         ShowMessage(LOC.Get('Messages', 'ErrorSavingPaletteFile', 'Error saving palette file: ') + E.Message);
      end;
   end;
end;

procedure TDocumentFrame.TogglePixelGrid;
begin
   FIsPixelGridVisible := not FIsPixelGridVisible;
   pbTileViewer.Invalidate;
end;

procedure TDocumentFrame.ToggleTileGrid;
begin
   FIsTileGridVisible := not FIsTileGridVisible;
   pbTileViewer.Invalidate;
end;

procedure TDocumentFrame.Undo;
var
   Action: TUndoableAction;
   SingleAction: TUndoAction;
   ActionGroup: TUndoActionGroup;
   i, x, y, SourceIndexInBlock: Integer;
   DestAddr: Int64;
   BlockHeight: Integer;
begin
   if FUndoStack.Count = 0 then Exit;

   // 1. Get the last action from the undo stack.
   Action := FUndoStack.Last;
   FUndoStack.Extract(Action);

   // 2. Handle group actions (from Fill Bucket, etc.).
   if Action is TUndoActionGroup then
   begin
      ActionGroup := Action as TUndoActionGroup;
      // Iterate through the group's actions IN REVERSE ORDER to undo them correctly.
      for i := ActionGroup.Count - 1 downto 0 do
      begin
         SingleAction := ActionGroup.Actions[i];
         // Group actions are always for single tiles.
         System.Move(SingleAction.OldData[0], FRomData[SingleAction.Offset], Length(SingleAction.OldData));
      end;
   end
   // Handle selection changes.
   else if Action is TSelectionChangeAction then
   begin
      // Undo the selection change.
      FSelectionRect := (Action as TSelectionChangeAction).OldSelection;
      pbTileViewer.Invalidate;
   end
   // 3. Handle single actions (from Pencil, Paste, Import, etc.).
   else if Action is TUndoAction then
   begin
      SingleAction := Action as TUndoAction;
      // Check if the action represents a block or a single tile.
      if (SingleAction.BlockWidth > 1) or (Length(SingleAction.OldData) > SingleAction.TileSize) then
      begin
         // Logic to undo a block (Paste, Import).
         BlockHeight := Length(SingleAction.OldData) div (SingleAction.BlockWidth * SingleAction.TileSize);
         for y := 0 to BlockHeight - 1 do
         begin
            for x := 0 to SingleAction.BlockWidth - 1 do
            begin
               SourceIndexInBlock := (y * SingleAction.BlockWidth + x) * SingleAction.TileSize;
               DestAddr := SingleAction.Offset + (y * SingleAction.TilesPerRow * SingleAction.TileSize) + (x * SingleAction.TileSize);

               if (DestAddr + SingleAction.TileSize) <= Length(FRomData) then
                  System.Move(SingleAction.OldData[SourceIndexInBlock], FRomData[DestAddr], SingleAction.TileSize);
            end;
         end;
      end
      else
      begin
         // Logic to undo a single tile (Pencil).
         System.Move(SingleAction.OldData[0], FRomData[SingleAction.Offset], Length(SingleAction.OldData));
      end;
   end;

   // 4. Move the action (whether single or group) to the redo stack.
   FRedoStack.Add(Action);

   // 5. Update UI.
   SetModified(True);
   UpdateAllViews;
   NotifyStateChange;
end;

procedure TDocumentFrame.UpdateMenuState(AUndoItem, ARedoItem, ACutItem, ACopyItem, APasteItem, AExportPNGItem, AImportPNGItem: TMenuItem; ATileGridItem, APixelGridItem: TMenuItem);
var
   HasSelection: Boolean;
begin
   // Undo/Redo state.
   AUndoItem.Enabled := FUndoStack.Count > 0;
   ARedoItem.Enabled := FRedoStack.Count > 0;

   // Clipboard state.
   HasSelection := not IsRectEmpty(FSelectionRect);
   ACutItem.Enabled := HasSelection;
   ACopyItem.Enabled := HasSelection;
   APasteItem.Enabled := Length(FCopiedTiles.TileData) > 0;

   // PNG state (only works with a selection).
   AExportPNGItem.Enabled := HasSelection;
   AImportPNGItem.Enabled := HasSelection;

   // View Grid state.
   ATileGridItem.Checked := FIsTileGridVisible;
   APixelGridItem.Checked := FIsPixelGridVisible;
end;

// --- PRIVATE EVENTS AND METHODS ---

procedure TDocumentFrame.SetModified(AValue: Boolean);
begin
   if FModified <> AValue then
   begin
      FModified := AValue;
      // Notify the main form that the modification state has changed.
      NotifyStateChange;
   end;
end;

procedure TDocumentFrame.UpdateActivePaletteFromMaster;
var
   SubPaletteSize, i: Integer;
begin
   if not Assigned(FCurrentCodec) then
      Exit;

   // Calcula o tamanho da sub-paleta com base no BPP do codec
   SubPaletteSize := 1 shl FCurrentCodec.BitsPerPixel;
   SetLength(FActivePalette, SubPaletteSize);

   // Popula o array FActivePalette a partir da FCurrentPalette, usando o FActivePaletteStartIndex
   for i := 0 to SubPaletteSize - 1 do
   begin
      if (FActivePaletteStartIndex + i) < Length(FCurrentPalette) then
         FActivePalette[i] := FCurrentPalette[FActivePaletteStartIndex + i]
      else
         FActivePalette[i] := clBlack; // Cor padrão se o índice estiver fora dos limites
   end;

   // Invalida os paintboxes para forçar o redesenho com as novas paletas
   pbActivePalette.Invalidate;
   pbPalette.Invalidate;
end;

procedure TDocumentFrame.UpdateAllViews;
begin
   if Length(FRomData) = 0 then
      Exit;
   if not Assigned(FCurrentCodec) then
      Exit;

   // If this is a newly loaded ROM, load the palette from it first.
   if NewROM then
      UpdatePaletteFromROM
   else
      pbPalette.Invalidate;

   UpdateTileViewer;
end;

procedure TDocumentFrame.UpdateTileViewer;
var
   TileX, TileY, px, py, Addr, TileIndex, TilesPerRow, PixelIndex, StartTile: Integer;
   DecodedPixels: TArray<Integer>;
   DestRect: TRect;
   SingleTileBitmap: TBitmap;
begin
   // Guard clauses to prevent errors if nothing is loaded.
   if not Assigned(FCurrentCodec) then
      Exit;
   if Length(FRomData) = 0 then
      Exit;

   // Prepare the off-screen bitmap that will be drawn to the screen.
   FTileBitmap.SetSize(pbTileViewer.ClientWidth, pbTileViewer.ClientHeight);
   FTileBitmap.Canvas.Brush.Color := TColor($00333333); // Custom background color.
   FTileBitmap.Canvas.FillRect(FTileBitmap.Canvas.ClipRect);

   // Create a temporary 8x8 bitmap to render a single tile.
   SingleTileBitmap := TBitmap.Create;
   try
      SingleTileBitmap.SetSize(8, 8);
      TilesPerRow := FTilesPerRow;

      // Calculate the starting tile based on the vertical scroll position.
      StartTile := vsbTileScroller.Position * TilesPerRow;

      // The vertical loop now uses the manual FTilesPerColumn value.
      for TileY := 0 to FTilesPerColumn - 1 do
      begin
         for TileX := 0 to TilesPerRow - 1 do
         begin
            // Calculate the absolute index of the tile to be drawn.
            TileIndex := StartTile + (TileY * TilesPerRow) + TileX;

            // The horizontal scrollbar acts as a fine-tune byte offset.
            Addr := (TileIndex * FCurrentCodec.TileSize) + sbOffset.Position;

            // If the calculated address is beyond the end of the file, stop drawing.
            if Addr + FCurrentCodec.TileSize > Length(FRomData) then
            Break; // Exit the inner loop (TileX).

            // Decode the tile and draw it pixel by pixel onto the temporary bitmap.
            DecodedPixels := FCurrentCodec.Decode(FRomData, Addr, 0);
            PixelIndex := 0;
            for py := 0 to 7 do
            begin
               for px := 0 to 7 do
               begin
                  if DecodedPixels[PixelIndex] < Length(FActivePalette) then
                     SingleTileBitmap.Canvas.Pixels[px, py] := FActivePalette[DecodedPixels[PixelIndex]]
                  else
                     SingleTileBitmap.Canvas.Pixels[px, py] := clFuchsia; // Error color for invalid index.

                  Inc(PixelIndex);
               end;
            end;

            // Draw the temporary bitmap (zoomed) onto the main off-screen bitmap.
            DestRect := TRect.Create(TileX * 8 * FZoom, TileY * 8 * FZoom, (TileX + 1) * 8 * FZoom, (TileY + 1) * 8 * FZoom);
            FTileBitmap.Canvas.StretchDraw(DestRect, SingleTileBitmap);
         end;

         // If the last calculated address was already past the end, stop the outer loop as well.
         if Addr + FCurrentCodec.TileSize > Length(FRomData) then
            Break; // Exit the outer loop (TileY).
      end;
   finally
      SingleTileBitmap.Free;
   end;

   // Invalidate the PaintBox to force an OnPaint event, which will draw the FTileBitmap to the screen.
   pbTileViewer.Invalidate;
end;

procedure TDocumentFrame.UpdateVerticalScrollerRange;
var
   TotalTiles, TotalRows: Integer;
begin
   if (Length(FRomData) = 0) or not Assigned(FCurrentCodec) or (FCurrentCodec.TileSize = 0) or (FTilesPerRow = 0) then
   begin
      vsbTileScroller.Max := 0;
      vsbTileScroller.Enabled := False;
      Exit;
   end;

   TotalTiles := Length(FRomData) div FCurrentCodec.TileSize;
   TotalRows := TotalTiles div FTilesPerRow;

   vsbTileScroller.Enabled := True;
   vsbTileScroller.Max := TotalRows;
   vsbTileScroller.Position := 0;
end;

procedure TDocumentFrame.vsbTileScrollerScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
   // When the scrollbar moves, just update the tile view.
   UpdateTileViewer;
end;

procedure TDocumentFrame.UpdatePaletteFromROM(Offset: Integer = 0);
var
   LDataToDecode: TBytes;
   LBytesToRead: Integer;
begin
   if not Assigned(FCurrentColorCodec) then
      Exit;
   if Length(FRomData) = 0 then
      Exit;
   // Read 512 bytes (256 colors * 2 bytes/color for common formats)
   LBytesToRead := 512;
   if Offset + LBytesToRead > Length(FRomData) then
      LBytesToRead := Length(FRomData) - Offset;
   SetLength(LDataToDecode, LBytesToRead);
   System.Move(FRomData[Offset], LDataToDecode[0], LBytesToRead);
   FCurrentColorCodec.Decode(LDataToDecode, FCurrentPalette);

   // Tracks the palette's state
   FMasterPaletteSource := pstRomOffset;
   FMasterPaletteInfo := IntToStr(Offset); // Salva o offset como string
   FActivePaletteFile := '';

   pbPalette.Invalidate;
   NewROM := False; // The initial palette has been loaded.
end;

procedure TDocumentFrame.GenerateDefaultPalette;
var
   i: Integer;
begin
   // Creates a default 256-color grayscale palette.
   SetLength(FCurrentPalette, 256);
   for i := 0 to 255 do
      FCurrentPalette[i] := RGB(i, i, i);

   // Tracks the palette's state
   FMasterPaletteSource := pstDefault;
   FMasterPaletteInfo := '';
   FActivePaletteFile := '';
end;

procedure TDocumentFrame.PopulateCodecs;
var
   LCodec: TTileCodec;
begin
   // Fills the codec combobox from the global Codec Manager.
   cbxCodecs.Items.Clear;
   for LCodec in GCodecManager.Codecs.Values do
      cbxCodecs.Items.AddObject(LCodec.Description, LCodec);
end;

procedure TDocumentFrame.PopulateColorCodecs;
var
   LColorCodec: TColorCodec;
begin
   // Fills the palette format combobox with available color codecs.
   FColorCodecs.Add(T15bgrColorCodec.Create);
   FColorCodecs.Add(T24rgbColorCodec.Create);
   cbxPaletteFormats.Items.Clear;
   for LColorCodec in FColorCodecs do
      cbxPaletteFormats.Items.AddObject(LColorCodec.Description, LColorCodec);
end;

procedure TDocumentFrame.DeselectTiles;
begin
   // If a selection exists, clear it and update the screen.
   if not IsRectEmpty(FSelectionRect) then
   begin
      // Create an action representing the change from a valid selection to an empty one.
      var Action := TSelectionChangeAction.Create(FSelectionRect, TRect.Empty);
      FUndoStack.Add(Action);
      FRedoStack.Clear;

      // Clear the selection and update the UI.
      FSelectionRect := TRect.Empty;
      pbTileViewer.Invalidate;
      NotifyStateChange;
   end;
end;

procedure TDocumentFrame.UpdateToolCursor;
var
   PaintBoxRect: TRect;
begin
   // Updates the mouse cursor based on the active tool, but only if the cursor is over the tile viewer.
   PaintBoxRect := pbTileViewer.ClientToScreen(pbTileViewer.ClientRect);
   if PtInRect(PaintBoxRect, Mouse.CursorPos) then
   begin
      case FCurrentTool of
         tlPointer:        Screen.Cursor := crDefault;
         tlPencil:         Screen.Cursor := crCross;
         tlFillBucket:     Screen.Cursor := crDrag;
         tlEyedropper:     Screen.Cursor := crHelp;
         tlColorReplacer:  Screen.Cursor := crSizeAll;
         tlZoom:           Screen.Cursor := crDefault;
         tlMove:           Screen.Cursor := crSizeAll;
      end;
   end;
end;

function TDocumentFrame.FindClosestColorIndex(AColor: TColor): Integer;
var
   i: Integer;
   MinDist: Int64;
   BestIndex: Integer;
   Dist: Int64;
   r1, g1, b1, r2, g2, b2: Integer;
begin
   // If the active palette is empty, return 0 to prevent errors.
   if Length(FActivePalette) = 0 then
   begin
      Result := 0;
      Exit;
   end;

   // 1. Initialize values with the FIRST color of the palette.
   BestIndex := 0;
   r1 := GetRValue(AColor);
   g1 := GetGValue(AColor);
   b1 := GetBValue(AColor);

   r2 := GetRValue(FActivePalette[0]);
   g2 := GetGValue(FActivePalette[0]);
   b2 := GetBValue(FActivePalette[0]);
   // Calculate squared Euclidean distance to avoid slow square roots.
   MinDist := Sqr(r1 - r2) + Sqr(g1 - g2) + Sqr(b1 - b2);

   // If the first color is an exact match, we can stop.
   if MinDist = 0 then
   begin
      Result := 0;
      Exit;
   end;

   // 2. Iterate through the rest of the palette (starting from the second item).
   for i := 1 to High(FActivePalette) do
   begin
      r2 := GetRValue(FActivePalette[i]);
      g2 := GetGValue(FActivePalette[i]);
      b2 := GetBValue(FActivePalette[i]);

      Dist := Sqr(r1 - r2) + Sqr(g1 - g2) + Sqr(b1 - b2);

      if Dist < MinDist then
      begin
         MinDist := Dist;
         BestIndex := i;
         if MinDist = 0 then
            Break; // Found an exact match.
      end;
   end;

   Result := BestIndex;
end;

procedure TDocumentFrame.PickColorAt(X, Y: Integer);
var
   TilesPerRow, TileX, TileY, TileIndex, Addr, PixelX, PixelY, PixelDataIndex, ClickedColorIndex: Integer;
   DecodedPixels: TArray<Integer>;
begin
   if not Assigned(FCurrentCodec) then
      Exit;

   // 1. Calculate the position of the clicked pixel.
   TilesPerRow := FTilesPerRow;
   TileX := X div (8 * FZoom);
   TileY := Y div (8 * FZoom);
   TileIndex := (vsbTileScroller.Position * TilesPerRow) + (TileY * FTilesPerRow) + TileX;
   Addr := (TileIndex * FCurrentCodec.TileSize) + sbOffset.Position;
   PixelX := (X mod (8 * FZoom)) div FZoom;
   PixelY := (Y mod (8 * FZoom)) div FZoom;
   PixelDataIndex := PixelY * 8 + PixelX;

   if Addr + FCurrentCodec.TileSize > Length(FRomData) then
      Exit;

   // 2. Decode the tile and get the color index.
   DecodedPixels := FCurrentCodec.Decode(FRomData, Addr, 0);
   ClickedColorIndex := DecodedPixels[PixelDataIndex];

   // 3. Set the picked color as the active drawing color.
   FCurrentColorIndex := ClickedColorIndex;

   // 4. Update the palettes to show the new selection highlight.
   pbActivePalette.Invalidate;
   pbPalette.Invalidate;
end;

procedure TDocumentFrame.FloodFillTile(var ATilePixels: TArray<Integer>; AStartX, AStartY, AReplacementIndex: Integer);
var
   Queue: TQueue<TPoint>;
   TargetIndex, CurrentIndex: Integer;
   CurrentPoint: TPoint;
begin
   // This is a standard non-recursive flood fill algorithm.
   // Get the color index of the pixel that will be replaced.
   TargetIndex := ATilePixels[AStartY * 8 + AStartX];

   // If the target color is already the replacement color, do nothing.
   if TargetIndex = AReplacementIndex then
      Exit;

   Queue := TQueue<TPoint>.Create;
   try
      // Add the starting pixel to the queue.
      Queue.Enqueue(TPoint.Create(AStartX, AStartY));

      while Queue.Count > 0 do
      begin
         // Get the next pixel from the queue.
         CurrentPoint := Queue.Dequeue;

         // Check if the pixel is within the 8x8 tile bounds.
         if (CurrentPoint.X >= 0) and (CurrentPoint.X < 8) and (CurrentPoint.Y >= 0) and (CurrentPoint.Y < 8) then
         begin
            CurrentIndex := CurrentPoint.Y * 8 + CurrentPoint.X;

            // If the current pixel has the target color...
            if ATilePixels[CurrentIndex] = TargetIndex then
            begin
               // ...paint it with the new color...
               ATilePixels[CurrentIndex] := AReplacementIndex;
               // ...and add its 4 neighbors to the queue to be checked.
               Queue.Enqueue(TPoint.Create(CurrentPoint.X + 1, CurrentPoint.Y)); // Right
               Queue.Enqueue(TPoint.Create(CurrentPoint.X - 1, CurrentPoint.Y)); // Left
               Queue.Enqueue(TPoint.Create(CurrentPoint.X, CurrentPoint.Y + 1)); // Down
               Queue.Enqueue(TPoint.Create(CurrentPoint.X, CurrentPoint.Y - 1)); // Up
            end;
         end;
      end;
   finally
      Queue.Free;
   end;
end;

procedure TDocumentFrame.CreateVirtualPixelMap(out AMap: TArray<Integer>; out AMapWidth, AMapHeight: Integer);
var
   TileX, TileY, px, py, TileIndex, StartTile: Integer;
   Addr: Int64;
   DecodedPixels: TArray<Integer>;
begin
   // Creates a 1:1 map of all visible pixels to perform global operations.
   // The map dimensions are based on the user-defined view settings.
   AMapWidth := FTilesPerRow * 8;
   AMapHeight := FTilesPerColumn * 8;
   SetLength(AMap, AMapWidth * AMapHeight);

   StartTile := vsbTileScroller.Position * FTilesPerRow;

   for TileY := 0 to FTilesPerColumn - 1 do
   begin
      for TileX := 0 to FTilesPerRow - 1 do
      begin
         TileIndex := StartTile + (TileY * FTilesPerRow) + TileX;
         Addr := (TileIndex * FCurrentCodec.TileSize) + sbOffset.Position;

         if (Addr + FCurrentCodec.TileSize) <= Length(FRomData) then
         begin
            DecodedPixels := FCurrentCodec.Decode(FRomData, Addr, 0);
            // Copy the decoded pixels into the virtual map.
            for py := 0 to 7 do
            begin
               for px := 0 to 7 do
               begin
                  var MapX := TileX * 8 + px;
                  var MapY := TileY * 8 + py;
                  if DecodedPixels[py * 8 + px] < Length(FActivePalette) then
                     AMap[MapY * AMapWidth + MapX] := DecodedPixels[py * 8 + px]
                  else
                     AMap[MapY * AMapWidth + MapX] := -1; // -1 for invalid color index.
               end;
            end;
         end
         else // If the tile is outside the ROM bounds
         begin
            // Fill the corresponding area in the map with an "empty" value.
            for py := 0 to 7 do
            begin
               for px := 0 to 7 do
               begin
                  var MapX := TileX * 8 + px;
                  var MapY := TileY * 8 + py;
                  AMap[MapY * AMapWidth + MapX] := -1; // -1 for area outside the ROM.
               end;
            end;
         end;
      end;
   end;
end;

procedure TDocumentFrame.CreateVirtualPixelMapFromSelection(out AMap: TArray<Integer>; out AMapWidth, AMapHeight: Integer);
var
   x, y, px, py, TileIndex, StartTile: Integer;
   Addr: Int64;
   DecodedPixels: TArray<Integer>;
begin
   // Similar to the above, but creates a map only from the selected tiles.
   if IsRectEmpty(FSelectionRect) then
      Exit;

   AMapWidth := FSelectionRect.Width * 8;
   AMapHeight := FSelectionRect.Height * 8;
   SetLength(AMap, AMapWidth * AMapHeight);
   StartTile := vsbTileScroller.Position * FTilesPerRow;

   for y := 0 to FSelectionRect.Height - 1 do
   begin
      for x := 0 to FSelectionRect.Width - 1 do
      begin
         TileIndex := StartTile + ((FSelectionRect.Top + y) * FTilesPerRow) + (FSelectionRect.Left + x);
         Addr := (TileIndex * FCurrentCodec.TileSize) + sbOffset.Position;

         if Addr + FCurrentCodec.TileSize <= Length(FRomData) then
            DecodedPixels := FCurrentCodec.Decode(FRomData, Addr, 0)
         else
         begin // If the tile doesn't exist, create an empty one.
            SetLength(DecodedPixels, 64);
            FillChar(DecodedPixels[0], 64 * SizeOf(Integer), $FFFFFFFF); // Fill with -1.
         end;

         // Copy the 64 pixels to the correct position in the large map.
         for py := 0 to 7 do
            for px := 0 to 7 do
               AMap[(y * 8 + py) * AMapWidth + (x * 8 + px)] := DecodedPixels[py * 8 + px];
      end;
   end;
end;

procedure TDocumentFrame.ApplyChangesFromPixelMap(const AOldMap, ANewMap: TArray<Integer>; AMapWidth, AMapHeight, AStartTileIndex, ABlockWidthInTiles: Integer);
var
   ChangedTiles: TDictionary<Integer, TArray<Integer>>;
   TileSize, x, y: Integer;
begin
   // This function compares two virtual maps, finds the differences, and applies them back to the ROM data.
   ChangedTiles := TDictionary<Integer, TArray<Integer>>.Create;
   TileSize := FCurrentCodec.TileSize;
   try
      // 1. Compare old and new maps to find which tiles were modified.
      for y := 0 to AMapHeight - 1 do
      begin
         for x := 0 to AMapWidth - 1 do
         begin
            var CurrentMapIndex := y * AMapWidth + x;
            if AOldMap[CurrentMapIndex] <> ANewMap[CurrentMapIndex] then
            begin
               var TileX := x div 8;
               var TileY := y div 8;
               var TileIndex := AStartTileIndex + (TileY * FTilesPerRow) + TileX;
               // If this tile hasn't been marked as changed yet...
               if not ChangedTiles.ContainsKey(TileIndex) then
               begin
                  // ...extract its new 8x8 pixel data from the modified map and add it to the dictionary.
                  var DecodedPixels: TArray<Integer>;
                  SetLength(DecodedPixels, 64);
                  for var py := 0 to 7 do
                     for var px := 0 to 7 do
                        DecodedPixels[py * 8 + px] := ANewMap[(TileY * 8 + py) * AMapWidth + (TileX * 8 + px)];
                  ChangedTiles.Add(TileIndex, DecodedPixels);
               end;
            end;
         end;
      end;

      if ChangedTiles.Count = 0 then
         Exit;

      // 2. Create an undo group for all the changes.
      var ActionGroup := TUndoActionGroup.Create;
      ActionGroup.Description := Format(LOC.Get('Messages', 'BlockActiondTiles', 'Block Action (%d tiles)'), [ChangedTiles.Count]);
      FUndoStack.Add(ActionGroup);

      // 3. For each changed tile, encode it and write it back to the ROM data.
      for var TileIndex in ChangedTiles.Keys do
      begin
         var DecodedPixels := ChangedTiles[TileIndex];
         var Addr := (TileIndex * TileSize) + sbOffset.Position;
         var OldData, EncodedTile: TBytes;
         SetLength(OldData, TileSize);
         System.Move(FRomData[Addr], OldData[0], TileSize);
         SetLength(EncodedTile, TileSize);
         FCurrentCodec.Encode(DecodedPixels, EncodedTile, 0, 0);
         System.Move(EncodedTile[0], FRomData[Addr], TileSize);
         // Add the change to the undo group.
         ActionGroup.Add(TUndoAction.Create(Addr, OldData, EncodedTile, 1, TileSize, FTilesPerRow));
      end;

      FRedoStack.Clear;
   finally
      ChangedTiles.Free;
   end;
end;

procedure TDocumentFrame.PerformGlobalFill(AStartX, AStartY: Integer);
var
   PixelMap, OldPixelMap: TArray<Integer>;
   MapWidth, MapHeight, TargetIndex, ReplacementIndex: Integer;
   Queue: TQueue<TPoint>;
   CurrentPoint: TPoint;
   StartTile: Integer;
   MapStartX, MapStartY: Integer;
begin
   // Validation to ensure the click is within the valid tile area.
   if not Assigned(FCurrentCodec) or (FCurrentCodec.TileSize = 0) then Exit;
   var ValidWidthPx := FTilesPerRow * 8 * FZoom;
   if AStartX >= ValidWidthPx then Exit;
   StartTile := vsbTileScroller.Position * FTilesPerRow;
   var ClickedTileY := AStartY div (8 * FZoom);
   var ClickedTileX := AStartX div (8 * FZoom);
   var ClickedTileIndex := StartTile + (ClickedTileY * FTilesPerRow) + ClickedTileX;
   var TotalTiles := Length(FRomData) div FCurrentCodec.TileSize;
   if ClickedTileIndex >= TotalTiles then Exit;

   // 1. Create a 1:1 "snapshot" of the visible pixels.
   CreateVirtualPixelMap(PixelMap, MapWidth, MapHeight);
   OldPixelMap := Copy(PixelMap);

   // Convert mouse coordinates to map space (no zoom).
   MapStartX := AStartX div FZoom;
   MapStartY := AStartY div FZoom;

   // 2. Perform the Flood Fill on the virtual map.
   TargetIndex := PixelMap[MapStartY * MapWidth + MapStartX];
   ReplacementIndex := FCurrentColorIndex;
   if (TargetIndex = ReplacementIndex) or (TargetIndex = -1) then Exit;

   Queue := TQueue<TPoint>.Create;
   try
      Queue.Enqueue(TPoint.Create(MapStartX, MapStartY));
      while Queue.Count > 0 do
      begin
         CurrentPoint := Queue.Dequeue;
         if (CurrentPoint.X >= 0) and (CurrentPoint.X < MapWidth) and (CurrentPoint.Y >= 0) and (CurrentPoint.Y < MapHeight) then
         begin
            if PixelMap[CurrentPoint.Y * MapWidth + CurrentPoint.X] = TargetIndex then
            begin
               PixelMap[CurrentPoint.Y * MapWidth + CurrentPoint.X] := ReplacementIndex;
               Queue.Enqueue(TPoint.Create(CurrentPoint.X + 1, CurrentPoint.Y));
               Queue.Enqueue(TPoint.Create(CurrentPoint.X - 1, CurrentPoint.Y));
               Queue.Enqueue(TPoint.Create(CurrentPoint.X, CurrentPoint.Y + 1));
               Queue.Enqueue(TPoint.Create(CurrentPoint.X, CurrentPoint.Y - 1));
            end;
         end;
      end;
   finally
      Queue.Free;
   end;

   // 3. Compare the maps and apply changes back to the ROM data.
   StartTile := vsbTileScroller.Position * FTilesPerRow;
   ApplyChangesFromPixelMap(OldPixelMap, PixelMap, MapWidth, MapHeight, StartTile, FTilesPerRow);

   // 4. Update the UI.
   SetModified(True);
   UpdateTileViewer;
end;

procedure TDocumentFrame.FlipHorizontal(var APixels: TArray<Integer>; AWidth, AHeight: Integer);
var
   y, x: Integer;
   Temp: Integer;
begin
   for y := 0 to AHeight - 1 do
   begin
      // Only need to go to the middle of the row.
      for x := 0 to (AWidth div 2) - 1 do
      begin
         // Swap pixels.
         Temp := APixels[y * AWidth + x];
         APixels[y * AWidth + x] := APixels[y * AWidth + (AWidth - 1 - x)];
         APixels[y * AWidth + (AWidth - 1 - x)] := Temp;
      end;
   end;
end;

procedure TDocumentFrame.FlipVertical(var APixels: TArray<Integer>; AWidth, AHeight: Integer);
var
   y, x: Integer;
   Temp: Integer;
begin
   for y := 0 to (AHeight div 2) - 1 do
   begin
      for x := 0 to AWidth - 1 do
      begin
         // Swap pixels.
         Temp := APixels[y * AWidth + x];
         APixels[y * AWidth + x] := APixels[(AHeight - 1 - y) * AWidth + x];
         APixels[(AHeight - 1 - y) * AWidth + x] := Temp;
      end;
   end;
end;

procedure TDocumentFrame.Rotate90Clockwise(var APixels: TArray<Integer>; var AWidth, AHeight: Integer);
var
   OldX, OldY, NewX, NewY, OldWidth, OldHeight: Integer;
   NewPixels: TArray<Integer>;
begin
   // Rotation is not done in-place, it requires a temporary buffer.
   OldWidth := AWidth;
   OldHeight := AHeight;
   SetLength(NewPixels, OldWidth * OldHeight);

   for OldY := 0 to OldHeight - 1 do
   begin
      for OldX := 0 to OldWidth - 1 do
      begin
         // Formula for 90-degree clockwise rotation.
         NewX := (OldHeight - 1) - OldY;
         NewY := OldX;
         NewPixels[NewY * OldWidth + NewX] := APixels[OldY * OldWidth + OldX];
      end;
   end;

   // Update the original array and the dimensions (which are swapped).
   APixels := NewPixels;
   AWidth := OldHeight;
   AHeight := OldWidth;
end;

procedure TDocumentFrame.ShiftPixels(var APixels: TArray<Integer>; ADeltaX, ADeltaY: Integer);
var
   OldX, OldY, NewX, NewY: Integer;
   NewPixels: TArray<Integer>;
begin
   // Shifting also requires a temporary buffer to avoid overwriting pixels before they are read.
   SetLength(NewPixels, 64);
   for OldY := 0 to 7 do
   begin
      for OldX := 0 to 7 do
      begin
         // Calculate the new position with wrap-around using the modulo operator.
         NewX := ((OldX + ADeltaX) mod 8 + 8) mod 8;
         NewY := ((OldY + ADeltaY) mod 8 + 8) mod 8;
         NewPixels[NewY * 8 + NewX] := APixels[OldY * 8 + OldX];
      end;
   end;
   APixels := NewPixels;
end;

procedure TDocumentFrame.ChangeZoom(ADelta: Integer);
const
   MIN_ZOOM = 1;
   MAX_ZOOM = 16;
var
   NewZoom: Integer;
begin
   NewZoom := FZoom + ADelta;

   // Clamp the zoom level to the defined min/max values.
   if NewZoom < MIN_ZOOM then NewZoom := MIN_ZOOM;
   if NewZoom > MAX_ZOOM then NewZoom := MAX_ZOOM;

   if NewZoom <> FZoom then
   begin
      FZoom := NewZoom;
      DeselectTiles; // Deselect because zoom invalidates pixel-based selections.
      UpdateTileViewer;
      // Update the status bar with the new zoom level.
      if Assigned(FStatusBar) then
         FStatusBar.Panels[2].Text := 'Zoom: ' + IntToStr(FZoom) + 'x';
   end;
end;

procedure TDocumentFrame.AddUndoAction(AOffset: Int64; const AOldData, ANewData: TBytes; ABlockWidth: Integer);
begin
   // Add a new action to the Undo stack.
   FUndoStack.Add(TUndoAction.Create(AOffset, AOldData, ANewData, ABlockWidth, FCurrentCodec.TileSize, FTilesPerRow));

   // Any new action clears the Redo stack.
   FRedoStack.Clear; // This also frees the TUndoAction objects in the list.
   NotifyStateChange;
end;

procedure TDocumentFrame.DoGoToOffset(AOffset: Int64);
var
   BytesPerRowOfTiles, TargetRow: Int64;
begin
   // Validation to prevent division by zero.
   if not Assigned(FCurrentCodec) or (FCurrentCodec.TileSize = 0) or (FTilesPerRow = 0) then
      Exit;

   // 1. Calculate how many bytes a full row of tiles occupies.
   BytesPerRowOfTiles := FTilesPerRow * FCurrentCodec.TileSize;
   if BytesPerRowOfTiles = 0 then Exit;

   // 2. Calculate which "tile row" the target offset is in.
   TargetRow := AOffset div BytesPerRowOfTiles;

   // 3. Set the vertical scrollbar position to that row.
   if TargetRow <= vsbTileScroller.Max then
      vsbTileScroller.Position := TargetRow
   else
      vsbTileScroller.Position := vsbTileScroller.Max;

   // 4. The remainder is the offset for the horizontal scrollbar.
   sbOffset.Position := AOffset mod BytesPerRowOfTiles;

   // 5. Force all views to update.
   UpdateAllViews;
end;

procedure TDocumentFrame.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
var
   NewPos: Integer;
begin
   // CTRL + Mouse Wheel for Zooming.
   if ssCtrl in Shift then
   begin
      ChangeZoom(-(WheelDelta div 120));
      Handled := True;
   end
   // Normal Mouse Wheel for vertical scrolling.
   else
   begin
      NewPos := vsbTileScroller.Position - (WheelDelta div 120);
      if NewPos < 0 then NewPos := 0;
      if NewPos > vsbTileScroller.Max then NewPos := vsbTileScroller.Max;

      if vsbTileScroller.Position <> NewPos then
      begin
         vsbTileScroller.Position := NewPos;
         UpdateTileViewer;
      end;
      Handled := True;
   end;
end;

procedure TDocumentFrame.UpdateHexViewer;
begin
   // This procedure is currently commented out in the original code.
   // It would be used to update a hexadecimal view of the data.
end;

procedure TDocumentFrame.cbxCodecsChange(Sender: TObject);
begin
   DeselectTiles;
   if cbxCodecs.ItemIndex > -1 then
      FCurrentCodec := TTileCodec(cbxCodecs.Items.Objects[cbxCodecs.ItemIndex])
   else
      FCurrentCodec := nil;

   UpdateAllViews;
   UpdateVerticalScrollerRange;
end;

procedure TDocumentFrame.seTilesPerRowChange(Sender: TObject);
begin
   DeselectTiles;
   FTilesPerRow := seTilesPerRow.Value;
   UpdateTileViewer;
   UpdateVerticalScrollerRange;
end;

procedure TDocumentFrame.sbOffsetScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
   if sbOffset.Position <> ScrollPos then
   begin
      sbOffset.Position := ScrollPos;
      UpdateAllViews;
   end;
end;

procedure TDocumentFrame.seTilesPerColumnChange(Sender: TObject);
begin
   DeselectTiles;
   FTilesPerColumn := seTilesPerColumn.Value;
   UpdateTileViewer;
end;

procedure TDocumentFrame.ToolButtonClick(Sender: TObject);
var
   NewTool: TTool;
begin
   // 1. Identify which tool was selected.
   if (Sender as TSpeedButton) = btnPointerTool then NewTool := tlPointer
   else if (Sender as TSpeedButton) = btnPencilTool then NewTool := tlPencil
   else if (Sender as TSpeedButton) = btnFillBucketTool then NewTool := tlFillBucket
   else if (Sender as TSpeedButton) = btnEyedropperTool then NewTool := tlEyedropper
   else if (Sender as TSpeedButton) = btnColorReplacerTool then NewTool := tlColorReplacer
   else if (Sender as TSpeedButton) = btnZoomTool then NewTool := tlZoom
   else if (Sender as TSpeedButton) = btnMoveTool then NewTool := tlMove
   else Exit;

   // 2. Set the new active tool.
   FCurrentTool := NewTool;

   // 3. Clear the selection ONLY if the new tool does not operate on an existing selection.
   if FCurrentTool in [tlPencil, tlFillBucket, tlEyedropper, tlZoom] then
   begin
      DeselectTiles;
   end;

   // 4. Update the mouse cursor for the new tool.
   UpdateToolCursor;
end;

procedure TDocumentFrame.TransformButtonClick(Sender: TObject);
var
   TargetRect: TRect;
   ActionGroup: TUndoActionGroup;
   TileSize: Integer;
   SelectionPixels: TArray<Integer>;
   SelectionWidthPx, SelectionHeightPx, SelWidthTiles, SelHeightTiles: Integer;
   x, y, px, py, TileIndex, StartTile: Integer;
   Addr: Int64;
   DecodedPixels: TArray<Integer>;
begin
   if not Assigned(FCurrentCodec) or (Length(FRomData) = 0) then
      Exit;

   // 1. Determine the target area: the selection, or the whole view if no selection.
   if IsRectEmpty(FSelectionRect) then
      TargetRect := TRect.Create(0, 0, FTilesPerRow, FTilesPerColumn)
   else
      TargetRect := FSelectionRect;

   // Validation for Rotation: only allowed on square selections.
   if (Sender = btnRotate) and (TargetRect.Width <> TargetRect.Height) then
   begin
      ShowMessage(LOC.Get('Messages', 'RotationOnlyForSquare', 'Rotation is only allowed for square selections (e.g., 2x2, 4x4 tiles).'));
      Exit;
   end;

   // PHASE 1: ASSEMBLE THE PIXEL MAP from the target area.
   SelWidthTiles := TargetRect.Width;
   SelHeightTiles := TargetRect.Height;
   SelectionWidthPx := SelWidthTiles * 8;
   SelectionHeightPx := SelHeightTiles * 8;
   SetLength(SelectionPixels, SelectionWidthPx * SelectionHeightPx);
   TileSize := FCurrentCodec.TileSize;
   StartTile := vsbTileScroller.Position * FTilesPerRow;
   for y := 0 to SelHeightTiles - 1 do
   begin
      for x := 0 to SelWidthTiles - 1 do
      begin
         TileIndex := StartTile + ((TargetRect.Top + y) * FTilesPerRow) + (TargetRect.Left + x);
         Addr := (TileIndex * TileSize) + sbOffset.Position;
         if Addr + TileSize <= Length(FRomData) then
         begin
            DecodedPixels := FCurrentCodec.Decode(FRomData, Addr, 0);
            for py := 0 to 7 do
               for px := 0 to 7 do
                  SelectionPixels[(y * 8 + py) * SelectionWidthPx + (x * 8 + px)] := DecodedPixels[py * 8 + px];
         end;
      end;
   end;

   // PHASE 2: TRANSFORM THE PIXEL MAP.
   if Sender = btnFlipH then FlipHorizontal(SelectionPixels, SelectionWidthPx, SelectionHeightPx);
   if Sender = btnFlipV then FlipVertical(SelectionPixels, SelectionWidthPx, SelectionHeightPx);
   if Sender = btnRotate then Rotate90Clockwise(SelectionPixels, SelectionWidthPx, SelectionHeightPx);

   // PHASE 3: DISASSEMBLE, WRITE, AND LOG FOR UNDO.
   ActionGroup := TUndoActionGroup.Create;
   FUndoStack.Add(ActionGroup);
   SetLength(DecodedPixels, 64);

   for y := 0 to SelHeightTiles - 1 do
   begin
      for x := 0 to SelWidthTiles - 1 do
      begin
         var OldData, EncodedTile: TBytes;
         TileIndex := StartTile + ((TargetRect.Top + y) * FTilesPerRow) + (TargetRect.Left + x);
         Addr := (TileIndex * TileSize) + sbOffset.Position;
         if Addr + TileSize <= Length(FRomData) then
         begin
            // Save old data.
            SetLength(OldData, TileSize);
            System.Move(FRomData[Addr], OldData[0], TileSize);
            // Get the 8x8 chunk from the transformed map.
            for py := 0 to 7 do
               for px := 0 to 7 do
                  DecodedPixels[py * 8 + px] := SelectionPixels[(y * 8 + py) * SelectionWidthPx + (x * 8 + px)];
            // Encode, write back, and add to the undo group.
            SetLength(EncodedTile, TileSize);
            FCurrentCodec.Encode(DecodedPixels, EncodedTile, 0, 0);
            System.Move(EncodedTile[0], FRomData[Addr], TileSize);
            ActionGroup.Add(TUndoAction.Create(Addr, OldData, EncodedTile, 1, TileSize, FTilesPerRow));
         end;
      end;
   end;

   // Finalize the operation.
   if ActionGroup.Count > 0 then
   begin
      SetModified(True);
      FRedoStack.Clear;
      UpdateTileViewer;
   end
   else
   begin
      FUndoStack.Remove(ActionGroup);
      ActionGroup.Free;
   end;
end;

procedure TDocumentFrame.ShiftButtonClick(Sender: TObject);
var
   TargetRect: TRect;
   ActionGroup: TUndoActionGroup;
   x, y, TileIndex, StartTile, TileSize: Integer;
   Addr: Int64;
   DecodedPixels: TArray<Integer>;
begin
   if not Assigned(FCurrentCodec) or (Length(FRomData) = 0) then Exit;

   // 1. Determine target area (selection or whole view).
   if IsRectEmpty(FSelectionRect) then
      TargetRect := TRect.Create(0, 0, FTilesPerRow, FTilesPerColumn)
   else
      TargetRect := FSelectionRect;

   // 2. Prepare for an atomic undo action.
   ActionGroup := TUndoActionGroup.Create;
   FUndoStack.Add(ActionGroup);
   TileSize := FCurrentCodec.TileSize;
   StartTile := vsbTileScroller.Position * FTilesPerRow;

   // 3. Iterate over each tile in the target area.
   for y := TargetRect.Top to TargetRect.Bottom - 1 do
   begin
      for x := TargetRect.Left to TargetRect.Right - 1 do
      begin
         TileIndex := StartTile + (y * FTilesPerRow) + x;
         Addr := (TileIndex * TileSize) + sbOffset.Position;
         if Addr + TileSize <= Length(FRomData) then
         begin
            var LOldData, LEncodedTile: TBytes;
            // a. Save old data.
            SetLength(LOldData, TileSize);
            System.Move(FRomData[Addr], LOldData[0], TileSize);
            // b. Decode the tile.
            DecodedPixels := FCurrentCodec.Decode(FRomData, Addr, 0);
            // c. Apply the correct shift based on the button clicked.
            if Sender = btnShiftLeft then ShiftPixels(DecodedPixels, -1, 0)
            else if Sender = btnShiftRight then ShiftPixels(DecodedPixels, 1, 0)
            else if Sender = btnShiftUp then ShiftPixels(DecodedPixels, 0, -1)
            else if Sender = btnShiftDown then ShiftPixels(DecodedPixels, 0, 1);
            // d. Encode the modified tile.
            SetLength(LEncodedTile, TileSize);
            FCurrentCodec.Encode(DecodedPixels, LEncodedTile, 0, 0);
            // e. Write back to ROM and add to the undo group.
            System.Move(LEncodedTile[0], FRomData[Addr], TileSize);
            ActionGroup.Add(TUndoAction.Create(Addr, LOldData, LEncodedTile, 1, TileSize, FTilesPerRow));
         end;
      end;
   end;

   // 4. Finalize the operation.
   if ActionGroup.Count > 0 then
   begin
      SetModified(True);
      FRedoStack.Clear;
      UpdateTileViewer;
   end
   else
   begin
      FUndoStack.Remove(ActionGroup);
      ActionGroup.Free;
   end;
end;

procedure TDocumentFrame.cbxPaletteFormatsChange(Sender: TObject);
begin
   if cbxPaletteFormats.ItemIndex > -1 then
      FCurrentColorCodec := TColorCodec(cbxPaletteFormats.Items.Objects[cbxPaletteFormats.ItemIndex])
   else
      FCurrentColorCodec := nil;
   UpdateAllViews;
end;

procedure TDocumentFrame.pbActivePaletteMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
   Index, GridWidth: Integer;
begin
   DeselectTiles;
   GridWidth := pbActivePalette.Width div 16;
   if GridWidth = 0 then GridWidth := 1;

   // Calculate the LOCAL index of the clicked color in the active palette.
   Index := (Y div 16) * GridWidth + (X div 16);
   if (Index >= 0) and (Index < Length(FActivePalette)) then
   begin
      // Left button: Select the color for drawing.
      if Button = mbLeft then
      begin
         FCurrentColorIndex := Index;
         pbActivePalette.Invalidate; // Redraw to show local highlight.
         pbPalette.Invalidate;       // Redraw master palette for global highlight.
      end
      // Right button: Edit the color.
      else if Button = mbRight then
      begin
         FColorDialog.Color := FActivePalette[Index];
         if FColorDialog.Execute then
         begin
            FActivePalette[Index] := FColorDialog.Color;
            SetModified(True);
            // Redraw everything to reflect the color change.
            pbActivePalette.Invalidate;
            UpdateTileViewer;
         end;
      end;
   end;
end;

procedure TDocumentFrame.pbActivePalettePaint(Sender: TObject);
var
   i, X, Y: Integer;
   Rect: TRect;
   GridWidth: Integer;
begin
   GridWidth := pbActivePalette.Width div 16;
   if GridWidth = 0 then GridWidth := 1;

   pbActivePalette.Canvas.Brush.Color := $00333333;
   pbActivePalette.Canvas.FillRect(pbActivePalette.Canvas.ClipRect);

   // Draw each color from the active palette.
   for i := 0 to High(FActivePalette) do
   begin
      X := (i mod GridWidth) * 16;
      Y := (i div GridWidth) * 16;
      Rect := TRect.Create(X, Y, X + 16, Y + 16);
      pbActivePalette.Canvas.Brush.Color := FActivePalette[i];
      pbActivePalette.Canvas.FillRect(Rect);
   end;

   // Add the selection highlight.
   if FCurrentColorIndex >= 0 then
   begin
      GridWidth := pbActivePalette.Width div 16;
      if GridWidth = 0 then GridWidth := 1;
      X := (FCurrentColorIndex mod GridWidth) * 16;
      Y := (FCurrentColorIndex div GridWidth) * 16;
      Rect := TRect.Create(X, Y, X + 16, Y + 16);
      pbActivePalette.Canvas.Brush.Style := bsClear;
      pbActivePalette.Canvas.Pen.Color := clWhite;
      pbActivePalette.Canvas.Pen.Width := 2;
      pbActivePalette.Canvas.Rectangle(Rect);
      pbActivePalette.Canvas.Brush.Style := bsSolid;
   end;
end;

procedure TDocumentFrame.pbPaletteMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
   Index, SubPaletteSize, i: Integer;
begin
   DeselectTiles;

   if not Assigned(FCurrentCodec) or (Button <> mbLeft) then
      Exit;

   // 1. Calculate the sub-palette size and its starting index based on the click.
   SubPaletteSize := 1 shl FCurrentCodec.BitsPerPixel;
   Index := (Y div 16) * 16 + (X div 16);
   FActivePaletteStartIndex := (Index div SubPaletteSize) * SubPaletteSize; // Store the start index.

   // 2. Populate the FActivePalette array from the master palette.
   UpdateActivePaletteFromMaster;

   // 3. Set a default drawing color (the first of the new sub-palette).
   FCurrentColorIndex := 0;

   // 4. Update visual components.
   pbActivePalette.Invalidate; // Redraw the active palette view.
   pbPalette.Invalidate;       // Redraw the master palette (for highlighting).
   UpdateTileViewer;           // Apply the new palette to the tiles.
end;

procedure TDocumentFrame.pbPaletteMouseLeave(Sender: TObject);
begin
   // When the mouse leaves, clear the hover index and redraw.
   FHoverStartIndex := -1;
   pbPalette.Invalidate;
end;

procedure TDocumentFrame.pbPaletteMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
   SubPaletteSize, Index: Integer;
begin
   if not Assigned(FCurrentCodec) then Exit;

   SubPaletteSize := 1 shl FCurrentCodec.BitsPerPixel;
   Index := (Y div 16) * 16 + (X div 16);

   // Update the starting index of the sub-palette to be highlighted.
   FHoverStartIndex := (Index div SubPaletteSize) * SubPaletteSize;
   // Invalidate the PaintBox to trigger a repaint.
   pbPalette.Invalidate;
end;

procedure TDocumentFrame.pbPalettePaint(Sender: TObject);
var
   X, Y, Index, i, GridX, GridY, SubPaletteSize: Integer;
   Rect, HighlightRect: TRect;
   SelX, SelY: Integer;
begin
   // 1. Clear and draw the master color grid.
   pbPalette.Canvas.Brush.Color := $00333333;
   pbPalette.Canvas.FillRect(pbPalette.Canvas.ClipRect);
   for Y := 0 to 15 do
   begin
      for X := 0 to 15 do
      begin
         Index := Y * 16 + X;
         Rect := TRect.Create(X * 16, Y * 16, (X + 1) * 16, (Y + 1) * 16);
         if Index < Length(FCurrentPalette) then
            pbPalette.Canvas.Brush.Color := FCurrentPalette[Index]
         else
            pbPalette.Canvas.Brush.Color := clDkGray;
         pbPalette.Canvas.FillRect(Rect);
      end;
   end;

   // Prepare pen for highlights.
   pbPalette.Canvas.Brush.Style := bsClear;
   pbPalette.Canvas.Pen.Width := 2;

   // 2. Draw the sub-palette preview highlight (on hover).
   if (FHoverStartIndex >= 0) and Assigned(FCurrentCodec) then
   begin
      SubPaletteSize := 1 shl FCurrentCodec.BitsPerPixel;
      pbPalette.Canvas.Pen.Color := clYellow;
      for i := 0 to SubPaletteSize - 1 do
      begin
         Index := FHoverStartIndex + i;
         if Index < 256 then // Ensure it doesn't draw outside the 16x16 grid.
         begin
            GridX := Index mod 16;
            GridY := Index div 16;
            Rect := TRect.Create(GridX * 16, GridY * 16, (GridX + 1) * 16, (GridY + 1) * 16);
            pbPalette.Canvas.Rectangle(Rect);
         end;
      end;
   end;

   // 3. Draw the highlight for the individually selected drawing color.
   if FCurrentColorIndex >= 0 then
   begin
      // Calculate the GLOBAL index of the selected color.
      Index := FActivePaletteStartIndex + FCurrentColorIndex;
      SelX := Index mod 16;
      SelY := Index div 16;
      HighlightRect := TRect.Create(SelX * 16, SelY * 16, (SelX + 1) * 16, (SelY + 1) * 16);
      pbPalette.Canvas.Pen.Color := clWhite;
      pbPalette.Canvas.Rectangle(HighlightRect);
   end;

   pbPalette.Canvas.Brush.Style := bsSolid;
end;

procedure TDocumentFrame.pbTileViewerMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
   ValidWidth, ValidHeight, TileX, TileY, PixelX, PixelY, TileIndex, TilesPerRow, Addr, PixelDataIndex: Integer;
   DecodedPixels: TArray<Integer>;
   EncodedTile, OldData: TBytes;
   TotalTiles, ViewStartTile, TileSize: Integer;
begin
   // Calculate valid drawing area. If the click is outside, ignore it.
   ValidWidth := FTilesPerRow * 8 * FZoom;
   ValidHeight := FTilesPerColumn * 8 * FZoom;
   if (X >= ValidWidth) or (Y >= ValidHeight) or (Length(FRomData) = 0) or (FZoom = 0) then Exit;

   if not Assigned(FCurrentCodec) then Exit;
   TileSize := FCurrentCodec.TileSize;

   case FCurrentTool of
      tlPointer:
      begin
         if Button = mbLeft then
         begin
            FMoveOriginalRect := FSelectionRect; // Save pre-drag selection state for undo.
            TileX := X div (8 * FZoom);
            TileY := Y div (8 * FZoom);

            ViewStartTile := vsbTileScroller.Position * FTilesPerRow;
            TileIndex := ViewStartTile + (TileY * FTilesPerRow) + TileX;
            if FCurrentCodec.TileSize > 0 then TotalTiles := Length(FRomData) div FCurrentCodec.TileSize else TotalTiles := 0;
            if TileIndex >= TotalTiles then Exit;

            // Start the dragging process.
            FIsDragging := True;
            FDragStartPoint := TPoint.Create(TileX, TileY);
            // Set the initial selection to just the clicked tile.
            FSelectionRect := TRect.Create(TileX, TileY, TileX + 1, TileY + 1);
            pbTileViewer.Invalidate;
         end;
      end;

      tlPencil:
      begin
         if Button = mbLeft then
         begin
            TilesPerRow := FTilesPerRow;
            TileX := X div (8 * FZoom);
            TileY := Y div (8 * FZoom);
            PixelX := (X mod (8 * FZoom)) div FZoom;
            PixelY := (Y mod (8 * FZoom)) div FZoom;
            PixelDataIndex := PixelY * 8 + PixelX;
            TileIndex := (vsbTileScroller.Position * TilesPerRow) + (TileY * TilesPerRow) + TileX;
            Addr := (TileIndex * FCurrentCodec.TileSize) + sbOffset.Position;
            if Addr + FCurrentCodec.TileSize > Length(FRomData) then Exit;

            // EYEDROPPER LOGIC (if CTRL is pressed).
            if ssCtrl in Shift then
            begin
               PickColorAt(X, Y);
            end
            // PENCIL LOGIC (normal).
            else
            begin
               DecodedPixels := FCurrentCodec.Decode(FRomData, Addr, 0);
               // Only proceed if the pixel color is actually changing.
               if DecodedPixels[PixelDataIndex] <> FCurrentColorIndex then
               begin
                  SetLength(OldData, FCurrentCodec.TileSize);
                  System.Move(FRomData[Addr], OldData[0], FCurrentCodec.TileSize);
                  DecodedPixels[PixelDataIndex] := FCurrentColorIndex;
                  SetLength(EncodedTile, FCurrentCodec.TileSize);
                  FCurrentCodec.Encode(DecodedPixels, EncodedTile, 0, 0);
                  System.Move(EncodedTile[0], FRomData[Addr], FCurrentCodec.TileSize);
                  AddUndoAction(Addr, OldData, EncodedTile, 1);
                  SetModified(True);
                  UpdateTileViewer;
               end;
            end;
         end;
      end;

      tlFillBucket:
      begin
         if Button = mbLeft then
         begin
            // SINGLE TILE FILL (if CTRL is pressed).
            if ssCtrl in Shift then
            begin
               TileX := X div (8 * FZoom);
               TileY := Y div (8 * FZoom);
               PixelX := (X mod (8 * FZoom)) div FZoom;
               PixelY := (Y mod (8 * FZoom)) div FZoom;
               TileIndex := (vsbTileScroller.Position * FTilesPerRow) + (TileY * FTilesPerRow) + TileX;
               Addr := (TileIndex * FCurrentCodec.TileSize) + sbOffset.Position;
               if Addr + FCurrentCodec.TileSize > Length(FRomData) then Exit;
               DecodedPixels := FCurrentCodec.Decode(FRomData, Addr, 0);
               SetLength(OldData, FCurrentCodec.TileSize);
               System.Move(FRomData[Addr], OldData[0], FCurrentCodec.TileSize);
               FloodFillTile(DecodedPixels, PixelX, PixelY, FCurrentColorIndex);
               SetLength(EncodedTile, FCurrentCodec.TileSize);
               FCurrentCodec.Encode(DecodedPixels, EncodedTile, 0, 0);
               System.Move(EncodedTile[0], FRomData[Addr], FCurrentCodec.TileSize);
               AddUndoAction(Addr, OldData, EncodedTile, 1);
               SetModified(True);
               UpdateTileViewer;
            end
            // GLOBAL FILL (normal click).
            else
               PerformGlobalFill(X, Y);
         end;
      end;

      tlEyedropper:
      begin
         if Button = mbLeft then
         begin
            PickColorAt(X, Y);
         end;
      end;

      tlColorReplacer:
      begin
         if Button = mbLeft then
         begin
            var PixelMap, OldPixelMap: TArray<Integer>;
            var MapWidth, MapHeight, TargetIndex, ReplacementIndex: Integer;
            TilesPerRow := FTilesPerRow;
            TileX := X div (8 * FZoom);
            TileY := Y div (8 * FZoom);
            ViewStartTile := vsbTileScroller.Position * FTilesPerRow;
            TileIndex := ViewStartTile + (TileY * TilesPerRow) + TileX;
            Addr := (TileIndex * FCurrentCodec.TileSize) + sbOffset.Position;
            PixelX := (X mod (8 * FZoom)) div FZoom;
            PixelY := (Y mod (8 * FZoom)) div FZoom;
            PixelDataIndex := PixelY * 8 + PixelX;
            if (Addr + FCurrentCodec.TileSize) > Length(FRomData) then Exit;

            ReplacementIndex := FCurrentColorIndex; // The replacement color is the active one.
            DecodedPixels := FCurrentCodec.Decode(FRomData, Addr, 0);
            TargetIndex := DecodedPixels[PixelDataIndex]; // The target color is the one clicked.
            if TargetIndex = ReplacementIndex then Exit;

            // Determine scope based on SHIFT key.
            if (ssShift in Shift) and not IsRectEmpty(FSelectionRect) then
            begin
               // SCOPE: SELECTION ONLY.
               CreateVirtualPixelMapFromSelection(PixelMap, MapWidth, MapHeight);
               var StartTile := vsbTileScroller.Position * FTilesPerRow + (FSelectionRect.Top * FTilesPerRow) + FSelectionRect.Left;
               var BlockWidth := FSelectionRect.Width;
               OldPixelMap := Copy(PixelMap);
               for var i := 0 to High(PixelMap) do if PixelMap[i] = TargetIndex then PixelMap[i] := ReplacementIndex;
               ApplyChangesFromPixelMap(OldPixelMap, PixelMap, MapWidth, MapHeight, StartTile, BlockWidth);
            end
            else
            begin
               // SCOPE: ENTIRE VIEW.
               CreateVirtualPixelMap(PixelMap, MapWidth, MapHeight);
               var StartTile := vsbTileScroller.Position * FTilesPerRow;
               var BlockWidth := FTilesPerRow;
               OldPixelMap := Copy(PixelMap);
               for var i := 0 to High(PixelMap) do if PixelMap[i] = TargetIndex then PixelMap[i] := ReplacementIndex;
               ApplyChangesFromPixelMap(OldPixelMap, PixelMap, MapWidth, MapHeight, StartTile, BlockWidth);
            end;
            SetModified(True);
            UpdateTileViewer;
         end;
      end;

      tlZoom:
      begin
         if Button = mbLeft then ChangeZoom(1) // Left button zooms in.
         else if Button = mbRight then ChangeZoom(-1); // Right button zooms out.
      end;

      tlMove:
      begin
         if IsRectEmpty(FSelectionRect) then Exit;
         TileX := X div (8 * FZoom);
         TileY := Y div (8 * FZoom);
         // Only start dragging if the click is INSIDE the selection.
         if not PtInRect(FSelectionRect, TPoint.Create(TileX, TileY)) then Exit;

         // 2. Start drag state.
         FIsDragging := True;
         FDragStartPoint := TPoint.Create(TileX, TileY);
         FMoveOriginalRect := FSelectionRect;

         // 3. Create the preview bitmap ("the cutout").
         FMoveSelectionBitmap := TBitmap.Create;
         var SelWidthPx := FMoveOriginalRect.Width * 8;
         var SelHeightPx := FMoveOriginalRect.Height * 8;
         FMoveSelectionBitmap.SetSize(SelWidthPx, SelHeightPx);
         // Draw the selected tiles onto the preview bitmap.
         var TempDecoded: TArray<Integer>;
         for var y_rel := 0 to FMoveOriginalRect.Height - 1 do
         begin
            for var x_rel := 0 to FMoveOriginalRect.Width - 1 do
            begin
               var CurrentTileIndex := (vsbTileScroller.Position * FTilesPerRow) + ((FMoveOriginalRect.Top + y_rel) * FTilesPerRow) + (FMoveOriginalRect.Left + x_rel);
               var CurrentAddr := (CurrentTileIndex * FCurrentCodec.TileSize) + sbOffset.Position;
               if CurrentAddr + FCurrentCodec.TileSize <= Length(FRomData) then
               begin
                  TempDecoded := FCurrentCodec.Decode(FRomData, CurrentAddr, 0);
                  for var py := 0 to 7 do for var px := 0 to 7 do
                     if TempDecoded[py * 8 + px] < Length(FActivePalette) then
                        FMoveSelectionBitmap.Canvas.Pixels[x_rel * 8 + px, y_rel * 8 + py] := FActivePalette[TempDecoded[py * 8 + px]];
               end;
            end;
         end;

         // 4. Prepare the undo group and "clear" the original area.
         FMoveActionGroup := TUndoActionGroup.Create;
         var BlankTile: TBytes;
         SetLength(BlankTile, FCurrentCodec.TileSize);
         var BlankPixels: TArray<Integer>;
         SetLength(BlankPixels, 64); // Initializes with zeros.
         FCurrentCodec.Encode(BlankPixels, BlankTile, 0, 0);
         for y := FMoveOriginalRect.Top to FMoveOriginalRect.Bottom - 1 do
         begin
            for x := FMoveOriginalRect.Left to FMoveOriginalRect.Right - 1 do
            begin
               var CurrentTileIndex := (vsbTileScroller.Position * FTilesPerRow) + (y * FTilesPerRow) + x;
               var CurrentAddr := (CurrentTileIndex * FCurrentCodec.TileSize) + sbOffset.Position;
               if CurrentAddr + FCurrentCodec.TileSize <= Length(FRomData) then
               begin
                  SetLength(OldData, FCurrentCodec.TileSize);
                  System.Move(FRomData[CurrentAddr], OldData[0], TileSize);
                  System.Move(BlankTile[0], FRomData[CurrentAddr], TileSize); // Clear the tile.
                  // Add the first part of the action (clearing) to the undo group.
                  FMoveActionGroup.Add(TUndoAction.Create(CurrentAddr, OldData, BlankTile, 1, TileSize, FTilesPerRow));
               end;
            end;
         end;
         UpdateTileViewer; // Show the "hole".
      end;
   end;
end;

procedure TDocumentFrame.pbTileViewerMouseEnter(Sender: TObject);
begin
   UpdateToolCursor;
end;

procedure TDocumentFrame.pbTileViewerMouseLeave(Sender: TObject);
begin
   Screen.Cursor := crDefault;
end;

procedure TDocumentFrame.pbTileViewerMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
   ValidWidth, ValidHeight, TileX, TileY, PixelX, PixelY, TileIndex, TilesPerRow, Addr, CurrentTileX, CurrentTileY, ViewStartTile, TotalTiles: Integer;
begin
   if (FZoom = 0) or (FCurrentCodec = nil) then Exit;
   TilesPerRow := FTilesPerRow;
   if TilesPerRow = 0 then Exit;

   // Update status bar info.
   TileX := X div (8 * FZoom);
   TileY := Y div (8 * FZoom);
   ViewStartTile := vsbTileScroller.Position * FTilesPerRow;
   TileIndex := ViewStartTile + TileY * TilesPerRow + TileX;
   Addr := sbOffset.Position + (TileIndex * FCurrentCodec.TileSize);
   PixelX := (X mod (8 * FZoom)) div FZoom;
   PixelY := (Y mod (8 * FZoom)) div FZoom;
   if Assigned(FStatusBar) then
      FStatusBar.Panels[1].Text := Format(LOC.Get('Messages', 'StatusBarAddrTilePixel', 'Addr: $%s, Tile: %d (%d,%d), Pixel: (%d,%d)'), [IntToHex(Addr, 8), TileIndex, TileX, TileY, PixelX, PixelY]);

   if FIsDragging and (ssLeft in Shift) then
   begin
      // Logic for resizing a selection with the Pointer tool.
      if FCurrentTool = tlPointer then
      begin
         ValidWidth := FTilesPerRow * 8 * FZoom;
         ValidHeight := FTilesPerColumn * 8 * FZoom;
         if (X >= ValidWidth) or (Y >= ValidHeight) then Exit;
         CurrentTileX := X div (8 * FZoom);
         CurrentTileY := Y div (8 * FZoom);
         TileIndex := ViewStartTile + (CurrentTileY * FTilesPerRow) + CurrentTileX;
         if FCurrentCodec.TileSize > 0 then TotalTiles := Length(FRomData) div FCurrentCodec.TileSize else TotalTiles := 0;
         if (TileIndex >= TotalTiles) then Exit;

         // Update the selection rectangle.
         FSelectionRect.Left   := Min(FDragStartPoint.X, CurrentTileX);
         FSelectionRect.Top    := Min(FDragStartPoint.Y, CurrentTileY);
         FSelectionRect.Right  := Max(FDragStartPoint.X, CurrentTileX) + 1;
         FSelectionRect.Bottom := Max(FDragStartPoint.Y, CurrentTileY) + 1;
         pbTileViewer.Invalidate; // Redraw to show the growing rectangle.
      end
      // Logic for showing the move preview.
      else if FCurrentTool = tlMove then
         pbTileViewer.Invalidate;
   end;

   // If the left mouse button is down, call the drawing logic (for continuous drawing with the pencil).
   if (ssLeft in Shift) and (FCurrentTool = tlPencil) then
      pbTileViewerMouseDown(Sender, mbLeft, Shift, X, Y);
end;

procedure TDocumentFrame.pbTileViewerMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
   CurrentTileX, CurrentTileY, DeltaX, DeltaY: Integer;
   TileSize: Integer;
   DecodedPixels: TArray<Integer>;
   x1, y1, py, px, DestTileIndex: Integer;
   DestAddr: Int64;
begin
   if Button = mbLeft then
   begin
      // Finalize the selection drag for the Pointer tool.
      if FIsDragging and (FCurrentTool = tlPointer) then
      begin
         // Create an undo action for the selection change. FMoveOriginalRect holds the pre-drag state.
         var Action := TSelectionChangeAction.Create(FMoveOriginalRect, FSelectionRect);
         FUndoStack.Add(Action);
         FRedoStack.Clear;
         NotifyStateChange;
      end;

      // --- LOGIC TO FINALIZE THE MOVE TOOL ---
      if FIsDragging and (FCurrentTool = tlMove) then
      begin
         // 1. Calculate the final paste position in tile coordinates.
         CurrentTileX := X div (8 * FZoom);
         CurrentTileY := Y div (8 * FZoom);
         DeltaX := CurrentTileX - FDragStartPoint.X;
         DeltaY := CurrentTileY - FDragStartPoint.Y;
         var DestRectTop := FMoveOriginalRect.Top + DeltaY;
         var DestRectLeft := FMoveOriginalRect.Left + DeltaX;
         TileSize := FCurrentCodec.TileSize;

         // 2. Iterate over the moved image to paste it tile by tile.
         SetLength(DecodedPixels, 64);
         for y1 := 0 to FMoveOriginalRect.Height - 1 do
         begin
            for x1 := 0 to FMoveOriginalRect.Width - 1 do
            begin
               // a. Extract the 8x8 tile from the preview bitmap and convert to palette indices.
               for py := 0 to 7 do for px := 0 to 7 do
                  DecodedPixels[py * 8 + px] := FindClosestColorIndex(FMoveSelectionBitmap.Canvas.Pixels[x1 * 8 + px, y1 * 8 + py]);
               // b. Calculate the final destination address in the ROM.
               DestTileIndex := (vsbTileScroller.Position * FTilesPerRow) + ((DestRectTop + y1) * FTilesPerRow) + (DestRectLeft + x1);
               DestAddr := (DestTileIndex * TileSize) + sbOffset.Position;
               if DestAddr + TileSize <= Length(FRomData) then
               begin
                  // c. Save the data that will be overwritten at the destination.
                  var OldData, EncodedTile: TBytes;
                  SetLength(OldData, TileSize);
                  System.Move(FRomData[DestAddr], OldData[0], TileSize);
                  // d. Encode and write the new tile.
                  SetLength(EncodedTile, TileSize);
                  FCurrentCodec.Encode(DecodedPixels, EncodedTile, 0, 0);
                  System.Move(EncodedTile[0], FRomData[DestAddr], TileSize);
                  // e. Add the second part of the action (the paste) to the same undo group.
                  FMoveActionGroup.Add(TUndoAction.Create(DestAddr, OldData, EncodedTile, 1, TileSize, FTilesPerRow));
               end;
            end;
         end;

         // 3. Finalize the undo operation and update the UI.
         FUndoStack.Add(FMoveActionGroup);
         FMoveActionGroup := nil; // Ownership transferred to the undo stack.
         FRedoStack.Clear;
         SetModified(True);
         DeselectTiles; // Clear the visual selection after moving.
         UpdateTileViewer;
         // Free the preview bitmap.
         FMoveSelectionBitmap.Free;
         FMoveSelectionBitmap := nil;
      end;

      // 4. Finalize the drag state for all tools.
      FIsDragging := False;
      NotifyStateChange;
   end;
end;

procedure TDocumentFrame.pbTileViewerPaint(Sender: TObject);
var
  SelectionRectPixels: TRect;
  GridColor, PixelGridColor: TColor;
  x, y, LineCoord, ValidWidthPx, ValidHeightPx: Integer;
begin
   // 1. Draw the main bitmap with the tiles (double buffering).
   pbTileViewer.Canvas.Draw(0, 0, FTileBitmap);

   // Calculate the valid width and height in pixels for drawing grids.
   ValidWidthPx := FTilesPerRow * 8 * FZoom;
   ValidHeightPx := FTilesPerColumn * 8 * FZoom;

   // Draw the 8x8 tile grid.
   if FIsTileGridVisible then
   begin
      GridColor := TColor($00505050);
      pbTileViewer.Canvas.Pen.Color := GridColor;
      pbTileViewer.Canvas.Pen.Width := 1;
      pbTileViewer.Canvas.Pen.Style := psSolid;
      for x := 0 to FTilesPerRow - 1 do
      begin
         LineCoord := x * 8 * FZoom;
         pbTileViewer.Canvas.MoveTo(LineCoord, 0);
         pbTileViewer.Canvas.LineTo(LineCoord, ValidHeightPx);
      end;
      for y := 0 to FTilesPerColumn - 1 do
      begin
         LineCoord := y * 8 * FZoom;
         pbTileViewer.Canvas.MoveTo(0, LineCoord);
         pbTileViewer.Canvas.LineTo(ValidWidthPx, LineCoord);
      end;
   end;

   // Draw the 1x1 pixel grid.
   if FIsPixelGridVisible and (FZoom > 2) then
   begin
      PixelGridColor := TColor($00606060);
      pbTileViewer.Canvas.Pen.Color := PixelGridColor;
      pbTileViewer.Canvas.Pen.Style := psDot;
      x := FZoom;
      while x < ValidWidthPx do
      begin
         pbTileViewer.Canvas.MoveTo(x, 0);
         pbTileViewer.Canvas.LineTo(x, ValidHeightPx);
         Inc(x, FZoom);
      end;
      y := FZoom;
      while y < ValidHeightPx do
      begin
         pbTileViewer.Canvas.MoveTo(0, y);
         pbTileViewer.Canvas.LineTo(ValidWidthPx, y);
         Inc(y, FZoom);
      end;
      pbTileViewer.Canvas.Pen.Style := psSolid;
   end;

   // 2. Draw the selection rectangle if it's not empty.
   if not IsRectEmpty(FSelectionRect) then
   begin
      SelectionRectPixels.Left   := FSelectionRect.Left * 8 * FZoom;
      SelectionRectPixels.Top    := FSelectionRect.Top * 8 * FZoom;
      SelectionRectPixels.Right  := FSelectionRect.Right * 8 * FZoom;
      SelectionRectPixels.Bottom := FSelectionRect.Bottom * 8 * FZoom;

      pbTileViewer.Canvas.Pen.Color := GSettings.DefaultSelectionBorderColor;
      pbTileViewer.Canvas.Pen.Width := GSettings.DefaultSelectionBorderWidth;
      pbTileViewer.Canvas.Brush.Color := GSettings.DefaultSelectionFillColor;
      pbTileViewer.Canvas.Brush.Style := GSettings.DefaultSelectionFillStyle;

      pbTileViewer.Canvas.Rectangle(SelectionRectPixels);
      pbTileViewer.Canvas.Brush.Style := bsSolid;
   end;

   // --- PREVIEW LOGIC FOR THE MOVE TOOL ---
   if FIsDragging and (FCurrentTool = tlMove) and Assigned(FMoveSelectionBitmap) then
   begin
      var MousePos := pbTileViewer.ScreenToClient(Mouse.CursorPos);
      var CurrentTileX := MousePos.X div (8 * FZoom);
      var CurrentTileY := MousePos.Y div (8 * FZoom);
      var DeltaX := CurrentTileX - FDragStartPoint.X;
      var DeltaY := CurrentTileY - FDragStartPoint.Y;

      // Calculate the new position for the preview rectangle.
      var PreviewRect: TRect;
      PreviewRect.Left   := (FMoveOriginalRect.Left + DeltaX) * 8 * FZoom;
      PreviewRect.Top    := (FMoveOriginalRect.Top + DeltaY) * 8 * FZoom;
      PreviewRect.Right  := PreviewRect.Left + FMoveSelectionBitmap.Width * FZoom;
      PreviewRect.Bottom := PreviewRect.Top + FMoveSelectionBitmap.Height * FZoom;

      // Draw the cutout bitmap at the new position.
      pbTileViewer.Canvas.StretchDraw(PreviewRect, FMoveSelectionBitmap);
   end;
end;

procedure TDocumentFrame.GetCurrentSettings(var Settings: TProjectFileInfo);
begin
   Settings.Path := FCurrentFileName;
   if Assigned(FCurrentCodec) then
      Settings.CodecID := FCurrentCodec.Id
   else
      Settings.CodecID := '';
   Settings.TilesPerRow := FTilesPerRow;
   Settings.TilesPerColumn := FTilesPerColumn;
   Settings.VScrollPos := vsbTileScroller.Position;
   Settings.HScrollPos := sbOffset.Position;
   Settings.Zoom := FZoom;
   Settings.IsTileGridVisible := FIsTileGridVisible;
   Settings.IsPixelGridVisible := FIsPixelGridVisible;
   Settings.MasterPaletteSource := FMasterPaletteSource;
   Settings.MasterPaletteInfo := FMasterPaletteInfo;
   Settings.ActivePaletteFile := FActivePaletteFile;
   Settings.ActivePaletteIndex := FActivePaletteStartIndex;
   Settings.ActiveColorIndex := FCurrentColorIndex;
end;

procedure TDocumentFrame.ApplyProjectSettings(const Settings: TProjectFileInfo);
var
   i: Integer;
begin
   // Set Codec
   for i := 0 to cbxCodecs.Items.Count - 1 do
   begin
      var Codec := TTileCodec(cbxCodecs.Items.Objects[i]);
      if Assigned(Codec) and (Codec.Id = Settings.CodecID) then
      begin
         cbxCodecs.ItemIndex := i;
         Break;
      end;
   end;
   // Apply the Codec
   cbxCodecsChange(cbxCodecs);

   case Settings.MasterPaletteSource of
      pstDefault: GenerateDefaultPalette;
      pstRomOffset:
      begin
         if TryStrToInt(Settings.MasterPaletteInfo, i) then
            UpdatePaletteFromROM(i);
      end;
      pstExternalFile:
      begin
         if FileExists(Settings.MasterPaletteInfo) and Assigned(FCurrentColorCodec) then
         begin
            var PaletteData := TFile.ReadAllBytes(Settings.MasterPaletteInfo);
            FCurrentColorCodec.Decode(PaletteData, FCurrentPalette);
            FMasterPaletteSource := pstExternalFile;
            FMasterPaletteInfo := Settings.MasterPaletteInfo;
         end;
      end;
   end;

   // Set View Dimensions
   seTilesPerRow.Value := Settings.TilesPerRow;
   seTilesPerColumn.Value := Settings.TilesPerColumn;
   FTilesPerRow := Settings.TilesPerRow;
   FTilesPerColumn := Settings.TilesPerColumn;

   // Set Scroll and Zoom
   FZoom := Settings.Zoom;
   vsbTileScroller.Position := Settings.VScrollPos;
   sbOffset.Position := Settings.HScrollPos;

   // Set Grids
   FIsTileGridVisible := Settings.IsTileGridVisible;
   FIsPixelGridVisible := Settings.IsPixelGridVisible;

   // Set Palette
   FActivePaletteStartIndex := Settings.ActivePaletteIndex;
   FCurrentColorIndex := Settings.ActiveColorIndex;

   //NewROM := True;

   FActivePaletteStartIndex := Settings.ActivePaletteIndex;
   FCurrentColorIndex := Settings.ActiveColorIndex;
   // A chamada abaixo irá popular FActivePalette e redesenhar os componentes da paleta
   UpdateActivePaletteFromMaster;

   UpdateAllViews;
end;

end.