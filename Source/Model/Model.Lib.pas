unit Model.Lib;

interface

Type

  TLib = class
    class function PathPadraoDownloadWin: string;
    class function PathExe: string;

    class function NomeArquivoValido(const ANomeOriginal: string): string;

    class function ByteToKilobyte(const AValueByte: Int64): Double;
    class function KilobyteToMegabyte(const AValueKilobyte: Double): Double;
  end;

implementation

uses
  System.SysUtils,
  Vcl.Forms;

const
  DIR_PADRAO_DOWNLOAD_WIN = 'Downloads/';
  CARACTER_INVALIDO_NOME_ARQUIVO: array[1..9] of char = ('\', '/', ':', '*', '?', '"', '<', '>', '|');
  FATOR_CONVERSAO_BYTE = 1000;

{ TLib }

class function TLib.PathPadraoDownloadWin: string;
begin
  Result := IncludeTrailingPathDelimiter(GetEnvironmentVariable('USERPROFILE')) +
            DIR_PADRAO_DOWNLOAD_WIN;
end;

class function TLib.ByteToKilobyte(const AValueByte: Int64): Double;
begin
  Result := AValueByte / FATOR_CONVERSAO_BYTE;
end;

class function TLib.KilobyteToMegabyte(const AValueKilobyte: Double): Double;
begin
  Result := AValueKilobyte / FATOR_CONVERSAO_BYTE;
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
