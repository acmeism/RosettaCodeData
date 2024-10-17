program Calculate_Pi;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  Velthuis.BigIntegers,
  System.Diagnostics;

function IntSqRoot(value, guess: BigInteger): BigInteger;
var
  term: BigInteger;
begin
  while True do
  begin
    term := value div guess;
    if (BigInteger.Abs(term - guess) <= 1) then
      break;
    guess := (guess + term) shr 1;
  end;
  Result := guess;
end;

function ISR(term, guess: BigInteger): BigInteger;
var
  value: BigInteger;
begin
  value := term * guess;
  while (True) do
  begin
    if (BigInteger.Abs(term - guess) <= 1) then
      break;
    guess := (guess + term) shr 1;
    term := value div guess;
  end;
  Result := guess;
end;

function CalcAGM(lam, gm: BigInteger; var z: BigInteger; ep: BigInteger): BigInteger;
var
  am, zi, v: BigInteger;
  n: UInt32;
begin
  n := 1;
  while True do
  begin
    am := (lam + gm) shr 1;
    gm := ISR(lam, gm);
    v := am - lam;
    zi := v * v * n;
    if (zi < ep) then
      break;
    z := z - zi;
    n := n shl 1;
    lam := am;
  end;
  Result := am;
end;

function BIP(exp: Integer; man: UInt32 = 1): BigInteger;
begin
  Result := man * BigInteger.Pow(10, exp);
end;

function Compress(val: string; size: Integer): string;
begin
  result := val.Remove(size, val.Length - size * 2).Insert(size, '...');
end;

const
  DEFAULT_DIGITS = 25000;

var
  d: Integer;
  am, gm, z, agm, pi: BigInteger;
  StopWatch: TStopwatch;
  s: string;

begin
  StopWatch := TStopwatch.Create;

  d := DEFAULT_DIGITS;
  if (ParamCount > 0) then
  begin
    d := StrToIntDef(ParamStr(1), d);

    if ((d < 1) or (d > 999999)) then
      d := DEFAULT_DIGITS;
  end;

  StopWatch.Start;

  am := BIP(d);

  gm := IntSqRoot(BIP(d + d - 1, 5), BIP(d - 15, Trunc(Sqrt(0.5) * 1e+15)));

  z := BIP(d + d - 2, 25);
  agm := CalcAGM(am, gm, z, BIP(d + 1));

  pi := (agm * agm * BIP(d - 2)) div z;
  s := pi.ToString.Insert(1, '.');

  StopWatch.Stop;
  Writeln(Format('Computation time: %.3f seconds ', [StopWatch.ElapsedMilliseconds
    / 1000]));

  Writeln(Compress(s, 20));
  readln;
end.
