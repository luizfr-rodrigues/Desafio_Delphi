unit Model.LibTest;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TLibTest = class
  public

    [TestCase('Nome válido', 'Arquivo Valido,Arquivo Valido')]
    [TestCase('Nome inválido', '\/:Arquivo ?"Invalido<>|,Arquivo Invalido')]
    procedure NomeArquivoValidoTest(const ANomeOriginal, AResult: string);

    [TestCase('Conversão 123287423 Bytes', '123287423,123287.423')]
    procedure ByteToKilobyteTest(const AValueByte: Int64; const AResult: Double);

    [TestCase('Conversão 123287.423 KB', '123287.423,123.287423')]
    procedure KilobyteToMegabyteTest(const AValueKilobyte, AResult: Double);
  end;

implementation

uses
  Model.Lib;

{ TLibTest }

procedure TLibTest.ByteToKilobyteTest(const AValueByte: Int64; const AResult: Double);
begin
  Assert.AreEqual(AResult, TLib.ByteToKilobyte(AValueByte));
end;

procedure TLibTest.KilobyteToMegabyteTest(const AValueKilobyte, AResult: Double);
begin
  Assert.AreEqual(AResult, TLib.KilobyteToMegabyte(AValueKilobyte));
end;

procedure TLibTest.NomeArquivoValidoTest(const ANomeOriginal, AResult: string);
begin
  Assert.AreEqual(AResult, TLib.NomeArquivoValido(ANomeOriginal));
end;

initialization
  TDUnitX.RegisterTestFixture(TLibTest);

end.
