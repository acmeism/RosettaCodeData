program Repeater;

{$APPTYPE CONSOLE}
{$R *.res}

type
  TSimpleProc = procedure;     // Can also define types for procedures (& functions) which
                               // require params.

procedure Once;
begin
  writeln('Hello World');
end;

procedure Iterate(proc : TSimpleProc; Iterations : integer);
var
  i : integer;
begin
  for i := 1 to Iterations do
    proc;
end;

begin
  Iterate(Once, 3);
  readln;
end.
