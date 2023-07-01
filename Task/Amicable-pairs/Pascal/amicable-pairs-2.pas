program AmicablePairs;
{$IFDEF FPC}
   {$MODE DELPHI}
   {$H+}
{$ELSE}
  {$APPTYPE CONSOLE}
{$ENDIF}
uses
  sysutils;
const
  MAX = 20000;
//MAX = 20*1000*1000;
type
  tValue = LongWord;
  tpValue = ^tValue;
  tPower = array[0..31] of tValue;
  tIndex = record
             idxI,
             idxS : Uint64;
           end;

var
  Indices      : array[0..511] of tIndex;
  //primes up to 65536 enough until 2^32
  primes       : array[0..6542] of tValue;

procedure InitPrimes;
// sieve of erathosthenes without multiples of 2
type
  tSieve = array[0..(65536-1) div 2] of ansichar;
var
  ESieve : ^tSieve;
  idx,i,j,p : LongINt;
Begin
  new(ESieve);
  fillchar(ESieve^[0],SizeOF(tSieve),#1);
  primes[0] := 2;
  idx := 1;

  //sieving
  j := 1;
  p := 2*j+1;
  repeat
    if Esieve^[j] = #1 then
    begin
      i := (2*j+2)*j;// i := (sqr(p) -1) div 2;
      if i > High(tSieve) then
        BREAK;
      repeat
        ESIeve^[i] := #0;
        inc(i,p);
      until i > High(tSieve);
    end;
    inc(j);
    inc(p,2);
  until j >High(tSieve);

  //collecting
  For i := 1 to High(tSieve) do
    IF Esieve^[i] = #1 then
    Begin
      primes[idx] := 2*i+1;
      inc(idx);
      IF idx>High(primes) then
        BREAK;
    end;
  dispose(Esieve);
end;

procedure Su_append(n,factor:tValue;var su:string);
var
  q,p : tValue;
begin
  p := 0;
  repeat
    q := n div factor;
    IF q*factor<>n then
      Break;
    inc(p);
    n := q;
  until false;
  IF p > 0 then
    IF p= 1 then
      su:= su+IntToStr(factor)+'*'
    else
      su:= su+IntToStr(factor)+'^'+IntToStr(p)+'*';
end;

procedure ProperDivs(n: Uint64);
//output of prime factorization
var
  su : string;
  primNo : tValue;
  p:tValue;

begin
  str(n:8,su);
  su:= su +' [';
  primNo := 0;
  p := primes[0];
  repeat
    Su_Append(n,p,su);
    inc(primNo);
    p := primes[primNo];
  until (p=0) OR (p*p >= n);
  p := n;
  Su_Append(n,p,su);
  su[length(su)] := ']';
  writeln(su);
end;

procedure AmPairOutput(cnt:tValue);
var
  i : tValue;
  r_max,r_min,r : double;
begin
  r_max := 1.0;
  r_min := 16.0;
  For i := 0 to cnt-1 do
    with Indices[i] do
    begin
      r := IdxS/IDxI;
      writeln(i+1:4,IdxI:16,IDxS:16,' ratio ',r:10:7);
      IF r < 1 then
      begin
        writeln(i);
        readln;
        halt;
      end;
      if r_max < r then
        r_max := r
      else
        if r_min > r then
          r_min := r;
    IF cnt < 20 then
      begin
        ProperDivs(IdxI);
        ProperDivs(IdxS);
      end;
    end;
  writeln(' min ratio ',r_min:12:10);  writeln(' max ratio ',r_max:12:10);
end;

procedure SumOFProperDiv(n: tValue;var SumOfProperDivs:tValue);
// calculated by prime factorization
var
  i,q, primNo, Prime,pot : tValue;
  SumOfDivs: tValue;
begin
  i := N;
  SumOfDivs := 1;
  primNo := 0;
  Prime := Primes[0];
  q := i DIV Prime;
  repeat
    if q*Prime = i then
    Begin
      pot := 1;
      repeat
        i := q;
        q := i div Prime;
        Pot := Pot * Prime+1;
      until q*Prime <> i;
      SumOfDivs := SumOfDivs * pot;
    end;
    Inc(primNo);
    Prime := Primes[primNo];
    q := i DIV Prime;

    {check if i already prime}
    if Prime > q then
    begin
      prime := i;
      q := 1;
    end;
  until i = 1;
  SumOfProperDivs := SumOfDivs - N;
end;

function Check:tValue;
const
  //going backwards
  DIV23 : array[0..5] of byte =
           //== 5,4,3,2,1,0
               (1,0,0,0,1,0);

var
  i,s,k,n : tValue;
  idx : nativeInt;
begin
  n := 0;
  idx := 3;
  For i := 2 to MAX do
  begin
    //must be divisble by 2 or 3 ( n < High(tValue) < 1e14 )
    IF DIV23[idx] = 0 then
    begin
      SumOFProperDiv(i,s);
      //only 24.7...%
      IF s>i then
      Begin
        SumOFProperDiv(s,k);
        IF k = i then
        begin
          With indices[n] do
          begin
            idxI := i;
            idxS := s;
          end;
          inc(n);
        end;
      end;
    end;
    dec(idx);
    IF idx < 0 then
      idx := high(DIV23);
  end;
  result := n;
end;

var
  T2,T1: TDatetime;
  APcnt: tValue;
begin
  InitPrimes;
  T1:= time;
  APCnt:= Check;
  T2:= time;
  AmPairOutput(APCnt);
  writeln('Time to find amicable pairs ',FormatDateTime('HH:NN:SS.ZZZ' ,T2-T1));
  {$IFNDEF UNIX} readln;{$ENDIF}
end.
