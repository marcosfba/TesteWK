unit uWKClientes;

interface

Uses SysUtils, WinTypes, WinProcs, Messages, Classes, Forms, uWKTypes;

type
  TClaClientes = class
  private
    class procedure PopulaBaseCliente;
  public
    class procedure PopularBase;
    class function AddCliente(const Nome, Cidade, UF : string) : Boolean;
    class function GetCliente(const Id: string) : Boolean;
  end;

const
  BaseCliente : array[0..19] of TCliente =
  (
    (Nome: 'TREVO INDUSTRIA E COMERCIO LTDA';  Cidade:'RECIFE';       UF:'PE'),
    (Nome: 'FORD BRASIL LTDA';                 Cidade:'LAJES';         UF:'RS'),
    (Nome: 'FRANCO REPRESENTACOES LTDA';       Cidade:'CAMPINAS';      UF:'SP'),
    (Nome: 'QUIMICOM LTDA';                    Cidade:'CAMPO ALEGRE';  UF:'MG'),
    (Nome: 'COLGATE-PALMOLIVE COMERCIAL LTDA.';Cidade:'BELO HORIZONTE';UF:'MG'),
    (Nome: 'JOHNSON & JOHNSON DO NORDESTE SA' ;Cidade:'RECIFE';        UF:'PE'),
    (Nome: 'DALTEX INDUSTRIAL LTDA';           Cidade:'UBERABA';       UF:'MG'),
    (Nome: 'CONDOR S/A';                       Cidade:'SÃO JOSE';      UF:'SP'),
    (Nome: 'BASF SA';                          Cidade:'BRASILIA';      UF:'DF'),
    (Nome: 'TINTAS RENNER S/A';                Cidade:'VIANA';         UF:'RS'),
    (Nome: 'SIKA S A';                         Cidade:'JEQUIE';        UF:'BA'),
    (Nome: 'ROBSON REIS LEMOS';                Cidade:'FRANCA';        UF:'SP'),
    (Nome: 'NUTRIAVE ALIMENTOS LTDA';          Cidade:'SÃO JOSE';      UF:'SP'),
    (Nome: 'TECNOMECANICA SA';                 Cidade:'SÃO JOSE';      UF:'SP'),
    (Nome: 'LAVINIA VEICULOS LTDA';            Cidade:'SÃO JOSE';      UF:'SP'),
    (Nome: 'MARCELO AMARAL SIQUEIRA';          Cidade:'TIRADENTES';    UF:'MG'),
    (Nome: 'VANDER LUCIO DIAS';                Cidade:'MURIAE';        UF:'MG'),
    (Nome: 'NEUZA MARIA SIQUEIRA';             Cidade:'BELO HORIZONTE';UF:'MG'),
    (Nome: 'CARLOS ROBERTO DA SILVA';          Cidade:'BELO HORIZONTE';UF:'MG'),
    (Nome: 'JOSE LUIZ PEREIRA MAGALHAES';      Cidade:'DIVINOPOLIS';   UF:'MG')
  );

implementation

uses uWKConections;

{ TClaClientes }

class function TClaClientes.AddCliente(const Nome, Cidade, UF: string): Boolean;
begin
  ClaConWK.Query.Close;
  ClaConWK.Query.SQL.Clear;
  ClaConWK.Query.SQL.Text := 'INSERT INTO TBCLIENTES(ID, NOME, CIDADE, UF) VALUES (:ID, :NOME, :CIDADE, :UF)';
  ClaConWK.Query.ParamByName('ID').AsInteger    := 0;
  ClaConWK.Query.ParamByName('NOME').AsString   := Nome;
  ClaConWK.Query.ParamByName('CIDADE').AsString := Cidade;
  ClaConWK.Query.ParamByName('UF').AsString     := UF;
  ClaConWK.Query.ExecSQL;
  Result := True;
end;

class function TClaClientes.GetCliente(const Id: string): Boolean;
const
  LinhaBusca : string = ' SELECT ID, NOME, CIDADE, UF FROM TBCLIENTES WHERE ID=:ID';
var
  s : string;
begin
  ClaConWK.Query.Close;
  ClaConWK.Query.SQL.Clear;
  ClaConWK.Query.SQL.Text := LinhaBusca;
  ClaConWK.Query.ParamByName('ID').AsString := ID;
  ClaConWK.Query.Open;
  s := ClaConWK.Query.FieldByName('NOME').AsString;
  Result := ((not s.IsEmpty) or (s.Length > 0) or (s.Trim <> ''));
end;

class procedure TClaClientes.PopulaBaseCliente;
var
  i : integer;
begin
  for I := 0 to High(BaseCliente) do
    AddCliente(BaseCliente[i].Nome,BaseCliente[i].Cidade,BaseCliente[i].UF);
end;

class procedure TClaClientes.PopularBase;
begin
  PopulaBaseCliente;
end;

end.

