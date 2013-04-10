program IntegerArithmetic;

{$APPTYPE CONSOLE}

uses SysUtils, Math;

var
  a, b: Integer;
begin
  a := StrToInt(ParamStr(1));
  b := StrToInt(ParamStr(2));

  WriteLn(Format('%d + %d = %d', [a, b, a + b]));
  WriteLn(Format('%d - %d = %d', [a, b, a - b]));
  WriteLn(Format('%d * %d = %d', [a, b, a * b]));
  WriteLn(Format('%d / %d = %d', [a, b, a div b])); // rounds towards 0
  WriteLn(Format('%d %% %d = %d', [a, b, a mod b])); // matches sign of the first operand
  WriteLn(Format('%d ^ %d = %d', [a, b, Trunc(Power(a, b))]));
end.
