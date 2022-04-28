program ProjDesafioDelphi;

uses
  Vcl.Forms,
  View.FormMain in 'View\View.FormMain.pas' {MainForm},
  Model.DownloadHTTP in 'Model\Model.DownloadHTTP.pas',
  Model.Download in 'Model\Model.Download.pas',
  Controller.Download in 'Controller\Controller.Download.pas',
  Model.ObserverInterface in 'Model\Model.ObserverInterface.pas',
  Model.DownloadStatus in 'Model\Model.DownloadStatus.pas',
  Model.AppConst in 'Model\Model.AppConst.pas',
  Model.DownloadLog in 'Model\Model.DownloadLog.pas',
  Controller.HistoricoDownload in 'Controller\Controller.HistoricoDownload.pas',
  Model.FiredacConexao in 'Model\Model.FiredacConexao.pas',
  Model.Conexao in 'Model\Model.Conexao.pas',
  View.HistoricoDownloadForm in 'View\View.HistoricoDownloadForm.pas' {FormHistoricoDownload},
  DAO.DownloadLog in 'DAO\DAO.DownloadLog.pas',
  Model.Lib in 'Model\Model.Lib.pas',
  Model.InicializacaoApp in 'Model\Model.InicializacaoApp.pas',
  DAO.ScriptBD in 'DAO\DAO.ScriptBD.pas',
  Model.ScriptBD in 'Model\Model.ScriptBD.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := DebugHook <> 0;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;

  if TInicializacaoApp.New.VerificarRequisitos then
  begin
    Application.CreateForm(TMainForm, MainForm);
    Application.Run;
  end;
end.
