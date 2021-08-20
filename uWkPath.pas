unit uWkPath;

interface

uses

  Windows, Messages, System.SysUtils, Classes, Vcl.Forms;

type
  TClaPath = class(TPersistent)
  private
    FAppPath: string;
    FBinPath: string;
    FDadosPath: string;
    FTempPath: string;
    procedure Clear;
    procedure SetAppPath(const Value: string);
    procedure SetBinPath(const Value: string);
    procedure SetDadosPath(const Value: string);
    procedure SetTempPath(const Value: string);
  public
    constructor Create; overload;
    destructor Destroy; override;
  published
    property AppPath: string read FAppPath write SetAppPath;
    property BinPath: string read FBinPath write SetBinPath;
    property DadosPath: string read FDadosPath write SetDadosPath;
    property TempPath: string read FTempPath write SetTempPath;
  end;

var
  ClaPath: TClaPath;

implementation

procedure TClaPath.Clear;
begin
  FAppPath := '';
  FBinPath := '';
  FDadosPath := '';
  FTempPath := '';
end;

constructor TClaPath.Create;
begin
  Self.Clear;
  FAppPath := UpperCase(ExtractFilePath(Application.ExeName));
  if Pos('BIN', UpperCase(FAppPath)) > 0 then
    FAppPath := copy(FAppPath, 1, Length(FAppPath) - 4);

  FBinPath   := FAppPath + 'Bin\';
  FDadosPath := FAppPath + 'Dados\';
  FTempPath  := FAppPath + 'Temp\';

  if not DirectoryExists(FAppPath) then
    ForceDirectories(FAppPath);
  if not DirectoryExists(FBinPath) then
    ForceDirectories(FBinPath);
  if not DirectoryExists(FDadosPath) then
    ForceDirectories(FDadosPath);
  if not DirectoryExists(FTempPath) then
    ForceDirectories(FTempPath);
end;

destructor TClaPath.Destroy;
begin
  inherited;
end;

procedure TClaPath.SetAppPath(const Value: string);
begin
  FAppPath := Value;
end;

procedure TClaPath.SetBinPath(const Value: string);
begin
  FBinPath := Value;
end;

procedure TClaPath.SetDadosPath(const Value: string);
begin
  FDadosPath := Value;
end;

procedure TClaPath.SetTempPath(const Value: string);
begin
  FTempPath := Value;
end;

end.
