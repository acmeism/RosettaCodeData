program Repeater;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils;

procedure Iterate(proc: TProc; Iterations: integer);
var
  i: integer;
begin
  for i := 1 to Iterations do
    proc;
end;

begin
  Iterate(
    procedure
    begin
      writeln('Hello World');
    end, 3);
  readln;
end.
