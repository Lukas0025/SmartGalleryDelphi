object Form4: TForm4
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'U'#269'en'#237
  ClientHeight = 606
  ClientWidth = 827
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 817
    Height = 513
    Stretch = True
  end
  object Label1: TLabel
    Left = 248
    Top = 531
    Width = 85
    Height = 13
    Caption = 'Tento obr'#225'zek je:'
  end
  object ComboBox1: TComboBox
    Left = 339
    Top = 528
    Width = 225
    Height = 21
    TabOrder = 0
    Text = 'vybete'
    Items.Strings = (
      'interi'#233'r'
      'sken'
      'no'#269'n'#237' krajina'
      'krajina')
  end
  object Button1: TButton
    Left = 384
    Top = 555
    Width = 75
    Height = 25
    Caption = 'Nau'#269' se!'
    TabOrder = 1
    OnClick = Button1Click
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Filter = '*.jpeg||*.jpg'
    Left = 768
    Top = 520
  end
end
