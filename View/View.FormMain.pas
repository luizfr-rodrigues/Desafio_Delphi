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

  Controller.Download;

type
  TMainForm = class(TForm)
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
  private
    { Private declarations }

    FController: IDownloadController;

  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.BtnIniciarClick(Sender: TObject);
begin
  FController.Iniciar(EdtLink.Text);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FController := TDownloadController.Create;
end;

initialization
  ReportMemoryLeaksOnShutdown := DebugHook <> 0;

end.
