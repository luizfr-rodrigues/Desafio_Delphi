object DMConexaoBD: TDMConexaoBD
  OldCreateOrder = False
  Height = 306
  Width = 435
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=C:\Projetos\desafio_delphi\Database\Desafio.db3'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 72
    Top = 56
  end
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    Left = 72
    Top = 128
  end
  object FDQueryExec: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'Select * From LOGDOWNLOAD')
    Left = 232
    Top = 64
  end
end
