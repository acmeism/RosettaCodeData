program Nimber_arithmetic;

uses
  System.SysUtils, System.Math;

Type
  TFnop = record
    fn: TFunc<Cardinal, Cardinal, Cardinal>;
    op: string;
  end;

  // Highest power of two that divides a given number.
function hpo2(n: Cardinal): Cardinal;
begin
  Result := n and (-n)
end;

// Base 2 logarithm of the highest power of 2 dividing a given number.
function lhpo2(n: Cardinal): Cardinal;
var
  m: Cardinal;

begin
  Result := 0;
  m := hpo2(n);

  while m mod 2 = 0 do
  begin
    m := m shr 1;
    inc(Result);
  end;
end;

// nim-sum of two numbers.
function nimsum(x, y: Cardinal): Cardinal;
begin
  Result := x xor y;
end;

function nimprod(x, y: Cardinal): Cardinal;
var
  h, xp, yp, comp: Cardinal;

begin
  if (x < 2) or (y < 2) then
    exit(x * y);

  h := hpo2(x);

  if x > h then
    exit((nimprod(h, y) xor nimprod((x xor h), y)));

  if hpo2(y) < y then
    exit(nimprod(y, x)); // break y into powers of 2 by flipping operands

  xp := lhpo2(x);
  yp := lhpo2(y);
  comp := xp and yp;

  if comp = 0 then
    exit(x * y); // no Fermat power in common

  h := hpo2(comp);

  // a Fermat number square is its sequimultiple
  Result := nimprod(nimprod(x shr h, y shr h), 3 shl (h - 1));

end;

var
  fnop: array [0 .. 1] of TFnop;
  f: TFnop;
  i, j, a, b: Cardinal;

begin
  with fnop[0] do
  begin
    fn := nimsum;
    op := '+';
  end;

  with fnop[1] do
  begin
    fn := nimprod;
    op := '*';
  end;

  for f in fnop do
  begin
    write(' ', f.op, ' |');
    for i := 0 to 15 do
      Write(i:3);
    Writeln;
    Writeln('--- ', string.Create('-', 48));

    for i := 0 to 15 do
    begin
      write(i:2, ' |');
      for j := 0 to 15 do
        write(f.fn(i, j):3);
      Writeln;
    end;
    Writeln;
  end;

  a := 21508;
  b := 42689;

  Writeln(Format('%d + %d = %d', [a, b, nimsum(a, b)]));

  Writeln(Format('%d * %d = %d', [a, b, nimprod(a, b)]));

  readln;

end.
