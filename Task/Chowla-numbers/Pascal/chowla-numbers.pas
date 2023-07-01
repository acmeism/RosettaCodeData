program Chowla_numbers;

{$IFDEF FPC}
  {$MODE Delphi}
{$ELSE}
  {$APPTYPE CONSOLE}
{$ENDIF}

uses
  SysUtils
  {$IFDEF FPC}
    ,StrUtils{for Numb2USA}
  {$ENDIF}
;


{$IFNDEF FPC}
function Numb2USA(const S: string): string;
var
  I, NA: Integer;
begin
  I := Length(S);
  Result := S;
  NA := 0;
  while (I > 0) do
  begin
    if ((Length(Result) - I + 1 - NA) mod 3 = 0) and (I <> 1) then
    begin
      Insert(',', Result, I);
      Inc(NA);
    end;
    Dec(I);
  end;
end;
{$ENDIF}

function Chowla(n: NativeUint): NativeUint;
var
  Divisor, Quotient: NativeUint;
begin
  result := 0;
  Divisor := 2;
  while sqr(Divisor) < n do
  begin
    Quotient := n div Divisor;
    if Quotient * Divisor = n then
      inc(result, Divisor + Quotient);
    inc(Divisor);
  end;
  if sqr(Divisor) = n then
    inc(result, Divisor);
end;

procedure Count10Primes(Limit: NativeUInt);
var
  n, i, cnt: integer;
begin
  writeln;
  writeln(' primes til |     count');
  i := 100;
  n := 2;
  cnt := 0;
  repeat
    repeat
      // Ord (true) = 1 ,Ord (false) = 0
      inc(cnt, ORD(chowla(n) = 0));
      inc(n);
    until n > i;
    writeln(Numb2USA(IntToStr(i)): 12, '|', Numb2USA(IntToStr(cnt)): 10);
    i := i * 10;
  until i > Limit;
end;

procedure CheckPerf;
var
  k, kk, p, cnt, limit: NativeInt;
begin
  writeln;
  writeln(' number that is perfect');
  cnt := 0;
  limit := 35000000;
  k := 2;
  kk := 3;
  repeat
    p := k * kk;
    if p > limit then
      BREAK;
    if chowla(p) = (p - 1) then
    begin
      writeln(Numb2USA(IntToStr(p)): 12);
      inc(cnt);
    end;
    k := kk + 1;
    inc(kk, k);
  until false;
end;

var
  I: integer;

begin
  for I := 2 to 37 do
    writeln('chowla(', I: 2, ') =', chowla(I): 3);
  Count10Primes(10 * 1000 * 1000);
  CheckPerf;
end.
