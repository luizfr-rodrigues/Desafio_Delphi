unit Model.DownloadLog;

interface

uses
  Model.Conexao;

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

    procedure Consultar(const AQuery: IQuery);
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
    class function New: IDownloadLog;

    constructor Create;
    destructor Destroy; override;

    property Codigo: integer read GetCodigo write SetCodigo;
    property URL: string read GetURL write SetURL;
    property DataInicio: TDateTime read GetDataInicio write SetDataInicio;
    property DataFim: TDateTime read GetDataFim write SetDataFim;

    procedure Salvar;
    procedure Atualizar;

    procedure Consultar(const AQuery: IQuery);
  end;

implementation

{ TDownloadLog }

uses
  DAO.DownloadLog;

procedure TDownloadLog.Atualizar;
begin
  TDownloadLogDAO.New.Atualizar(Self);
end;

procedure TDownloadLog.Consultar(const AQuery: IQuery);
begin
  TDownloadLogDAO.New.Consultar(AQuery);
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

class function TDownloadLog.New: IDownloadLog;
begin
  Result := TDownloadLog.Create;
end;

procedure TDownloadLog.Salvar;
begin
  TDownloadLogDAO.New.Salvar(Self);
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
