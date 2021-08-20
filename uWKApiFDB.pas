unit uWKApiFDB;

interface

uses
  Vcl.Dialogs, SysUtils, Classes, Vcl.Forms, System.Variants,
  UNI, UniScript, UniProvider, InterBaseUniProvider, Data.DB,
  uWKClaConApiInt, uWKTypes;

type
  TClaConApiFDB = class(TInterfacedObject, IClaConApi)
  private
    FFilename : string;
    FbLog     : boolean;
    FCon257   : TUniConnection;
    FQuery    : TUniQuery;
    FSQL      : TUniSql;
    FQry      : TUniQuery;
    FCursor   : TUniQuery;
    procedure FQueryAfterClose(DataSet: TDataSet);
    procedure GetConnect(const FileName, dll: string; var FCon: TUniConnection; var isConect: Boolean);
    function OpenBanco(const filename: string) : Boolean;
    procedure SetCursor(const Value: TUniQuery);
    function BasePrepareSQL(const AQry: TUniQuery; const ASQL: String;
                            const AParams: array of Variant; const ATypes: array of TFieldType): Boolean;
    function GetbLog: boolean;
    function GetCursor: TUniQuery;
    function GetFilename: string;
    function GetQuery: TUniQuery;
    function GetSQL: TUniSql;
    procedure SetbLog(const Value: boolean);
    procedure SetFilename(const Value: string);
    procedure SetQuery(const Value: TUniQuery);
    procedure SetSQL(const Value: TUniSql);
  public
    constructor Create;
    destructor Destroy; override;
    function AddField(const Tabela, Campo, Tipo, Tamanho, Decimal: string; const Obrigatorio: boolean): boolean;
    procedure CheckFieldSizeVarChar(const Tabela, Campo, size: string);
    function CheckFieldType(const Tabela, Campo, Tipo: string): boolean;
    function ChkIndice(const FilenameIndex, Tabela, Campos: string): boolean;
    function ConectaBanco(const aFilename: string): boolean;
    function ConstraintExists(const Tabela, regra: string): boolean;
    function CreateIndex(const Tabela, sfields: string; const FilenameIndex: string = ''): boolean;
    function CreateTable(const Tabela, sql: string): boolean;
    procedure DeleteIndex(const filename : string);
    procedure DeleteTable(const filename: string);
    function ExecSQLScalar(const ASQL: String): Variant; overload;
    function ExecSQLScalar(const ASQL: String; const AParams: array of Variant) : Variant; overload;
    function ExecSQLScalar(const ASQL: String; const AParams: array of Variant; const ATypes: array of TFieldType): Variant; overload;
    function FieldExists(const Tabela, Campo: string): boolean;
    function GeneratorExists(const Tabela: string): boolean;
    function GetFieldSize(const Tabela, Campo: string): Integer;
    procedure GetFieldSizeDecimal(const Campo, sTableUsed: string; var Tamanho, Decimal: Integer);
    function GetFileNameIndice(const tabela, sfields : string): string;
    procedure GetTablesFromDataBase(var MyLista: TStringList);
    procedure GetIndicesFromTable(var MyLista: TStringList; const TableName: string);
    procedure GetNameIndices(var MyLista: TStringList);
    function GetQtdRecord(const Tabela: string): Integer;
    procedure GetTBStructFDB(const sTBFileName : string; var X : TXRegStructFDB);
    procedure HabilitaIndices(const OK: boolean; const MyLista: TStringList);
    procedure HabilitaIndicesFromTable(const OK: boolean; const MyLista: TStringList); overload;
    procedure HabilitaIndicesFromTable(const OK: boolean; const tabela : string); overload;
    function IndexExists(const tabela : string):boolean;
    function ProcedureExists(const Tabela: string): boolean;
    function RecordExists(const Tabela: string): boolean;
    function RunSql(const sSql: string): boolean; overload;
    function RunSql(const sSql: string; const AParams: array of Variant): boolean; overload;
    procedure SetActiveIndex(const TableName: string; const OK: boolean);
    procedure SetIndiceTable(const TableName: string; const OK: boolean);
    procedure SetNotNull(const Tabela, Campo: string);
    function TableExists(const Tabela: string): boolean;
    function TriggerExists(const Tabela: string): boolean;
    function ViewExists(const Tabela: string): boolean;
    function GetConnection: TUniConnection;
    procedure Close;
    function IsConnected: boolean;

    property bLog : boolean read GetbLog write SetbLog;
    property Filename : string read GetFilename write SetFilename;
    property Query: TUniQuery read GetQuery write SetQuery;
    property Cursor: TUniQuery read GetCursor write SetCursor;
    property SQL: TUniSql read GetSQL write SetSQL;
  end;

implementation

uses uWKMsg;

