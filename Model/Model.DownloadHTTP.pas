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
    procedure SetProcNotificar(const AProcNotificar: TNotificarProgresso);

    function TamanhoArquivoAsBytes: Int64;
    function BaixadoAsBytes: Int64;

    function NomeArquivo: string;
  end;

  TDownloadHTTP = class(TInterfacedObject, IDownloadHTTP)
  private
    FHTTPClient: TNetHTTPClient;

    FControleStatus: IDownloadControleStatus;
    FProcNotificar: TNotificarProgresso;

    FTamanhoArquivoEmBytes: Int64;
    FBaixadoEmBytes: Int64;

    FNomeArquivo: string;

    procedure IniciarRequisicao;

    procedure HTTPClientOnReceiveData(const Sender: TObject; AContentLength, AReadCount: Int64;
                                      var AAbort: Boolean);

    procedure ExtrairNomeArquivoResponse(const AHTTPResponse: IHTTPResponse);

  public
    constructor Create(const AControleStatus: IDownloadControleStatus);
    destructor Destroy; override;

    procedure Executar(const ALink: string; const AStream: TStream);
    procedure SetProcNotificar(const AProcNotificar: TNotificarProgresso);

    function TamanhoArquivoAsBytes: Int64;
    function BaixadoAsBytes: Int64;

    function NomeArquivo: string;
  end;

implementation

uses
  System.SysUtils;

const
  HEADER_INFO_ARQUIVO = 'Content-Disposition';
  HEADER_TAG_NOME_ARQUIVO = 'filename=';

  CARACTER_INVALIDO_NOME_ARQUIVO: array[1..9] of char = ('\', '/', ':', '*', '?', '"', '<', '>', '|');

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

  FProcNotificar := nil;
end;

destructor TDownloadHTTP.Destroy;
begin
  FreeAndNil(FHTTPClient);

  inherited;
end;

procedure TDownloadHTTP.HTTPClientOnReceiveData(const Sender: TObject; AContentLength, AReadCount: Int64;
                                                var AAbort: Boolean);
begin
  AAbort := FControleStatus.StatusAtual = dsInterrompido;

  FTamanhoArquivoEmBytes := AContentLength;
  FBaixadoEmBytes := AReadCount;

  if Assigned(FProcNotificar) then
    FProcNotificar(Sender);
end;

procedure TDownloadHTTP.IniciarRequisicao;
begin
  FTamanhoArquivoEmBytes := 0;
  FBaixadoEmBytes := 0;

  FNomeArquivo := '';
end;

function TDownloadHTTP.NomeArquivo: string;
begin
  Result := FNomeArquivo;
end;

procedure TDownloadHTTP.SetProcNotificar(const AProcNotificar: TNotificarProgresso);
begin
  FProcNotificar := AProcNotificar;
end;

procedure TDownloadHTTP.Executar(const ALink: string; const AStream: TStream);
var
  Response: IHTTPResponse;
begin
  IniciarRequisicao;

  Response := FHTTPClient.Get(ALink, AStream);
  ExtrairNomeArquivoResponse(Response);
end;

procedure TDownloadHTTP.ExtrairNomeArquivoResponse(const AHTTPResponse: IHTTPResponse);
var
  Conteudo: string;
  PosInicialNomeArquivo, i: Integer;
begin
  with AHTTPResponse do
  begin
    if ContainsHeader(HEADER_INFO_ARQUIVO) then
    begin
      Conteudo := HeaderValue[HEADER_INFO_ARQUIVO];

      PosInicialNomeArquivo := Pos(HEADER_TAG_NOME_ARQUIVO, Conteudo) +
                               ( Length(HEADER_TAG_NOME_ARQUIVO) - 1 );

      FNomeArquivo := Conteudo.Substring(PosInicialNomeArquivo);

      for I := 1 to High(CARACTER_INVALIDO_NOME_ARQUIVO) do
        FNomeArquivo := FNomeArquivo.Replace(CARACTER_INVALIDO_NOME_ARQUIVO[i], '');
    end;
  end;
end;

function TDownloadHTTP.TamanhoArquivoAsBytes: Int64;
begin
  Result := FTamanhoArquivoEmBytes;
end;

end.
