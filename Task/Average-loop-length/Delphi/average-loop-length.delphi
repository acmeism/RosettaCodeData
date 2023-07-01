program Average_loop_length;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Math;

const
  MAX_N = 20;
  TIMES = 1000000;

function Factorial(const n: Double): Double;
begin
  Result := 1;
  if n > 1 then
    Result := n * Factorial(n - 1);
end;

function Expected(const n: Integer): Double;
var
  i: Integer;
begin
  Result := 0;
  for i := 1 to n do
    Result := Result + (factorial(n) / Power(n, i) / factorial(n - i));
end;

function Test(const n, times: Integer): integer;
var
  i, x, bits: Integer;
begin
  Result := 0;
  for i := 0 to times - 1 do
  begin
    x := 1;
    bits := 0;
    while ((bits and x) = 0) do
    begin
      inc(Result);
      bits := bits or x;
      x := 1 shl random(n);
    end;
  end;
end;

var
  n, cnt: Integer;
  avg, theory, diff: Double;

begin
  Randomize;
  Writeln(#10' tavg'^I'exp.'^I'diff'#10'-------------------------------');

  for n := 1 to MAX_N do
  begin
    cnt := test(n, times);
    avg := cnt / times;
    theory := expected(n);
    diff := (avg / theory - 1) * 100;
    writeln(format('%2d %8.4f %8.4f %6.3f%%', [n, avg, theory, diff]));
  end;

  readln;
end.
