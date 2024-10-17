program ChineseRemainderTheorem;

uses
  System.SysUtils, Velthuis.BigIntegers;

function mulInv(a, b: BigInteger): BigInteger;
var
  b0, x0, x1, q, amb, xqx: BigInteger;
begin
  b0 := b;
  x0 := 0;
  x1 := 1;

  if (b = 1) then
    exit(1);

  while (a > 1) do
  begin
    q := a div b;
    amb := a mod b;
    a := b;
    b := amb;
    xqx := x1 - q * x0;
    x1 := x0;
    x0 := xqx;
  end;

  if (x1 < 0) then
    x1 := x1 + b0;

  Result := x1;
end;

function chineseRemainder(n: TArray<BigInteger>; a: TArray<BigInteger>)
  : BigInteger;
var
  i: Integer;
  prod, p, sm: BigInteger;
begin
  prod := 1;

  for i := 0 to High(n) do
    prod := prod * n[i];

  p := 0;
  sm := 0;

  for i := 0 to High(n) do
  begin
    p := prod div n[i];
    sm := sm + a[i] * mulInv(p, n[i]) * p;
  end;
  Result := sm mod prod;
end;

var
  n, a: TArray<BigInteger>;

begin
  n := [3, 5, 7];
  a := [2, 3, 2];

  Writeln(chineseRemainder(n, a).ToString);
end.
