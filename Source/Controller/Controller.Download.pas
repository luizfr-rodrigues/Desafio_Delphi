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
    procedure Parar;
  end;

  TDownloadController = class(TInterfacedObject, IDownloadController)
  private
    FDownload: IDownload;

  public
    class function New(const ASenderForm: IObserver): IDownloadController;

    constructor Create(const ASenderForm: IObserver);
    destructor Destroy; override;

    function Download: IDownload;

    procedure Iniciar(const ALink: string);
    procedure Parar;
  end;

implementation

{ TDownloadController }

constructor TDownloadController.Create(const ASenderForm: IObserver);
begin
  FDownload := TDownload.New;
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

class function TDownloadController.New(const ASenderForm: IObserver): IDownloadController;
begin
  Result := TDownloadController.Create(ASenderForm);
end;

procedure TDownloadController.Parar;
begin
  FDownload.Parar;
end;

end.
