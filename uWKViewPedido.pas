unit uWKViewPedido;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  RxCurrEdit, Vcl.Mask, RxToolEdit, Vcl.StdCtrls, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls, MemDS, VirtualTable, Vcl.DBCtrls, Vcl.Buttons;

type
  TFormViewPedidos = class(TForm)
    PanelChave: TPanel;
    ButtonNovoPedido: TButton;
    ButtonSelecionaPedido: TButton;
    Panel1: TPanel;
    LabelDTEmissao: TLabel;
    DateEditEmissao: TDateEdit;
    Label5: TLabel;
    EditQtdItens: TEdit;
    Label1: TLabel;
    DBGridItens: TDBGrid;
    BtIncluirProduto: TButton;
    BtAlterarProduto: TButton;
    BtExcluirProduto: TButton;
    BarraNavega: TDBNavigator;
    VTItens: TVirtualTable;
    VTItensPRODUTO: TIntegerField;
    VTItensDESCRICAO: TStringField;
    VTItensQTD: TFloatField;
    VTItensVLRUNIT: TFloatField;
    VTItensVLRTOTAL: TFloatField;
    DSItens: TDataSource;
    Label2: TLabel;
    EditCliente: TEdit;
    ButtonSalvaPedido: TButton;
    ButtonCancelar: TButton;
    SpeedButtonCliente: TSpeedButton;
    VTItensNROITEM: TStringField;
    EditValorPedido: TCurrencyEdit;
    LabelNumPedido: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ButtonNovoPedidoClick(Sender: TObject);
    procedure ButtonCancelarClick(Sender: TObject);
    procedure BtIncluirProdutoClick(Sender: TObject);
    procedure BtAlterarProdutoClick(Sender: TObject);
    procedure BtExcluirProdutoClick(Sender: TObject);
    procedure ButtonSelecionaPedidoClick(Sender: TObject);
    procedure SpeedButtonClienteClick(Sender: TObject);
    procedure ButtonSalvaPedidoClick(Sender: TObject);
  private
    function isExecuteForm(Sender: TForm; NomeForm: TFormClass) : integer;
    procedure LimpaForm;
    procedure AdicionaItem;
    procedure AtualizaItem;
    procedure AtualizaPedido;
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses uWKConections, uWKTypes, uWKNewITNF, uWKMsg, uWKSelCliente, uWKClientes,
     uWKSelPedido, uWKPedidos;

procedure TFormViewPedidos.AdicionaItem;

function GetNroItem: integer;
begin
  if VTItens.RecordCount = 0 then Result := 1
  else Result := VTItens.RecordCount + 1;
end;

var
  NroItem: string;

begin
  NroItem := IntToStr(GetNroItem).PadLeft(3,'0');

  VTItens.Append;
  VTItens.FieldByName('NROITEM').AsString   := NroItem;
  VTItens.FieldByName('PRODUTO').AsString   := ItemNF.Produto;
  VTItens.FieldByName('DESCRICAO').AsString := ItemNF.Descricao;
  VTItens.FieldByName('QTD').AsFloat        := ItemNF.Qtd;
  VTItens.FieldByName('VLRUNIT').AsFloat    := ItemNF.VlrITem;
  VTItens.FieldByName('VLRTOTAL').AsFloat   := ItemNF.VlrTotal;
  VTItens.Post;
  AtualizaPedido;
end;

procedure TFormViewPedidos.AtualizaItem;
begin
  if VTItens.Locate('NROITEM;PRODUTO',VarArrayOf([ItemNF.NroItem, ItemNF.Produto]),[]) then
  begin
     VTItens.Edit;
     VTItens.FieldByName('QTD').AsFloat        := ItemNF.Qtd;
     VTItens.FieldByName('VLRUNIT').AsFloat    := ItemNF.VlrITem;
     VTItens.FieldByName('VLRTOTAL').AsFloat   := ItemNF.VlrTotal;
     VTItens.Post;
  end;
  AtualizaPedido;
end;

procedure TFormViewPedidos.AtualizaPedido;
var
  Soma: Double;
begin
  EditQtdItens.Text    := VTItens.RecordCount.ToString;
  VTItens.DisableControls;
  VTItens.First;
  Soma := 0;
  while not VTItens.Eof do
  begin
    soma := Soma + VTItens.FieldByName('VLRTOTAL').AsFloat;
    VTItens.Next;
  end;
  VTItens.First;
  VTItens.EnableControls;
  EditValorPedido.Text := FormatFloat('###,###,###.00',soma);
end;

procedure TFormViewPedidos.BtAlterarProdutoClick(Sender: TObject);
begin
  with ItemNF do
  begin
    NroItem   := VTItens.FieldByName('NROITEM').AsString;
    Produto   := VTItens.FieldByName('PRODUTO').AsString;
    Descricao := VTItens.FieldByName('DESCRICAO').AsString;
    Qtd       := VTItens.FieldByName('QTD').AsFloat;
    VlrITem   := VTItens.FieldByName('VLRUNIT').AsFloat;
    VlrTotal  := Qtd * VlrITem;
  end;
  if isExecuteForm(Self, TFormCadNewITNF) = 1 then AtualizaItem;
