Unit uWKNewITNF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, DB, MemDS, DBAccess, Mask, rxToolEdit, rxCurrEdit,
  Buttons;

type
  TFormCadNewITNF = class(TForm)
    LabelProduto: TLabel;
    LabelDescricao: TLabel;
    EditDescricao: TEdit;
    ButtonCancela: TButton;
    EditProduto: TEdit;
    ButtonOK: TButton;
    StatusBar1: TStatusBar;
    Label11: TLabel;
    EditQuantidade: TCurrencyEdit;
    Label14: TLabel;
    edValorProduto: TCurrencyEdit;
    procedure ButtonOKClick(Sender: TObject);
    procedure ButtonCancelaClick(Sender: TObject);
    procedure EditProdutoExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    procedure ChkProduto(const Produto: string);
    function isValidForm: Boolean;
    { Private declarations }
  public
  end;

implementation

{$R *.DFM}

uses uWKTypes, uWKMsg, uWKProdutos, uWKConections;

procedure TFormCadNewITNF.ButtonCancelaClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFormCadNewITNF.ButtonOKClick(Sender: TObject);
begin
  if isValidForm then
  begin
    with ItemNF do
    begin
      Produto   := EditProduto.Text;
      Descricao := EditDescricao.Text;
      Qtd       := EditQuantidade.Value;
      VlrITem   := edValorProduto.Value;
      VlrTotal  := Qtd * VlrITem;
    end;
    ModalResult := mrOk;
  end;
end;

procedure TFormCadNewITNF.ChkProduto(const Produto: string);
begin
  if TClaProdutos.GetProduto(Produto) then
  begin
    EditDescricao.Text    := ClaConWK.Query.FieldByName('DESCRICAO').AsString;
    edValorProduto.Value  := ClaConWK.Query.FieldByName('VALOR').AsFloat;
    EditQuantidade.SetFocus;
  end
  else MsgAdverte('Produto não existente na base de dadoos');
end;

procedure TFormCadNewITNF.EditProdutoExit(Sender: TObject);
var
  s : string;
begin
  if ActiveControl = ButtonCancela then exit;
  s := EditProduto.Text;
  if ((s.IsEmpty) or (s.Length = 0) or (s.Trim = '')) then
  begin
    MsgAdverte('Produto é obrigatório.');
    keybd_event(VK_BACK, 0, 0, 0);
    EditProduto.SetFocus;
    exit;
  end;
  ChkProduto(EditProduto.Text);
end;

procedure TFormCadNewITNF.FormActivate(Sender: TObject);
begin
  EditProduto.Text     := ItemNF.Produto;
  EditDescricao.Text   := ItemNF.Descricao;
  EditQuantidade.Value := ItemNF.Qtd;
  edValorProduto.Value := ItemNF.VlrITem;

  if ( (ItemNF.Produto.IsEmpty) or (ItemNF.Produto.Length = 0) or (ItemNF.Produto.Trim = '')) then
    EditProduto.SetFocus
  else
    begin
      EditProduto.Enabled := False;
      EditDescricao.Enabled := False;
      EditQuantidade.SetFocus;
    end;
end;

procedure TFormCadNewITNF.FormCreate(Sender: TObject);
var
  i : integer;
begin
  for I := 1 to ComponentCount - 1 do
  begin
    if Components[i] is TEdit then
      (Components[i] as TEdit).Text := '';
    if Components[i] is TCurrencyEdit then
      (Components[i] as TCurrencyEdit).Value := 0.00;
  end;
end;

function TFormCadNewITNF.isValidForm: Boolean;
var
  s : string;
begin
  s := EditProduto.Text;
  if ( (s.IsEmpty) or (s.Length = 0) or (s.Trim = '')) then
  begin
    Result := False;
    MsgAdverte('Produto é obrigatório.');
    EditProduto.SetFocus;
    exit;
  end;

  s := EditDescricao.Text;
  if ( (s.IsEmpty) or (s.Length = 0) or (s.Trim = '')) then
  begin
    Result := False;
    MsgAdverte('Produto é obrigatório.');
    EditProduto.SetFocus;
    exit;
  end;

  if EditQuantidade.Value = 0  then
  begin
    Result := False;
    MsgAdverte('Quantidade não pode ser zero.');
    EditQuantidade.SetFocus;
    exit;
  end;

  if edValorProduto.Value = 0  then
  begin
    Result := False;
    MsgAdverte('Valor do produto não pode ser zero.');
    edValorProduto.SetFocus;
    exit;
  end;
  Result := True;
end;

end.
