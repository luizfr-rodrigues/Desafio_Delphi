unit View.FormMain;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ComCtrls,

  Controller.Download,
  Model.ObserverInterface;

type
  TMainForm = class(TForm, IObserver)
    BtnIniciar: TButton;
    BtnParar: TButton;
    EdtLink: TEdit;
    ProgressBar1: TProgressBar;
    BtnPercentual: TButton;
    Label3: TLabel;
    BtnHistorico: TButton;
    procedure FormCreate(Sender: TObject);
    procedure BtnIniciarClick(Sender: TObject);
    procedure BtnPercentualClick(Sender: TObject);
    procedure BtnPararClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure BtnHistoricoClick(Sender: TObject);
  private
    { Private declarations }

    FController: IDownloadController;

    procedure Atualizar;
    function ConfirmarEncerrarDownload: Boolean;

  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  Model.DownloadConst,
  View.HistoricoDownloadForm;

procedure TMainForm.Atualizar;
begin
  ProgressBar1.Max := FController.Download.TamanhoArquivoAsByte;
  ProgressBar1.Position := FController.Download.BaixadoAsByte;

  if FController.Download.Status = dsConcluido then
    ShowMessage('Download concluído')

  else if FController.Download.Status = dsInterrompido then
    ShowMessage('Download interrompido');
end;

procedure TMainForm.BtnHistoricoClick(Sender: TObject);
begin
  FormHistoricoDownload.Abrir;
end;

procedure TMainForm.BtnIniciarClick(Sender: TObject);
begin
  ProgressBar1.Position := 0;

  Try
    FController.Iniciar(EdtLink.Text);

  Except
    on E: Exception do
      ShowMessage(E.Message);
  End;
end;

procedure TMainForm.BtnPararClick(Sender: TObject);
begin
  Try
    FController.Parar;

  Except
    on E: Exception do
      ShowMessage(E.Message);
  End;
end;

procedure TMainForm.BtnPercentualClick(Sender: TObject);
begin
  ShowMessage('Percentual atual do download: ' +
              FormatFloat('###,##0.00 %', FController.Download.PercentualBaixado));
end;

function TMainForm.ConfirmarEncerrarDownload: Boolean;
begin
  Result := MessageDlg('Existe um download em andamento, deseja interrompe-lo?',
                       TMsgDlgType.mtConfirmation,
                       [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
                       0) = mrYes;

  if Result then
    FController.Parar;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if FController.Download.Status = dsIniciado then
    CanClose := ConfirmarEncerrarDownload;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FController := TDownloadController.New(Self);
end;

initialization
  ReportMemoryLeaksOnShutdown := DebugHook <> 0;

end.
