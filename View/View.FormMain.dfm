object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MainForm'
  ClientHeight = 245
  ClientWidth = 704
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 20
    Top = 168
    Width = 31
    Height = 13
    Caption = 'Label1'
  end
  object Label2: TLabel
    Left = 20
    Top = 187
    Width = 31
    Height = 13
    Caption = 'Label2'
  end
  object Label3: TLabel
    Left = 8
    Top = 29
    Width = 22
    Height = 16
    Caption = 'Link'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object BtnIniciar: TButton
    Left = 8
    Top = 112
    Width = 75
    Height = 25
    Caption = 'Iniciar'
    TabOrder = 0
    OnClick = BtnIniciarClick
  end
  object BtnParar: TButton
    Left = 170
    Top = 112
    Width = 75
    Height = 25
    Caption = 'Parar'
    TabOrder = 1
    OnClick = BtnPararClick
  end
  object EdtLink: TEdit
    Left = 8
    Top = 48
    Width = 612
    Height = 21
    TabOrder = 2
    Text = 
      'https://az764295.vo.msecnd.net/stable/78a4c91400152c0f27ba4d363e' +
      'b56d2835f9903a/VSCodeUserSetup-x64-1.43.0.exe'
  end
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 220
    Width = 704
    Height = 25
    Align = alBottom
    TabOrder = 3
  end
  object BtnPercentual: TButton
    Left = 89
    Top = 112
    Width = 75
    Height = 25
    Caption = 'Percentual'
    TabOrder = 4
    OnClick = BtnPercentualClick
  end
end
