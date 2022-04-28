program ProjDesafioDelphi;

uses
  Vcl.Forms,
  View.FormMain in 'View\View.FormMain.pas' {MainForm},
  Model.DownloadHTTP in 'Model\Model.DownloadHTTP.pas',
  Model.Download in 'Model\Model.Download.pas',
  Controller.Download in 'Controller\Controller.Download.pas',
  Model.ObserverInterface in 'Model\Model.ObserverInterface.pas',
  Model.DownloadStatus in 'Model\Model.DownloadStatus.pas',
  Model.DownloadConst in 'Model\Model.DownloadConst.pas',
  Model.DownloadLog in 'Model\Model.DownloadLog.pas',
  Controller.HistoricoDownload in 'Controller\Controller.HistoricoDownload.pas',
  Model.FiredacConexao in 'Model\Model.FiredacConexao.pas',
  Model.Conexao in 'Model\Model.Conexao.pas',
  View.HistoricoDownloadForm in 'View\View.HistoricoDownloadForm.pas' {FormHistoricoDownload},
  DAO.DownloadLog in 'DAO\DAO.DownloadLog.pas',
  Model.Lib in 'Model\Model.Lib.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
