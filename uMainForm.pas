{***********************************************************************************}
{                                                                               		}
{   Unit: uMainForm                                                             		}
{   Project: Tile Bulinator                                                     		}
{   Description: This unit defines the main form of the application. It acts as 		}
{                the MDI container, managing multiple document frames in a      		}
{                tabbed interface (TPageControl). It handles the main menu,     		}
{                status bar, shared dialogs, and routes user actions and events 		}
{                to the currently active document frame. It also manages the    		}
{                recent files list.                                             		}
{                                                                               		}
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
unit uMainForm;

interface

uses
   Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.IOUtils,
   Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
   Vcl.ComCtrls, Vcl.Menus,
   uDocumentFrame, uLocalization, uProject, uSettings, uSettingsForm, uAboutForm;

type
   TMainForm = class(TForm)
      MainMenu1: TMainMenu;
      mnuFile: TMenuItem;
      mnuOpen: TMenuItem;
      mnuOpenRecent: TMenuItem;
      mnuSave: TMenuItem;
      mnuSaveAs: TMenuItem;
      N1: TMenuItem;
      mnuClose: TMenuItem;
      mnuCloseAll: TMenuItem;
      mnuExit: TMenuItem;
      mnuEdit: TMenuItem;
      mnuUndo: TMenuItem;
      mnuRedo: TMenuItem;
      N4: TMenuItem;
      mnuCopy: TMenuItem;
      mnuPaste: TMenuItem;
      N2: TMenuItem;
      mnuExportToPNG: TMenuItem;
      mnuImportFromPNG: TMenuItem;
      ImportarPNGparaSeleo1: TMenuItem; // Note: This might be a duplicate menu item to be reviewed.
      mnuGoTo: TMenuItem;
      mnuView: TMenuItem;
      mnuTileGrid: TMenuItem;
      mnuPixelGrid: TMenuItem;
      mnuPalette: TMenuItem;
      mnuLoadMasterPaletteFromFile: TMenuItem;
      N3: TMenuItem;
      mnuLoadActivePaletteFromFile: TMenuItem;
      mnuSaveActivePalette: TMenuItem;
      OpenDialog: TOpenDialog;
      SaveDialog1: TSaveDialog;
      OpenPaletteDialog: TOpenDialog;
      ColorDialog: TColorDialog;
      sbStatus: TStatusBar;
      pgcDocuments: TPageControl; // The tab control that hosts document frames.
      mnuCut: TMenuItem;
      mnuSaveAll: TMenuItem;
      mnuLoadMasterPaletteFromROM: TMenuItem;
      mnuProject: TMenuItem;
      mnuNewProject: TMenuItem;
      N6: TMenuItem;
      mnuOpenProject: TMenuItem;
      mnuSaveProject: TMenuItem;
      N7: TMenuItem;
      mnuCloseProject: TMenuItem;
      mnuSaveProjectAs: TMenuItem;
      mnuOpenRecentProject: TMenuItem;
      N_PROJ_EMPTY: TMenuItem;
      mnuSettings: TMenuItem;
    mnuHelp: TMenuItem;
    mnuUserManual: TMenuItem;
    mnuAbout: TMenuItem;
      // --- Event Handler Declarations ---
      procedure mnuExitClick(Sender: TObject);
      procedure mnuOpenClick(Sender: TObject);
      procedure mnuUndoClick(Sender: TObject);
      procedure mnuRedoClick(Sender: TObject);
      procedure mnuCopyClick(Sender: TObject);
      procedure mnuPasteClick(Sender: TObject);
      procedure mnuGoToClick(Sender: TObject);
      procedure mnuExportToPNGClick(Sender: TObject);
      procedure mnuImportFromPNGClick(Sender: TObject);
      procedure LoadMasterPalette(Sender: TObject);
      procedure LoadActivePalette(Sender: TObject);
      procedure SaveActivePalette(Sender: TObject);
      procedure mnuTileGridClick(Sender: TObject);
      procedure mnuPixelGridClick(Sender: TObject);
      procedure mnuSaveClick(Sender: TObject);
      procedure mnuSaveAsClick(Sender: TObject);
      procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
      procedure mnuCutClick(Sender: TObject);
      procedure FormCreate(Sender: TObject);
      procedure FormShow(Sender: TObject);
      procedure pgcDocumentsChange(Sender: TObject);
      procedure FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
      procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
      procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
      procedure mnuLoadMasterPaletteFromFileClick(Sender: TObject);
      procedure mnuLoadActivePaletteFromFileClick(Sender: TObject);
      procedure mnuSaveActivePaletteClick(Sender: TObject);
      procedure mnuCloseClick(Sender: TObject);
      procedure mnuCloseAllClick(Sender: TObject);
      procedure mnuSaveAllClick(Sender: TObject);
      procedure mnuLoadMasterPaletteFromROMClick(Sender: TObject);
      procedure mnuFileClick(Sender: TObject);
      procedure RecentFileClick(Sender: TObject);
      procedure NotImplementedYet(Sender: TObject);
      procedure mnuNewProjectClick(Sender: TObject);
      procedure mnuOpenProjectClick(Sender: TObject);
      procedure mnuSaveProjectClick(Sender: TObject);
      procedure mnuSaveProjectAsClick(Sender: TObject);
      procedure mnuCloseProjectClick(Sender: TObject);
      procedure RecentProjectClick(Sender: TObject);
      procedure mnuProjectClick(Sender: TObject);
      procedure mnuSettingsClick(Sender: TObject);
    procedure mnuAboutClick(Sender: TObject);
   private
      { Private declarations }
      MaxRecentFiles: Integer;
      FRecentFiles: TStringList;    // List to manage the "Open Recent" menu items.
      FRecentProjects: TStringList; // List to manage the "Open Recent Project" menu items.
      FCurrentProject: TProject;
      FCurrentProjectFileName: String;
      FProjectModified: Boolean;
      procedure LoadRecentFiles;
      procedure SaveRecentFiles;
      procedure AddToRecentFiles(const AFileName: string);
      procedure LoadRecentProjects;
      procedure SaveRecentProjects;
      procedure AddToRecentProjects(const AFileName: string);
      function GetActiveFrame: TDocumentFrame; // Helper to get the currently focused document frame.
      procedure UpdateMenus; // Updates the enabled/checked state of all menus.
      procedure FrameStateDidChange(Sender: TObject); // Event handler called by frames when their state changes.
      function CloseTab(ATabSheet: TTabSheet): Boolean; // Logic for closing a single tab, including the "Save changes?" prompt.
      procedure OpenROMFile(AFileName: String); // Core procedure for opening a file in a new tab.
      function CheckAndSaveCurrentProject: Boolean; // Check if the project needs to be saved
   public
      { Public declarations }
      destructor Destroy; override;
   end;

