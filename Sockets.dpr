program Sockets;

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {Form1},
  Common_Unit in 'Common_Unit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
