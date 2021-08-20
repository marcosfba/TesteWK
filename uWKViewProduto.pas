unit uWKViewProduto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  RxCurrEdit, Vcl.Mask, RxToolEdit, Vcl.StdCtrls, Data.DB, Vcl.Grids,
  Vcl.DBGrids;

type
  TFormViewProdutos = class(TForm)
    DBGrid1: TDBGrid;
    DataSource: TDataSource;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses uWKConections;

procedure TFormViewProdutos.FormCreate(Sender: TObject);
begin
  ClaConWK.Query.Close;
  ClaConWK.Query.SQL.Clear;
  ClaConWK.Query.SQL.Text := 'SELECT * FROM TBPRODUTOS';
  ClaConWK.Query.Open;
  DataSource.DataSet := ClaConWK.Query;
  DBGrid1.DataSource := DataSource;
end;

end.
