unit Controller.Download;

interface

uses
  Model.Download,
  Model.ObserverInterface;

Type

  IDownloadController = interface
    ['{81122FE9-4312-40CE-9764-0C160DECF412}']

    function Download: IDownload;
    procedure Iniciar(const ALink: string);
  end;

  TDownloadController = class(TInterfacedObject, IDownloadController)
  private
    FDownload: IDownload;

  public
    constructor Create(const ASenderForm: IObserver);
    destructor Destroy; override;

    function Download: IDownload;
    procedure Iniciar(const ALink: string);
  end;

implementation

{ TDownloadController }

constructor TDownloadController.Create(const ASenderForm: IObserver);
begin
  FDownload := TDownload.Create;
  TDownload(FDownload).AdicionarObserver(ASenderForm);
end;

destructor TDownloadController.Destroy;
begin

  inherited;
end;

function TDownloadController.Download: IDownload;
begin
  Result := FDownload;
end;

procedure TDownloadController.Iniciar(const ALink: string);
begin
  FDownload.Iniciar(ALink);
end;

end.
