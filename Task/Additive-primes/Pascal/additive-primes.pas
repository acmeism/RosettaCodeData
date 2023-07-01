program AdditivePrimes;
{$IFDEF FPC}
{$MODE DELPHI}{$CODEALIGN proc=16}
{$ELSE}
{$APPTYPE CONSOLE}
{$ENDIF}
{$DEFINE DO_OUTPUT}

uses
  sysutils;

const
  RANGE = 500; // 1000*1000;//
  MAX_OFFSET = 0; // 1000*1000*1000;//

type
  tNum = array [0 .. 15] of byte;

  tNumSum = record
    dgtNum, dgtSum: tNum;
    dgtLen, num: Uint32;
  end;

  tpNumSum = ^tNumSum;

function isPrime(n: Uint32): boolean;
const
  wheeldiff: array [0 .. 7] of Uint32 = (+6, +4, +2, +4, +2, +4, +6, +2);
var
  p: NativeUInt;
  flipflop: Int32;
begin
  if n < 64 then
    EXIT(n in [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47,
      53, 59, 61])
  else
  begin
    IF (n AND 1 = 0) OR (n mod 3 = 0) OR (n mod 5 = 0) then
      EXIT(false);
    result := true;
    p := 1;
    flipflop := 6;

    while result do
    Begin
      p := p + wheeldiff[flipflop];
      if p * p > n then
        BREAK;
      result := n mod p <> 0;
      flipflop := flipflop - 1;
      if flipflop < 0 then
        flipflop := 7;
    end
  end
end;

procedure IncNum(var NumSum: tNumSum; delta: Uint32);
const
  BASE = 10;
var
  carry, dg: Uint32;
  le: Int32;
Begin
  if delta = 0 then
    EXIT;
  le := 0;
  with NumSum do
  begin
    num := num + delta;
    repeat
      carry := delta div BASE;
      delta := delta - BASE * carry;
      dg := dgtNum[le] + delta;
      IF dg >= BASE then
      Begin
        dg := dg - BASE;
        inc(carry);
      end;
      dgtNum[le] := dg;
      inc(le);
      delta := carry;
    until carry = 0;
    if dgtLen < le then
      dgtLen := le;
    // correct sum of digits // le is >= 1
    delta := dgtSum[le];
    repeat
      dec(le);
      delta := delta + dgtNum[le];
      dgtSum[le] := delta;
    until le = 0;
  end;
end;

var
  NumSum: tNumSum;
  s: AnsiString;
  i, k, cnt, Nr: NativeUInt;
  ColWidth, MAXCOLUMNS, NextRowCnt: NativeUInt;

BEGIN
  ColWidth := Trunc(ln(MAX_OFFSET + RANGE) / ln(10)) + 2;
  MAXCOLUMNS := 80;
  NextRowCnt := MAXCOLUMNS DIV ColWidth;

  fillchar(NumSum, SizeOf(NumSum), #0);
  NumSum.dgtLen := 1;
  IncNum(NumSum, MAX_OFFSET);
  setlength(s, ColWidth);
  fillchar(s[1], ColWidth, ' ');
  // init string
  with NumSum do
  Begin
    For i := dgtLen - 1 downto 0 do
      s[ColWidth - i] := AnsiChar(dgtNum[i] + 48);
    // reset digits lenght to get the max changed digits since last update of string
    dgtLen := 0;
  end;
  cnt := 0;
  Nr := NextRowCnt;
  For i := 0 to RANGE do
    with NumSum do
    begin
      if isPrime(dgtSum[0]) then
        if isPrime(num) then
        Begin
          cnt := cnt + 1;
          dec(Nr);

          // correct changed digits in string s
          For k := dgtLen - 1 downto 0 do
            s[ColWidth - k] := AnsiChar(dgtNum[k] + 48);
          dgtLen := 0;
{$IFDEF DO_OUTPUT}
          write(s);
          if Nr = 0 then
          begin
            writeln;
            Nr := NextRowCnt;
          end;
{$ENDIF}
        end;
      IncNum(NumSum, 1);
    end;
  if Nr <> NextRowCnt then
    write(#10);
  writeln(cnt, ' additive primes found.');
END.