var
   MainForm: TMainForm;

implementation

{$R *.dfm}

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
begin
   Self.Caption := 'Tile Bulinator 0.9.1 by Delutto';

   // Load the program language from Settings.
   LOC.LoadLanguage(GSettings.LanguageFile);
   LOC.TranslateComponent(Self);

   // Configure the open dialog to allow selecting multiple files at once.
   OpenDialog.Options := OpenDialog.Options + [ofAllowMultiSelect];

   // Load the Recent sub-menu itens
   LoadRecentFiles;
   LoadRecentProjects;

   // Project System Initialization
   FCurrentProject := TProject.Create;
   FCurrentProjectFileName := '';
   FProjectModified := False;

   // Set variables from Settings
   MaxRecentFiles := GSettings.MaxRecentFiles;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
   ActiveFrame: TDocumentFrame;
begin
   // Forward key down events to the active document frame.
   ActiveFrame := GetActiveFrame;
   if Assigned(ActiveFrame) then
      ActiveFrame.HandleKeyDown(Key, Shift);
end;

procedure TMainForm.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
   ActiveFrame: TDocumentFrame;
begin
   // Forward key up events to the active document frame.
   ActiveFrame := GetActiveFrame;
   if Assigned(ActiveFrame) then
      ActiveFrame.HandleKeyUp(Key, Shift);
end;

procedure TMainForm.FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var
   ActiveFrame: TDocumentFrame;
   TileViewerRect: TRect;
begin
   ActiveFrame := GetActiveFrame;
   if not Assigned(ActiveFrame) then
      Exit;

   // Get the active frame's tile viewer rectangle in screen coordinates.
   TileViewerRect := ActiveFrame.pbTileViewer.ClientToScreen(ActiveFrame.pbTileViewer.ClientRect);

   // Check if the global mouse cursor position is inside the tile viewer.
   if PtInRect(TileViewerRect, Mouse.CursorPos) then
   begin
      // If the mouse is over the viewer, forward the event to the frame.
      ActiveFrame.DoMouseWheel(Shift, WheelDelta, Handled);
   end;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
   Self.WindowState := GSettings.DefaultWindowState;
   UpdateMenus;
end;

