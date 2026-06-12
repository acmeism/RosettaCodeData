program NumNdivSumEqualdivSumNextN;
//modified https://rosettacode.org/wiki/Factors_of_an_integer#using_Prime_decomposition
{$IFDEF FPC}
  {$MODE DELPHI}  {$OPTIMIZATION ON,ALL}  {$COPERATORS ON}
{$ELSE}
  {$APPTYPE CONSOLE}
{$ENDIF}
uses
  sysutils
{$IFDEF WINDOWS},Windows{$ENDIF}
  ;
const
  cMaxVALUE = 1000*1000;
type
  tPrimes = array[0..6541] of Uint32;
  tDgtSum = array of UInt32;
  tpDgtSum = pUInt32;
var
  SmallPrimes: tPrimes;

procedure InitSmallPrimes;
//get primes. #0..65535.Sieving only odd numbers
const
  MAXLIMIT = (65536-1) shr 1;
var
  Eratos : array[0..MAXLIMIT] of byte;
  pEratos : pByte;
  p,j,d,flipflop :NativeUInt;
Begin
  fillchar(Eratos[0],SizeOf(Eratos),#0);
  pEratos := @Eratos[0];
  p := 0;
  repeat
    repeat
      p +=1
    until pEratos[p]= 0;
    j := (p+1)*p*2;
    if j>MAXLIMIT then
      BREAK;
    d := 2*p+1;
    repeat
      pEratos[j] := 1;
      j += d;
    until j>MAXLIMIT;
  until false;

  SmallPrimes[0] := 2;
  SmallPrimes[1] := 3;
  SmallPrimes[2] := 5;
  j := 3;
  d := 7;
  flipflop := (2+1)-1;//7+2*2,11+2*1,13,17,19,23
  p := 3;
  repeat
    if pEratos[p] = 0 then
    begin
      SmallPrimes[j] := d;
      inc(j);
    end;
    d += 2*flipflop;
    p+=flipflop;
    flipflop := 3-flipflop;
  until (p > MAXLIMIT) OR (j>High(SmallPrimes));
end;

procedure GenSumOfDivSieve(MaxLmt:UInt32;var DgtSum:tDgtSum);
var
  i,j : UInt32;
  pDgtSum : tpDgtSum;
Begin
  setlength(DgtSum,MaxLmt);
  pDgtSum :=@DgtSum[0];
  For i :=1 to MaxLmt do
    pDgtSum[i]:= i+1;
  For i := 2 to MaxLmt DIV 2 do
  begin
    j := i+i;
    repeat
      pDgtSum[j] += i;
      inc(j,i);
    until j>MaxLmt;
  end;
end;

function GetDivsSum(n:Uint64):Uint64;
var
  pr,i,fac,q :NativeUInt;
Begin
  result := 1;
  i := 0;
  while i < High(SmallPrimes) do
  begin
    pr := SmallPrimes[i];
    if n < pr*pr then
      BREAK;
    q := n DIV pr;
    if n = pr*q then
    Begin
      fac := pr;
      repeat
        n := q;
        q := n div pr;
        fac *= pr;
      until n <> pr*q;
      result *= (fac-1)DIV(pr-1);
    end;
    inc(i);
  end;
  if n > 1 then
    result *= n+1
end;

var
  DgtSum:tDgtSum;
  T0:Int64;
  n,LastDivCnt,ActDivCnt,cnt : NativeUInt;
Begin
  InitSmallPrimes;
  T0 := GetTickCount64;
  GenSumOfDivSieve(cMaxVALUE,DgtSum);
  writeln(#10,'Time used GenSumOfDivSieve ',GetTickCount64-T0:6);

  T0 := GetTickCount64;
  ActDivCnt := 0;//DgtSum[0]
  n := 1;
  cnt := 0;
  repeat
    LastDivCnt := ActDivCnt;
    ActDivCnt :=  GetDivsSum(n);
//    ActDivCnt :=  DgtSum[n];// takes nearly no time
    if ActDivCnt = LastDivCnt then
    Begin
      inc(cnt);
      write(n-1:8); if cnt and 7 = 0 then      Writeln;
    end;
    inc(n);
  until n > cMaxVALUE+1;
  writeln(#10,'Time used GetDivsSum(n)   ',GetTickCount64-T0:6);
  writeln(#10,'Found ',cnt,' out of ',cMaxVALUE);
end.
