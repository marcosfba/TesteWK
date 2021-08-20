unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TFormMain = class(TForm)
    Panel1: TPanel;
    ButtonPopulaClientes: TButton;
    ButtonPopulaProdutos: TButton;
    ButtonClientes: TButton;
    ButtonProdutos: TButton;
    ButtonPedidos: TButton;
    Panel2: TPanel;
    StatusBar1: TStatusBar;
    ButtonTelaInicial: TButton;
    procedure ButtonPopulaClientesClick(Sender: TObject);
    procedure ButtonPopulaProdutosClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonClientesClick(Sender: TObject);
    procedure ButtonProdutosClick(Sender: TObject);
    procedure ButtonTelaInicialClick(Sender: TObject);
    procedure ButtonPedidosClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

uses uWKConections, uWKProdutos, uWKClientes, uWKViewCliente, uWKViewProduto,
     uWKViewPedido, uWkMsg;

var
  FormViewCliente : TFormViewCliente;
  FormViewProduto : TFormViewProdutos;
  FormViewPedido  : TFormViewPedidos;

procedure TFormMain.ButtonPopulaClientesClick(Sender: TObject);
begin
  StatusBar1.SimpleText := 'Populando base de clientes...';
  TClaClientes.PopularBase;
  MsgInforma('Operação realizada com sucesso!');
  ButtonPopulaClientes.Enabled := not ClaConWK.RecordExists('TBCLIENTES');
  StatusBar1.SimpleText := '';
end;

procedure TFormMain.ButtonPopulaProdutosClick(Sender: TObject);
begin
  StatusBar1.SimpleText := 'Populando base de produtos...';
  TClaProdutos.PopularBase;
  MsgInforma('Operação realizada com sucesso!');
  ButtonPopulaProdutos.Enabled := not ClaConWK.RecordExists('TBPRODUTOS');
  StatusBar1.SimpleText := '';
end;

procedure TFormMain.ButtonClientesClick(Sender: TObject);
begin
  StatusBar1.SimpleText := 'Visualização da base de Clientes';
  ButtonTelaInicial.Click;
  FormViewCliente := TFormViewCliente.Create(Panel2);
  FormViewCliente.Parent      := Panel2;
  FormViewCliente.Position    := poDesigned;
  FormViewCliente.BorderStyle := bsNone;
  FormViewCliente.Top         := 0;
  FormViewCliente.Left        := 0;
  FormViewCliente.Show;
end;

procedure TFormMain.ButtonProdutosClick(Sender: TObject);
begin
  StatusBar1.SimpleText := 'Visualização da base de Produtos';
  ButtonTelaInicial.Click;
  FormViewProduto := TFormViewProdutos.Create(Panel2);
  FormViewProduto.Parent      := Panel2;
  FormViewProduto.Position    := poDesigned;
  FormViewProduto.BorderStyle := bsNone;
  FormViewProduto.Top         := 0;
  FormViewProduto.Left        := 0;
  FormViewProduto.Show;
end;

procedure TFormMain.ButtonPedidosClick(Sender: TObject);
begin
  StatusBar1.SimpleText := 'Inclusão do Pedido';
  ButtonTelaInicial.Click;
  FormViewPedido := TFormViewPedidos.Create(Panel2);
  FormViewPedido.Parent      := Panel2;
  FormViewPedido.Position    := poDesigned;
  FormViewPedido.BorderStyle := bsNone;
  FormViewPedido.Top         := 0;
  FormViewPedido.Left        := 0;
  FormViewPedido.Show;
end;

procedure TFormMain.ButtonTelaInicialClick(Sender: TObject);
begin
  if FormViewCliente <> nil then
  begin
    FormViewCliente.Free;
    FormViewCliente := nil;
  end;
  if FormViewProduto <> nil then
  begin
    FormViewProduto.Free;
    FormViewProduto := nil;
  end;
  if FormViewPedido <> nil then
  begin
    FormViewPedido.Free;
    FormViewPedido := nil;
  end;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  TClaConWK.Open(True);
  ButtonPopulaClientes.Enabled := not ClaConWK.RecordExists('TBCLIENTES');
  ButtonPopulaProdutos.Enabled := not ClaConWK.RecordExists('TBPRODUTOS');
  FormViewCliente := nil;
  FormViewProduto := nil;
  FormViewPedido  := nil;
end;



end.
