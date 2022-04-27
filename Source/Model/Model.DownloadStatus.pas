unit Model.DownloadStatus;

interface

uses
  Model.DownloadConst;

Type

  IDownloadControleStatus = interface
    ['{F5801CFA-F51E-4F29-BD84-62E0E8F5D214}']

    function GetStatus: TDownloadStatus;
    procedure SetStatus(const AValue: TDownloadStatus);

    property Status: TDownloadStatus read GetStatus write SetStatus;
  end;

  TDownloadControleStatus = class(TInterfacedObject, IDownloadControleStatus)
  private
    FStatus: TDownloadStatus;

    function GetStatus: TDownloadStatus;
    procedure SetStatus(const Value: TDownloadStatus);

  public
    class function New: IDownloadControleStatus;

    constructor Create;
    destructor Destroy; override;

    property Status: TDownloadStatus read GetStatus write SetStatus;
  end;

implementation

{ TDownloadControleStatus }

procedure TDownloadControleStatus.SetStatus(const Value: TDownloadStatus);
begin
  FStatus := Value;
end;

constructor TDownloadControleStatus.Create;
begin
  FStatus := dsAguardando;
end;

destructor TDownloadControleStatus.Destroy;
begin

  inherited;
end;

function TDownloadControleStatus.GetStatus: TDownloadStatus;
begin
  Result := FStatus;
end;

class function TDownloadControleStatus.New: IDownloadControleStatus;
begin
  Result := TDownloadControleStatus.Create;
end;

end.
