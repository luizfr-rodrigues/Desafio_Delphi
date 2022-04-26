unit DAO.DownloadLog;

interface

uses
  Model.DownloadLog,
  Model.Conexao;

Type
  IDownloadLogDAO = interface
    ['{02678069-62AF-4BB7-90DA-95DC6440790C}']

    procedure Salvar(const ADownloadLog: IDownloadLog);
    procedure Atualizar(const ADownloadLog: IDownloadLog);

    procedure Consultar(const AQuery: IQuery);
  end;

  TDownloadLogDAO = class(TInterfacedObject, IDownloadLogDAO)
  private
    FQuery: IQuery;

    function UltimoIDInserido: integer;

  public
    class function New: IDownloadLogDAO;

    constructor Create;
    destructor Destroy; override;

    procedure Salvar(const ADownloadLog: IDownloadLog);
    procedure Atualizar(const ADownloadLog: IDownloadLog);

    procedure Consultar(const AQuery: IQuery);
  end;

implementation

uses
  System.SysUtils;

{ TDownloadLogDAO }

procedure TDownloadLogDAO.Atualizar(const ADownloadLog: IDownloadLog);
var
  StrComandoSQL: TStringBuilder;
begin
  Try
    StrComandoSQL := TStringBuilder.Create;

    StrComandoSQL.Append('Update LOGDOWNLOAD set ');

    StrComandoSQL.Append('URL = ');
    StrComandoSQL.Append(QuotedStr(ADownloadLog.URL)).Append(', ');

    StrComandoSQL.Append('DATAINICIO = ');
    if ADownloadLog.DataInicio > 0 then
      StrComandoSQL.Append(QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', ADownloadLog.DataInicio))).Append(', ')
    else
      StrComandoSQL.Append('Null, ');

    StrComandoSQL.Append('DATAFIM = ');
    if ADownloadLog.DataFim > 0 then
      StrComandoSQL.Append(QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', ADownloadLog.DataFim))).Append(' ')
    else
      StrComandoSQL.Append('Null ');

    StrComandoSQL.Append('where CODIGO = ');
    StrComandoSQL.Append(ADownloadLog.Codigo);

    FQuery.ExecSQL(StrComandoSQL.ToString);

  Finally
    FreeAndNil(StrComandoSQL);
  End;
end;

procedure TDownloadLogDAO.Consultar(const AQuery: IQuery);
begin
  AQuery.Open('Select CODIGO, URL, DATAINICIO, DATAFIM From LOGDOWNLOAD');
end;

constructor TDownloadLogDAO.Create;
begin
  FQuery := TQueryFactory.New.Query;
end;

destructor TDownloadLogDAO.Destroy;
begin

  inherited;
end;

class function TDownloadLogDAO.New: IDownloadLogDAO;
begin
  Result := TDownloadLogDAO.Create;
end;

procedure TDownloadLogDAO.Salvar(const ADownloadLog: IDownloadLog);
var
  StrComandoSQL: TStringBuilder;
begin
  Try
    StrComandoSQL := TStringBuilder.Create;

    StrComandoSQL.Append('Insert Into LOGDOWNLOAD ');
    StrComandoSQL.Append('(URL, DATAINICIO, DATAFIM) ');
    StrComandoSQL.Append('Values (');

    StrComandoSQL.Append(QuotedStr(ADownloadLog.URL)).Append(', ');

    if ADownloadLog.DataInicio > 0 then
      StrComandoSQL.Append(QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', ADownloadLog.DataInicio))).Append(', ')
    else
      StrComandoSQL.Append('Null, ');

    if ADownloadLog.DataFim > 0 then
      StrComandoSQL.Append(QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', ADownloadLog.DataFim))).Append(')')
    else
      StrComandoSQL.Append('Null)');

    FQuery.ExecSQL(StrComandoSQL.ToString);

    ADownloadLog.Codigo := UltimoIDInserido;

  Finally
    FreeAndNil(StrComandoSQL);
  End;
end;

function TDownloadLogDAO.UltimoIDInserido: integer;
begin
  Result := 0;

  FQuery.Open('Select last_insert_rowid() as LastID');

  if not FQuery.DataSet.IsEmpty then
    Result := FQuery.DataSet.FieldByName('LastID').AsInteger;
end;

end.