procedure TMainForm.FrameStateDidChange(Sender: TObject);
begin
   // When a frame's state changes, we update the menus, window title and project status.
   FProjectModified := True;
   UpdateMenus;
   var ActiveFrame := GetActiveFrame;
   if Assigned(ActiveFrame) then
   begin
      // Add or remove the asterisk (*) to indicate modified status.
      if ActiveFrame.IsModified then
      begin
         pgcDocuments.ActivePage.Caption := ExtractFileName(ActiveFrame.FileName) + '*';
         Self.Caption := 'Tile Bulinator 0.9.1 by Delutto - ' + ExtractFileName(ActiveFrame.FileName) + '*';
      end
      else
      begin
         pgcDocuments.ActivePage.Caption := ExtractFileName(ActiveFrame.FileName);
         Self.Caption := 'Tile Bulinator 0.9.1 by Delutto - ' + ExtractFileName(ActiveFrame.FileName);
      end;
   end
   else
      Self.Caption := 'Tile Bulinator 0.9.1 by Delutto';
end;

procedure TMainForm.pgcDocumentsChange(Sender: TObject);
var
   ActiveFrame: TDocumentFrame;
begin
   // 1. Whenever the user switches tabs, update the menu states and window title.
   ActiveFrame := GetActiveFrame;
   UpdateMenus;
   FrameStateDidChange(nil);

   // 2. Update the status bar.
   if Assigned(ActiveFrame) then
   begin
      sbStatus.Panels[0].Text := ActiveFrame.FileName;
      sbStatus.Panels[1].Text := ''; // Clear position info.
      sbStatus.Panels[2].Text := 'Zoom: ' + IntToStr(ActiveFrame.Zoom) + 'x'; // Use the frame's zoom level.
   end
   else
   begin
      sbStatus.Panels[0].Text := LOC.Get('Messages','NoFileOpen', 'No file open');
      sbStatus.Panels[1].Text := '';
      sbStatus.Panels[2].Text := '';
   end;
end;

procedure TMainForm.RecentFileClick(Sender: TObject);
var
   MenuItem: TMenuItem;
   FileName: String;
begin
   // Handles a click on any item in the "Open Recent" menu.
   if Sender is TMenuItem then
   begin
      MenuItem := Sender as TMenuItem;
      // Get the filename from our list using the Tag we stored earlier.
      if (MenuItem.Tag >= 0) and (MenuItem.Tag < FRecentFiles.Count) then
      begin
         FileName := FRecentFiles[MenuItem.Tag];
         // Open the selected file.
         OpenROMFile(FileName);
      end;
   end;
end;

procedure TMainForm.RecentProjectClick(Sender: TObject);
var
   MenuItem: TMenuItem;
   FileName: String;
begin
   if not (Sender is TMenuItem) then
      Exit;

   MenuItem := Sender as TMenuItem;
   if (MenuItem.Tag >= 0) and (MenuItem.Tag < FRecentProjects.Count) then
   begin
      FileName := FRecentProjects[MenuItem.Tag];

      // Logic to open the project (similar to mnuOpenProjectClick)
      if not CheckAndSaveCurrentProject then
         Exit;

      mnuCloseAllClick(nil);
      if pgcDocuments.PageCount > 0 then
         Exit;

      FCurrentProject.LoadFromFile(FileName);
      FCurrentProjectFileName := FileName;
      AddToRecentProjects(FileName); // Move to top of list

      for var FileInfo in FCurrentProject.Files do
      begin
         OpenROMFile(FileInfo.Path);
         var Frame := GetActiveFrame;
         if Assigned(Frame) and (CompareText(ExtractFileName(Frame.FileName), ExtractFileName(FileInfo.Path)) = 0) then
            Frame.ApplyProjectSettings(FileInfo);
      end;

      if (FCurrentProject.ActiveTabIndex >= 0) and (FCurrentProject.ActiveTabIndex < pgcDocuments.PageCount) then
         pgcDocuments.ActivePageIndex := FCurrentProject.ActiveTabIndex;

      Self.Caption := 'Tile Bulinator - ' + ExtractFileName(FCurrentProjectFileName);
      FProjectModified := False;
      UpdateMenus;
   end;
end;

function TMainForm.GetActiveFrame: TDocumentFrame;
begin
   // Safely gets the active TDocumentFrame from the current tab.
   Result := nil;
   if (pgcDocuments.ActivePage <> nil) and (pgcDocuments.ActivePage.ControlCount > 0) then
   begin
      if pgcDocuments.ActivePage.Controls[0] is TDocumentFrame then
         Result := pgcDocuments.ActivePage.Controls[0] as TDocumentFrame;
   end;
end;

procedure TMainForm.UpdateMenus;
var
   ActiveFrame: TDocumentFrame;
   IsProjectOpen: Boolean;
