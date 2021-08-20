Unit uWKSelPedido;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, DB, MemDS, DBAccess, Mask, rxToolEdit, rxCurrEdit,
  Buttons, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids;

type
  TFormSelPedido = class(TForm)
    StatusBar1: TStatusBar;
    Panel2: TPanel;
    labelLocalizar: TLabel;
    edLocalizar: TEdit;
    RadioGroupTipoLoc: TRadioGroup;
    DBGrid1: TDBGrid;
    ButtonCancela: TButton;
    ButtonOK: TButton;
    DataSource: TDataSource;
    procedure ButtonOKClick(Sender: TObject);
    procedure ButtonCancelaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RadioGroupTipoLocClick(Sender: TObject);
    procedure edLocalizarChange(Sender: TObject);
    procedure edLocalizarKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
  private
    bFirst: Boolean;
    procedure Selecionar;
    { Private declarations }
  public
  end;

implementation

{$R *.DFM}

uses uWKTypes, uWKMsg, uWKConections;

procedure TFormSelPedido.ButtonCancelaClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFormSelPedido.ButtonOKClick(Sender: TObject);
begin
  with Pedido do
  begin
    IdCliente := ClaConWK.Query.FieldByName('IDCLIENTE').AsString;
    IdPedido  := ClaConWK.Query.FieldByName('IDPEDIDO').AsString;
  end;
  ModalResult := mrOk;
end;

procedure TFormSelPedido.DBGrid1DblClick(Sender: TObject);
begin
  ButtonOK.Click;
end;

procedure TFormSelPedido.edLocalizarChange(Sender: TObject);
begin
  Selecionar;
end;

procedure TFormSelPedido.edLocalizarKeyPress(Sender: TObject; var Key: Char);
begin
  if key =#13 then Selecionar;
end;

procedure TFormSelPedido.FormActivate(Sender: TObject);
begin
  if bFirst then
  begin
    bFirst := False;
    Selecionar;
  end;
end;

procedure TFormSelPedido.FormCreate(Sender: TObject);
begin
  bFirst := true;
  edLocalizar.Text := '';
  labelLocalizar.Caption := 'Localizar Pedido';
end;

procedure TFormSelPedido.RadioGroupTipoLocClick(Sender: TObject);
begin
  case RadioGroupTipoLoc.ItemIndex of
  0 : LabelLocalizar.Caption := 'Localizar Pedido (ID do Cliente)';
  1 : LabelLocalizar.Caption := 'Localizar Pedido (ID do Pedido)';
  2 : LabelLocalizar.Caption := 'Localizar Pedido (Nome do Cliente)';
  end;
  edLocalizar.Text := '';
  Selecionar;
  Application.ProcessMessages;
end;

procedure TFormSelPedido.Selecionar;
var
  s2, s : string;
begin
  case RadioGroupTipoLoc.ItemIndex of
  0 : s2 := ' WHERE P.ID =' + QuotedStr(edLocalizar.Text);
  1 : s2 := ' WHERE P.ID_CLIENTE =' + QuotedStr(edLocalizar.Text);
  2 : s2 := ' WHERE C.NOME LIKE ' + QuotedStr(edLocalizar.Text+'%');
  end;

  s := ' SELECT P.ID AS IDPEDIDO, P.DTPEDIDO, P.ID_CLIENTE AS IDCLIENTE, P.VALOR,' +
       '       C.NOME' +
       ' FROM TBPEDIDO P' +
       ' LEFT JOIN TBCLIENTES C ON C.ID = P.ID_CLIENTE';

  if edLocalizar.Text <> '' then s := s + s2;

  ClaConWK.Query.Close;
  ClaConWK.Query.SQL.Clear;
  ClaConWK.Query.SQL.Text := s;
  ClaConWK.Query.Open;
  DataSource.DataSet := ClaConWK.Query;
  DBGrid1.DataSource := DataSource;
end;

end.
