program Parallel_calculations;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Threading,
  Velthuis.BigIntegers;

function IsPrime(n: BigInteger): Boolean;
var
  i: BigInteger;
begin
  if n <= 1 then
    exit(False);

  i := 2;
  while i < BigInteger.Sqrt(n) do
  begin
    if n mod i = 0 then
      exit(False);
    inc(i);
  end;

  Result := True;
end;

function GetPrimes(n: BigInteger): TArray<BigInteger>;
var
  divisor, next, rest: BigInteger;
begin
  divisor := 2;
  next := 3;
  rest := n;
  while (rest <> 1) do
  begin
    while (rest mod divisor = 0) do
    begin
      SetLength(Result, Length(Result) + 1);
      Result[High(Result)] := divisor;
      rest := rest div divisor;
    end;
    divisor := next;
    next := next + 2;
  end;
end;

function Min(l: TArray<BigInteger>): BigInteger;
begin
  if Length(l) = 0 then
    exit(0);

  Result := l[0];
  for var v in l do
    if v < result then
      Result := v;
end;

const
  n: array of Uint64 = [12757923, 12878611, 12757923, 15808973, 15780709, 197622519];

var
  m: BigInteger;
  len, j, i: Uint64;
  l: TArray<TArray<BigInteger>>;

begin
  j := 0;
  m := 0;
  len := length(n);
  SetLength(l, len);

  TParallel.for (0, len - 1,
    procedure(i: Integer)
    begin
      l[i] := getPrimes(n[i]);
    end);

  for i := 0 to len - 1 do
  begin
    var _min := Min(l[i]);
    if _min > m then
    begin
      m := _min;
      j := i;
    end;
  end;

  writeln('Number ', n[j].ToString, ' has largest minimal factor:');
  for var v in l[j] do
    write(' ', v.ToString);

  readln;
end.
