unit Model.DownloadStatus;

interface

Type

  TDownloadStatus = (dsAguardando, dsIniciado, dsInterrompido, dsConcluido);

  IDownloadControleStatus = interface
    ['{F5801CFA-F51E-4F29-BD84-62E0E8F5D214}']

    procedure AlterarStatus(const ANovoStatus: TDownloadStatus);
    function StatusAtual: TDownloadStatus;
  end;

  TDownloadControleStatus = class(TInterfacedObject, IDownloadControleStatus)
  private
    FStatusAtual: TDownloadStatus;

  public
    constructor Create;
    destructor Destroy; override;

    procedure AlterarStatus(const ANovoStatus: TDownloadStatus);
    function StatusAtual: TDownloadStatus;
  end;

implementation

{ TDownloadControleStatus }

function TDownloadControleStatus.StatusAtual: TDownloadStatus;
begin
  Result := FStatusAtual;
end;

procedure TDownloadControleStatus.AlterarStatus(const ANovoStatus: TDownloadStatus);
begin
  FStatusAtual := ANovoStatus;
end;

constructor TDownloadControleStatus.Create;
begin
  FStatusAtual := dsAguardando;
end;

destructor TDownloadControleStatus.Destroy;
begin

  inherited;
end;

end.
