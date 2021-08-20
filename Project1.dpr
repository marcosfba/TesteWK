program Project1;

uses
  Vcl.Forms,
  uWkPath,
  uMain in 'uMain.pas' {FormMain};

{$R *.res}

begin
  if not Assigned(ClaPath) then ClaPath := TClaPath.Create;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
