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
    Label1: TLabel;
    Label2: TLabel;
    BtnPercentual: TButton;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure BtnIniciarClick(Sender: TObject);
    procedure BtnPercentualClick(Sender: TObject);
  private
    { Private declarations }

    FController: IDownloadController;

    procedure Atualizar;

  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.Atualizar;
begin
  ProgressBar1.Max := FController.Download.TamanhoArquivoAsByte;
  ProgressBar1.Position := FController.Download.BaixadoAsByte;

  Label1.Caption := FloatToStr(FController.Download.TamanhoArquivoAsByte);
  Label2.Caption := FloatToStr(FController.Download.BaixadoAsByte);

  if FController.Download.Finalizado then
    ShowMessage('Download concluído');
end;

procedure TMainForm.BtnIniciarClick(Sender: TObject);
begin
  ProgressBar1.Position := 0;

  FController.Iniciar(EdtLink.Text);
end;

procedure TMainForm.BtnPercentualClick(Sender: TObject);
begin
  ShowMessage('Percentual atual do download: ' +
              FormatFloat('###,##0.00 %', FController.Download.PercentualBaixado));
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FController := TDownloadController.Create(Self);
end;

initialization
  ReportMemoryLeaksOnShutdown := DebugHook <> 0;

end.
