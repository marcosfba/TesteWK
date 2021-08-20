unit uWKApiGet;

interface

uses
  Classes, Vcl.Dialogs, System.SysUtils, uWKClaConApiInt, uWKApiFDB;

Type
  TNotifyEventChecDB = function (var aClaCon : IClaConApi) : boolean of object;

  TClaConAPI = class
  public
    class function Get(var aClaCon: IClaConApi;
                         const filename: string;
                         const bCheck: boolean;
                         const aFuncCheck: TNotifyEventChecDB) : boolean; overload;
  end;

implementation

uses uWKMsg;

class function TClaConAPI.Get(var aClaCon: IClaConApi;
                               const filename: string;
                               const bCheck: boolean;
                               const aFuncCheck: TNotifyEventChecDB) : boolean;
begin
  if not Assigned(aClaCon) then
  begin
    aClaCon := TClaConApiFDB.Create;
    Result := aClaCon.ConectaBanco(filename);
    if Result then
    begin
      if (bCheck) and (Assigned(aFuncCheck)) then
      begin
        Result := aFuncCheck(aClaCon);
      end;
    end;
    if not Result then
      MsgErro('Erro: Banco de dados não conectado. ' + #13 + filename);
  end
  else
  begin
    Result := (aClaCon.IsConnected) and (aClaCon.Filename = filename);
    if not Result then
       Result := aClaCon.ConectaBanco(Filename);
    if Result then
    begin
      if (bCheck) and (Assigned(aFuncCheck)) then
      begin
        Result := aFuncCheck(aClaCon);
      end;
    end;
  end;
end;

end.



