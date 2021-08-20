Unit uWKSelCliente;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, DB, MemDS, DBAccess, Mask, rxToolEdit, rxCurrEdit,
  Buttons, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids;

type
  TFormSelCliente = class(TForm)
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
    bFirst : Boolean;
    procedure Selecionar;
    { Private declarations }
  public
  end;

implementation

{$R *.DFM}

uses uWKTypes, uWKMsg, uWKConections;

procedure TFormSelCliente.ButtonCancelaClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFormSelCliente.ButtonOKClick(Sender: TObject);
begin
  with Pedido do
  begin
    IdCliente := ClaConWK.Query.FieldByName('ID').AsString;
  end;
  ModalResult := mrOk;
end;

procedure TFormSelCliente.DBGrid1DblClick(Sender: TObject);
begin
  ButtonOK.Click;
end;

procedure TFormSelCliente.edLocalizarChange(Sender: TObject);
begin
  Selecionar;
end;

procedure TFormSelCliente.edLocalizarKeyPress(Sender: TObject; var Key: Char);
begin
  if key =#13 then Selecionar;
end;

procedure TFormSelCliente.FormActivate(Sender: TObject);
begin
  if bFirst then
  begin
    bFirst := false;
    Selecionar;
  end;
end;

procedure TFormSelCliente.FormCreate(Sender: TObject);
begin
  bFirst := true;
  edLocalizar.Text := '';
  labelLocalizar.Caption := 'Localizar Cliente';
end;

procedure TFormSelCliente.RadioGroupTipoLocClick(Sender: TObject);
begin
  case RadioGroupTipoLoc.ItemIndex of
  0 : LabelLocalizar.Caption := 'Localizar (ID do Cliente)';
  1 : LabelLocalizar.Caption := 'Localizar (UF do Cliente)';
  2 : LabelLocalizar.Caption := 'Localizar (Cidade do Cliente)';
  3 : LabelLocalizar.Caption := 'Localizar (Nome do Cliente)';
  end;
  edLocalizar.Text := '';
  Selecionar;
  Application.ProcessMessages;
end;

procedure TFormSelCliente.Selecionar;
var
  s2, s : string;
begin
  case RadioGroupTipoLoc.ItemIndex of
  0 : s2 := ' WHERE ID =' + QuotedStr(edLocalizar.Text);
  1 : s2 := ' WHERE UF =' + QuotedStr(edLocalizar.Text);
  2 : s2 := ' WHERE CIDADE LIKE ' + QuotedStr(edLocalizar.Text+'%');
  3 : s2 := ' WHERE NOME LIKE ' + QuotedStr(edLocalizar.Text+'%');
  end;
  s := 'SELECT * FROM TBCLIENTES';
  if edLocalizar.Text <> '' then s := s + s2;

  ClaConWK.Query.Close;
  ClaConWK.Query.SQL.Clear;
  ClaConWK.Query.SQL.Text := s;
  ClaConWK.Query.Open;
  DataSource.DataSet := ClaConWK.Query;
  DBGrid1.DataSource := DataSource;
end;

end.
