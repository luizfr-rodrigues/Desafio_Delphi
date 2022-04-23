unit View.HistoricoDownloadForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, DAO.DMConexaoBD;

type
  TFormHistoricoDownload = class(TForm)
    DBGrid1: TDBGrid;
    DataSource: TDataSource;
    FDQuery: TFDQuery;
    FDQueryURL: TStringField;
    FDQueryDATAINICIO: TDateTimeField;
    FDQueryDATAFIM: TDateTimeField;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
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

procedure TFormHistoricoDownload.FormShow(Sender: TObject);
begin
  FDQuery.Open;
end;

end.
