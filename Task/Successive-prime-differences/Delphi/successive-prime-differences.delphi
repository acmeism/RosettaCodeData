program Successive_prime_differences;


{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Generics.Collections;

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

function Primes(const limit: UInt64): TArray<UInt64>;
var
  i: UInt64;

  procedure Add(const value: UInt64);
  begin
    SetLength(result, Length(result) + 1);
    Result[Length(result) - 1] := value;
  end;

begin
  if limit < 2 then
    exit;

  // 2 is the only even prime
  Add(2);

  i := 3;
  while i <= limit do
  begin
    if IsPrime(i) then
      Add(i);
    inc(i, 2);
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

function CheckScan(index: Integer; p: TArray<UInt64>; pattern: array of Integer): Boolean;
var
  i, last: Integer;
begin
  last := Length(pattern) - 1;
  for i := 0 to last do
    if p[index - last + i - 1] + pattern[i] <> p[index - last + i] then
      exit(False);
  Result := True;
end;

const
  GroupLabel: array[1..6] of string = ('(2)', '(1)', '(2, 2)', '(2, 4)',
    '(4, 2)', '(6, 4, 2)');

var
  limit, start: UInt64;
  c: TArray<UInt64>;
  i, j: UInt64;
  Group: array[1..6] of Tlist<string>;

begin
  for i := 1 to 6 do
    Group[i] := Tlist<string>.Create;

  limit := Trunc(1e6 - 1);
  c := Primes(limit);

  for j := 1 to High(c) do
  begin
    if CheckScan(j, c, [2]) then
      Group[1].Add(format('(%d,%d)', [c[j - 1], c[j]]));

    if CheckScan(j, c, [1]) then
      Group[2].Add(format('(%d,%d)', [c[j - 1], c[j]]));

    if j > 1 then
    begin
      if CheckScan(j, c, [2, 2]) then
        Group[3].Add(format('(%d,%d,%d)', [c[j - 2], c[j - 1], c[j]]));

      if CheckScan(j, c, [2, 4]) then
        Group[4].Add(format('(%d,%d,%d)', [c[j - 2], c[j - 1], c[j]]));

      if CheckScan(j, c, [4, 2]) then
        Group[5].Add(format('(%d,%d,%d)', [c[j - 2], c[j - 1], c[j]]));
    end;

    if j > 2 then
      if CheckScan(j, c, [6, 4, 2]) then
        Group[6].Add(format('(%d,%d,%d,%d)', [c[j - 3], c[j - 2], c[j - 1], c[j]]));

  end;

  for i := 1 to 6 do
  begin
    Write(GroupLabel[i], ': first group = ', Group[i].First);
    Writeln(', last group = ', Group[i].last, ', count = ', Group[i].Count);
    Group[i].free;
  end;

  readln;
end.