begin
   ActiveFrame := GetActiveFrame;
   IsProjectOpen := pgcDocuments.PageCount > 0;

   // Enable/disable top-level menus based on whether a document is active.
   // File Menu
   mnuSave.Enabled := Assigned(ActiveFrame);
   mnuSaveAs.Enabled := Assigned(ActiveFrame);
   mnuClose.Enabled := IsProjectOpen;
   mnuCloseAll.Enabled := IsProjectOpen;
   mnuSaveAll.Enabled := IsProjectOpen;

   // Project Menu
   mnuSaveProject.Enabled := IsProjectOpen and FProjectModified;
   mnuSaveProjectAs.Enabled := IsProjectOpen;
   mnuCloseProject.Enabled := IsProjectOpen;

   // Other Menus
   mnuEdit.Enabled := Assigned(ActiveFrame);
   mnuView.Enabled := Assigned(ActiveFrame);
   mnuPalette.Enabled := Assigned(ActiveFrame);

   if Assigned(ActiveFrame) then
   begin
      // Enable action items that only depend on a file being open.
      mnuGoTo.Enabled := True;

      // Ask the active frame to update the more complex menu states (which depend on selection, clipboard, etc.).
      ActiveFrame.UpdateMenuState(mnuUndo, mnuRedo, mnuCut, mnuCopy, mnuPaste, mnuExportToPNG, mnuImportFromPNG, mnuTileGrid, mnuPixelGrid);
   end
   else
   begin
      // If no document is open, disable all action menus.
      mnuUndo.Enabled := False;
      mnuRedo.Enabled := False;
      mnuCopy.Enabled := False;
      mnuPaste.Enabled := False;
      mnuCut.Enabled := False;
      mnuGoTo.Enabled := False;
      mnuExportToPNG.Enabled := False;
      mnuImportFromPNG.Enabled := False;
   end;
end;

procedure TMainForm.mnuOpenClick(Sender: TObject);
var
   I: Integer;
begin
   if OpenDialog.Execute then
   begin
      // Allow opening multiple files at once.
      for i := 0 to OpenDialog.Files.Count - 1 do
      begin
         try
            OpenROMFile(OpenDialog.Files[I]);
         finally
            // Add the file to the recent files list regardless of successful load.
            AddToRecentFiles(OpenDialog.Files[I]);
         end;
      end;
   end;
end;

procedure TMainForm.mnuOpenProjectClick(Sender: TObject);
var
   OpenProjDialog: TOpenDialog;
   i: Integer;
   FileInfo: TProjectFileInfo;
begin
   if not CheckAndSaveCurrentProject then
      Exit;

   mnuCloseAllClick(nil);
   if pgcDocuments.PageCount > 0 then
      Exit; // User cancelled closing a tab

   OpenProjDialog := TOpenDialog.Create(Self);
   try
      OpenProjDialog.Filter := LOC.Get('Messages', 'OpenProjDialogFilter');
      OpenProjDialog.DefaultExt := 'tbproj';
      OpenProjDialog.Title := LOC.Get('Messages', 'OpenProjDialogTitle');
      if OpenProjDialog.Execute then
      begin
         FCurrentProject.LoadFromFile(OpenProjDialog.FileName);
         FCurrentProjectFileName := OpenProjDialog.FileName;

         // Add the file to the recent project list
         AddToRecentProjects(OpenProjDialog.FileName);

         // Open all files listed in the project
         for FileInfo in FCurrentProject.Files do
         begin
            OpenROMFile(FileInfo.Path);
            // Apply saved settings to the newly opened frame
            var Frame := GetActiveFrame;
            if Assigned(Frame) and (CompareText(ExtractFileName(Frame.FileName), ExtractFileName(FileInfo.Path)) = 0) then
               Frame.ApplyProjectSettings(FileInfo);
         end;

         // Set the active tab
         if (FCurrentProject.ActiveTabIndex >= 0) and (FCurrentProject.ActiveTabIndex < pgcDocuments.PageCount) then
            pgcDocuments.ActivePageIndex := FCurrentProject.ActiveTabIndex;

         Self.Caption := 'Tile Bulinator - ' + ExtractFileName(FCurrentProjectFileName);
         FProjectModified := False;
      end;
   finally
      OpenProjDialog.Free;
   end;
end;

procedure TMainForm.AddToRecentFiles(const AFileName: string);
var
   I: Integer;
begin
   // Search if the file already exists and remove it to move it to the top.
   for i := FRecentFiles.Count - 1 downto 0 do
      if SameText(FRecentFiles[i], AFileName) then
         FRecentFiles.Delete(i);

   // Add the new file to the top of the list.
   FRecentFiles.Insert(0, AFileName);

   // Ensure the list does not exceed the maximum size.
   while FRecentFiles.Count > MaxRecentFiles do
      FRecentFiles.Delete(FRecentFiles.Count - 1);
end;

procedure TMainForm.AddToRecentProjects(const AFileName: string);
var
   I: Integer;
begin
   for i := FRecentProjects.Count - 1 downto 0 do
   begin
      if SameText(FRecentProjects[i], AFileName) then
         FRecentProjects.Delete(i);
   end;

   FRecentProjects.Insert(0, AFileName);

   while FRecentProjects.Count > MaxRecentFiles do
      FRecentProjects.Delete(FRecentProjects.Count - 1);
