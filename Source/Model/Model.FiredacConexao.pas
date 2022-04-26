unit Model.FiredacConexao;

interface

uses
  Model.Conexao,

  FireDAC.Comp.Client,
  FireDAC.DApt,
  Data.DB;

Type

  TFiredacQuery = class(TInterfacedObject, IQuery)
  private
    FQuery: TFDQuery;

  public
    class function New(const AConexao: TFDConnection): IQuery;

    constructor Create(const AConexao: TFDConnection);
    destructor Destroy; override;

    function DataSet: TDataSet;

    procedure Open(const AStrSQL: String);
    procedure ExecSQL(const AStrSQL: String);
  end;

implementation

uses
  System.SysUtils;

{ TFiredacQuery }

constructor TFiredacQuery.Create(const AConexao: TFDConnection);
begin
  FQuery := TFDQuery.Create(nil);
  FQuery.Connection := AConexao;
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

class function TFiredacQuery.New(const AConexao: TFDConnection): IQuery;
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

end.
