object FormHistoricoDownload: TFormHistoricoDownload
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Hist'#243'rico de Download'
  ClientHeight = 254
  ClientWidth = 674
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 0
    Top = 0
    Width = 674
    Height = 254
    Align = alClient
    DataSource = DataSource
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'URL'
        Width = 400
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DATAINICIO'
        Title.Alignment = taCenter
        Title.Caption = 'Data Hora In'#237'cio'
        Width = 120
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DATAFIM'
        Title.Alignment = taCenter
        Title.Caption = 'Data Hora Fim'
        Width = 120
        Visible = True
      end>
  end
  object DataSource: TDataSource
    DataSet = FDQuery
    Left = 368
    Top = 128
  end
  object FDQuery: TFDQuery
    Connection = DMConexaoBD.FDConnection
    SQL.Strings = (
      'Select CODIGO, URL, DATAINICIO, DATAFIM'
      'From LOGDOWNLOAD')
    Left = 296
    Top = 128
    object FDQueryURL: TStringField
      FieldName = 'URL'
      Origin = 'URL'
      Required = True
      Size = 600
    end
    object FDQueryDATAINICIO: TDateTimeField
      Alignment = taCenter
      FieldName = 'DATAINICIO'
      Origin = 'DATAINICIO'
      Required = True
    end
    object FDQueryDATAFIM: TDateTimeField
      Alignment = taCenter
      FieldName = 'DATAFIM'
      Origin = 'DATAFIM'
    end
  end
end
