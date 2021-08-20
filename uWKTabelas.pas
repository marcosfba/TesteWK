unit uWKTabelas;

interface

Uses SysUtils, WinTypes, WinProcs, Messages, Classes, Forms, uWKClaConApiInt;

type
  TClaTabelas = class (TPersistent)
  private
  public
    constructor Create;
    destructor Destroy; override;
    function CheckBanco(var ManDB : IClaConApi): boolean;
    function GetFilename: string;
  end;

implementation

uses uWkPath;

constructor TClaTabelas.Create;
begin
  inherited;
end;

destructor TClaTabelas.Destroy;
begin
  inherited;
end;

function TClaTabelas.GetFilename: string;
begin
  Result := ClaPath.DadosPath + 'TESTE.FDB';
end;

function TClaTabelas.CheckBanco(var ManDB: IClaConApi): boolean;
var
  sSql : string;
begin

  //------------------ TBClientes
  sSQL :=
    'CREATE TABLE TBCLIENTES (' +
    'ID            INTEGER NOT NULL,' +
    'NOME          VARCHAR(240),' +
    'CIDADE        VARCHAR(240),' +
    'UF            VARCHAR(02),' +
    'CONSTRAINT PK_TBCLIENTES PRIMARY KEY  (ID))';
  ManDB.CreateTable('TBCLIENTES', sSql);
  ManDB.CreateIndex('TBCLIENTES','NOME');

  if not ManDB.GeneratorExists('GEN_TBCLIENTES_ID') then
  begin
   sSQL := 'CREATE GENERATOR GEN_TBCLIENTES_ID';
   ManDB.RunSql(sSql);
   sSQL := 'SET GENERATOR GEN_TBCLIENTES_ID TO 0';
   ManDB.RunSql(sSql);
  end;

  if not ManDB.TriggerExists('TRIG_TBCLIENTES_BI') then
  begin
    sSql := ' CREATE TRIGGER TRIG_TBCLIENTES_BI FOR TBCLIENTES '+
    ' ACTIVE BEFORE INSERT POSITION 0'+
    ' AS'+
    ' begin'+
    '   if (NEW.id IS NULL or NEW.id = 0)  then'+
    '     NEW.id = gen_id(GEN_TBCLIENTES_ID,1);'+
    ' end';
   ManDB.RunSql(sSql);
  end;

  //------------------ TBProduto
  sSQL :=
    'CREATE TABLE TBPRODUTOS (' +
    'ID            INTEGER NOT NULL,' +
    'DESCRICAO     VARCHAR(240),' +
    'VALOR         NUMERIC(18,2),' +
    'CONSTRAINT PK_TBPRODUTOS PRIMARY KEY  (ID))';
  ManDB.CreateTable('TBPRODUTOS', sSql);
  ManDB.CreateIndex('TBPRODUTOS','DESCRICAO');

  if not ManDB.GeneratorExists('GEN_TBPRODUTOS_ID') then
  begin
   sSQL := 'CREATE GENERATOR GEN_TBPRODUTOS_ID';
   ManDB.RunSql(sSql);
   sSQL := 'SET GENERATOR GEN_TBPRODUTOS_ID TO 0';
   ManDB.RunSql(sSql);
  end;

  if not ManDB.TriggerExists('TRIG_TBPRODUTOS_BI') then
  begin
    sSql := ' CREATE TRIGGER TRIG_TBPRODUTOS_BI FOR TBPRODUTOS '+
    ' ACTIVE BEFORE INSERT POSITION 0'+
    ' AS'+
    ' begin'+
    '   if (NEW.id IS NULL or NEW.id = 0)  then'+
    '     NEW.id = gen_id(GEN_TBPRODUTOS_ID,1);'+
    ' end';
   ManDB.RunSql(sSql);
  end;

  //------------------ TBPedido
  sSQL :=
    'CREATE TABLE TBPEDIDO (' +
    'ID            INTEGER NOT NULL,' +
    'DTPEDIDO      DATE,' +
    'ID_CLIENTE    INTEGER,' +
    'VALOR         NUMERIC(18,2),' +
    'CONSTRAINT PK_TBPEDIDO PRIMARY KEY  (ID))';
  ManDB.CreateTable('TBPEDIDO', sSql);

  if not ManDB.GeneratorExists('GEN_TBPEDIDO_ID') then
  begin
   sSQL := 'CREATE GENERATOR GEN_TBPEDIDO_ID';
   ManDB.RunSql(sSql);
   sSQL := 'SET GENERATOR GEN_TBPEDIDO_ID TO 0';
   ManDB.RunSql(sSql);
  end;

  if not ManDB.TriggerExists('TRIG_TBPEDIDO_BI') then
  begin
    sSql := ' CREATE TRIGGER TRIG_TBPEDIDO_BI FOR TBPEDIDO '+
    ' ACTIVE BEFORE INSERT POSITION 0'+
    ' AS'+
    ' begin'+
    '   if (NEW.id IS NULL or NEW.id = 0)  then'+
    '     NEW.id = gen_id(GEN_TBPEDIDO_ID,1);'+
    ' end';
   ManDB.RunSql(sSql);
  end;

  //------------------ TBITENS
  sSQL :=
    'CREATE TABLE TBITENS (' +
    'ID            INTEGER NOT NULL,' +
    'ID_PEDIDO     INTEGER NOT NULL,' +
    'ID_PROD       INTEGER NOT NULL,' +
    'NRO_ITEM      VARCHAR(03) NOT NULL,' +
    'QTD           NUMERIC(18,3),' +
    'VLR_ITEM      NUMERIC(18,2),' +
    'CONSTRAINT PK_TBITENS PRIMARY KEY  (ID))';
  ManDB.CreateTable('TBITENS', sSql);

  if not ManDB.GeneratorExists('GEN_TBITENS_ID') then
  begin
   sSQL := 'CREATE GENERATOR GEN_TBITENS_ID';
   ManDB.RunSql(sSql);
   sSQL := 'SET GENERATOR GEN_TBITENS_ID TO 0';
   ManDB.RunSql(sSql);
  end;

  if not ManDB.TriggerExists('TRIG_TBITENS_BI') then
  begin
    sSql := ' CREATE TRIGGER TRIG_TBITENS_BI FOR TBITENS '+
    ' ACTIVE BEFORE INSERT POSITION 0'+
    ' AS'+
    ' begin'+
    '   if (NEW.id IS NULL or NEW.id = 0)  then'+
    '     NEW.id = gen_id(GEN_TBITENS_ID,1);'+
    ' end';
   ManDB.RunSql(sSql);
  end;

  Result := true;
end;

end.