end;

function TMainForm.CheckAndSaveCurrentProject: Boolean;
var
   SaveChangesResult: Integer;
begin
   Result := True; // Assume we can proceed
   if not FProjectModified then
      Exit; // If it has not been modified, do nothing and continue

   SaveChangesResult := MessageDlg( LOC.Get('Messages', 'ProjectModifiedPrompt'),
                                    mtConfirmation, [mbYes, mbNo, mbCancel], 0, mbYes,
                                    [LOC.Get('Messages', 'msgYes'),
                                    LOC.Get('Messages', 'msgNo'),
                                    LOC.Get('Messages', 'msgCancel')]);

   case SaveChangesResult of
      mrYes:
      begin
         mnuSaveProjectClick(nil);
         // If the user canceled the "Save As" dialog, FProjectModified will still be True.
         Result := not FProjectModified;
      end;
      mrNo: Result := True; // Continue without saving
      mrCancel: Result := False; // Abortar a operação
   end;
end;

function TMainForm.CloseTab(ATabSheet: TTabSheet): Boolean;
var
   Frame: TDocumentFrame;
   SaveChangesResult: Integer;
begin
   Result := False; // Assume it won't close by default.
   if not Assigned(ATabSheet) or (ATabSheet.ControlCount = 0) then
      Exit;

   Frame := ATabSheet.Controls[0] as TDocumentFrame;

   // If the document is not modified, just close it.
   if not Frame.IsModified then
   begin
      Result := True; // Allow closing.
      ATabSheet.Free; // Free the tab and its child frame.
      Exit;
   end;

   // If modified, ask the user.
   pgcDocuments.ActivePage := ATabSheet; // Bring the tab to the front before asking.
   SaveChangesResult := MessageDlg( Format(LOC.Get('Messages', 'SaveChangesPrompt'),[ExtractFileName(Frame.FileName)]),
                                    mtConfirmation, [mbYes, mbNo, mbCancel], 0, mbYes,
                                    [LOC.Get('Messages', 'msgYes'),
                                    LOC.Get('Messages', 'msgNo'),
                                    LOC.Get('Messages', 'msgCancel')]);

   case SaveChangesResult of
      mrYes:
      begin
         Frame.Save;
         // If the file is still modified (e.g., user cancelled "Save As"), don't close.
         Result := not Frame.IsModified;
         if Result then
            ATabSheet.Free;
      end;
      mrNo: // Close without saving.
      begin
         Result := True;
         ATabSheet.Free;
      end;
      mrCancel: // Cancel the close operation.
         Result := False;
   end;
end;

destructor TMainForm.Destroy;
begin
   FCurrentProject.Free;
   inherited;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
   try
      // Persist the recent files list before closing.
      SaveRecentFiles;
      SaveRecentProjects;
   finally
   end;
   // Attempt to close all tabs.
   mnuCloseAllClick(Sender);
   // The form can only close if no tabs remain open.
   CanClose := (pgcDocuments.PageCount = 0);
end;

// --- ACTION ROUTING ROUTINES ---
// These methods simply get the active frame and call the corresponding method on it.

procedure TMainForm.mnuCopyClick(Sender: TObject);
begin
   var ActiveFrame := GetActiveFrame;
   if Assigned(ActiveFrame) then
      ActiveFrame.CopySelection;
end;

procedure TMainForm.mnuPasteClick(Sender: TObject);
begin
   var ActiveFrame := GetActiveFrame;
   if Assigned(ActiveFrame) then
      ActiveFrame.PasteSelection;
end;

procedure TMainForm.mnuCutClick(Sender: TObject);
begin
   var ActiveFrame := GetActiveFrame;
   if Assigned(ActiveFrame) then
      ActiveFrame.CutSelection;
end;

procedure TMainForm.mnuExportToPNGClick(Sender: TObject);
begin
   var ActiveFrame := GetActiveFrame;
   if Assigned(ActiveFrame) then
      ActiveFrame.ExportSelectionToPNG;
end;

procedure TMainForm.mnuFileClick(Sender: TObject);
var
   I: Integer;
   NewItem: TMenuItem;
begin
   // This event dynamically populates the "Open Recent" submenu before it's shown.
   // 1. Clear old items (except the placeholder "Empty" if it exists).
   while mnuOpenRecent.Count > 1 do
      mnuOpenRecent.Items[1].Free;

   // 2. If the recent list is not empty, remove the placeholder.
   if (FRecentFiles.Count > 0) and (mnuOpenRecent.Count > 0) then
      mnuOpenRecent.Items[0].Free;

   // 3. Populate the menu with files from the list.
   for i := 0 to FRecentFiles.Count - 1 do
   begin
      NewItem := TMenuItem.Create(Self);
      // Display the filename and a shortcut number (&1, &2, etc.).
      NewItem.Caption := Format('&%d %s', [i + 1, FRecentFiles[i]]);
      NewItem.Tag := i; // Store the index for easy access.
      NewItem.OnClick := RecentFileClick; // All items use the same event handler.
      mnuOpenRecent.Add(NewItem);
   end;
