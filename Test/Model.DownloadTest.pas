unit Model.DownloadTest;

interface

uses
  DUnitX.TestFramework,
  Model.Download;

type
  [TestFixture]
  TDownloadTest = class
  private
    FDownload: TDownload;

  public
    [Setup]
    procedure Setup;

    [TearDown]
    procedure TearDown;

    [Test]
    procedure IniciarSemLinkTest;
  end;

implementation

uses
  System.SysUtils;

procedure TDownloadTest.IniciarSemLinkTest;
begin
  Assert.WillRaise(procedure
                   begin
                     FDownload.Iniciar('');
                   end,
                   Exception,
                   'Deveria retornar uma exceção');
end;

procedure TDownloadTest.Setup;
begin
  FDownload := TDownload.Create;
end;

procedure TDownloadTest.TearDown;
begin
  FreeAndNil(FDownload);
end;

initialization
  TDUnitX.RegisterTestFixture(TDownloadTest);

end.
