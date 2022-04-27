unit Controller.HistoricoDownload;

interface

uses
  Model.DownloadLog,
  Model.Conexao;

Type

  IHistoricoDownloadController = interface
    ['{B04D0529-5AED-47D8-9708-44BD02404977}']

    function Query: IQuery;
    procedure Consultar;
  end;

  THistoricoDownloadController = class(TInterfacedObject, IHistoricoDownloadController)
  private
    FDownloadLog: IDownloadLog;
    FQuery: IQuery;

  public
    class function New: IHistoricoDownloadController;

    constructor Create;
    destructor Destroy; override;

    function Query: IQuery;
    procedure Consultar;
  end;

implementation

uses
  System.SysUtils;

{ THistoricoDownloadController }

procedure THistoricoDownloadController.Consultar;
begin
  FDownloadLog.Consultar(FQuery);
end;

constructor THistoricoDownloadController.Create;
begin
  FDownloadLog := TDownloadLog.New;
  FQuery := TQueryFactory.New.Query;
end;

destructor THistoricoDownloadController.Destroy;
begin

  inherited;
end;

class function THistoricoDownloadController.New: IHistoricoDownloadController;
begin
  Result := THistoricoDownloadController.Create;
end;

function THistoricoDownloadController.Query: IQuery;
begin
  Result := FQuery;
end;

end.
