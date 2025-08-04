object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Tile Bulinator by Delutto'
  ClientHeight = 709
  ClientWidth = 1086
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyUp = FormKeyUp
  OnMouseWheel = FormMouseWheel
  OnShow = FormShow
  TextHeight = 13
  object sbStatus: TStatusBar
    Left = 0
    Top = 690
    Width = 1086
    Height = 19
    Panels = <
      item
        Width = 500
      end
      item
        Width = 450
      end
      item
        Width = 50
      end>
  end
  object pgcDocuments: TPageControl
    Left = 0
    Top = 0
    Width = 1086
    Height = 690
    Align = alClient
    TabOrder = 1
    OnChange = pgcDocumentsChange
  end
  object OpenDialog: TOpenDialog
    Filter = 'SNES ROM File(*.smc, *.sfs)|*.smc;*.sfs'
    Title = 'Open ROM file'
    Left = 508
    Top = 80
  end
  object OpenPaletteDialog: TOpenDialog
    Filter = 
      'Tile Bulinator Palette (*.tbpal)|*.tbpal|Mesen CG RAM (*.dmp)|*.' +
      'dmp|All Files (*.*)|*.*'
    Title = 'Load palette file'
    Left = 508
    Top = 132
  end
  object ColorDialog: TColorDialog
    Left = 508
    Top = 184
  end
  object MainMenu1: TMainMenu
    Left = 508
    Top = 28
    object mnuFile: TMenuItem
      Caption = '&File'
      OnClick = mnuFileClick
      object mnuOpen: TMenuItem
        Caption = '&Open...'
        ShortCut = 16463
        OnClick = mnuOpenClick
      end
      object mnuOpenRecent: TMenuItem
        Caption = 'Open Recent'
        object N_EMPTY: TMenuItem
          Caption = '(Empty)'
          Enabled = False
        end
      end
      object N_Separator_After_Open: TMenuItem
        Caption = '-'
      end
      object mnuSave: TMenuItem
        Caption = '&Save'
        ShortCut = 16467
        OnClick = mnuSaveClick
      end
      object mnuSaveAs: TMenuItem
        Caption = 'Save &As...'
        ShortCut = 49235
        OnClick = mnuSaveAsClick
      end
      object mnuSaveAll: TMenuItem
        Caption = 'Save All'
        ShortCut = 24659
        OnClick = mnuSaveAllClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object mnuClose: TMenuItem
        Caption = 'Close'
        ShortCut = 16471
        OnClick = mnuCloseClick
      end
      object mnuCloseAll: TMenuItem
        Caption = 'Close All'
        ShortCut = 24663
        OnClick = mnuCloseAllClick
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object mnuExit: TMenuItem
        Caption = 'E&xit'
        OnClick = mnuExitClick
      end
    end
    object mnuProject: TMenuItem
      Caption = 'Project'
      OnClick = mnuProjectClick
      object mnuNewProject: TMenuItem
        Caption = 'New Project'
        OnClick = mnuNewProjectClick
      end
      object mnuOpenProject: TMenuItem
        Caption = 'Open Project...'
        OnClick = mnuOpenProjectClick
      end
      object mnuOpenRecentProject: TMenuItem
        Caption = 'Open Recent Project'
        object N_PROJ_EMPTY: TMenuItem
          Caption = '(Empty)'
          Enabled = False
        end
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object mnuSaveProject: TMenuItem
        Caption = 'Save Project'
        OnClick = mnuSaveProjectClick
      end
      object mnuSaveProjectAs: TMenuItem
        Caption = 'Save Project As...'
        OnClick = mnuSaveProjectAsClick
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object mnuCloseProject: TMenuItem
        Caption = 'Close Project'
        OnClick = mnuCloseProjectClick
      end
    end
    object mnuEdit: TMenuItem
      Caption = '&Edit'
      object mnuUndo: TMenuItem
        Caption = '&Undo'
        Enabled = False
        ShortCut = 16474
        OnClick = mnuUndoClick
      end
      object mnuRedo: TMenuItem
        Caption = '&Redo'
        Enabled = False
        ShortCut = 16473
        OnClick = mnuRedoClick
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object mnuCut: TMenuItem
        Caption = 'Cu&t'
        ShortCut = 16472
        OnClick = mnuCutClick
      end
      object mnuCopy: TMenuItem
        Caption = '&Copy'
        ShortCut = 16451
        OnClick = mnuCopyClick
      end
      object mnuPaste: TMenuItem
        Caption = '&Paste'
        Enabled = False
        ShortCut = 16470
        OnClick = mnuPasteClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object mnuExportToPNG: TMenuItem
        Caption = 'Export Selection as PNG...'
        OnClick = mnuExportToPNGClick
      end
      object mnuImportFromPNG: TMenuItem
        Caption = 'Import PNG to Selection...'
        OnClick = mnuImportFromPNGClick
      end
      object ImportarPNGparaSeleo1: TMenuItem
        Caption = '-'
      end
      object mnuGoTo: TMenuItem
        Caption = '&Go to Offset...'
        ShortCut = 16455
        OnClick = mnuGoToClick
      end
    end
    object mnuView: TMenuItem
      Caption = '&View'
      object mnuTileGrid: TMenuItem
        Caption = 'Tile Grid'
        OnClick = mnuTileGridClick
      end
      object mnuPixelGrid: TMenuItem
        Caption = 'Pixel Grid'
        OnClick = mnuPixelGridClick
      end
    end
    object mnuPalette: TMenuItem
      Caption = '&Palette'
      object mnuLoadMasterPaletteFromFile: TMenuItem
        Caption = 'Load Master Palette from a File...'
        OnClick = mnuLoadMasterPaletteFromFileClick
      end
      object mnuLoadMasterPaletteFromROM: TMenuItem
        Caption = 'Load Master Palette from ROM...'
        OnClick = mnuLoadMasterPaletteFromROMClick
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object mnuLoadActivePaletteFromFile: TMenuItem
        Caption = 'Load Active Palette...'
        OnClick = mnuLoadActivePaletteFromFileClick
      end
      object mnuSaveActivePalette: TMenuItem
        Caption = 'Save Active Palette...'
        OnClick = mnuSaveActivePaletteClick
      end
    end
    object mnuSettings: TMenuItem
      Caption = '&Settings'
      OnClick = mnuSettingsClick
    end
    object mnuHelp: TMenuItem
      Caption = '&Help'
      object mnuUserManual: TMenuItem
        Caption = 'User Manual'
      end
      object mnuAbout: TMenuItem
        Caption = '&About...'
        OnClick = mnuAboutClick
      end
    end
  end
  object SaveDialog1: TSaveDialog
    Left = 508
    Top = 240
  end
end
