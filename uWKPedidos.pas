unit uWKPedidos;

interface

Uses SysUtils, WinTypes, WinProcs, Messages, Classes, Forms, VirtualTable,
     uWKTypes;

type
  TClaPedidos = class
  private
    class function GetIdPedido: integer;
    class function AddItensPedido(var Itens: TVirtualTable; const IdPedido: integer): Boolean;
  public
    class function AddPedido(const DtPedido: TDateTime; const Valor: double; const Pedido: TPedido;
       var Itens: TVirtualTable) : Boolean;
    class function GetDadosPedido(const IdPedido: integer; var Itens: TVirtualTable) : Boolean;
  end;

implementation

uses uWKConections;

{ TClaPedidos }

class function TClaPedidos.AddItensPedido(var Itens: TVirtualTable;
  const IdPedido: integer): Boolean;
const
  LinhaDel : string = ' DELETE FROM TBITENS WHERE ID_PEDIDO =:ID_PEDIDO';

  LinhaIns : string = ' INSERT INTO TBITENS (ID, ID_PEDIDO, ID_PROD, NRO_ITEM, QTD, VLR_ITEM)' +
                      ' VALUES (:ID, :ID_PEDIDO, :ID_PROD, :NRO_ITEM, :QTD, :VLR_ITEM)';
begin
  ClaConWK.Query.Close;
  ClaConWK.Query.SQL.Clear;
  ClaConWK.Query.SQL.Text := LinhaDel;
  ClaConWK.Query.ParamByName('ID_PEDIDO').AsInteger := IdPedido;
  ClaConWK.Query.ExecSQL;

  ClaConWK.Query.Close;
  ClaConWK.Query.SQL.Clear;
  ClaConWK.Query.SQL.Text := LinhaIns;
  ClaConWK.Query.Prepare;

  Itens.DisableControls;
  Itens.First;
  while not Itens.Eof do
  begin
    ClaConWK.Query.Close;
    ClaConWK.Query.ParamByName('ID').AsInteger := 0;
    ClaConWK.Query.ParamByName('ID_PEDIDO').AsInteger := IdPedido;
    ClaConWK.Query.ParamByName('ID_PROD').AsInteger   := Itens.FieldByName('PRODUTO').AsInteger;
    ClaConWK.Query.ParamByName('NRO_ITEM').AsString   := Itens.FieldByName('NROITEM').AsString;
    ClaConWK.Query.ParamByName('QTD').AsFloat         := Itens.FieldByName('QTD').AsFloat;
    ClaConWK.Query.ParamByName('VLR_ITEM').AsFloat    := Itens.FieldByName('VLRUNIT').AsFloat;
    ClaConWK.Query.ExecSQL;
    Itens.Next;
  end;
  Itens.EnableControls;

  Result := true;
end;

class function TClaPedidos.AddPedido(const DtPedido: TDateTime;
  const Valor: double; const Pedido: TPedido;
  var Itens: TVirtualTable): Boolean;
const
  LinhaIns : string = ' INSERT INTO TBPEDIDO (ID, DTPEDIDO, ID_CLIENTE, VALOR)' +
                      ' VALUES (:ID, :DTPEDIDO, :ID_CLIENTE, :VALOR)';
  LinhaUpd : string = ' UPDATE TBPEDIDO SET DTPEDIDO = :DTPEDIDO, ID_CLIENTE = :ID_CLIENTE,' +
                      '    VALOR = :VALOR WHERE (ID = :ID)';
var
  s : string;
  iIDPedido: integer;
begin
  if Pedido.IdPedido = '0' then
  begin
    iIDPedido := 0;
    s := LinhaIns;
  end
  else
    begin
      iIDPedido := StrToInt(Pedido.IdPedido);
      s := LinhaUpd;
    end;

  ClaConWK.Query.Close;
  ClaConWK.Query.SQL.Clear;
  ClaConWK.Query.SQL.Text := s;
  ClaConWK.Query.ParamByName('ID').AsInteger         := StrToInt(Pedido.IdPedido);
  ClaConWK.Query.ParamByName('DTPEDIDO').AsDateTime  := DtPedido;
  ClaConWK.Query.ParamByName('ID_CLIENTE').AsInteger := StrToInt(Pedido.IdCliente);
  ClaConWK.Query.ParamByName('VALOR').AsFloat        := Valor;
  ClaConWK.Query.ExecSQL;

  if iIDPedido = 0 then iIDPedido := GetIdPedido;

  result := AddItensPedido(Itens, iIDPedido);
end;

class function TClaPedidos.GetIdPedido: integer;
begin
  ClaConWK.Query.Close;
  ClaConWK.Query.SQL.Clear;
  ClaConWK.Query.SQL.Text :='SELECT MAX(ID) AS VALOR FROM TBPEDIDO';
  ClaConWK.Query.Open;
  Result := ClaConWK.Query.FieldByName('VALOR').AsInteger;
end;

class function TClaPedidos.GetDadosPedido(const IdPedido: integer;
  var Itens: TVirtualTable): Boolean;
const
  LinhaSel : string = ' SELECT I.ID_PROD AS PRODUTO, I.NRO_ITEM AS NROITEM, I.QTD, I.VLR_ITEM AS VLRUNIT,' +
                      '       (I.QTD * I.VLR_ITEM) AS VLRTOTAL, P.DESCRICAO' +
                      ' FROM TBITENS I' +
                      ' LEFT JOIN TBPRODUTOS P ON P.ID = I.ID_PROD' +
                      ' WHERE I.ID_PEDIDO = :IDPEDIDO';
var
  i : integer;
  NomeCampo : string;
begin
  ClaConWK.Query.Close;
  ClaConWK.Query.SQL.Clear;
  ClaConWK.Query.SQL.Text := LinhaSel;
  ClaConWK.Query.ParamByName('IDPEDIDO').AsInteger := IdPedido;
  ClaConWK.Query.Open;
  ClaConWK.Query.First;
  while not ClaConWK.Query.Eof do
  begin
    Itens.Append;
    for i := 0 to ClaConWK.Query.FieldCount - 1 do
    begin
      NomeCampo := ClaConWK.Query.Fields[i].FieldName;
      Itens.FieldByName(NomeCampo).Value := ClaConWK.Query.FieldByName(NomeCampo).Value;
    end;
    Itens.Post;
    ClaConWK.Query.Next;
  end;

  ClaConWK.Query.Close;
  ClaConWK.Query.SQL.Clear;
  ClaConWK.Query.SQL.Text :='SELECT * FROM TBPEDIDO WHERE ID=:ID';
  ClaConWK.Query.ParamByName('ID').AsInteger := IdPedido;
  ClaConWK.Query.Open;

  Result := True;
end;


end.