end;

procedure TMainForm.mnuCloseClick(Sender: TObject);
begin
   // Just call our new function for the active tab.
   if CloseTab(pgcDocuments.ActivePage) then
   begin
      FProjectModified := True; // Closing a tab changes the project's file list
      UpdateMenus;
   end;
end;

procedure TMainForm.mnuCloseProjectClick(Sender: TObject);
begin
   if not CheckAndSaveCurrentProject then
      Exit;

   // Same as creating a new project
   mnuNewProjectClick(Sender);
end;

procedure TMainForm.mnuAboutClick(Sender: TObject);
var
   frmAbout: TAboutForm;
begin
   frmAbout := TAboutForm.Create(Self);
   try
      frmAbout.ShowModal;
   finally
      frmAbout.Free;
   end;
end;

procedure TMainForm.mnuCloseAllClick(Sender: TObject);
var
   I: Integer;
begin
   // Iterate through all tabs BACKWARDS. This is crucial when removing items from a list.
   I := pgcDocuments.PageCount - 1;
   while I >= 0 do
   begin
      // Try to close the tab. If the user cancels, the function will return False.
      if not CloseTab(pgcDocuments.Pages[I]) then
         Break; // Abort the "Close All" operation if the user clicks "Cancel".
      Dec(I);
   end;
end;

procedure TMainForm.mnuImportFromPNGClick(Sender: TObject);
begin
   var ActiveFrame := GetActiveFrame;
   if Assigned(ActiveFrame) then
      ActiveFrame.ImportPNGToSelection;
end;

procedure TMainForm.mnuLoadActivePaletteFromFileClick(Sender: TObject);
begin
   var ActiveFrame := GetActiveFrame;
   if Assigned(ActiveFrame) then
      ActiveFrame.LoadActivePalette;
end;

procedure TMainForm.mnuLoadMasterPaletteFromFileClick(Sender: TObject);
begin
   var ActiveFrame := GetActiveFrame;
   if Assigned(ActiveFrame) then
      ActiveFrame.LoadMasterPalette;
end;

procedure TMainForm.mnuLoadMasterPaletteFromROMClick(Sender: TObject);
begin
   var ActiveFrame := GetActiveFrame;
   if Assigned(ActiveFrame) then
      ActiveFrame.LoadMasterPaletteFromROM;
end;

procedure TMainForm.mnuNewProjectClick(Sender: TObject);
begin
   if not CheckAndSaveCurrentProject then
      Exit;

   mnuCloseAllClick(nil); // Close all ROM's tabs
   if pgcDocuments.PageCount = 0 then
   begin
      FCurrentProject.Clear;
      FCurrentProjectFileName := '';
      FProjectModified := False;
      Self.Caption := 'Tile Bulinator - ' + LOC.Get('Messages', 'UntitledProject');
      UpdateMenus;
   end;
end;

procedure TMainForm.mnuGoToClick(Sender: TObject);
begin
   var ActiveFrame := GetActiveFrame;
   if Assigned(ActiveFrame) then
      ActiveFrame.GoToOffset;
end;

procedure TMainForm.mnuRedoClick(Sender: TObject);
begin
   var ActiveFrame := GetActiveFrame;
   if Assigned(ActiveFrame) then
      ActiveFrame.Redo;
end;

procedure TMainForm.mnuUndoClick(Sender: TObject);
begin
   var ActiveFrame := GetActiveFrame;
   if Assigned(ActiveFrame) then
      ActiveFrame.Undo;
end;

procedure TMainForm.NotImplementedYet(Sender: TObject);
begin
   ShowMessage(LOC.Get('Messages', 'NotImplemented'));
end;

procedure TMainForm.OpenROMFile(AFileName: String);
var
   DocFrame: TDocumentFrame;
   TabSheet: TTabSheet;
