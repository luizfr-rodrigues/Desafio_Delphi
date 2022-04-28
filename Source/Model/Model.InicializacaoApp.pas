unit Model.InicializacaoApp;

interface

uses
  Model.ScriptBD;

Type

  IInicializacaoApp = interface
    ['{0D19DBAE-77C8-4F30-9D68-46847CCF4F52}']

    function VerificarRequisitos: Boolean;
  end;

  IInicializacaoBD = interface
    ['{4DBEC03C-8BF5-489C-AE7E-566EBD7949B9}']

    procedure Iniciar;
  end;

  TInicializacaoApp = class(TInterfacedObject, IInicializacaoApp)
  public
    class function New: IInicializacaoApp;

    constructor Create;
    destructor Destroy; override;

    function VerificarRequisitos: Boolean;
  end;

  TInicializacaoBD = class(TInterfacedObject, IInicializacaoBD)
  private
    FScriptBD: IScriptBD;

    procedure VerificarECriarDir;
    function VerificarConexao: Boolean;

  public
    class function New: IInicializacaoBD;

    constructor Create;
    destructor Destroy; override;

    procedure Iniciar;
  end;

implementation

{ TInicializacaoApp }

uses
  System.SysUtils,
  Vcl.Dialogs,

  Model.Lib,
  Model.Conexao,
  Model.AppConst;

constructor TInicializacaoApp.Create;
begin

end;

destructor TInicializacaoApp.Destroy;
begin

  inherited;
end;

class function TInicializacaoApp.New: IInicializacaoApp;
begin
  Result := TInicializacaoApp.Create;
end;

function TInicializacaoApp.VerificarRequisitos: Boolean;
begin
  Result := False;

  Try
    TInicializacaoBD.New.Iniciar;
    Result := True;

  Except
    on E: Exception do
      MessageDlg('Erro durante a inicialização do aplicativo' + #13 + e.message,
                 TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
  End;
end;

{ TInicializacaoBD }

function TInicializacaoBD.VerificarConexao: Boolean;
begin
  Result := TConexaoFactory.New.Conexao.Connection.Connected;
end;

constructor TInicializacaoBD.Create;
begin
  FScriptBD := TScriptBD.New;
end;

destructor TInicializacaoBD.Destroy;
begin

  inherited;
end;

procedure TInicializacaoBD.Iniciar;
begin
  VerificarECriarDir;

  if VerificarConexao then
    FScriptBD.Executar
  else
    raise Exception.Create('Conexão com banco de dados não foi estabelecida');
end;

class function TInicializacaoBD.New: IInicializacaoBD;
begin
  Result := TInicializacaoBD.Create;
end;

procedure TInicializacaoBD.VerificarECriarDir;
begin
  if not DirectoryExists(TLib.PathExe + DATABASE_DIR) then
    CreateDir(TLib.PathExe + DATABASE_DIR);
end;

end.
