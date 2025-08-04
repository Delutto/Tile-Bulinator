{***********************************************************************************}
{                                                                                   }
{   Unit: UndoSystem                                                                }
{   Project: Tile Bulinator                                                         }
{   Description: This unit defines the data structures and classes for the          }
{                application's undo/redo system. It includes classes for            }
{                individual data modification actions, grouped actions,             }
{                selection changes, and clipboard data structures.                  }
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
unit UndoSystem;

interface

uses
   System.SysUtils, System.Types, System.Generics.Collections;


type
   // Record to hold tile data for clipboard operations (copy/paste).
   TTileClipboardData = record
      Width: Integer;      // Width of the copied block in tiles.
      Height: Integer;     // Height of the copied block in tiles.
      TileData: TBytes;    // The raw byte data of the copied tiles.
   end;

   // Base class for any action that can be placed on the undo/redo stack.
   TUndoableAction = class
   public
      // Description of the action, for UI purposes (e.g., "Draw Tool").
      Description: string;
      constructor Create; virtual;
   end;

   // Represents a single, concrete data modification action.
   TUndoAction = class(TUndoableAction)
   public
      Offset: Int64;       // The starting offset in the data stream where the change occurred.
      OldData: TBytes;     // A copy of the data BEFORE the modification.
      NewData: TBytes;     // A copy of the data AFTER the modification.
      BlockWidth: Integer; // The width of the modified block in tiles.
      TileSize: Integer;   // The size in bytes of a single tile.
      TilesPerRow: Integer;// The total number of tiles in a full row of the source data.
      constructor Create(AOffset: Int64; const AOldData, ANewData: TBytes;
      ABlockWidth, ATileSize, ATilesPerRow: Integer);
   end;

   // Groups multiple TUndoAction objects into a single undoable step.
   // Useful for operations like fill, which can modify many separate areas.
   TUndoActionGroup = class(TUndoableAction)
   private
      // A list that owns and manages the individual TUndoAction objects.
      FActions: TObjectList<TUndoAction>;
      function GetAction(AIndex: Integer): TUndoAction;
   public
      constructor Create;
      destructor Destroy; override;
      procedure Add(AAction: TUndoAction);
      function Count: Integer;
      // Provides access to the individual actions in the group.
      property Actions[AIndex: Integer]: TUndoAction read GetAction;
   end;

   // Represents a change in the user's selection area.
   TSelectionChangeAction = class(TUndoableAction)
   public
      OldSelection: TRect; // The selection rectangle before the change.
      NewSelection: TRect; // The selection rectangle after the change.
      constructor Create(const AOldSelection, ANewSelection: TRect);
   end;

implementation

{ TUndoableAction }

constructor TUndoableAction.Create;
begin
   inherited;
   // Initialize with an empty description.
   Description := '';
end;

{ TUndoAction }

// Creates an action that represents a change in the tile data.
constructor TUndoAction.Create(AOffset: Int64; const AOldData, ANewData: TBytes; ABlockWidth, ATileSize, ATilesPerRow: Integer);
begin
   inherited Create;
   // Store all the necessary information to undo or redo this change.
   Self.Offset := AOffset;
   Self.OldData := AOldData;
   Self.NewData := ANewData;
   Self.BlockWidth := ABlockWidth;
   Self.TileSize := ATileSize;
   Self.TilesPerRow := ATilesPerRow;
end;

{ TUndoActionGroup }

// Creates a group of actions.
constructor TUndoActionGroup.Create;
begin
   inherited Create;
   // Set a default description for the group.
   Description := 'Grouped Action';
   // Create the list that will own the child actions.
   FActions := TObjectList<TUndoAction>.Create(True);
end;

// Frees the list of actions.
destructor TUndoActionGroup.Destroy;
begin
   FActions.Free;
   inherited;
end;

// Adds a child action to the group.
procedure TUndoActionGroup.Add(AAction: TUndoAction);
begin
   FActions.Add(AAction);
end;

// Returns the number of child actions in the group.
function TUndoActionGroup.Count: Integer;
begin
   Result := FActions.Count;
end;

// Returns a specific child action by its index.
function TUndoActionGroup.GetAction(AIndex: Integer): TUndoAction;
begin
   Result := FActions[AIndex];
end;

{ TSelectionChangeAction }

// Creates an action that represents a change in the selection rectangle.
constructor TSelectionChangeAction.Create(const AOldSelection, ANewSelection: TRect);
begin
   inherited Create;
   // Set a default description.
   Description := 'Selection Change';
   // Store the old and new selection states.
   Self.OldSelection := AOldSelection;
   Self.NewSelection := ANewSelection;
end;

end.