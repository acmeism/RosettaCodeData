program Calculating_the_value_of_e;
{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

{$IFDEF WINDOWS}
  {$APPTYPE CONSOLE}
{$ENDIF}
uses
  SysUtils;

const
  EPSILON = 1.0e-14;

function Get_E: Extended;
var
  recfact: Extended;
  n: Integer;
begin
  recfact := 1.0;
  Result := 2.0;
  n := 2;
  repeat
    recfact /= n;
    inc(n);
    Result := Result + recfact;
  until (recfact < EPSILON);
end;

begin
  writeln(format('calc e = %.15f intern e= %.15f', [Get_E,exp(1.0)]));
  {$IFDEF WINDOWS}readln;{$ENDIF}
end.
