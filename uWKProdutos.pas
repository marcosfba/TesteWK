unit uWKProdutos;

interface

Uses SysUtils, WinTypes, WinProcs, Messages, Classes, Forms, uWKTypes;

type
  TClaProdutos = class
  private
    class procedure PopulaBaseProduto;
  public
    class procedure PopularBase;
    class function AddProduto(const Descricao: string; const Valor: Double) : Boolean;
    class function GetProduto(const Produto: string): Boolean;
  end;

const
  BaseProduto : array[0..19] of TProduto =
  (
    (Descricao: 'PICOLE SABOR UVA'; Valor:1.75),
    (Descricao: 'SORVETE POTE 2L'; Valor:25.50),
    (Descricao: 'SORVETE POTE 3L'; Valor:35.50),
    (Descricao: 'CEL MULTIL E P9101 PTO 16GB DC 3G'; Valor:1250.00),
    (Descricao: 'RADIO PORT MONDIAL BX18'; Valor:100.00),
    (Descricao: 'ANTENA DIG INTELBRAS PASSIVA AI2021'; Valor:200.00),
    (Descricao: 'FURAD/PARAF MAKITA DF330 12V ML BIV'; Valor:1185.78),
    (Descricao: 'RADIO RELOGIO MOTOBRAS RRD22 BIVOLT'; Valor:90.36),
    (Descricao: 'FRITAD MONDIAL AFRYER AF14 110 VERM'; Valor:1002.99),
    (Descricao: 'CONTROLE V.GAME PLAYSTATION 4 S/FIO'; Valor:244.99),
    (Descricao: 'CHALEIRA EL MONDIAL PRATIC 110V INX'; Valor:1001.89),
    (Descricao: 'DVD MONDIAL D18'; Valor:350.00),
    (Descricao: 'DVD KARAOKE MONDIAL D15'; Valor:500.00),
    (Descricao: 'DEPILADOR PHILIPS SATIN HP6421 BIV'; Valor:545.78),
    (Descricao: 'CAMINHAO BANDEIRANTE BRUTUS'; Valor:550.00),
    (Descricao: 'ESCOVA ALISADORA MONDIAL EA-01 BIV'; Valor:780.00),
    (Descricao: 'NOTE ACER CI5 8G 1T W10'; Valor:1999.99),
    (Descricao: 'MONITOR DIG PRESS TECHLINE BP2208'; Valor:1899.52),
    (Descricao: 'PANELA PRESSAO EL PHILCO 4L 110V'; Valor:1149.20),
    (Descricao: 'TV LG LED MT49DF 20 C/CONV DIGITAL'; Valor:3000.75)
  );

implementation

uses uWKConections;

{ TClaProdutos }

class function TClaProdutos.AddProduto(const Descricao: string; const Valor: Double): Boolean;
begin
  ClaConWK.Query.Close;
  ClaConWK.Query.SQL.Clear;
  ClaConWK.Query.SQL.Text := 'INSERT INTO TBPRODUTOS(ID, DESCRICAO, VALOR) VALUES (:ID, :DESCRICAO, :VALOR)';
  ClaConWK.Query.ParamByName('ID').AsInteger    := 0;
  ClaConWK.Query.ParamByName('DESCRICAO').AsString := Descricao;
  ClaConWK.Query.ParamByName('VALOR').AsFloat      := Valor;
  ClaConWK.Query.ExecSQL;
  Result := True;
end;

class function TClaProdutos.GetProduto(const Produto: string): Boolean;
const
  LinhaBusca : string = ' SELECT ID, DESCRICAO, VALOR FROM TBPRODUTOS WHERE ID=:ID';
var
  s : string;
begin
  ClaConWK.Query.Close;
  ClaConWK.Query.SQL.Clear;
  ClaConWK.Query.SQL.Text := LinhaBusca;
  ClaConWK.Query.ParamByName('ID').AsString := Produto;
  ClaConWK.Query.Open;
  s := ClaConWK.Query.FieldByName('DESCRICAO').AsString;
  Result := ((not s.IsEmpty) or (s.Length > 0) or (s.Trim <> ''));
end;

class procedure TClaProdutos.PopulaBaseProduto;
var
  i : integer;
begin
  for I := 0 to High(BaseProduto) do
    AddProduto(BaseProduto[i].Descricao , BaseProduto[i].Valor);
end;

class procedure TClaProdutos.PopularBase;
begin
  PopulaBaseProduto;
end;

end.

