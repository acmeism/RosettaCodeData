program Calculating_the_value_of_e;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

const
  EPSILON = 1.0e-15;

function fAbs(value: Extended): Extended;
begin
  Result := value;
  if value < 0 then
    Result := -Result;
end;

function e: Extended;
var
  fact: UInt64;
  e, e0: Extended;
  n: Integer;
begin
  fact := 1;
  Result := 2.0;
  n := 2;
  repeat
    e0 := Result;
    fact := fact * n;
    inc(n);
    Result := Result + (1.0 / fact);
  until (fAbs(Result - e0) < EPSILON);
end;

begin
  writeln(format('e = %.15f', [e]));
  readln;
end.
