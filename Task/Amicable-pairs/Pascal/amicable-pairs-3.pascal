program AmicPair;
{find amicable pairs in a limited region 2..MAX
beware that >both< numbers must be smaller than MAX
there are 455 amicable pairs up to 524*1000*1000
correct up to
#437 460122410
}
//optimized for freepascal 2.6.4 32-Bit
{$IFDEF FPC}
   {$MODE DELPHI}
   {$OPTIMIZATION ON,peephole,cse,asmcse,regvar}
   {$CODEALIGN loop=1,proc=8}
{$ELSE}
  {$APPTYPE CONSOLE}
{$ENDIF}

uses
  sysutils;

type
  tValue = LongWord;
  tpValue = ^tValue;
  tDivSum = array[0..0] of tValue;// evil, but dynamic arrays are slower
  tpDivSum = ^tDivSum;
  tPower = array[0..31] of tValue;
  tIndex = record
             idxI,
             idxS : tValue;
           end;
var
  power,
  PowerFac     : tPower;
  ds           : array of tValue;
  Indices      : array[0..511] of tIndex;
  DivSumField  : tpDivSum;
  MAX : tValue;

procedure Init;
var
  i : LongInt;
begin
  DivSumField[0]:= 0;
  For i := 1 to MAX do
    DivSumField[i]:= 1;
end;

procedure ProperDivs(n: tValue);
//Only for output, normally a factorication would do
var
  su,so : string;
  i,q : tValue;
begin
  su:= '1';
  so:= '';
  i := 2;
  while i*i <= n do
  begin
    q := n div i;
    IF q*i -n = 0 then
    begin
      su:= su+','+IntToStr(i);
      IF q <> i then
        so:= ','+IntToStr(q)+so;
    end;
    inc(i);
  end;
  writeln('  [',su+so,']');
end;

procedure AmPairOutput(cnt:tValue);
var
  i : tValue;
  r : double;
begin
  r := 1.0;
  For i := 0 to cnt-1 do
  with Indices[i] do
  begin
    writeln(i+1:4,IdxI:12,IDxS:12,' ratio ',IdxS/IDxI:10:7);
    if r < IdxS/IDxI then
      r := IdxS/IDxI;
      IF cnt < 20 then
      begin
        ProperDivs(IdxI);
        ProperDivs(IdxS);
      end;
  end;
  writeln(' max ratio ',r:10:4);
end;

function Check:tValue;
var
  i,s,n : tValue;
begin
  n := 0;
  For i := 1 to MAX do
  begin
    //s = sum of proper divs (I)  == sum of divs (I) - I
    s := DivSumField^[i];
    IF (s <=MAX) AND (s>i) AND (DivSumField^[s]= i)then
    begin
      With indices[n] do
      begin
        idxI := i;
        idxS := s;
      end;
      inc(n);
    end;
  end;
  result := n;
end;

Procedure CalcPotfactor(prim:tValue);
//PowerFac[k] = (prim^(k+1)-1)/(prim-1) == Sum (i=0..k) prim^i
var
  k: tValue;
  Pot,       //== prim^k
  PFac : Int64;
begin
  Pot := prim;
  PFac := 1;
  For k := 0 to High(PowerFac) do
  begin
    PFac := PFac+Pot;
    IF (POT > MAX) then
      BREAK;
    PowerFac[k] := PFac;
    Pot := Pot*prim;
  end;
end;

procedure InitPW(prim:tValue);
begin
  fillchar(power,SizeOf(power),#0);
  CalcPotfactor(prim);
end;

function NextPotCnt(p: tValue):tValue;
//return the first power <> 0
//power == n to base prim
var
  i : tValue;
begin
  result := 0;
  repeat
    i := power[result];
    Inc(i);
    IF i < p then
      BREAK
    else
    begin
      i := 0;
      power[result]  := 0;
      inc(result);
    end;
  until false;
  power[result] := i;
end;

procedure Sieve(prim: tValue);
var
  actNumber,idx : tValue;
begin
  //sieve with "small" primes
  while prim*prim <= MAX do
  begin
    InitPW(prim);
    Begin
      //actNumber = actual number = n*prim
      actNumber := prim;
      idx := prim;
      while actNumber <= MAX do
      begin
        dec(idx);
        IF idx > 0 then
          DivSumField^[actNumber] *= PowerFac[0]
        else
        Begin
          DivSumField^[actNumber] *= PowerFac[NextPotCnt(prim)+1];
          idx := Prim;
        end;
        inc(actNumber,prim);
      end;
    end;
    //next prime
    repeat
      inc(prim);
    until DivSumField^[prim]= 1;//(DivSumField[prim] = 1);
  end;

  //sieve with "big" primes, only one factor is possible
  while 2*prim <= MAX do
  begin
    InitPW(prim);
    Begin
      actNumber := prim;
      idx := PowerFac[0];
      while actNumber <= MAX do
      begin
        DivSumField^[actNumber] *= idx;
        inc(actNumber,prim);
      end;
    end;
    repeat
      inc(prim);
    until DivSumField^[prim]= 1;
  end;

  For idx := 2 to MAX do
    dec(DivSumField^[idx],idx);
end;

var
  T2,T1,T0: TDatetime;
  APcnt: tValue;
  i: NativeInt;
begin
  MAX := 20000;
  IF  ParamCount > 0 then
    MAX := StrToInt(ParamStr(1));
  setlength(ds,MAX);
  DivSumField := @ds[0];
  T0:= time;
  For i := 1 to 1 do
  Begin
    Init;
    Sieve(2);
  end;
  T1:= time;

  APCnt := Check;
  T2:= time;
  AmPairOutput(APCnt);
  writeln(APCnt,' amicable pairs til ',MAX);
  writeln('Time to calc sum of divs    ',FormatDateTime('HH:NN:SS.ZZZ' ,T1-T0));
  writeln('Time to find amicable pairs ',FormatDateTime('HH:NN:SS.ZZZ' ,T2-T1));
  setlength(ds,0);
  {$IFNDEF UNIX}
    readln;
  {$ENDIF}
end.
