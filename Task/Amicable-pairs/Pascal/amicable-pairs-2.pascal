program AmicablePairs;
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
const
//MAX = 20000;
{$IFDEF UNIX} MAX = 524*1000*1000;{$ELSE}MAX = 499*1000*1000;{$ENDIF}
type
  tValue = LongWord;
  tpValue = ^tValue;
  tPower = array[0..31] of tValue;
  tIndex = record
             idxI,
             idxS : tValue;
           end;
  tdpa   = array[0..2] of LongWord;
var
  power        : tPower;
  PowerFac     : tPower;
  DivSumField  : array[0..MAX] of tValue;
  Indices      : array[0..511] of tIndex;
  DpaCnt       : tdpa;

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
  fillchar(DpaCnt,SizeOf(dpaCnt),#0);
  n := 0;
  For i := 1 to MAX do
  begin
    //s = sum of proper divs (I)  == sum of divs (I) - I
    s := DivSumField[i]-i;
    IF (s <=MAX) AND (s>i) then
    begin
      IF DivSumField[s]-s = i then
      begin
        With indices[n] do
        begin
          idxI := i;
          idxS := s;
        end;
        inc(n);
      end;
    end;
    inc(DpaCnt[Ord(s>=i)-Ord(s<=i)+1]);
  end;
  result := n;
end;

Procedure CalcPotfactor(prim:tValue);
//PowerFac[k] = (prim^(k+1)-1)/(prim-1) == Sum (i=1..k) prim^i
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

function NextPotCnt(p: tValue):tValue;inline;
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

function Sieve(prim: tValue):tValue;
//simple version
var
  actNumber : tValue;
begin
  while prim <= MAX do
  begin
    InitPW(prim);
    //actNumber = actual number = n*prim
    //power == n to base prim
    actNumber := prim;
    while actNumber < MAX do
    begin
      DivSumField[actNumber] := DivSumField[actNumber] *PowerFac[NextPotCnt(prim)];
      inc(actNumber,prim);
    end;
    //next prime
    repeat
      inc(prim);
    until (DivSumField[prim] = 1);
  end;
  result := prim;
end;

var
  T2,T1,T0: TDatetime;
  APcnt: tValue;

begin
  T0:= time;
  Init;
  Sieve(2);
  T1:= time;
  APCnt := Check;
  T2:= time;
  AmPairOutput(APCnt);
  writeln(DpaCnt[0]:10,' deficient');
  writeln(DpaCnt[1]:10,' perfect');
  writeln(DpaCnt[2]:10,' abundant');
  writeln(DpaCnt[2]/DpaCnt[0]:14:10,' ratio abundant/deficient ');
  writeln('Time to calc sum of divs    ',FormatDateTime('HH:NN:SS.ZZZ' ,T1-T0));
  writeln('Time to find amicable pairs ',FormatDateTime('HH:NN:SS.ZZZ' ,T2-T1));
  {$IFNDEF UNIX}
    readln;
  {$ENDIF}
end.
