object GoToForm: TGoToForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Go to Offset'
  ClientHeight = 137
  ClientWidth = 297
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 13
  object lblOffset: TLabel
    Left = 8
    Top = 8
    Width = 35
    Height = 13
    Caption = 'Offset:'
  end
  object edtOffset: TEdit
    Left = 47
    Top = 5
    Width = 106
    Height = 21
    CharCase = ecUpperCase
    TabOrder = 0
    Text = '0'
    OnChange = edtOffsetChange
  end
  object rgBase: TRadioGroup
    Left = 8
    Top = 33
    Width = 145
    Height = 67
    Caption = ' Base '
    ItemIndex = 0
    Items.Strings = (
      'Auto ($ for Hex)'
      'Decimal'
      'Hexadecimal')
    TabOrder = 1
    OnClick = rgBaseClick
  end
  object rgMode: TRadioGroup
    Left = 161
    Top = 8
    Width = 129
    Height = 92
    Caption = ' Relative To '
    ItemIndex = 0
    Items.Strings = (
      'Start of ROM'
      'Current Position'
      'End of ROM')
    TabOrder = 2
  end
  object btnOK: TButton
    Left = 70
    Top = 105
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object btnCancel: TButton
    Left = 151
    Top = 105
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
end
