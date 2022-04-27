unit Model.Conexao;

interface

uses
  Data.DB;

Type

  IConexao = interface
    ['{9F7CCB65-D333-4B1C-B6D9-0D64CA266099}']

    function Connection: TCustomConnection;
  end;

  IQuery = interface
    ['{4335CA34-9961-46CA-88D3-54B1A4DBB83C}']

    function DataSet: TDataSet;

    procedure Open(const AStrSQL: String);
    procedure ExecSQL(const AStrSQL: String);
  end;

  IQueryFactory = interface
    ['{DAC43CB2-C2B2-49F8-B534-4ED8AD993B91}']

    function Query: IQuery;
  end;

  IConexaoFactory = interface
    ['{E0F6F158-9E15-484F-8589-789C5564C74A}']

    function Conexao: IConexao;
  end;

  TConexaoFactory = class(TInterfacedObject, IConexaoFactory)
  private
    class var FConexao: IConexao;

  public
    class function New: IConexaoFactory;

    constructor Create;
    destructor Destroy; override;

    function Conexao: IConexao;
  end;

  TQueryFactory = class(TInterfacedObject, IQueryFactory)
  public
    class function New: IQueryFactory;

    constructor Create;
    destructor Destroy; override;

    function Query: IQuery;
  end;

implementation

uses
  Model.FiredacConexao;

{ TQueryFactory }

constructor TQueryFactory.Create;
begin

end;

destructor TQueryFactory.Destroy;
begin

  inherited;
end;

class function TQueryFactory.New: IQueryFactory;
begin
  Result := TQueryFactory.Create;
end;

function TQueryFactory.Query: IQuery;
begin
  Result := TFiredacQuery.New(TConexaoFactory.New.Conexao);
end;

{ TConexaoFactory }

function TConexaoFactory.Conexao: IConexao;
begin
  if not Assigned(FConexao) then
    FConexao := TFiredacConexao.New;

   Result := FConexao;
end;

constructor TConexaoFactory.Create;
begin

end;

destructor TConexaoFactory.Destroy;
begin

  inherited;
end;

class function TConexaoFactory.New: IConexaoFactory;
begin
  Result := TConexaoFactory.Create;
end;

end.
