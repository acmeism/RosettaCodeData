program DivideByZero;

{$APPTYPE CONSOLE}

uses SysUtils;

var
  a, b: Integer;
begin
  a := 1;
  b := 0;
  try
    WriteLn(a / b);
  except
    on e: EZeroDivide do
      Writeln(e.Message);
  end;
end.
