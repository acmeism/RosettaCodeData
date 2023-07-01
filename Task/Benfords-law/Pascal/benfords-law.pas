program fibFirstdigit;
{$IFDEF FPC}{$MODE Delphi}{$ELSE}{$APPTYPE CONSOLE}{$ENDIF}
uses
  sysutils;
type
  tDigitCount = array[0..9] of LongInt;
var
  s: Ansistring;
  dgtCnt,
  expectedCnt : tDigitCount;

procedure GetFirstDigitFibonacci(var dgtCnt:tDigitCount;n:LongInt=1000);
//summing up only the first 9 digits
//n = 1000 -> difference to first 9 digits complete fib < 100 == 2 digits
var
  a,b,c : LongWord;//about 9.6 decimals
Begin
  for a in dgtCnt do dgtCnt[a] := 0;
  a := 0;b := 1;
  while n > 0 do
  Begin
    c := a+b;
    //overflow? round and divide by base 10
    IF c < a then
      Begin a := (a+5) div 10;b := (b+5) div 10;c := a+b;end;
    a := b;b := c;
    s := IntToStr(a);inc(dgtCnt[Ord(s[1])-Ord('0')]);
    dec(n);
  end;
end;

procedure InitExpected(var dgtCnt:tDigitCount;n:LongInt=1000);
var
  i: integer;
begin
  for i := 1 to 9  do
    dgtCnt[i] := trunc(n*ln(1 + 1 / i)/ln(10));
end;

var
  reldiff: double;
  i,cnt: integer;
begin
  cnt := 1000;
  InitExpected(expectedCnt,cnt);
  GetFirstDigitFibonacci(dgtCnt,cnt);
  writeln('Digit  count  expected  rel diff');
  For i := 1 to 9 do
  Begin
    reldiff := 100*(expectedCnt[i]-dgtCnt[i])/expectedCnt[i];
    writeln(i:5,dgtCnt[i]:7,expectedCnt[i]:10,reldiff:10:5,' %');
  end;
end.
