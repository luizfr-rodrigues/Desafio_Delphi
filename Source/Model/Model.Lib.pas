unit Model.Lib;

interface

Type

  TLib = class
    class function PathPadraoDownloadWin: string;
    class function PathExe: string;

    class function NomeArquivoValido(const ANomeOriginal: string): string;
  end;

implementation

uses
  System.SysUtils,
  Vcl.Forms;

const
  DIR_PADRAO_DOWNLOAD_WIN = 'Downloads/';
  CARACTER_INVALIDO_NOME_ARQUIVO: array[1..9] of char = ('\', '/', ':', '*', '?', '"', '<', '>', '|');

{ TLib }

class function TLib.PathPadraoDownloadWin: string;
begin
  Result := IncludeTrailingPathDelimiter(GetEnvironmentVariable('USERPROFILE')) +
            DIR_PADRAO_DOWNLOAD_WIN;
end;

class function TLib.NomeArquivoValido(const ANomeOriginal: string): string;
var
  I: Integer;
begin
  Result := ANomeOriginal;

  for I := 1 to High(CARACTER_INVALIDO_NOME_ARQUIVO) do
    Result := Result.Replace(CARACTER_INVALIDO_NOME_ARQUIVO[i], '');
end;

class function TLib.PathExe: string;
begin
  Result := ExtractFilePath(Application.ExeName);
end;

end.
