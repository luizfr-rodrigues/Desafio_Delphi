unit Model.Download;

interface

uses
  System.Classes,
  Generics.Collections,

  Model.DownloadHTTP,
  Model.ObserverInterface,
  Model.DownloadStatus,
  Model.DownloadConst,
  Model.DownloadLog;

Type
  IDownload = interface
    ['{231F7092-41B6-4851-8229-49B9D5BF15F8}']

    procedure Iniciar(const ALink: string);
    procedure Parar;

    function Status: TDownloadStatus;

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
    FObservers: TList<IObserver>;

    FControleStatus: IDownloadControleStatus;
    FDownloadHTTP: IDownloadHTTP;

    FLog: IDownloadLog;

    function GetNomeArquivoTemp: string;
    function GetPathArquivoTemp: string;

    function GetPathArquivoNovo(const ACountArquivo: Integer = 0): string;

    procedure AtualizarProgresso(const Sender: TObject);
    procedure Notificar;

    procedure SalvarLog(const AURL: string);
    procedure SalvarFinalizacaoLog;

  public
    constructor Create;
    destructor Destroy; override;

    procedure Iniciar(const ALink: string);
    procedure Parar;

    function Status: TDownloadStatus;

    function TamanhoArquivoAsByte: Int64;
    function TamanhoArquivoAsKilobyte: Double;
    function TamanhoArquivoAsMegabyte: Double;

    function BaixadoAsByte: Int64;
    function BaixadoAsKilobyte: Double;
    function BaixadoAsMegabyte: Double;

    function PercentualBaixado: Double;

    procedure AdicionarObserver(Observer: IObserver);
  end;

implementation

uses
  System.Threading,
  System.SysUtils;

{ TDownload }

function TDownload.BaixadoAsByte: Int64;
begin
  Result := FDownloadHTTP.BaixadoAsBytes;
end;

function TDownload.BaixadoAsKilobyte: Double;
begin
  Result := Self.BaixadoAsByte / 1024;
end;

function TDownload.BaixadoAsMegabyte: Double;
begin
  Result := Self.BaixadoAsKilobyte / 1024;
end;

constructor TDownload.Create;
begin
  FObservers := TList<IObserver>.Create;

  FControleStatus := TDownloadControleStatus.Create;

  FDownloadHTTP := TDownloadHTTP.Create(FControleStatus);
  FDownloadHTTP.SetProcNotificar(AtualizarProgresso);

  FLog := TDownloadLog.Create;
end;

destructor TDownload.Destroy;
begin
  FreeAndNil(FObservers);

  inherited;
end;

function TDownload.GetNomeArquivoTemp: string;
begin
  Result := 'temp_file.download';
end;

function TDownload.GetPathArquivoNovo(const ACountArquivo: Integer): string;
var
  Diretorio, Path, ExtensaoArquivo, NomeArquivoSemExtensao: string;
begin
  Diretorio := IncludeTrailingPathDelimiter(GetEnvironmentVariable('USERPROFILE')) +
               'Downloads\';

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
begin
  Result := IncludeTrailingPathDelimiter(GetEnvironmentVariable('USERPROFILE')) +
            'Downloads\' +
            GetNomeArquivoTemp;
end;

procedure TDownload.Iniciar(const ALink: string);
var
  Task: ITask;
begin
  if ALink.IsEmpty then
    raise Exception.Create('Link para download não foi informado');

  if FControleStatus.StatusAtual = dsIniciado then
    raise Exception.Create('Já existe um download em andamento');

  Task := TTask.Create(
    procedure
    var
      Arquivo: TFileStream;
    begin

      Try
        Arquivo := TFileStream.Create(GetPathArquivoTemp, fmCreate);

        FControleStatus.AlterarStatus(dsIniciado);
        SalvarLog(ALink);

        FDownloadHTTP.Executar(ALink, Arquivo);

      Finally
        FreeAndNil(Arquivo);
      End;

      if FControleStatus.StatusAtual = dsIniciado then
      begin
        RenameFile(GetPathArquivoTemp, GetPathArquivoNovo);

        FControleStatus.AlterarStatus(dsConcluido);
        SalvarFinalizacaoLog;

        Self.Notificar;
      end

      else if FControleStatus.StatusAtual = dsInterrompido then
        DeleteFile(GetPathArquivoTemp);

    end);

  Task.Start;
end;

procedure TDownload.Notificar;
var
  Observer: IObserver;
begin
  for Observer in FObservers do
    Observer.Atualizar;
end;

procedure TDownload.Parar;
begin
  if FControleStatus.StatusAtual <> dsIniciado then
    raise Exception.Create('Não existe nenhum download em andamento');

  FControleStatus.AlterarStatus(dsInterrompido);
end;

function TDownload.PercentualBaixado: Double;
begin
  Result := 0;

  if Self.TamanhoArquivoAsByte > 0 then
    Result := ( (Self.BaixadoAsByte / Self.TamanhoArquivoAsByte) * 100);
end;

procedure TDownload.SalvarFinalizacaoLog;
begin
  FLog.DataFim := Now;
  FLog.Atualizar;
end;

procedure TDownload.SalvarLog(const AURL: string);
begin
  FLog.Codigo := 0;
  FLog.URL := AURL;
  FLog.DataInicio := Now;
  FLog.DataFim := 0;

  FLog.Salvar;
end;

function TDownload.Status: TDownloadStatus;
begin
  Result := FControleStatus.StatusAtual;
end;

procedure TDownload.AdicionarObserver(Observer: IObserver);
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
  Result := Self.TamanhoArquivoAsByte / 1024;
end;

function TDownload.TamanhoArquivoAsMegabyte: Double;
begin
  Result := Self.TamanhoArquivoAsKilobyte / 1024;
end;

end.
