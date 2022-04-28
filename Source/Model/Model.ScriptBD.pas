unit Model.ScriptBD;

interface

Type

  IScriptBD = interface
    ['{8B00F628-52C2-4EC1-9455-FBD77C0E45E1}']

    procedure Executar;
  end;

  TScriptBD = class(TInterfacedObject, IScriptBD)
  public
    class function New: IScriptBD;

    constructor Create;
    destructor Destroy; override;

    procedure Executar;
  end;

implementation

{ TScriptBD }

uses
  DAO.ScriptBD;

constructor TScriptBD.Create;
begin

end;

destructor TScriptBD.Destroy;
begin

  inherited;
end;

procedure TScriptBD.Executar;
begin
  TScriptBDDAO.New.CreateTable_LOGDOWNLOAD;
end;

class function TScriptBD.New: IScriptBD;
begin
  Result := TScriptBD.Create;
end;

end.