begin
   // Creates a new tab.
   TabSheet := TTabSheet.Create(pgcDocuments);
   TabSheet.PageControl := pgcDocuments;

   // Creates a new document frame inside the tab.
   DocFrame := TDocumentFrame.Create(TabSheet);
   DocFrame.Parent := TabSheet;
   DocFrame.Align := alClient;

   // Pass the shared dialogs and status bar to the frame.
   DocFrame.OpenDialog := OpenDialog;
   DocFrame.OpenPaletteDialog := OpenPaletteDialog;
   DocFrame.SaveDialog := SaveDialog1;
   DocFrame.ColorDialog := ColorDialog;
   DocFrame.StatusBar := sbStatus;

   // Hook up the event handler so the frame can notify the main form of changes.
   DocFrame.OnStateChange := FrameStateDidChange;

   // Load the file into the frame.
   if DocFrame.LoadFromFile(AFileName) then
   begin
      TabSheet.Caption := ExtractFileName(AFileName);
      pgcDocuments.ActivePage := TabSheet; // Make the new tab active.
      FProjectModified := True; // <- Adicione esta linha
      UpdateMenus;
   end
   else
   begin
      TabSheet.Free; // If loading fails, destroy the new tab.
   end;
end;

procedure TMainForm.mnuSaveClick(Sender: TObject);
begin
   var ActiveFrame := GetActiveFrame;
   if Assigned(ActiveFrame) then
   begin
       if MessageDlg(Format(LOC.Get('Messages', 'SaveChangesPrompt'), [ExtractFileName(ActiveFrame.FileName)]),
                     mtConfirmation, [mbYes, mbNo], 0, mbYes,
                     [LOC.Get('Messages', 'msgYes'),
                     LOC.Get('Messages', 'msgNo'),
                     LOC.Get('Messages', 'msgCancel')]) = mrYes then
       begin
          ActiveFrame.Save;
       end;
   end;
end;

procedure TMainForm.mnuSaveProjectAsClick(Sender: TObject);
var
   SaveProjDialog: TSaveDialog;
begin
   SaveProjDialog := TSaveDialog.Create(Self);
   try
      SaveProjDialog.Filter := LOC.Get('Messages', 'OpenProjDialogFilter');
      SaveProjDialog.DefaultExt := 'tbproj';
      SaveProjDialog.Title := LOC.Get('Messages', 'SaveProjectAs');
      if SaveProjDialog.Execute then
      begin
         FCurrentProjectFileName := SaveProjDialog.FileName;
         mnuSaveProjectClick(nil); // Now call the regular save
         AddToRecentProjects(FCurrentProjectFileName);
      end;
   finally
      SaveProjDialog.Free;
   end;
end;

procedure TMainForm.mnuSaveProjectClick(Sender: TObject);
var
   SaveProjDialog: TSaveDialog;
   i: Integer;
   Frame: TDocumentFrame;
   FileInfo: TProjectFileInfo;
begin
   if FCurrentProjectFileName = '' then
   begin
      // If project was never saved, act as "Save As"
      mnuSaveProjectAsClick(Sender);
      Exit;
   end;

   FCurrentProject.Clear;
   FCurrentProject.ActiveTabIndex := pgcDocuments.ActivePageIndex;

   // Gather state from all open frames
   for i := 0 to pgcDocuments.PageCount - 1 do
   begin
      Frame := pgcDocuments.Pages[i].Controls[0] as TDocumentFrame;
      Frame.GetCurrentSettings(FileInfo);
      FCurrentProject.Files.Add(FileInfo);
   end;

   FCurrentProject.SaveToFile(FCurrentProjectFileName);
   FProjectModified := False;
   Self.Caption := 'Tile Bulinator - ' + ExtractFileName(FCurrentProjectFileName);
end;

procedure TMainForm.mnuSettingsClick(Sender: TObject);
var
   frmSettings: TSettingsForm;
begin
   frmSettings := TSettingsForm.Create(Self);
   try
      if frmSettings.ShowModal = mrOk then
      begin
         // O usuário clicou em OK. As configurações já foram salvas.
         // Notifica o usuário para reiniciar o app para aplicar algumas mudanças.
         ShowMessage(LOC.Get('Messages', 'RestartRequired'));
      end;
   finally
      frmSettings.Free;
   end;
end;

procedure TMainForm.mnuSaveAsClick(Sender: TObject);
begin
   var ActiveFrame := GetActiveFrame;
   if Assigned(ActiveFrame) then
      ActiveFrame.SaveAs;
end;

procedure TMainForm.mnuSaveActivePaletteClick(Sender: TObject);
begin
var ActiveFrame := GetActiveFrame;
   if Assigned(ActiveFrame) then
      ActiveFrame.SaveActivePalette;
end;

procedure TMainForm.mnuSaveAllClick(Sender: TObject);
var
   I: Integer;
   Frame: TDocumentFrame;
