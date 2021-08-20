unit uWKConections;

interface

uses Classes, uWKClaConApiInt;

var
  ClaConWK : IClaConApi;

type
  TClaConWK = class
  public
    class function Open(const bcheck : Boolean = True): Boolean;
    class procedure Close;
  end;

implementation

uses uWKTabelas, uWKApiGet;

class function TClaConWK.Open(const bcheck : Boolean = True) : boolean;
var
  F : TClaTabelas;
begin
  if Assigned(ClaConWK) then
  begin
    if ClaConWK.IsConnected then
    begin
      Result := true;
      Exit;
    end;
  end;
  F := TClaTabelas.Create;
  Result := TClaConAPI.Get(ClaConWK, F.GetFilename, bCheck,  F.CheckBanco);
  F.Free;
end;

class procedure TClaConWK.Close;
begin
  if Assigned(ClaConWK) then
  begin
    ClaConWK.Close;
    ClaConWK := nil;
  end;
end;


end.
