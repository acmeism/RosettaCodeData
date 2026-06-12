program practicalnumbers;
{$IFDEF FPC}
  {$MODE DELPHI}{$OPTIMIZATION ON,ALL}
{$ELSE}
  {$APPTYPE CONSOLE}

{$ENDIF}

uses
  sysutils
{$IFNDEF FPC}
    ,Windows
{$ENDIF}
  ;

const
  LOW_DIVS = 0;
  HIGH_DIVS = 2048 - 1;

type
  tdivs = record
    DivsVal: array[LOW_DIVS..HIGH_DIVS] of Uint32;
    DivsMaxIdx, DivsNum, DivsSumProp: NativeUInt;
  end;

var
  Divs: tDivs;
  HasSum: array of byte;

procedure GetDivisors(var Divs: tdivs; n: Uint32);
//calc all divisors,keep sorted
var
  i, quot, ug, og: UInt32;
  sum: UInt64;
begin
  with Divs do
  begin
    DivsNum := n;
    sum := 0;
    ug := 0;
    og := HIGH_DIVS;
    i := 1;

    while i * i < n do
    begin
      quot := n div i;
      if n - quot * i = 0 then
      begin
        DivsVal[og] := quot;
        Divs.DivsVal[ug] := i;
        inc(sum, quot + i);
        dec(og);
        inc(ug);
      end;
      inc(i);
    end;
    if i * i = n then
    begin
      DivsVal[og] := i;
      inc(sum, i);
      dec(og);
    end;
  //move higher divisors down
    while og < high_DIVS do
    begin
      inc(og);
      DivsVal[ug] := DivsVal[og];
      inc(ug);
    end;
    DivsMaxIdx := ug - 2;
    DivsSumProp := sum - n;
  end; //with
end;

function SumAllSetsForPractical(Limit: Uint32): boolean;
//mark sum and than shift by next divisor == add
//for practical numbers every sum must be marked
var
  hs0, hs1: pByte;
  idx, j, loLimit, maxlimit, delta: NativeUint;
begin
  Limit := trunc(Limit * (Limit / Divs.DivsSumProp));
  loLimit := 0;
  maxlimit := 0;
  hs0 := @HasSum[0];
  hs0[0] := 1; //empty set
  for idx := 0 to Divs.DivsMaxIdx do
  begin
    delta := Divs.DivsVal[idx];
    hs1 := @hs0[delta];
    for j := maxlimit downto 0 do
      hs1[j] := hs1[j] or hs0[j];
    maxlimit := maxlimit + delta;
    while hs0[loLimit] <> 0 do
      inc(loLimit);
    //IF there is a 0 < delta, it will never be set
    //IF there are more than the Limit set,
    //it will be copied by the following Delta's
    if (loLimit < delta) or (loLimit > Limit) then
      Break;
  end;
  result := (loLimit > Limit);
end;

function isPractical(n: Uint32): boolean;
var
  i: NativeInt;
  sum: NativeUInt;
begin
  if n = 1 then
    EXIT(True);
  if ODD(n) then
    EXIT(false);
  if (n > 2) and not ((n mod 4 = 0) or (n mod 6 = 0)) then
    EXIT(false);

  GetDivisors(Divs, n);
  i := n - 1;
  sum := Divs.DivsSumProp;
  if sum < i then
    result := false
  else
  begin
    if length(HasSum) > sum + 1 + 1 then
      FillChar(HasSum[0], sum + 1, #0)
    else
    begin
      setlength(HasSum, 0);
      setlength(HasSum, sum + 8 + 1);
    end;
    result := SumAllSetsForPractical(i);
  end;
end;

procedure OutIsPractical(n: nativeInt);
begin
  if isPractical(n) then
    writeln(n, ' is practical')
  else
    writeln(n, ' is not practical');
end;

const
  ColCnt = 10;
  MAX = 333;

var
  T0: Int64;
  n, col, count: NativeInt;

begin
  col := ColCnt;
  count := 0;
  for n := 1 to MAX do
    if isPractical(n) then
    begin
      write(n: 5);
      inc(count);
      dec(col);
      if col = 0 then
      begin
        writeln;
        col := ColCnt;
      end;
    end;
  writeln;
  writeln('There are ', count, ' pratical numbers from 1 to ', MAX);
  writeln;

  T0 := GetTickCount64;
  OutIsPractical(666);
  OutIsPractical(6666);
  OutIsPractical(66666);
  OutIsPractical(954432);
  OutIsPractical(720);
  OutIsPractical(5384);
  OutIsPractical(1441440);
  writeln(Divs.DivsNum, ' has ', Divs.DivsMaxIdx + 1, ' proper divisors');
  writeln((GetTickCount64 - T0) / 1000: 10: 3, ' s');
  T0 := GetTickCount64;
  OutIsPractical(99998640);
  writeln(Divs.DivsNum, ' has ', Divs.DivsMaxIdx + 1, ' proper divisors ');
  writeln((GetTickCount64 - T0) / 1000: 10: 3, ' s');
  T0 := GetTickCount64;
  OutIsPractical(99998640);
  writeln(Divs.DivsNum, ' has ', Divs.DivsMaxIdx + 1, ' proper divisors ');
  writeln((GetTickCount64 - T0) / 1000: 10: 3, ' s');
  setlength(HasSum, 0);
  {$IFNDEF UNIX}  readln; {$ENDIF}
end.
