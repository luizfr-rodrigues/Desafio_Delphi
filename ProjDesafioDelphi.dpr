program ProjDesafioDelphi;

uses
  Vcl.Forms,
  View.FormMain in 'View\View.FormMain.pas' {MainForm},
  Model.DownloadHTTP in 'Model\Model.DownloadHTTP.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
