program NivenGaps;
{$IFDEF FPC}
  {$MODE DELPHI}
  {$OPTIMIZATION ON,ALL}
{$ELSE}
  {$APPTYPE DELPHI}
{$ENDIF}
uses
  sysutils,
  strutils;
const
  base = 10;
type
  tNum      = Uint64;
const
  cntbasedigits = ((trunc(ln(High(tNum))/ln(base))+1) DIV 8 +1) *8;
type
  tSumDigit = record
                sdDigits  : array[0..cntbasedigits-1] of byte;
                sdNumber,
                sdNivCount,
                sdSumDig  : tNum;
                sdIsNiven : boolean;
              end;
var
  MySumDig : tSumDigit;

procedure OutNivenGap(ln,num,delta:TNum);
Begin
  writeln(delta:3,Numb2USA(IntToStr(MySumDig.sdNivCount-1)):16,
          Numb2USA(IntToStr(ln)):17);
end;

function InitSumDigit( n : tNum):tSumDigit;
var
  sd : tSumDigit;
  qt : tNum;
  i  : NativeInt;
begin
  with sd do
  begin
    sdNumber:= n;
    fillchar(sdDigits,SizeOf(sdDigits),#0);
    sdSumDig :=0;
    sdIsNiven := false;
    i := 0;
    // calculate Digits und sum them up
    while n > 0 do
    begin
      qt := n div base;
      {n mod base}
      sdDigits[i] := n-qt*base;
      inc(sdSumDig,sdDigits[i]);
      n:= qt;
      inc(i);
    end;
    IF sdSumDig  >0 then
      sdIsNiven := (sdNumber MOD sdSumDig = 0);
    sdNivCount := Ord( sdIsNiven);
  end;
  InitSumDigit:=sd;
end;

procedure NextNiven(var sd:tSumDigit);
var
  Num,Sum : tNum;
  i,d,One: NativeUInt;
begin
  One := 1;// put it in a register :-)
  with sd do
  begin
    num := sdNumber;
    Sum := sdSumDig;
    repeat
      //inc sum of digits
      i := 0;
      num += One;
      repeat
        d := sdDigits[i]+One;
        Sum += One;
        //base-1 times the repeat is left here
        if d < base then
        begin
          sdDigits[i] := d;
          BREAK;
        end
        else
        begin
          sdDigits[i] := 0;
          i += One;
          dec(Sum,base);
        end;
      until i > high( sdDigits);
    until (Num MOD Sum) = 0;
    sdIsNiven :=  true;
    sdNumber := num;
    sdSumDig := Sum;
    inc(sdNivCount);
  end;
end;

procedure FindGaps;
var
  delta,LastNiven : TNum;
Begin
  writeln('Gap    Index of gap   Starting Niven');
  writeln('===   =============   ==============');

  LastNiven:= 1;
  MySumDig:=InitSumDigit(LastNiven);
  delta := 0;
  repeat
    NextNiven(MySumDig);
    with MySumDig do
    Begin
      IF delta < sdNumber-LastNiven then
      begin
        delta := sdNumber-LastNiven;
        OutNivenGap(LastNiven,sdNumber,delta);
      end;
      LastNiven:= sdNumber;
    end;
  until MySumDig.sdNumber > 20*1000*1000*1000;
end;

begin
  FindGaps;
end.