procedure TClaConApiFDB.SetCursor(const Value: TUniQuery);
begin
  FCursor := Value;
end;

procedure TClaConApiFDB.SetFilename(const Value: string);
begin
  FFileName := Value;
end;

constructor TClaConApiFDB.Create;
begin
  inherited Create;
  FbLog    := false;
  FCon257  := TUniConnection.Create(nil);
  FQuery   := TUniQuery.Create(nil);
  FQuery.AfterClose := FQueryAfterClose;
  FCursor  := TUniQuery.Create(nil);
  FQry     := TUniQuery.Create(nil);
  FSQL     := TUniSql.Create(nil);
end;

destructor TClaConApiFDB.Destroy;
begin
  FQuery.Close;
  FQry.Close;
  FCursor.Close;

  if Assigned(FSQL) then FSQL.Free;
  if Assigned(FQuery) then FQuery.Free;
  if Assigned(FCursor) then FCursor.Free;
  if Assigned(FQry) then FQry.Free;

  FCon257.Close;

  inherited;
end;


function TClaConApiFDB.GetbLog: boolean;
begin
  Result := FbLog;
end;

function TClaConApiFDB.GetConnection: TUniConnection;
begin
  Result := FCon257;
end;

function TClaConApiFDB.GetCursor: TUniQuery;
begin
  Result := FCursor;
end;

procedure TClaConApiFDB.Close;
begin
  if FCon257.Connected then FCon257.Close;
end;

function TClaConApiFDB.IsConnected: boolean;
begin
   Result := (FCon257 <> nil) and (FCon257.Connected);
end;

procedure TClaConApiFDB.CheckFieldSizeVarChar(const tabela, campo, size : string);
var
  sOldSize : string;
begin
  sOldSize := '';
  FQry.Close;
  FQry.SQL.Text :=
    'SELECT RDB$FIELD_LENGTH, RDB$FIELD_TYPE ' +
    'FROM RDB$FIELDS ' +
    'WHERE RDB$FIELD_NAME = ' +
    '      (SELECT RDB$FIELD_SOURCE ' +
    '         FROM RDB$RELATION_FIELDS ' +
    '        WHERE RDB$RELATION_NAME = ' + QuotedStr(UpperCase(tabela)) + ' AND ' +
    '              RDB$FIELD_NAME = ' +  QuotedStr(UpperCase(campo)) + ')';
  try
    FQry.Open;
  except
    On E : Exception do
    begin
      MsgInforma(FQry.SQL.Text + chr(13) + e.message);
    End;
  end;
  if FQry.RecordCount > 0 then
  begin
    soldsize := FQry.FieldByName('RDB$FIELD_LENGTH').AsString;
  end;
  FQry.Close;
  if (sOldSize <> '') and (sOldSize <> Size) then
  begin
    FSQL.SQL.Text :=
               'ALTER TABLE  ' + UpperCase(tabela) +
               '  ALTER COLUMN  ' + UpperCase(campo) +
               '  TYPE VARCHAR(' + Size + ')';
    FSQL.Execute;
  end;
end;

function TClaConApiFDB.CheckFieldType(const Tabela, Campo, Tipo : string) : Boolean;
begin
  FQry.Close;
  FQry.SQL.Text :=' SELECT RDB$FIELD_LENGTH TAMANHO,' +
                      ' CASE' +
                      ' WHEN DADOSCAMPO.RDB$FIELD_PRECISION > 0 THEN ''NUMERIC''' +
                      ' WHEN TIPOS.RDB$TYPE_NAME = ''LONG'' THEN ''INTEGER''' +
                      ' WHEN TIPOS.RDB$TYPE_NAME = ''SHORT'' THEN ''SMALLINT''' +
                      ' WHEN TIPOS.RDB$TYPE_NAME = ''INT64'' THEN ''NUMERIC''' +
                      ' WHEN TIPOS.RDB$TYPE_NAME = ''VARYING'' THEN ''VARCHAR''' +
                      ' WHEN TIPOS.RDB$TYPE_NAME = ''TEXT'' THEN ''CHAR''' +
                      ' WHEN TIPOS.RDB$TYPE_NAME = ''BLOB'' THEN ''BLOB SUB_TYPE''' +
                      ' ELSE TIPOS.RDB$TYPE_NAME' +
                      ' END AS TIPO' +
                      ' FROM RDB$RELATIONS TABELAS, RDB$RELATION_FIELDS CAMPOS,' +
                      '      RDB$FIELDS DADOSCAMPO, RDB$TYPES TIPOS' +
                      ' WHERE TABELAS.RDB$RELATION_NAME = '+QuotedStr(Tabela)+' AND' +
                      '       TIPOS.RDB$FIELD_NAME = ''RDB$FIELD_TYPE'' AND' +
                      '       TABELAS.RDB$RELATION_NAME = CAMPOS.RDB$RELATION_NAME AND' +
                      '       CAMPOS.RDB$FIELD_SOURCE = DADOSCAMPO.RDB$FIELD_NAME AND' +
                      '       DADOSCAMPO.RDB$FIELD_TYPE = TIPOS.RDB$TYPE AND' +
                      '       CAMPOS.RDB$FIELD_NAME = '+QuotedStr(Campo);
  FQry.Open;
  Result := (Tipo = trim(FQry.FieldByName('TIPO').AsString));
  FQry.Close;
