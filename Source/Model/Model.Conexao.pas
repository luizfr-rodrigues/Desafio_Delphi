unit Model.Conexao;

interface

uses
  Data.DB;

Type

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

  TQueryFactory = class(TInterfacedObject, IQueryFactory)
  public
    class function New: IQueryFactory;

    constructor Create;
    destructor Destroy; override;

    function Query: IQuery;
  end;

implementation

uses
  Model.FiredacConexao,
  DAO.DMConexaoBD;

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
  Result := TFiredacQuery.New(DMConexaoBD.FDConnection)
end;

end.
