object SettingsForm: TSettingsForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Settings'
  ClientHeight = 252
  ClientWidth = 433
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 13
  object pgcSettings: TPageControl
    Left = 8
    Top = 8
    Width = 417
    Height = 197
    ActivePage = tsGeneral
    TabOrder = 0
    object tsGeneral: TTabSheet
      Caption = 'General'
      object lblLanguage: TLabel
        Left = 16
        Top = 24
        Width = 51
        Height = 13
        Caption = 'Language:'
        FocusControl = cbxLanguage
      end
      object lblDefaultCodec: TLabel
        Left = 16
        Top = 57
        Width = 72
        Height = 13
        Caption = 'Default Codec:'
        FocusControl = cbxDefaultCodec
      end
      object lblDefaultPaletteFormat: TLabel
        Left = 16
        Top = 90
        Width = 113
        Height = 13
        Caption = 'Default Palette Format:'
      end
      object lblMaxRecentFiles: TLabel
        Left = 16
        Top = 123
        Width = 89
        Height = 13
        Caption = 'Max. Recent Files:'
      end
      object cbxLanguage: TComboBox
        Left = 154
        Top = 21
        Width = 239
        Height = 21
        Style = csDropDownList
        TabOrder = 0
      end
      object cbxDefaultCodec: TComboBox
        Left = 154
        Top = 54
        Width = 239
        Height = 21
        Style = csDropDownList
        TabOrder = 1
      end
      object cbxDefaultPaletteFormat: TComboBox
        Left = 154
        Top = 87
        Width = 239
        Height = 21
        Style = csDropDownList
        TabOrder = 2
      end
      object seMaxRecentFiles: TSpinEdit
        Left = 154
        Top = 120
        Width = 57
        Height = 22
        MaxValue = 30
        MinValue = 1
        TabOrder = 3
        Value = 10
      end
    end
    object tsAppearance: TTabSheet
      Caption = 'Appearance'
      ImageIndex = 1
      object lblWindowState: TLabel
        Left = 24
        Top = 19
        Width = 71
        Height = 13
        Caption = 'Window State:'
      end
      object grpSelection: TGroupBox
        Left = 8
        Top = 48
        Width = 393
        Height = 113
        Caption = ' Selection Style '
        TabOrder = 1
        DesignSize = (
          393
          113)
        object lblBorderColor: TLabel
          Left = 16
          Top = 27
          Width = 64
          Height = 13
          Caption = 'Border Color:'
        end
        object lblFillColor: TLabel
          Left = 16
          Top = 54
          Width = 44
          Height = 13
          Caption = 'Fill Color:'
        end
        object lblBorderWidth: TLabel
          Left = 301
          Top = 27
          Width = 32
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          Caption = 'Width:'
        end
        object lblFillStyle: TLabel
          Left = 16
          Top = 81
          Width = 43
          Height = 13
          Caption = 'Fill Style:'
        end
        object clbBorderColor: TColorBox
          Left = 146
          Top = 24
          Width = 130
          Height = 22
          TabOrder = 0
        end
        object clbFillColor: TColorBox
          Left = 146
          Top = 51
          Width = 130
          Height = 22
          TabOrder = 2
        end
        object seBorderWidth: TSpinEdit
          Left = 339
          Top = 24
          Width = 42
          Height = 22
          MaxValue = 10
          MinValue = 1
          TabOrder = 1
          Value = 1
        end
        object cbxFillStyle: TComboBox
          Left = 146
          Top = 78
          Width = 130
          Height = 21
          Style = csDropDownList
          TabOrder = 3
        end
      end
      object cbxWindowState: TComboBox
        Left = 154
        Top = 16
        Width = 130
        Height = 21
        Style = csDropDownList
        TabOrder = 0
      end
    end
    object tsControls: TTabSheet
      Caption = 'Controls'
      ImageIndex = 2
      object grpDefaultView: TGroupBox
        Left = 8
        Top = 8
        Width = 393
        Height = 97
        Caption = ' Tile Viewer Settings '
        TabOrder = 0
        object lblDefaultDimension: TLabel
          Left = 16
          Top = 29
          Width = 90
          Height = 13
          Caption = 'Default Dimension:'
        end
        object lblX: TLabel
          Left = 207
          Top = 29
          Width = 6
          Height = 13
          Caption = 'x'
        end
        object lblDefaultZoom: TLabel
          Left = 16
          Top = 62
          Width = 68
          Height = 13
          Caption = 'Default Zoom:'
        end
        object seTilesPerRow: TSpinEdit
          Left = 144
          Top = 26
          Width = 57
          Height = 22
          MaxValue = 128
          MinValue = 1
          TabOrder = 0
          Value = 16
        end
        object seTilesPerColumn: TSpinEdit
          Left = 219
          Top = 26
          Width = 57
          Height = 22
          MaxValue = 128
          MinValue = 1
          TabOrder = 1
          Value = 16
        end
        object seDefaultZoom: TSpinEdit
          Left = 144
          Top = 59
          Width = 57
          Height = 22
          MaxValue = 16
          MinValue = 1
          TabOrder = 2
          Value = 4
        end
      end
    end
  end
  object btnOK: TButton
    Left = 188
    Top = 216
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 269
    Top = 216
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object btnApply: TButton
    Left = 350
    Top = 216
    Width = 75
    Height = 25
    Caption = 'Apply'
    TabOrder = 3
    OnClick = btnApplyClick
  end
end