begin
   if MessageDlg( LOC.Get('Messages', 'ConfirmSaveAll'),
                  mtConfirmation, [mbYes, mbNo], 0, mbYes,
                  [LOC.Get('Messages', 'msgYes'),
                  LOC.Get('Messages', 'msgNo'),
                  LOC.Get('Messages', 'msgCancel')]) = mrYes then
   begin
      I := pgcDocuments.PageCount - 1;
      while I >= 0 do
      begin
         Frame := pgcDocuments.Pages[I].Controls[0] as TDocumentFrame;
         try
            Frame.Save;
         finally
            // After saving, update the caption to remove the asterisk (*).
            if not Frame.IsModified then
               pgcDocuments.Pages[I].Caption := ExtractFileName(Frame.FileName);
         end;
         Dec(I);
      end;
   end;
end;

procedure TMainForm.mnuPixelGridClick(Sender: TObject);
begin
   var ActiveFrame := GetActiveFrame;
   if Assigned(ActiveFrame) then
   begin
      ActiveFrame.TogglePixelGrid;
      (Sender as TMenuItem).Checked := ActiveFrame.IsPixelGridVisible;
   end;
end;

procedure TMainForm.mnuProjectClick(Sender: TObject);
var
   I: Integer;
   NewItem: TMenuItem;
begin
   // Limpa os itens antigos
   while mnuOpenRecentProject.Count > 1 do
      mnuOpenRecentProject.Items[1].Free;

   if FRecentProjects.Count > 0 then
      mnuOpenRecentProject.Items[0].Free; // Remove o placeholder "(Vazio)"

   // Popula o menu com os projetos recentes
   for i := 0 to FRecentProjects.Count - 1 do
   begin
      NewItem := TMenuItem.Create(Self);
      NewItem.Caption := Format('&%d %s', [i + 1, FRecentProjects[i]]);
      NewItem.Tag := i;
      NewItem.OnClick := RecentProjectClick; // Define o handler do clique
      mnuOpenRecentProject.Add(NewItem);
   end;
end;

procedure TMainForm.mnuTileGridClick(Sender: TObject);
begin
   var ActiveFrame := GetActiveFrame;
   if Assigned(ActiveFrame) then
   begin
      ActiveFrame.ToggleTileGrid;
      (Sender as TMenuItem).Checked := ActiveFrame.IsTileGridVisible;
   end;
end;

procedure TMainForm.LoadActivePalette(Sender: TObject);
begin
   var ActiveFrame := GetActiveFrame;
   if Assigned(ActiveFrame) then
      ActiveFrame.LoadActivePalette;
end;

procedure TMainForm.LoadMasterPalette(Sender: TObject);
begin
   var ActiveFrame := GetActiveFrame;
   if Assigned(ActiveFrame) then
      ActiveFrame.LoadMasterPalette;
end;

procedure TMainForm.LoadRecentFiles;
var
   HistoryFile: string;
begin
   // Create the TStringList instance.
   FRecentFiles := TStringList.Create;
   // Define the path to the history file in a safe user folder.
   HistoryFile := TPath.Combine(TPath.GetAppPath, 'data', 'RecentFiles.txt');
   if FileExists(HistoryFile) then
   begin
      try
         FRecentFiles.LoadFromFile(HistoryFile);
      except
         // Silently ignore loading errors.
      end;
   end;
end;

procedure TMainForm.LoadRecentProjects;
var
   HistoryFile: string;
begin
   FRecentProjects := TStringList.Create;
   HistoryFile := TPath.Combine(TPath.GetAppPath, 'data', 'RecentProjects.txt');
   if FileExists(HistoryFile) then
   begin
      try
         FRecentProjects.LoadFromFile(HistoryFile);
      except
         // Silently ignore loading errors
      end;
   end;
end;

procedure TMainForm.SaveActivePalette(Sender: TObject);
begin
   var ActiveFrame := GetActiveFrame;
   if Assigned(ActiveFrame) then
      ActiveFrame.SaveActivePalette;
end;

procedure TMainForm.SaveRecentFiles;
var
   HistoryFile, HistoryPath: String;
begin
   HistoryPath := TPath.Combine(TPath.GetAppPath, 'data');
   HistoryFile := TPath.Combine(HistoryPath, 'RecentFiles.txt');
   try
      // Ensure the directory exists.
      if not DirectoryExists(HistoryPath) then
         ForceDirectories(HistoryPath);
      FRecentFiles.SaveToFile(HistoryFile);
   except
      // Silently ignore saving errors.
   end;
end;

procedure TMainForm.SaveRecentProjects;
var
   HistoryFile, HistoryPath: String;
begin
   HistoryPath := TPath.Combine(TPath.GetAppPath, 'data');
   HistoryFile := TPath.Combine(HistoryPath, 'RecentProjects.txt');
   try
      if not DirectoryExists(HistoryPath) then
         ForceDirectories(HistoryPath);
      FRecentProjects.SaveToFile(HistoryFile);
   except
      // Silently ignore saving errors
   end;
end;

procedure TMainForm.mnuExitClick(Sender: TObject);
begin
   Close;
end;

end.