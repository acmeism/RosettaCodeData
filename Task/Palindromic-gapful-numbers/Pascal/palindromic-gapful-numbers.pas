program PalinGap;
{$IFDEF FPC}
   {$MODE DELPHI}{$OPTIMIZATION ON,ALL}{$CODEALIGN proc=16}{$ALIGN 16}
{$ELSE}
  {$APPTYPE CONSOLE}
{$ENDIF}
//example 5 digits, digit d
//  d000d
// +00100 10 -times delta[0] aka middle digit
//->d010d d020d d030d d040d d050d d060d d070d d080d d090d and
//  d100d -> not palindromatic
//correct by -10x00100 and use the next delta for the next digitplaces
//  d000d
//+ 01010 -> delta[1]
//  d101d
// starting over again with delta[0] until delta[1] is used 10 times
type
  tLimits = record
              LoLmt,HiLmt:Uint64;
            end;
const
  base = 10;

var
  delta    : Array[0..9] of Uint64;
  deltaBase: Array[0..9] of Uint64;
  deltaMod : Array[0..9] of Uint32;
  deltaModBase : Array[0..9] of Uint32;

  IdxCnt : Array[0..9] of Uint32;
  ModSum : UInt64;
  dgtMod : UInt32;

procedure InitDelta(dgt:Byte;dgtCnt:Byte);
var
  n : Uint64;
  i,k,mid : NativeInt;
Begin
  mid := (dgtCnt-1) DIV 2;
  //create Add masks
  For i := 0 to mid do
  Begin
    IF ODD(dgtCnt) then
//first 1,101,10001,1000001,100000001,10000000001
    Begin
      n := 1;
      IF i> 0 then
      Begin
        For k := 1 to i do
          n := n*(Base*Base);
        inc(n);
      end
    end
    Else //even
//  first 11,1001,100001,10000001...
    Begin
      n := Base;
      For k := 1 to i do
        n := n*(Base*Base);
      inc(n);
    end;
//  second move to the right place
//  1000000,10100000,10001000,10000010,100000001
    dgtMod := (dgt*(Base+1));
    For k := mid-1 DOWNTO i do
      n := n*Base;

    delta[i] := n;
    deltaMod[i]:= n MOD dgtMod;
    deltaBase[i] := base*n;
    deltaModBase[i]:= (base*n) MOD dgtMod;
  end;
  //counter for digit position
  For k := 0 to 9 do
    IdxCnt[k] := Base;
end;

function NextPalin(n : Uint64;dgtcnt:NativeInt):Uint64;inline;
var
  k,b: NativeInt;
begin
  k := 0;
  repeat
    n := n+delta[k];
    inc(ModSum,deltaMod[k]);
    b := IdxCnt[k]-1;
    IdxCnt[k]:= b;
    IF b <> 0 then
      break
    else
    Begin
      n := n-deltaBase[k];
      dec(ModSum,deltaModBase[k]);
      IdxCnt[k]:= Base;
      inc(k);
      IF k = dgtCnt then
      Begin
        n := 0;
        BREAK;
      end;
    end;
  until false;
  NextPalin  := n;
end;

procedure OutPalinGap(lowLmt,HiLmt,dgt:NativeInt);
var
  n : Uint64;
  i,dgtcnt,mid :NativeInt;
begin
  i:=1;
  write(dgt,' :');
  For dgtcnt := 3 to 20 do
  Begin
    mid := (dgtcnt-1) shr 1;
    initDelta(dgt,dgtcnt);
    n := dgt*delta[mid];// '10...01' -> 'd0...0d'
    ModSum := n MOD dgtMod;

    while (n <>0) AND (i< LowLmt) do
    Begin
      IF (ModSum MOD dgtMod) = 0 then
      Begin
        inc(i);
        ModSum :=0;//reduce Modsum
      end;
      n := NextPalin(n,mid);
    end;

    while (n <>0) AND (i<= HiLmt) do
    Begin
      IF (ModSum MOD dgtMod) = 0 then
      Begin
        inc(i);
        write(n:dgtcnt+1);
        ModSum :=0;//reduce Modsum
      end;
      n := NextPalin(n,mid);
    end;
    IF (i > HiLmt) then
      BREAK;
  end;
  writeln;
end;

var
  dgt : NativeInt;
begin
  writeln('palindromic gapful numbers from 1 to 20');
  For dgt := 1 to 9 do
    OutPalinGap(1,20,dgt);
  writeln;
  writeln('palindromic gapful numbers from 86 to 100');
  For dgt := 1 to 9 do
    OutPalinGap(86,100,dgt);
  writeln;
  writeln('palindromic gapful numbers from 991 to 1000');
  For dgt := 1 to 9 do
    OutPalinGap(991,1000,dgt);
  writeln;
  writeln('palindromic gapful number    100,000');
  For dgt := 1 to 9 do
    OutPalinGap(100000,100000,dgt);
  writeln;
  writeln('palindromic gapful number  1,000,000');
  For dgt := 1 to 9 do
    OutPalinGap(1000000,1000000,dgt);
  writeln;
  writeln('palindromic gapful number  10,000,000');
  For dgt := 1 to 9 do
    OutPalinGap(10000000,10000000,dgt);
  writeln;
end.
