program TestAssert;

{$APPTYPE CONSOLE}

{.$ASSERTIONS OFF}   // remove '.' to disable assertions

uses
  SysUtils;

var
  a: Integer;

begin
  try
    Assert(a = 42);
  except
    on E:Exception do
      Writeln(E.Classname, ': ', E.Message);
  end;
  Readln;
end.
