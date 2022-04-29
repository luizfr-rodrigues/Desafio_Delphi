unit Model.Download;

interface

uses
  Generics.Collections,

  Model.DownloadHTTP,
  Model.ObserverInterface,
  Model.DownloadStatus,
  Model.AppConst,
  Model.DownloadLog;

Type

  IDownload = interface
    ['{231F7092-41B6-4851-8229-49B9D5BF15F8}']

    procedure Iniciar(const ALink: string);
    procedure Parar;

    function Status: TDownloadStatus;
    function ErroMsg: string;

    function TamanhoArquivoAsByte: Int64;
    function TamanhoArquivoAsKilobyte: Double;
    function TamanhoArquivoAsMegabyte: Double;

    function BaixadoAsByte: Int64;
    function BaixadoAsKilobyte: Double;
    function BaixadoAsMegabyte: Double;

    function PercentualBaixado: Double;
  end;

  TDownload = class(TInterfacedObject, IDownload, ISubject)
  private
    FObservers: TList<Model.ObserverInterface.IObserver>;

    FControleStatus: IDownloadControleStatus;
    FDownloadHTTP: IDownloadHTTP;

    FDownloadLog: IDownloadLog;

    FErroMsg: string;
    FNomeArquivoTemp: string;
    FURL: string;

    FDtHrInicio: TDateTime;

    procedure ExecutarReqThread;
    procedure ExecutarReq;

    procedure GerarNomeArquivoTemp;
    function GetPathArquivoTemp: string;

    function GetPathArquivoNovo(const ACountArquivo: Integer = 0): string;

    procedure AtualizarProgresso(const Sender: TObject);
    procedure Notificar;

    procedure SalvarHistIniciar;
    procedure SalvarHistFinalizar;

  public
    class function New: IDownload;

    constructor Create;
    destructor Destroy; override;

    procedure Iniciar(const ALink: string);
    procedure Parar;

    function Status: TDownloadStatus;
    function ErroMsg: string;

    function TamanhoArquivoAsByte: Int64;
    function TamanhoArquivoAsKilobyte: Double;
    function TamanhoArquivoAsMegabyte: Double;

    function BaixadoAsByte: Int64;
    function BaixadoAsKilobyte: Double;
    function BaixadoAsMegabyte: Double;

    function PercentualBaixado: Double;

    procedure AdicionarObserver(Observer: Model.ObserverInterface.IObserver);
  end;

implementation

uses
  System.Classes,
  System.SysUtils,
  System.Threading,

  Model.Lib;

const
  PREFIXO_ARQUIVO_TEMP = 'temp_file';
  EXTENSAO_ARQUIVO_TEMP = '.download';

{ TDownload }

function TDownload.BaixadoAsByte: Int64;
begin
  Result := FDownloadHTTP.BaixadoAsBytes;
end;

function TDownload.BaixadoAsKilobyte: Double;
begin
  Result := TLib.ByteToKilobyte(Self.BaixadoAsByte)
end;

function TDownload.BaixadoAsMegabyte: Double;
begin
  Result := TLib.KilobyteToMegabyte(Self.BaixadoAsKilobyte);
end;

constructor TDownload.Create;
begin
  FObservers := TList<Model.ObserverInterface.IObserver>.Create;

  FControleStatus := TDownloadControleStatus.New;

  FDownloadHTTP := TDownloadHTTP.New(FControleStatus);
  FDownloadHTTP.SetProcNotificarProgresso(AtualizarProgresso);

  FDownloadLog := TDownloadLog.New;

  FErroMsg := '';
end;

destructor TDownload.Destroy;
begin
  FreeAndNil(FObservers);

  inherited;
end;

function TDownload.ErroMsg: string;
begin
  Result := FErroMsg;
end;

procedure TDownload.ExecutarReq;
var
  Arquivo: TFileStream;
begin
  SalvarHistIniciar;

  Try

    Try
      Arquivo := TFileStream.Create(GetPathArquivoTemp, fmCreate);
      FDownloadHTTP.Executar(FURL, Arquivo);

    Finally
      FreeAndNil(Arquivo);
    End;

    if FControleStatus.Status = dsInterrompido then
      DeleteFile(GetPathArquivoTemp)

    else
    begin
      RenameFile(GetPathArquivoTemp, GetPathArquivoNovo);
      SalvarHistFinalizar;

      FControleStatus.Status := dsConcluido;
      Self.Notificar;
    end;

  Except
    on E: Exception do
    begin
      DeleteFile(GetPathArquivoTemp);

      FControleStatus.Status := dsErro;
      FErroMsg := E.Message;

      Self.Notificar;
    end;
  End;