end;

procedure TFormViewPedidos.BtExcluirProdutoClick(Sender: TObject);
var
  s : string;
begin
  if (VTItens.RecordCount = 0) then exit;

  s := 'Produto..: ' + VTItens.fieldbyname('PRODUTO').AsString + #13 +
       'Descrição: ' + VTItens.fieldbyname('DESCRICAO').AsString + #13 +
       'Quantid..: ' + VTItens.fieldbyname('QTD').AsString + #13 +
       'Valor  ..: ' + FormatFloat('###,###.#0',VTItens.fieldbyname('VLRUNIT').AsFloat) + #13 +
       'Valor Tot: ' + FormatFloat('###,###.#0',VTItens.fieldbyname('VLRTOTAL').AsFloat) + #13 +
       'Tem certeza da exclusão do item deste pedido?';

  if MsgConfirma(s) then
  begin
    VTItens.Delete;
    AtualizaPedido;
  end;
end;

procedure TFormViewPedidos.BtIncluirProdutoClick(Sender: TObject);
begin
  ItemNF.Clear;
  if isExecuteForm(Self, TFormCadNewITNF) = 1 then AdicionaItem;
end;

procedure TFormViewPedidos.ButtonCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TFormViewPedidos.ButtonNovoPedidoClick(Sender: TObject);
begin
  DateEditEmissao.Text := DateToStr(Now);
  EditQtdItens.Text    := '0';
  EditValorPedido.Text := FormatFloat('###,###,###.00', 0);
  EditCliente.Text     := '';
  LabelNumPedido.Caption := '';
  VTItens.Clear;
  ButtonSelecionaPedido.Enabled := False;
  ButtonNovoPedido.Enabled := False;
  Pedido.Clear;
  EditCliente.SetFocus;
end;

procedure TFormViewPedidos.ButtonSelecionaPedidoClick(Sender: TObject);
begin
  Pedido.Clear;
  if isExecuteForm(Self, TFormSelPedido) = 1 then
  begin
    VTItens.Clear;
    LabelNumPedido.Caption := 'Pedido de nº: ' + Pedido.IdPedido;
    if TClaClientes.GetCliente(Pedido.IdCliente) then
      EditCliente.Text := ClaConWK.Query.FieldByName('NOME').AsString;

    if TClaPedidos.GetDadosPedido(StrToInt(Pedido.IdPedido), VTItens) then
    begin
      DateEditEmissao.Date  := ClaConWK.Query.FieldByName('DTPEDIDO').AsDateTime;
      EditValorPedido.Value := ClaConWK.Query.FieldByName('VALOR').AsFloat;
      AtualizaPedido;
    end;
  end;
end;

procedure TFormViewPedidos.FormCreate(Sender: TObject);
begin
  LabelNumPedido.Caption := '';
  DateEditEmissao.Text := '';
  EditQtdItens.Text := '';
  EditValorPedido.Text := '';
  EditCliente.Text     := '';
  VTItens.Open;
  DSItens.DataSet := VTItens;
  DBGridItens.DataSource := DSItens;
  Pedido.Clear;
end;

function TFormViewPedidos.isExecuteForm(Sender: TForm;
  NomeForm: TFormClass): integer;
var
  MyForm: TForm;
begin
  MyForm := NomeForm.Create(nil);
  try
    if MyForm.PopupMenu = nil then
      MyForm.PopupMenu := TForm(Sender).PopupMenu;
    MyForm.ShowModal;
    Result := MyForm.ModalResult;
  finally
    FreeAndNil(MyForm);
  end;
end;

procedure TFormViewPedidos.LimpaForm;
begin
  ButtonNovoPedido.Enabled := True;
  ButtonSelecionaPedido.Enabled := true;
  LabelNumPedido.Caption := '';
  DateEditEmissao.Text := '';
  EditQtdItens.Text := '';
  EditValorPedido.Text := '';
  EditCliente.Text     := '';
  VTItens.Clear;
  Pedido.Clear;
  ItemNF.Clear;
end;

procedure TFormViewPedidos.SpeedButtonClienteClick(Sender: TObject);
begin
  if isExecuteForm(Self, TFormSelCliente) = 1 then
  begin
    if TClaClientes.GetCliente(Pedido.IdCliente) then
      EditCliente.Text := ClaConWK.Query.FieldByName('NOME').AsString;
  end;
end;

procedure TFormViewPedidos.ButtonSalvaPedidoClick(Sender: TObject);
begin
  if VTItens.RecordCount = 0 then
  begin
    MsgAdverte('Pelo menos um Item deve ser adicionado!.');
    DBGridItens.SetFocus;
    exit;
  end;
  if TClaPedidos.AddPedido(DateEditEmissao.Date, EditValorPedido.Value, Pedido, VTItens) then
  begin
    MsgInforma('Operação realizada com sucesso!');
    LimpaForm;
  end;
end;


end.
