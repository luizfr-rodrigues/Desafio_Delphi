unit Model.DownloadHTTP;

interface

uses
  System.Classes,
  System.Net.HttpClientComponent,
  System.Net.HttpClient,

  Model.DownloadStatus;

Type

  TNotificarProgresso = procedure(const Sender: TObject) of object;

  IDownloadHTTP = interface
    ['{4C10A6A1-B5FC-45E8-AD41-A155A39588FC}']

    procedure Executar(const ALink: string; const AStream: TStream);
    procedure SetProcNotificarProgresso(const AProcNotificar: TNotificarProgresso);

    function TamanhoArquivoAsBytes: Int64;
    function BaixadoAsBytes: Int64;

    function NomeArquivo: string;
  end;

  TDownloadHTTP = class(TInterfacedObject, IDownloadHTTP)
  private
    FHTTPClient: TNetHTTPClient;

    FControleStatus: IDownloadControleStatus;
    FProcNotificarProgresso: TNotificarProgresso;

    FTamanhoArquivoEmBytes: Int64;
    FBaixadoEmBytes: Int64;

    FNomeArquivo: string;

    procedure Inicializar;

    procedure HTTPClientOnReceiveData(const Sender: TObject; AContentLength, AReadCount: Int64;
                                      var AAbort: Boolean);

    procedure ExtrairNomeArquivoResponse(const AHTTPResponse: IHTTPResponse);

  public
    class function New(const AControleStatus: IDownloadControleStatus): IDownloadHTTP;

    constructor Create(const AControleStatus: IDownloadControleStatus);
    destructor Destroy; override;

    procedure Executar(const ALink: string; const AStream: TStream);
    procedure SetProcNotificarProgresso(const AProcNotificar: TNotificarProgresso);

    function TamanhoArquivoAsBytes: Int64;
    function BaixadoAsBytes: Int64;

    function NomeArquivo: string;
  end;

implementation

uses
  System.SysUtils,
  Model.DownloadConst,
  Model.Lib;

const
  HTTP_CODE_SUCCESS = 200;

  HEADER_INFO_ARQUIVO = 'Content-Disposition';
  HEADER_TAG_NOME_ARQUIVO = 'filename=';

{ TDownloadHTTP }

function TDownloadHTTP.BaixadoAsBytes: Int64;
begin
  Result := FBaixadoEmBytes;
end;

constructor TDownloadHTTP.Create(const AControleStatus: IDownloadControleStatus);
begin
  FHTTPClient := TNetHTTPClient.Create(nil);
  FHTTPClient.OnReceiveData := HTTPClientOnReceiveData;

  FControleStatus := AControleStatus;

  FProcNotificarProgresso := nil;
end;

destructor TDownloadHTTP.Destroy;
begin
  FreeAndNil(FHTTPClient);

  inherited;
end;

procedure TDownloadHTTP.HTTPClientOnReceiveData(const Sender: TObject; AContentLength, AReadCount: Int64;
                                                var AAbort: Boolean);
begin
  AAbort := FControleStatus.Status = dsInterrompido;

  FTamanhoArquivoEmBytes := AContentLength;
  FBaixadoEmBytes := AReadCount;

  if Assigned(FProcNotificarProgresso) then
    FProcNotificarProgresso(Sender);
end;

procedure TDownloadHTTP.Inicializar;
begin
  FTamanhoArquivoEmBytes := 0;
  FBaixadoEmBytes := 0;

  FNomeArquivo := '';
end;

class function TDownloadHTTP.New(const AControleStatus: IDownloadControleStatus): IDownloadHTTP;
begin
  Result := TDownloadHTTP.Create(AControleStatus);
end;

function TDownloadHTTP.NomeArquivo: string;
begin
  Result := FNomeArquivo;
end;

procedure TDownloadHTTP.SetProcNotificarProgresso(const AProcNotificar: TNotificarProgresso);
begin
  FProcNotificarProgresso := AProcNotificar;
end;

procedure TDownloadHTTP.Executar(const ALink: string; const AStream: TStream);
var
  Response: IHTTPResponse;
begin
  Inicializar;

  Response := FHTTPClient.Get(ALink, AStream);

  if Response.StatusCode = HTTP_CODE_SUCCESS then
    ExtrairNomeArquivoResponse(Response)
  else
    raise Exception.Create('Erro na requisição' + #13 + 'Verifique se o link informado está correto');
end;

procedure TDownloadHTTP.ExtrairNomeArquivoResponse(const AHTTPResponse: IHTTPResponse);
var
  Conteudo: string;
  PosInicialNomeArquivo: Integer;
begin
  with AHTTPResponse do
  begin
    if ContainsHeader(HEADER_INFO_ARQUIVO) then
    begin
      Conteudo := HeaderValue[HEADER_INFO_ARQUIVO];

      PosInicialNomeArquivo := Pos(HEADER_TAG_NOME_ARQUIVO, Conteudo) +
                               ( Length(HEADER_TAG_NOME_ARQUIVO) - 1 );

      FNomeArquivo := TLib.NomeArquivoValido(Conteudo.Substring(PosInicialNomeArquivo));
    end;
  end;
end;

function TDownloadHTTP.TamanhoArquivoAsBytes: Int64;
begin
  Result := FTamanhoArquivoEmBytes;
end;

end.
