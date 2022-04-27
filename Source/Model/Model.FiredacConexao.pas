unit Model.FiredacConexao;

interface

uses
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.VCLUI.Wait,
  FireDAC.Comp.Client,
  FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat,
  FireDAC.Phys.SQLiteDef,
  FireDAC.Phys.SQLite,
  FireDAC.DApt,
  Data.DB,

  Model.Conexao;

Type

  TFiredacConexao = class(TInterfacedObject, IConexao)
  private
    FConnection: TFDConnection;

    procedure ConfigurarConexao;

  public
    class function New: IConexao;

    constructor Create;
    destructor Destroy; override;

    function Connection: TCustomConnection;
  end;

  TFiredacQuery = class(TInterfacedObject, IQuery)
  private
    FQuery: TFDQuery;

  public
    class function New(const AConexao: IConexao): IQuery;

    constructor Create(const AConexao: IConexao);
    destructor Destroy; override;

    function DataSet: TDataSet;

    procedure Open(const AStrSQL: String);
    procedure ExecSQL(const AStrSQL: String);
  end;

implementation

uses
  System.SysUtils;

const
  SQLITE_DRIVER_ID = 'SQLite';
  SQLITE_DB_PATH   = '..\Database\Desafio.db3';

{ TFiredacQuery }

constructor TFiredacQuery.Create(const AConexao: IConexao);
begin
  FQuery := TFDQuery.Create(nil);
  FQuery.Connection := TFDConnection(AConexao.Connection);
end;

destructor TFiredacQuery.Destroy;
begin
  FreeAndNil(FQuery);

  inherited;
end;

procedure TFiredacQuery.ExecSQL(const AStrSQL: String);
begin
  FQuery.ExecSQL(AStrSQL);
end;

class function TFiredacQuery.New(const AConexao: IConexao): IQuery;
begin
  Result := TFiredacQuery.Create(AConexao);
end;

procedure TFiredacQuery.Open(const AStrSQL: String);
begin
  FQuery.Open(AStrSQL);
end;

function TFiredacQuery.DataSet: TDataSet;
begin
  Result := FQuery;
end;

{ TFiredacConexao }

procedure TFiredacConexao.ConfigurarConexao;
begin
  with FConnection do
  begin
    Params.Values['DriverID'] := SQLITE_DRIVER_ID;
    Params.Values['Database'] := SQLITE_DB_PATH;

    LoginPrompt := False;
  end;
end;

function TFiredacConexao.Connection: TCustomConnection;
begin
  Result := FConnection;
end;

constructor TFiredacConexao.Create;
begin
  FConnection := TFDConnection.Create(nil);

  ConfigurarConexao;
  FConnection.Connected := True;
end;

destructor TFiredacConexao.Destroy;
begin
  FreeAndNil(FConnection);

  inherited;
end;

class function TFiredacConexao.New: IConexao;
begin
  Result := TFiredacConexao.Create;
end;

end.
