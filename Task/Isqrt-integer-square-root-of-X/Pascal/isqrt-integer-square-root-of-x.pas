//************************************************//
//                                                //
//  Thanks for rvelthuis for BigIntegers library  //
//  https://github.com/rvelthuis/DelphiBigNumbers //
//                                                //
//************************************************//

program IsqrtTask;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Velthuis.BigIntegers;

function isqrt(x: BigInteger): BigInteger;
var
  q, r, t: BigInteger;
begin
  q := 1;
  r := 0;
  while (q <= x) do
    q := q shl 2;

  while (q > 1) do
  begin
    q := q shr 2;
    t := x - r - q;
    r := r shr 1;
    if (t >= 0) then
    begin
      x := t;
      r := r + q;
    end;
  end;
  Result := r;
end;

function commatize(const n: BigInteger; size: Integer): string;
var
  str: string;
  digits: Integer;
  i: Integer;
begin
  Result := '';
  str := n.ToString;
  digits := str.Length;

  for i := 1 to digits do
  begin
    if ((i > 1) and (((i - 1) mod 3) = (digits mod 3))) then
      Result := Result + ',';
    Result := Result + str[i];
  end;

  if Result.Length < size then
    Result := string.Create(' ', size - Result.Length) + Result;
end;

const
  POWER_WIDTH = 83;
  ISQRT_WIDTH = 42;

var
  n, i: Integer;
  f: TextFile;
  p: BigInteger;

begin
  AssignFile(f, 'output.txt');
  rewrite(f);

  Writeln(f, 'Integer square root for numbers 0 to 65:');
  for n := 0 to 65 do
    Write(f, isqrt(n).ToString, ' ');

  Writeln(f, #10#10'Integer square roots of odd powers of 7 from 1 to 73:');

  Write(f, ' n |', string.Create(' ', 78), '7 ^ n |', string.Create(' ', 30),
    'isqrt(7 ^ n)'#10);

  Writeln(f, string.Create('-', 17 + POWER_WIDTH + ISQRT_WIDTH));

  p := 7;
  n := 1;
  repeat
    Writeln(f, Format('%2d', [n]), ' |', commatize(p, power_width), ' |',
      commatize(isqrt(p), isqrt_width));
    inc(n, 2);
    p := p * 49;
  until (n > 73);

  CloseFile(f);
end.
