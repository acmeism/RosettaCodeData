program Pells_equation;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  Velthuis.BigIntegers;

type
  TPellResult = record
    x, y: BigInteger;
  end;

function SolvePell(nn: UInt64): TPellResult;
var
  n, x, y, z, r, e1, e2, f1,  t, u, a, b: BigInteger;
begin
  n := nn;
  x := nn;
  x := BigInteger.Sqrt(x);
  y := BigInteger(x);
  z := BigInteger.One;
  r := x shl 1;

  e1 := BigInteger.One;
  e2 := BigInteger.Zero;
  f1 := BigInteger.Zero;
  b := BigInteger.One;

  while True do
  begin
    y := (r * z) - y;
    z := (n - (y * y)) div z;
    r := (x + y) div z;

    u := BigInteger(e1);
    e1 := BigInteger(e2);
    e2 := (r * e2) + u;

    u := BigInteger(f1);
    f1 := BigInteger(b);

    b := r * b + u;
    a := e2 + x * b;

    t := (a * a) - (n * b * b);

    if t = 1 then
    begin
      with Result do
      begin
        x := BigInteger(a);
        y := BigInteger(b);
      end;
      Break;
    end;
  end;
end;

const
  ns: TArray<UInt64> = [61, 109, 181, 277];
  fmt = 'x^2 - %3d*y^2 = 1 for x = %-21s and y = %s';

begin
  for var n in ns do
    with SolvePell(n) do
      writeln(format(fmt, [n, x.ToString, y.ToString]));

  {$IFNDEF UNIX} readln; {$ENDIF}
end.
