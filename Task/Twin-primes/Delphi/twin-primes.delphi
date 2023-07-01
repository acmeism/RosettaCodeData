program Primes;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

function IsPrime(a: UInt64): Boolean;
var
  d: UInt64;
begin
  if (a < 2) then
    exit(False);

  if (a mod 2) = 0 then
    exit(a = 2);

  if (a mod 3) = 0 then
    exit(a = 3);

  d := 5;

  while (d * d <= a) do
  begin
    if (a mod d = 0) then
      Exit(false);
    inc(d, 2);

    if (a mod d = 0) then
      Exit(false);
    inc(d, 4);
  end;

  Result := True;
end;


function Sieve(limit: UInt64): TArray<Boolean>;
var
  p, p2, i: UInt64;
begin
  inc(limit);
  SetLength(Result, limit);
  FillChar(Result[2], sizeof(Boolean) * limit - 2, 0); // all false except 1,2
  FillChar(Result[0], sizeof(Boolean) * 2, 1); // 1,2 are true

  p := 3;
  while true do
  begin
    p2 := p * p;
    if p2 >= limit then
      break;

    i := p2;
    while i < limit do
    begin
      Result[i] := true;
      inc(i, 2 * p);
    end;

    while true do
    begin
      inc(p, 2);
      if not Result[p] then
        Break;
    end;
  end;
end;

function Commatize(const n: UInt64): string;
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
end;

var
  limit, start, twins: UInt64;
  c: TArray<Boolean>;
  i, j: UInt64;

begin

  c := Sieve(Trunc(1e9 - 1));
  limit := 10;
  start := 3;
  twins := 0;
  for i := 1 to 9 do
  begin
    j := start;
    while j < limit do
    begin
      if (not c[j]) and (not c[j - 2]) then
        inc(twins);
      inc(j, 2);
    end;
    Writeln(Format('Under %14s there are %10s pairs of twin primes.', [commatize
      (limit), commatize(twins)]));

    start := limit + 1;
    limit := 10 * limit;
  end;

  readln;

end.
