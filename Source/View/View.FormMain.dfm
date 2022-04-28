object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Principal'
  ClientHeight = 281
  ClientWidth = 724
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
  object Label3: TLabel
    Left = 8
    Top = 13
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
    Top = 59
    Width = 150
    Height = 25
    Caption = 'Iniciar Download'
    TabOrder = 0
    OnClick = BtnIniciarClick
  end
  object BtnParar: TButton
    Left = 164
    Top = 59
    Width = 150
    Height = 25
    Caption = 'Parar download'
    TabOrder = 1
    OnClick = BtnPararClick
  end
  object EdtLink: TEdit
    Left = 8
    Top = 32
    Width = 708
    Height = 21
    TabOrder = 2
    Text = 
      'https://az764295.vo.msecnd.net/stable/78a4c91400152c0f27ba4d363e' +
      'b56d2835f9903a/VSCodeUserSetup-x64-1.43.0.exe'
  end
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 256
    Width = 724
    Height = 25
    Align = alBottom
    TabOrder = 3
  end
  object BtnPercentual: TButton
    Left = 566
    Top = 59
    Width = 150
    Height = 25
    Caption = 'Exibir mensagem'
    TabOrder = 4
    OnClick = BtnPercentualClick
  end
  object BtnHistorico: TButton
    Left = 8
    Top = 138
    Width = 150
    Height = 25
    Caption = 'Exibir hist'#243'rico de downloads'
    TabOrder = 5
    OnClick = BtnHistoricoClick
  end
end
