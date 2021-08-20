unit uWKClaConApiInt;

interface

uses Classes, UNI, Data.DB, uWKTypes;

type
  IClaConApi = interface
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
    function GetFileNameIndice(const Tabela, sfields: string): string;
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
    function GetbLog: boolean;
    function GetCursor: TUniQuery;
    function GetFilename: string;
    function GetQuery: TUniQuery;
    function GetSQL: TUniSql;
    procedure SetbLog(const Value: boolean);
    procedure SetFilename(const Value: string);
    procedure SetQuery(const Value: TUniQuery);
    procedure SetSQL(const Value: TUniSql);
    procedure SetCursor(const Value: TUniQuery);

    property bLog : boolean read GetbLog write SetbLog;
    property Filename : string read GetFilename write SetFilename;
    property Query: TUniQuery read GetQuery write SetQuery;
    property Cursor: TUniQuery read GetCursor write SetCursor;
    property SQL: TUniSql read GetSQL write SetSQL;
  end;

implementation

end.
