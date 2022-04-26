unit View.HistoricoDownloadForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids, Controller.HistoricoDownload;

type
  TFormHistoricoDownload = class(TForm)
    DBGrid1: TDBGrid;
    DataSource: TDataSource;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FController: IHistoricoDownloadController;

  public
    { Public declarations }

    procedure Abrir;
  end;

var
  FormHistoricoDownload: TFormHistoricoDownload;

implementation

{$R *.dfm}

{ TFormHistoricoDownload }

procedure TFormHistoricoDownload.Abrir;
begin
  FormHistoricoDownload := TFormHistoricoDownload.Create(Application);
  with FormHistoricoDownload do
  begin
    ShowModal;
    Free;
  end;
end;

procedure TFormHistoricoDownload.FormCreate(Sender: TObject);
begin
  FController := THistoricoDownloadController.New;
  DataSource.DataSet := FController.Query.DataSet;
end;

procedure TFormHistoricoDownload.FormShow(Sender: TObject);
begin
  FController.Consultar;
end;

end.
