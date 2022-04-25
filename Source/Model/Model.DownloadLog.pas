unit Model.DownloadLog;

interface

uses Model.Conexao;

Type
  IDownloadLog = interface
    ['{F02A5A04-B817-4E9C-A608-9A6A038F8794}']

    function GetCodigo: integer;
    function GetURL: string;
    function GetDataInicio: TDateTime;
    function GetDataFim: TDateTime;

    procedure SetCodigo(const AValue: Integer);
    procedure SetURL(const AValue: string);
    procedure SetDataInicio(const AValue: TDateTime);
    procedure SetDataFim(const AValue: TDateTime);

    property Codigo: integer read GetCodigo write SetCodigo;
    property URL: string read GetURL write SetURL;
    property DataInicio: TDateTime read GetDataInicio write SetDataInicio;
    property DataFim: TDateTime read GetDataFim write SetDataFim;

    procedure Salvar;
    procedure Atualizar;

    procedure ConsultarTodos(const AQuery: IQuery);
  end;

  TDownloadLog = class(TInterfacedObject, IDownloadLog)
  private
    FCodigo: integer;
    FDataFim: TDateTime;
    FDataInicio: TDateTime;
    FURL: string;

    function GetCodigo: integer;
    function GetURL: string;
    function GetDataInicio: TDateTime;
    function GetDataFim: TDateTime;

    procedure SetCodigo(const Value: integer);
    procedure SetDataFim(const Value: TDateTime);
    procedure SetDataInicio(const Value: TDateTime);
    procedure SetURL(const Value: string);

  public
    constructor Create;
    destructor Destroy; override;

    property Codigo: integer read GetCodigo write SetCodigo;
    property URL: string read GetURL write SetURL;
    property DataInicio: TDateTime read GetDataInicio write SetDataInicio;
    property DataFim: TDateTime read GetDataFim write SetDataFim;

    procedure Salvar;
    procedure Atualizar;

    procedure ConsultarTodos(const AQuery: IQuery);
  end;

implementation

{ TDownloadLog }

uses DAO.DMConexaoBD, Data.DB;

procedure TDownloadLog.Atualizar;
begin
  with DMConexaoBD.FDQueryExec do
  begin
    SQL.Clear;
    SQL.Add('Update LOGDOWNLOAD set');
    SQL.Add('  URL = :URL, DATAINICIO = :DATAINICIO, DATAFIM = :DATAFIM');
    SQL.Add('where CODIGO = :CODIGO');

    ParamByName('CODIGO').DataType := ftInteger;
    ParamByName('CODIGO').AsInteger := Self.Codigo;

    ParamByName('URL').DataType := ftString;
    ParamByName('URL').AsString := Self.URL;

    ParamByName('DATAINICIO').DataType := ftDateTime;
    if Self.DataInicio > 0 then
      ParamByName('DATAINICIO').AsDateTime := Self.DataInicio;

    ParamByName('DATAFIM').DataType := ftDateTime;
    if Self.DataFim > 0 then
      ParamByName('DATAFIM').AsDateTime := Self.DataFim;

    ExecSQL;
  end;
end;

procedure TDownloadLog.ConsultarTodos(const AQuery: IQuery);
begin
  AQuery.Open('Select CODIGO, URL, DATAINICIO, DATAFIM From LOGDOWNLOAD');
end;

constructor TDownloadLog.Create;
begin

end;

destructor TDownloadLog.Destroy;
begin

  inherited;
end;

function TDownloadLog.GetCodigo: integer;
begin
  Result := FCodigo;
end;

function TDownloadLog.GetDataFim: TDateTime;
begin
  Result := FDataFim;
end;

function TDownloadLog.GetDataInicio: TDateTime;
begin
  Result := FDataInicio;
end;

function TDownloadLog.GetURL: string;
begin
    Result := FURL;
end;

procedure TDownloadLog.Salvar;
begin
  with DMConexaoBD.FDQueryExec do
  begin
    SQL.Clear;
    SQL.Add('Insert Into LOGDOWNLOAD');
    SQL.Add('  (URL, DATAINICIO, DATAFIM)');
    SQL.Add('Values');
    SQL.Add('  (:URL, :DATAINICIO, :DATAFIM)');

    ParamByName('URL').DataType := ftString;
    ParamByName('URL').AsString := Self.URL;

    ParamByName('DATAINICIO').DataType := ftDateTime;
    if Self.DataInicio > 0 then
      ParamByName('DATAINICIO').AsDateTime := Self.DataInicio;

    ParamByName('DATAFIM').DataType := ftDateTime;
    if Self.DataFim > 0 then
      ParamByName('DATAFIM').AsDateTime := Self.DataFim;

    ExecSQL;

    SQL.Clear;
    SQL.Add('Select last_insert_rowid() as LastID');
    Open;

    if not IsEmpty then
      Self.Codigo := FieldByName('LastID').AsInteger;

    Close;
  end;
end;

procedure TDownloadLog.SetCodigo(const Value: integer);
begin
  FCodigo := Value;
end;

procedure TDownloadLog.SetDataFim(const Value: TDateTime);
begin
  FDataFim := Value;
end;

procedure TDownloadLog.SetDataInicio(const Value: TDateTime);
begin
  FDataInicio := Value;
end;

procedure TDownloadLog.SetURL(const Value: string);
begin
  FURL := Value;
end;

end.
