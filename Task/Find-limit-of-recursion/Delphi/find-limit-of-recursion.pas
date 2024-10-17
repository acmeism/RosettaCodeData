program Project2;
{$APPTYPE CONSOLE}
uses
  SysUtils;

function Recursive(Level : Integer) : Integer;
begin
  try
    Level := Level + 1;
    Result := Recursive(Level);
  except
    on E: EStackOverflow do
      Result := Level;
  end;
end;

begin
  Writeln('Recursion Level is ', Recursive(0));
  Writeln('Press any key to Exit');
  Readln;
end.