end;

procedure TDownload.ExecutarReqThread;
var
  Task: ITask;
begin
  Task := TTask.Create(
    procedure
    begin
      ExecutarReq;
    end);

  Task.Start;
end;

procedure TDownload.GerarNomeArquivoTemp;
begin
  FNomeArquivoTemp := PREFIXO_ARQUIVO_TEMP +
                      FormatDateTime('_hhmmsszzz', Now) +
                      EXTENSAO_ARQUIVO_TEMP;
end;

function TDownload.GetPathArquivoNovo(const ACountArquivo: Integer): string;
var
  Diretorio, Path, ExtensaoArquivo, NomeArquivoSemExtensao: string;
begin
  Diretorio := TLib.PathPadraoDownloadWin;

  if not DirectoryExists(Diretorio) then
    Diretorio := TLib.PathExe;

  if ACountArquivo > 0 then
  begin
    ExtensaoArquivo := ExtractFileExt(FDownloadHTTP.NomeArquivo);

    NomeArquivoSemExtensao := FDownloadHTTP.NomeArquivo;
    Delete(NomeArquivoSemExtensao, Pos(ExtensaoArquivo, FDownloadHTTP.NomeArquivo), Length(ExtensaoArquivo));

    Path := Diretorio + NomeArquivoSemExtensao + '(' + IntToStr(ACountArquivo) + ')' + ExtensaoArquivo;
  end
  else
    Path := Diretorio + FDownloadHTTP.NomeArquivo;

  if FileExists(Path) then
    Path := GetPathArquivoNovo(ACountArquivo + 1);

  Result := Path;
end;

function TDownload.GetPathArquivoTemp: string;
var
  Diretorio: string;
begin
  Diretorio := TLib.PathPadraoDownloadWin;

  if not DirectoryExists(Diretorio) then
    Diretorio := TLib.PathExe;

  Result := Diretorio + FNomeArquivoTemp;
end;

procedure TDownload.Iniciar(const ALink: string);
begin
  if ALink.IsEmpty then
    raise Exception.Create('Link para download não foi informado');

  if FControleStatus.Status = dsIniciado then
    raise Exception.Create('Já existe um download em andamento');

  GerarNomeArquivoTemp;
  FURL := ALink;
  FDtHrInicio := Now;

  FControleStatus.Status := dsIniciado;

  ExecutarReqThread;
end;

class function TDownload.New: IDownload;
begin
  Result := TDownload.Create;
end;

procedure TDownload.Notificar;
var
  Observer: Model.ObserverInterface.IObserver;
begin
  for Observer in FObservers do
    Observer.Atualizar;
end;

procedure TDownload.Parar;
begin
  if FControleStatus.Status <> dsIniciado then
    raise Exception.Create('Nenhum download em andamento');

  FControleStatus.Status := dsInterrompido;
end;

function TDownload.PercentualBaixado: Double;
begin
  Result := 0;

  if Self.TamanhoArquivoAsByte > 0 then
    Result := ( (Self.BaixadoAsByte / Self.TamanhoArquivoAsByte) * 100);
end;

procedure TDownload.SalvarHistFinalizar;
begin
  FDownloadLog.DataFim := Now;
  FDownloadLog.Atualizar;
end;

procedure TDownload.SalvarHistIniciar;
begin
  FDownloadLog.Codigo := 0;
  FDownloadLog.URL := FURL;
  FDownloadLog.DataInicio := FDtHrInicio;
  FDownloadLog.DataFim := 0;

  FDownloadLog.Salvar;
end;

function TDownload.Status: TDownloadStatus;
begin
  Result := FControleStatus.Status;
end;

procedure TDownload.AdicionarObserver(Observer: Model.ObserverInterface.IObserver);
begin
  FObservers.Add(Observer);
end;

procedure TDownload.AtualizarProgresso(const Sender: TObject);
begin
  Self.Notificar;
end;

function TDownload.TamanhoArquivoAsByte: Int64;
begin
  Result := FDownloadHTTP.TamanhoArquivoAsBytes;
end;

function TDownload.TamanhoArquivoAsKilobyte: Double;
begin
  Result := TLib.ByteToKilobyte(Self.TamanhoArquivoAsByte);
end;

function TDownload.TamanhoArquivoAsMegabyte: Double;
begin
  Result := TLib.KilobyteToMegabyte(Self.TamanhoArquivoAsKilobyte);
end;

end.
