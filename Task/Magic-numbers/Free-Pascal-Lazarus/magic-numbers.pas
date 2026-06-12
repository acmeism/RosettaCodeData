program MagicNUmbers;
{$IFDEF FPC}{$MODE DELPHI}{$Optimization ON,All}{$ENDIF}
{$IFDEF Windows}{$APPTYPE CONSOLE}{$ENDIF}
uses
  sysutils;// TDatetime
const
  CntMagicNUmbers = 2492;
var
  MagicNumbs : array[0..CntMagicNUmbers] of Uint64;
  MagicCnt : Int32;
function checkpanX_9(MinDigit : Int32):UInt64;
var
  n,q : Uint64;
  idx: Uint32;
  testDigits,
  AllDigits : set of 0..9;
begin
  AllDigits := [];
  For idx := 9 downto MinDigit do
    include(AllDigits,idx);
  For idx := 1 to MagicCnt do
  begin
    n := MagicNumbs[idx];
    testDigits := [];
    repeat
      q := n DIV 10;
      include(TestDigits,n-10*q);
      n:= q;
    until q = 0;
    if TestDigits = AllDigits then
      EXIT(MagicNumbs[idx]);
  end;
end;

function ExtendMagic(dgtcnt:Int32):Boolean;
var
  newMg : Uint64;
  i,j,k : Int32;
begin
  i := 1;
  j := CntMagicNUmbers-MagicCnt+1;
  Move(MagicNumbs[i],MagicNumbs[j],SizeOf(MagicNumbs[0])*MagicCnt);
  if dgtcnt = 2 then //Jump over zero
    inc(j);
  repeat
    newMg := MagicNumbs[j]*10;
    k := newMg MOD dgtcnt;
    IF k > 0 then
      k := dgtCnt-k;
    newMg += k;
    while k in [0..9] do
    Begin
      MagicNumbs[i] := newMg;
      k += dgtCnt;
      newMg +=dgtcnt;
      inc(i);
    end;
    inc(j);
  until j > CntMagicNUmbers;
  MagicCnt := i-1;
  result := true;
end;

var
 PAN1_9,PAN0_9: Int64;
 i,sum : Int32;
Begin
  MagicNumbs[1] := 0;
  MagicCnt := 0;
  sum := 0;
  writeln('Magic number counts by number of digits and max value: ');
  For i := 1 to 18 do
  begin
    ExtendMagic(i);
    IF i = 9 then
      PAN1_9 := checkpanX_9(1);
    IF i = 10 then
      PAN0_9 :=  checkpanX_9(0);
    inc(sum,MagicCnt);
    writeln(i:4,MagicCnt:10,MagicNumbs[MagicCnt]:19);
  end;
  Writeln(' Sum of MagicCnt: ',sum);
  Writeln(' Pandigital number with 1..9: ', PAN1_9);
  Writeln(' Pandigital number with 0..9: ', PAN0_9);
end.
