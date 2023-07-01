program N_smooth_numbers;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  System.Generics.Collections,
  Velthuis.BigIntegers;

var
  primes: TList<BigInteger>;
  smallPrimes: TList<Integer>;

function IsPrime(value: BigInteger): Boolean;
var
  v: BigInteger;
begin
  if value < 2 then
    exit(False);

  for v in [2, 3, 5, 7, 11, 13, 17, 19, 23] do
  begin
    if (value mod v) = 0 then
      exit(value = v);
  end;

  v := 29;

  while v * v < value do
  begin
    if (value mod v) = 0 then
      exit(False);
    inc(value, 2);
    if (value mod v) = 0 then
      exit(False);
    inc(v, 4);
  end;

  Result := True;
end;

function Min(values: TList<BigInteger>): BigInteger;
var
  value: BigInteger;
begin
  if values.Count = 0 then
    exit(0);

  Result := values[0];
  for value in values do
  begin
    if value < Result then
      result := value;
  end;
end;

function NSmooth(n, size: Integer): TList<BigInteger>;
var
  bn, p: BigInteger;
  ok: Boolean;
  i: Integer;
  next: TList<BigInteger>;
  indices: TList<Integer>;
  m: Integer;
begin
  Result := TList<BigInteger>.Create;
  if (n < 2) or (n > 521) then
    raise Exception.Create('Argument out of range: "n"');

  if (size < 1) then
    raise Exception.Create('Argument out of range: "size"');

  bn := n;
  ok := false;
  for p in primes do
  begin
    ok := bn = p;
    if ok then
      break;
  end;

  if not ok then
    raise Exception.Create('"n" must be a prime number');

  Result.Add(1);

  for i := 1 to size - 1 do
    Result.Add(0);

  next := TList<BigInteger>.Create;

  for p in primes do
  begin
    if p > bn then
      Break;
    next.Add(p);
  end;

  indices := TList<Integer>.Create;
  for i := 0 to next.Count - 1 do
    indices.Add(0);

  for m := 1 to size - 1 do
  begin
    Result[m] := Min(next);
    for i := 0 to indices.Count - 1 do
      if Result[m] = next[i] then
      begin
        indices[i] := indices[i] + 1;
        next[i] := primes[i] * Result[indices[i]];
      end;
  end;

  indices.Free;
  next.Free;
end;

procedure Init();
var
  i: BigInteger;
begin
  primes := TList<BigInteger>.Create;
  smallPrimes := TList<Integer>.Create;
  primes.Add(2);
  smallPrimes.Add(2);

  i := 3;
  while i <= 521 do
  begin
    if IsPrime(i) then
    begin

      primes.Add(i);
      if i <= 29 then
        smallPrimes.Add(Integer(i));
    end;
    inc(i, 2);
  end;

end;

procedure Println(values: TList<BigInteger>; CanFree: Boolean = False);
var
  value: BigInteger;
begin
  Write('[');
  for value in values do
    Write(value.ToString, ', ');
  Writeln(']'#10);

  if CanFree then
    values.Free;
end;

procedure Finish();
begin
  primes.Free;
  smallPrimes.Free;
end;

var
  p: Integer;
  ns: TList<BigInteger>;

const
  RANGE_3: array[0..2] of integer = (503, 509, 521);

begin
  Init;
  for p in smallPrimes do
  begin
    Writeln('The first ', p, '-smooth numbers are:');
    Println(NSmooth(p, 25), True);
  end;

  smallPrimes.Delete(0);
  for p in smallPrimes do
  begin
    Writeln('The 3,000 to 3,202 ', p, '-smooth numbers are:');
    ns := nSmooth(p, 3002);
    ns.DeleteRange(0, 2999);
    println(ns, True);
  end;

  for p in RANGE_3 do
  begin
    Writeln('The 3,000 to 3,019 ', p, '-smooth numbers are:');
    ns := nSmooth(p, 30019);
    ns.DeleteRange(0, 29999);
    println(ns, True);
  end;

  Finish;
  Readln;
end.