end;

function TClaConApiFDB.ChkIndice(const FilenameIndex, Tabela, Campos : string) : boolean;
begin
  Result := true;
  if not Self.IndexExists(FilenameIndex) then
  begin
    try
      FSQL.SQL.Text :=
        'CREATE INDEX ' + FilenameIndex + ' ON ' + tabela + '(' + campos + ')';
      FSQL.Execute;
    except
      On E : Exception do
      begin
        Result := false;
      end;
    end;
  end;
end;

procedure TClaConApiFDB.GetConnect(const FileName, dll: string; var FCon: TUniConnection; var isConect: Boolean);
begin
  try
    with FCon do
    begin
      if Connected then Disconnect;
      SpecificOptions.Clear;
      ProviderName := 'InterBase';
      SpecificOptions.Values['ClientLibrary'] := dll;
      Server := '';
      LoginPrompt := False;
      Password    := 'masterkey';
      Username    := 'SYSDBA';
      Database    := filename;
      Application.ProcessMessages;
      Connect;
      isConect := True;
    end;
  except
    On E : Exception do
    begin
      MsgErro(ParamStr(0) + #13 + 'ClaConAPI OpenBanco: Não consegui conectar Banco de Dados: ' + filename + #13 + e.message);
      isConect := false;
    end;
  end; 
end;


function TClaConApiFDB.OpenBanco(const filename : string) : Boolean;
var
  dll : string;
begin
  Result := true;
  dll := ExtractFilePath(Application.ExeName) + 'fbclient.dll';
  FCon257.Close;
  GetConnect(filename, dll, FCon257, Result);
  if Result then
  begin
    FQuery.Connection  := Self.GetConnection;
    FCursor.Connection := Self.GetConnection;
    FQry.Connection    := Self.GetConnection;
    FSQL.Connection    := Self.GetConnection;
    FCursor.UniDirectional := true;
    FCursor.SpecificOptions.Values['FetchAll'] := 'false';
    FCursor.FetchRows := 100;
  end;
end;

function TClaConApiFDB.ConectaBanco(const aFilename: string) : Boolean;
var
  UniScript : TUniScript;
  DConnection : TUniConnection;
begin
  FFilename := aFilename;
  if not FileExists(aFilename) then
  begin
    DConnection := TUniConnection.Create(nil);
    DConnection.ProviderName := 'Interbase';
    DConnection.SpecificOptions.Values['ClientLibrary'] := ExtractFilePath(Application.ExeName) + 'fbclient.dll';

    UniScript := TUniScript.Create(nil);
    UniScript.Connection := DConnection;
    UniScript.NoPreconnect := True;
    UniScript.SQL.Clear;
    UniScript.SQL.Add('CREATE DATABASE ' + QuotedStr(aFilename));
    UniScript.Execute;
    UniScript.Free;
    DConnection.Close;
    DConnection.Free;
    Result := OpenBanco(aFilename);
  end else
  begin
    Result := OpenBanco(aFilename);
  end;
end;

function TClaConApiFDB.ConstraintExists(const tabela, regra : string):boolean;
begin
  FQry.Close;
  FQry.SQL.Text :=
    'SELECT COUNT(*) FROM RDB$RELATION_CONSTRAINTS WHERE ' +
    'RDB$RELATION_NAME = ' + QuotedStr(UpperCase(tabela)) + ' AND ' +
    'RDB$CONSTRAINT_NAME = ' + QuotedStr(UpperCase(regra));
  FQry.Open;
  Result := (FQry.Fields[0].AsInteger > 0);
  FQry.Close;
end;

function TClaConApiFDB.GetFileNameIndice(const tabela, sfields : string): string;
var
  s : string;
  i : integer;
  Lista : TStringList;
begin
  Lista := TStringList.Create;
  Lista.Clear;

  ExtractStrings([','], [], PChar(sfields), Lista);

  s := '';
  for i := 0 to Lista.Count - 1 do
  begin
    if s <> '' then s := s + '_';
    s := s + Trim(Lista[i]);
  end;
  Result := tabela + '_' + s + '_IDX';
  if Length(Result) > 31 then
  begin
    s := '';
    for i := 0 to Lista.Count - 1 do
    begin
      if s <> '' then s := s + '_';
      s := s + Copy(Trim(Lista[i]), 1, 4);
    end;
    Result := Copy(Trim(tabela), 1, 8) + '_' + s + '_IDX';
  end;
  Lista.Clear;
  Lista.Free;

{
TBHISTORICOESTOQUE_DTESTOQUE_IDX
TBHISTOR_DTEST_IDX
}
end;

function TClaConApiFDB.CreateIndex(const tabela, sfields: string; const filenameIndex : string = ''): boolean;
var
  s, filename : string;
begin
  Result := false;
  if (Tabela.Trim.IsEmpty) or (Tabela.Trim.Length = 0) or (Tabela.Trim = '') then Exit;
  if (sfields.Trim.IsEmpty) or (sfields.Trim.Length = 0) or (sfields.Trim = '') then Exit;
  filename := FileNameIndex;
  if filename = '' then
    filename := GetFileNameIndice(tabela, sfields);
  if not Self.IndexExists(filename) then
  begin
    s := 'CREATE INDEX ' + filename + ' ON ' + tabela + '(' + sfields + ')';
    Result := RunSql(s);
  end;
end;

function TClaConApiFDB.CreateTable(const tabela, sql: string): boolean;
begin
  Result := true;
  if not Self.TableExists(tabela) then
  begin
    Result := Self.RunSql(sql);
  end;
end;

procedure TClaConApiFDB.DeleteIndex(const filename : string);
begin
  if Self.IndexExists(filename) then Self.RunSql('DROP INDEX ' + filename);
end;

procedure TClaConApiFDB.DeleteTable(const filename : string);
begin
  if Self.TableExists(filename) then Self.RunSql('DROP TABLE ' + filename);
end;

function TClaConApiFDB.FieldExists(const tabela,campo : string):boolean;
begin
  FQry.Close;
  FQry.SQL.Text :=
    'SELECT COUNT(*) from RDB$RELATION_FIELDS ' +
    'WHERE RDB$RELATION_NAME = ''' + UpperCase(tabela) +'''' +
    'AND RDB$FIELD_NAME = ''' + UpperCase(campo) +'''';
  FQry.Open;
  Result := (FQry.Fields[0].AsInteger > 0);
  FQry.Close;
end;

procedure TClaConApiFDB.FQueryAfterClose(DataSet: TDataSet);
begin
  FQuery.IndexFieldNames := '';
end;

function TClaConApiFDB.GeneratorExists(const tabela : string):boolean;
begin
  FQry.Close;
  FQry.SQL.Text :=
    'SELECT COUNT(*) FROM RDB$GENERATORS WHERE RDB$GENERATOR_NAME = ' +
    QuotedStr(UpperCase(tabela));
  FQry.Open;
  Result := (FQry.Fields[0].AsInteger > 0);
  FQry.Close;
end;

function TClaConApiFDB.GetFieldSize(const tabela, campo : string) : integer;
begin
  Result := 0;
  FQry.Close;
  FQry.SQL.Text :=
    'SELECT RDB$FIELD_LENGTH, RDB$FIELD_TYPE ' +
    'FROM RDB$FIELDS ' +
    'WHERE RDB$FIELD_NAME = ' +
    '      (SELECT RDB$FIELD_SOURCE ' +
    '         FROM RDB$RELATION_FIELDS ' +
    '        WHERE RDB$RELATION_NAME = ' + QuotedStr(UpperCase(tabela)) + ' AND ' +
    '              RDB$FIELD_NAME = ' +  QuotedStr(UpperCase(campo)) + ')';
  try
    FQry.Open;
  except
    On E : Exception do
    begin
      MsgInforma(FQry.SQL.Text + chr(13) + e.message);
    End;
  end;
  if FQry.RecordCount > 0 then
  begin
    Result := FQry.FieldByName('RDB$FIELD_LENGTH').AsInteger;
  end;
  FQry.Close;
end;

procedure TClaConApiFDB.GetFieldSizeDecimal(const campo, sTableUsed : string; var Tamanho, Decimal : integer);
const
  Busca : string = ' SELECT B.RDB$FIELD_PRECISION AS TAMANHO,' +
                   '        ABS(B.RDB$FIELD_SCALE) AS ESCALA,' +
                   '        A.RDB$FIELD_NAME AS CAMPO' +
                   ' FROM' +
                   ' RDB$RELATION_FIELDS A' +
                   ' INNER JOIN RDB$FIELDS B ON (A.RDB$FIELD_SOURCE = B.RDB$FIELD_NAME)' +
                   ' WHERE RDB$RELATION_NAME = :TABELA AND A.RDB$FIELD_NAME =:CAMPO';
var
  Lista : TStringList;
  i : integer;
  ok : Boolean;
  s : string;
begin
  Tamanho := 18;
  Decimal := 2;
  Lista := TStringList.Create;
  i := ExtractStrings(['|'], [' '], PChar(sTableUsed), Lista);
  if i > 0 then
  begin
    ok := False;
    for i := 0 to  Lista.Count - 1 do
    begin
       s := StringReplace(Busca, ':TABELA', QuotedStr(Lista[i]), [rfReplaceAll, rfIgnoreCase]);
       s := StringReplace(s,     ':CAMPO',  QuotedStr(campo), [rfReplaceAll, rfIgnoreCase]);
       FQry.Close;
       FQry.SQL.Clear;
       FQry.SQL.Text := s;
       FQry.Open;
       if not FQry.Eof then
       begin
         Tamanho := FQry.FieldByName('TAMANHO').AsInteger;
         Decimal := FQry.FieldByName('ESCALA').AsInteger;
         ok := true;
       end;
       FQry.Close;
       if ok then Break;
    end;
  end;
  Lista.Free;
end;

function TClaConApiFDB.GetFilename: string;
begin
  Result := FFilename;
end;

procedure TClaConApiFDB.GetIndicesFromTable(var MyLista : TStringList; const TableName : string);
var
  s : string;
begin
  FQry.Close;
  FQry.SQL.Text :=
    'SELECT RDB$INDEX_NAME FROM RDB$INDICES ' +
    'WHERE RDB$RELATION_NAME = ''' + TableName + '''';
  FQry.Open;
  FQry.First;
  MyLista.Clear;
  while not FQry.Eof do
  begin
    s := FQry.FieldByName('RDB$INDEX_NAME').AsString;
    if (Pos('PK', s) = 0) and
       (Pos('FK', s) = 0) and
       (Pos('RDB$', s) =0) then
    begin
      MyLista.Add(s);
    end;
    FQry.Next;
  end;
  FQry.Close;
end;//HabilitaIndices

procedure TClaConApiFDB.SetIndiceTable(const TableName : string; const ok : boolean );
var
  s : string;
begin
  FQry.Close;
  FQry.SQL.Text :=
    'SELECT RDB$INDEX_NAME FROM RDB$INDICES ' +
    'WHERE RDB$RELATION_NAME = ''' + TableName + '''';
  FQry.Open;
  FQry.First;
  while not FQry.Eof do
  begin
    s := FQry.FieldByName('RDB$INDEX_NAME').AsString;
    if (Pos('PK', s) = 0) and
       (Pos('FK', s) = 0) and
       (Pos('RDB$', s) =0) then
    begin
      if OK then
        FSQL.SQL.Text := ' ALTER INDEX ' + s + ' ACTIVE'
      else
        FSQL.SQL.Text := ' ALTER INDEX ' + s + ' INACTIVE';
      FSQL.Execute;
    end;
    FQry.Next;
  end;
  FQry.Close;
end;

procedure TClaConApiFDB.GetNameIndices(var MyLista : TStringList);
var
  s, sSql : string;
begin
  sSQL := ' select  rdb$indices.rdb$index_name ' +
          '        ,rdb$indices.rdb$relation_name ' +
          '        ,rdb$indices.rdb$index_id ' +
          '        ,rdb$indices.rdb$unique_flag ' +
          '        ,rdb$indices.rdb$segment_count ' +
          '        ,rdb$indices.rdb$foreign_key ' +
          '        ,rdb$indices.rdb$system_flag ' +
          '        ,rdb$indices.rdb$index_inactive ' +
          '        ,rdb$indices.rdb$index_type ' +
          ' from    rdb$indices ' +
          ' where   rdb$indices.rdb$index_name not in (select  rdb$indices.rdb$index_name ' +
          '                                            from    rdb$indices ' +
          '                                            where   rdb$indices.rdb$system_flag = 1) ';
  FQry.Close;
  FQry.SQL.Text := sSql;
  FQry.Open;
  FQry.First;
  MyLista.Clear;
  while not FQry.Eof do
  begin
    s := FQry.FieldByName('RDB$INDEX_NAME').AsString;
    if (Pos('PK', s) = 0) and
       (Pos('FK', s) = 0) and
       (Pos('RDB$', s) =0) then
    begin
      MyLista.Add(s);
    end;
    FQry.Next;
  end;
  FQry.Close;
end;

function TClaConApiFDB.GetQtdRecord(const tabela : string):Integer;
begin
  FQry.Close;
  FQry.SQL.Clear;
  FQry.SQL.Text := 'SELECT COUNT(*) AS QTD FROM ' + tabela;
  FQry.Open;
  Result := FQry.fieldbyname('QTD').ASINTEGER;
  FQry.Close;
end;

function TClaConApiFDB.GetQuery: TUniQuery;
begin
  Result := FQuery;
end;

function TClaConApiFDB.GetSQL: TUniSql;
begin
  Result := FSQL;
end;

procedure TClaConApiFDB.GetTablesFromDataBase(var MyLista: TStringList);
var
  s: string;
  i: Integer;
begin
  FQry.Close;
  FQry.sql.Clear;
  FQry.sql.Text := ' SELECT DISTINCT RDB$RELATION_NAME AS TABLE_NAME FROM RDB$RELATIONS WHERE RDB$FLAGS = 1';
  FQry.Open;
  FQry.First;
  MyLista.Clear;
  while not FQry.Eof do
  begin
    s := FQry.FieldByName('TABLE_NAME').AsString;
    if not MyLista.Find(s, i) then
      MyLista.Add(s);
    FQry.Next;
  end;
  FQry.Close;
end;

Procedure TClaConApiFDB.GetTBStructFDB(const sTBFileName : string; var X : TXRegStructFDB);
var
  i : integer;
  s : string;
begin
  s :=
  'SELECT DISTINCT CAMPOS.RDB$FIELD_NAME AS FIELDNAME, ' +
  'CASE ' +
  '  WHEN DADOSCAMPO.RDB$FIELD_PRECISION > 0 THEN ''NUMERIC''  ' +
  '  WHEN TIPOS.RDB$TYPE_NAME = ''LONG'' THEN ''INTEGER'' ' +
  '  WHEN TIPOS.RDB$TYPE_NAME = ''SHORT'' THEN ''SMALLINT'' ' +
  '  WHEN TIPOS.RDB$TYPE_NAME = ''INT64'' THEN ''NUMERIC'' ' +
  '  WHEN TIPOS.RDB$TYPE_NAME = ''VARYING'' THEN ''VARCHAR'' ' +
  '  WHEN TIPOS.RDB$TYPE_NAME = ''TEXT'' THEN ''CHAR'' ' +
  '  WHEN TIPOS.RDB$TYPE_NAME = ''BLOB'' THEN ''BLOB SUB_TYPE'' ' +
  '  ELSE TIPOS.RDB$TYPE_NAME ' +
  'END AS FIELDTYPE, ' +
  'CASE ' +
  '  WHEN DADOSCAMPO.RDB$FIELD_TYPE IN(16,8) THEN DADOSCAMPO.RDB$FIELD_PRECISION ' +
  '  ELSE DADOSCAMPO.RDB$FIELD_LENGTH ' +
  'END AS FIELDLENGTH, ' +
  'ABS(DADOSCAMPO.RDB$FIELD_SCALE) AS FIELDSCALE, ' +
  'CASE ' +
  '  CAMPOS.RDB$NULL_FLAG WHEN 1 THEN ''N'' ELSE ''Y''  ' +
  'END AS FIELDNULLABLE ' +
  'FROM RDB$RELATIONS TABELAS, RDB$RELATION_FIELDS CAMPOS, ' +
  '     RDB$FIELDS DADOSCAMPO, RDB$TYPES TIPOS ' +
  'WHERE TABELAS.RDB$RELATION_NAME = ''' + sTBFilename + ''' AND ' +
  '      TIPOS.RDB$FIELD_NAME = ''RDB$FIELD_TYPE'' AND ' +
  '      TABELAS.RDB$RELATION_NAME = CAMPOS.RDB$RELATION_NAME AND ' +
  '      CAMPOS.RDB$FIELD_SOURCE = DADOSCAMPO.RDB$FIELD_NAME AND ' +
  '      DADOSCAMPO.RDB$FIELD_TYPE = TIPOS.RDB$TYPE ' +
  'ORDER BY CAMPOS.RDB$FIELD_POSITION ';

  FQry.Close;
  FQry.SQL.Text := s;
  FQry.Open;
  i := 0;
  while not FQry.Eof do
  begin
    inc(i);
    FQry.Next;
  end;
  SetLength(X, i);
  i := -1;
  FQry.First;
  while not FQry.Eof do
  begin
    inc(i);
    X[i].Nome    := FQry.FieldByName('FIELDNAME').AsString;
    X[i].Tipo    := FQry.FieldByName('FIELDTYPE').AsString;
    X[i].Tamanho := FQry.FieldByName('FIELDLENGTH').AsInteger;
    X[i].Decimal := FQry.FieldByName('FIELDSCALE').AsInteger;
    FQry.Next;
  end;
  FQry.Close;
end;

procedure TClaConApiFDB.HabilitaIndices(const OK : boolean; const MyLista : TStringList);
var
  i : integer;
begin
  for i := 0 to MyLista.Count - 1 do
  begin
    if OK then
      FSQL.SQL.Text := ' ALTER INDEX ' + MyLista[i] + ' ACTIVE'
    else
      FSQL.SQL.Text := ' ALTER INDEX ' + MyLista[i] + ' INACTIVE';
    FSQL.Execute;
  end;
end;

procedure TClaConApiFDB.HabilitaIndicesFromTable(const OK: boolean;
  const MyLista: TStringList);
var
  i : integer;
begin
  for i := 0 to MyLista.Count - 1 do
  begin
    SetIndiceTable(MyLista[i], OK);
  end;
end;

procedure TClaConApiFDB.HabilitaIndicesFromTable(const OK: boolean;
  const tabela: string);
begin
  SetIndiceTable(tabela, OK);
end;

function TClaConApiFDB.IndexExists(const tabela : string):boolean;
begin
  FQry.Close;
  FQry.SQL.Text :=
    'SELECT COUNT(*) FROM RDB$INDICES WHERE RDB$INDEX_NAME = ' +
    QuotedStr(UpperCase(tabela));
  FQry.Open;
  Result := (FQry.Fields[0].AsInteger > 0);
  FQry.Close;
end;


function TClaConApiFDB.ProcedureExists(const tabela : string):boolean;
begin
  FQry.Close;
  FQry.SQL.Text :=
    'SELECT COUNT(*) FROM RDB$PROCEDURES WHERE RDB$PROCEDURE_NAME = ' +
    QuotedStr(UpperCase(tabela));
  FQry.Open;
  Result := (FQry.Fields[0].AsInteger > 0);
  FQry.Close;
end;

function TClaConApiFDB.RecordExists(const tabela : string):boolean;
begin
  Result := false;
  if TableExists(tabela) then
  begin
    FQry.Close;
    FQry.SQL.Text := 'SELECT FIRST 1 * FROM ' + tabela;
    FQry.Open;
    Result := not FQry.Eof;
    FQry.Close;
  end;
end;

function TClaConApiFDB.RunSql( const sSql: string) : Boolean;
begin
  Result := RunSql(sSql, []);
end;

function TClaConApiFDB.RunSql( const sSql: string; const AParams: array of Variant) : Boolean;
var
  i : integer;
begin
  Result := true;
  try
    FSql.Params.Clear;
    FSql.SQL.Clear;
    FSql.SQL.Text := sSql;
    if High(AParams) >= Low(AParams) then
    begin
      for i := Low(AParams) to High(AParams) do
        FSql.Params[i].Value := AParams[i];
      FSql.Prepare();
    end;
    FSql.Execute;
  except
    On E : Exception do
    begin
      MsgInforma('Erro DSQL: ' + #13 + FSql.SQL.Text + #13 + e.message);
      Result := false;
    end;
  end;
end;

procedure TClaConApiFDB.SetActiveIndex(const TableName : string; const OK : boolean);
var
  i : integer;
  MyLista: TStringList;
begin
  Mylista := TStringList.Create;
  MyLista.Clear;
  GetIndicesFromTable(MyLista, TableName);
  for i := 0 to MyLista.Count - 1 do
  begin
    if OK then
      FSQL.SQL.Text := ' ALTER INDEX ' + MyLista[i] + ' ACTIVE'
    else
      FSQL.SQL.Text := ' ALTER INDEX ' + MyLista[i] + ' INACTIVE';
    FSQL.Execute;
  end;
  MyLista.Free;
end;

procedure TClaConApiFDB.SetbLog(const Value: boolean);
begin
  FbLog := Value;
end;

procedure TClaConApiFDB.SetNotNull(const tabela, campo : string);
begin
  FSQL.SQL.Text :=
    'UPDATE RDB$RELATION_FIELDS SET RDB$NULL_FLAG = 1 '+
    'WHERE RDB$FIELD_NAME = ''' + campo + ''' AND ' +
    'RDB$RELATION_NAME = ''' + tabela + '''';
    QuotedStr(UpperCase(tabela));
  FSQL.Execute;
end;

procedure TClaConApiFDB.SetQuery(const Value: TUniQuery);
begin
  FQuery := Value;
end;

procedure TClaConApiFDB.SetSQL(const Value: TUniSql);
begin
  FSQL := Value;
end;

function TClaConApiFDB.TableExists(const tabela : string):boolean;
begin
  FQry.Close;
  FQry.SQL.Text :=
    'SELECT COUNT(*) FROM RDB$RELATIONS WHERE RDB$RELATION_NAME = ' +
    QuotedStr(UpperCase(tabela));
  FQry.Open;
  Result := (FQry.Fields[0].AsInteger > 0);
  FQry.Close;
end;

 function TClaConApiFDB.TriggerExists(const tabela : string):boolean;
begin
  FQry.Close;
  FQry.SQL.Text :=
    'SELECT COUNT(*) FROM RDB$TRIGGERS WHERE RDB$TRIGGER_NAME = ' +
    QuotedStr(UpperCase(tabela));
  FQry.Open;
  Result := (FQry.Fields[0].AsInteger > 0);
  FQry.Close;
end;

 function TClaConApiFDB.ViewExists(const tabela : string):boolean;
begin
  FQry.Close;
  FQry.SQL.Text :=
   'SELECT COUNT(*) FROM rdb$relations WHERE (rdb$relation_name = '
     + QuotedStr(UpperCase(tabela)) + ') AND (rdb$view_blr IS NOT NULL)';
  FQry.Open;
  Result := (FQry.Fields[0].AsInteger > 0);
  FQry.Close;
end;

function TClaConApiFDB.AddField(const Tabela, Campo, Tipo, Tamanho, Decimal: string;
  const Obrigatorio: Boolean): Boolean;
var
  sSql, sSqlUpdate, sSql2 : string;
begin
  sSql  := 'ALTER TABLE ' + Tabela + ' ADD '+ Campo;
  if (Tipo = 'VARCHAR') or (Tipo = 'CHAR') then
  begin
    sSql := sSql + ' ' + Tipo + '(' + Tamanho + ')';
    if Obrigatorio then
      sSql := sSql + ' NOT NULL '
    else
      begin
        sSql := sSql + ' DEFAULT '''' ';
        sSqlUpdate := ' = '''' ';
      end;
  end
  else if (Tipo = 'INTEGER') or (Tipo ='SMALLINT') then
  begin
    sSql := sSql + ' ' + Tipo ;
    if Obrigatorio then
      sSql := sSql + ' NOT NULL '
    else
      begin
        sSql := sSql + ' DEFAULT 0';
        sSqlUpdate := ' = 0 ';
      end;
  end
  else if (Tipo = 'FLOAT') or (Tipo ='NUMERIC') then
  begin
    if ((StrToInt(Tamanho) = 0) or (StrToInt(Decimal) = 0)) then
      sSql := sSql + ' NUMERIC (15,2)'
    else
      sSql := sSql + ' NUMERIC ' + '(' + Tamanho +', ' + Decimal +')';

    if Obrigatorio then
      sSql := sSql + ' NOT NULL'
    else
      begin
        sSql := sSql + ' DEFAULT 0';
        sSqlUpdate := ' = 0 ';
      end;
  end
  else if (Tipo = 'DATE') then
  begin
    sSql := sSql + ' ' + Tipo ;
    if Obrigatorio then
      sSql := sSql + ' NOT NULL ';
  end
  else
  begin
    sSql := sSql + ' ' + Tipo ;
  end;

  sSql2 := '';
  if sSqlUpdate <> '' then
  begin
    sSql2 := 'UPDATE ' + Tabela + ' SET ' + Campo;
    sSql2 := sSql2 + sSqlUpdate;
  end;

  if not FieldExists(Tabela, Campo) then
  begin
    RunSql(sSql);
    if sSql2 <> '' then RunSql(sSql2);
  end;
  Result := True;
end;

function TClaConApiFDB.BasePrepareSQL(const AQry: TUniQuery; const ASQL: String;
                                   const AParams: array of Variant; const ATypes: array of TFieldType): Boolean;
var
  i: Integer;
begin
  Result := true;
  AQry.Close;
  AQry.Params.Clear;
  AQry.SQL.Clear;
  AQry.SQL.Text := ASQL;
  if High(AParams) >= Low(AParams) then
  begin
    for i := Low(ATypes) to High(ATypes) do
      if ATypes[i] <> ftUnknown then
        AQry.Params[i].DataType := ATypes[i];
    for i := Low(AParams) to High(AParams) do
      AQry.Params[i].Value := AParams[i];
    AQry.Prepare();
  end;
end;

function TClaConApiFDB.ExecSQLScalar(const ASQL: String): Variant;
begin
  Result := ExecSQLScalar(ASQL, [], []);
end;

function TClaConApiFDB.ExecSQLScalar(const ASQL: String; const AParams: array of Variant): Variant;
begin
  Result := ExecSQLScalar(ASQL, AParams, []);
end;

function TClaConApiFDB.ExecSQLScalar(const ASQL: String;  const AParams: array of Variant; const ATypes: array of TFieldType): Variant;
var
  Qry : TUniQuery;
begin
  Qry := TUniQuery.Create(nil);
  try
    Qry.Connection := Self.GetConnection;
    BasePrepareSQL(Qry, ASQL, AParams, ATypes);
    Qry.Open;
    if (Qry.RecordCount > 0) and (Qry.FieldCount > 0) then
        Result := Qry.Fields[0].Value
    else
      Result := Unassigned;
  finally
    Qry.Close;
    Qry.Free;
  end;
end;

end.

