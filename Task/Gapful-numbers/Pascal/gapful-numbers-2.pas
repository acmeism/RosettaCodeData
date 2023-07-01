program gapful;
{$IFDEF FPC}
   {$MODE DELPHI}{$OPTIMIZATION ON,ALL}
{$ELSE}
  {$APPTYPE CONSOLE}
{$ENDIF}
uses
  sysutils,// IntToStr
  strUtils;// Numb2USA aka commatize

var
  LCMsHL : array of NativeInt;

function GCD(a, b: Int64): Int64;
var
  temp: Int64;
begin
  while b <> 0 do
  begin
    temp := b;
    b := a mod b;
    a := temp
  end;
  result := a
end;

function LCM(a, b: Int64): Int64;
begin
  LCM := (a DIV GCD(a,b)) * b;
end;

procedure InitLCM(Base:NativeInt);
var
  i : integer;
Begin
  For i := Base to (Base*Base-1) do
    LCMsHL[i] := LCM(i,Base);
end;

function CountGapFul(H_Digit,Base:NativeInt;PotBase:Uint64):Uint64;
//Counts gapfulnumbers [n*PotBase..(n+1)*PotBase -1] ala [100..199]
var
  EndDgt,Dgt : NativeInt;
  P,k,lmt,sum,dSum: UInt64;
begin
  P := PotBase*H_Digit;
  lmt := P+PotBase-1;
  Dgt := H_Digit*Base;
  sum := (PotBase-1) DIV dgt +1;
  For EndDgt := 1 to Base-1 do
  Begin
    inc(Dgt);
    //search start
    //first value divisible by dgt
    k := p-(p MOD dgt)+ dgt;
    //value divisible by dgt ending in the right digit
    while (k mod Base) <> EndDgt do
      inc(k,dgt);
    IF k> lmt then
      continue;
    //one found +1
    //count the occurences in (lmt-k)
    dSum := (lmt-k) DIV LCMsHL[dgt] +1;
    inc(sum,dSum);
    //writeln(dgt:5,k:21,dSum:21,Sum:21);
  end;
  //writeln(p:21,Sum:21);
  CountGapFul := sum;
end;

procedure Main(Base:NativeUInt);
var
  i : NativeUInt;
  pot,total,lmt: Uint64;//High(Uint64) = 2^64-1
Begin
  lmt := High(pot) DIV Base;
  pot := sqr(Base);//"100" in Base
  setlength(LCMsHL,pot);
  InitLCM(Base);
  total := 0;
  repeat
    IF pot > lmt then
      break;
    For i := 1 to Base-1 do //ala  100..199 ,200..299,300..399,..,900..999
      inc(total,CountGapFul(i,base,pot));
    pot *= Base;
    writeln('Total [',sqr(Base),'..',Numb2USA(IntToStr(pot)),'] : ',Numb2USA(IntToStr(total+1)));
  until false;
  setlength(LCMsHL,0);
end;

BEGIN
  Main(10);
  Main(100);
END.
