unit uWKMsg;

interface

Uses SysUtils, WinTypes, Vcl.Forms, Vcl.Dialogs, System.UITypes;

procedure Mostrar(const s: string);
procedure MsgAdverte(const Msg: String);
procedure MsgInforma(const Msg: String);
procedure MsgErro(const Msg: String);
function  MsgConfirma(const Msg: String): Boolean;
function  Confirm(const Msg: String): Boolean;

implementation

procedure Mostrar(const s: string);
begin
  Application.MessageBox(pchar(s), '', 0);
end;

procedure MsgErro(const Msg: String);
begin
  Application.MessageBox(PChar(Msg), 'Erro', MB_OK + MB_ICONERROR);
end;

procedure MsgInforma(const Msg: String);
begin
  Application.MessageBox(PChar(Msg), 'Informação', MB_OK + MB_ICONINFORMATION);
end;

procedure MsgAdverte(const Msg: String);
begin
  Application.MessageBox(PChar(Msg), 'Advertência', MB_OK + MB_ICONWARNING);
end;

function MsgConfirma(const Msg: String): Boolean;
begin
  Result := MessageDlg(Msg, mtConfirmation, [mbYes, mbNo], 0) = mrYes;
end;

function Confirm(const Msg: String): Boolean;
begin
  Result := MessageDlg(Msg, mtConfirmation, [mbYes, mbNo], 0) = mrYes;
end;

end.

