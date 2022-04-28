unit DAO.ScriptBD;

interface

uses
  Model.Conexao;

Type

  IScriptBDDAO = interface
    ['{A8966EF2-DCA1-48FA-99C3-E40267D5CF23}']

    procedure CreateTable_LOGDOWNLOAD;
  end;

  TScriptBDDAO = class(TInterfacedObject, IScriptBDDAO)
  private
    FQuery: IQuery;

  public
    class function New: IScriptBDDAO;

    constructor Create;
    destructor Destroy; override;

    procedure CreateTable_LOGDOWNLOAD;
  end;

implementation

uses
  System.SysUtils;

{ TScriptBDDAO }

constructor TScriptBDDAO.Create;
begin
  FQuery := TQueryFactory.New.Query;
end;

procedure TScriptBDDAO.CreateTable_LOGDOWNLOAD;
var
  StrComandoSQL: TStringBuilder;
begin
  Try
    StrComandoSQL := TStringBuilder.Create;

    StrComandoSQL.Append('CREATE TABLE IF NOT EXISTS LOGDOWNLOAD ( ');
    StrComandoSQL.Append('CODIGO INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, ');
    StrComandoSQL.Append('URL VARCHAR (600) NOT NULL, ');
    StrComandoSQL.Append('DATAINICIO DATETIME NOT NULL, ');
    StrComandoSQL.Append('DATAFIM DATETIME ');
    StrComandoSQL.Append(');');

    FQuery.ExecSQL(StrComandoSQL.ToString);

  Finally
    FreeAndNil(StrComandoSQL);
  End;
end;

destructor TScriptBDDAO.Destroy;
begin

  inherited;
end;

class function TScriptBDDAO.New: IScriptBDDAO;
begin
  Result := TScriptBDDAO.Create;
end;

end.
