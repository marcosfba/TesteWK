unit uWKTypes;

interface

uses Classes;

type
  TProduto = record
    Descricao: string;
    Valor: Double;
  end;

  TCliente = record
    Nome, Cidade, UF : string;
  end;

  TPedido = record
    IdCliente : string;
    IdPedido  : string;
    procedure Clear;
  end;

  TItemNF = record
    NroItem, NumItem, Produto, Descricao : string;
    Qtd, VlrITem, VlrTotal: Double;
    procedure Clear;
  end;

  TRegStructDBF = record
                    Nome    : string;
                    Tipo    : string;
                    Tamanho : Integer;
                    Decimal : Integer;
                  end;

  TXRegStructDBF = array of TRegStructDBF;
  TXRegStructFDB = array of TRegStructDBF;


var
  ItemNF : TItemNF;
  Pedido : TPedido;

implementation

{ TItemNF }

procedure TItemNF.Clear;
begin
  NroItem := ''; NumItem:= ''; Produto := ''; Descricao :='';
  Qtd := 0; VlrITem := 0; VlrTotal:=0;
end;

{ TPedido }

procedure TPedido.Clear;
begin
  IdCliente := '';
  IdPedido  := '0';
end;

end.
