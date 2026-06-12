program PrimeTriplets;
//Free Pascal Compiler version 3.2.1 [2020/11/03] for x86_64fpc  3.2.1
{$IFDEF FPC}
  {$MODE DELPHI}
  {$Optimization ON,ALL}
{$ELSE}
  {$APPTYPE CONSOLE}
{$ENDIF}
const
  MAXZAHL = 100000;// > 3
  MAXSUM  = 3*MAXZAHL;

  CountOfPrimes = trunc(MAXZAHL/(ln(MAXZAHL)-1.08))+100;

type
  tChkprimes = array[0..MAXSUM] of byte;//prime == 1 , nonprime == 0
var
  Chkprimes:tChkprimes;
  primes : array[0..CountOfPrimes]of Uint32;//here starting with 3
  count,primeCount:NativeInt;

procedure InitPrimes;
//sieve of eratothenes
var
  i,j : NativeInt;
begin
  fillchar(Chkprimes,SizeOf(tChkprimes),#1);
  i := 2;
  j := 2*2;
  if j> MAXSUM then
      EXIT;
  repeat
    Chkprimes[j]:= 0;
    inc(j,i);
  until j> Maxsum;

  For i := 3 to MAXSUM do
  Begin
    if Chkprimes[i] <>0 then
    Begin
      j := i*i;
      if j> MAXSUM then
        Break;
      repeat
        Chkprimes[j]:= 0;
        inc(j,2*i);
      until j> Maxsum;
    end;
  end;

  j := 0;
  For i := 3 to MAXZAHL do
    IF Chkprimes[i]<>0 then
    Begin
      primes[j] := i;
      inc(j);
    end;
  primeCount := j-1;
  j :=CountOfPrimes -primeCount;

  IF j <0 then
  begin
    writeln(' Need more space for primes ', -j);
    HALT(-243);
  end;
end;

function GetMaxPrimeIdx(lmt:NativeInt):NativeInt;
begin
  if lmt >= Maxzahl then
  Begin
    result := primecount;
    EXIT;
  end;

  result := 0;
  while (result < primecount) AND (primes[result]<lmt) do
    inc(result);
  dec(result);
end;

procedure Out_Check(lmt:nativeInt);
//simplest version
var
  i,j,k,s,pc:   NativeInt;
Begin
  pc:= GetMaxPrimeIdx(lmt);
  count := 0;
  For i := 0 to pc do
    For j := i+1 to pc do
      For k := j+1 to pc do
      Begin
        s := primes[i]+primes[j]+Primes[k];
        //if takes the longest time
        if ChkPrimes[s]<> 0 then
        begin
          inc(count);
          writeln(count:3,': ',primes[i],'+',primes[j],'+',primes[k],' = ',s);
        end;
      end;
  writeln;
end;

procedure Count_Check(pc:nativeInt);
// the power of many registers ( 64-Bit )
var
  cnt : Uint64;
  pPrimes : pUint32;
  pChkPrimes : ^tChkprimes;
  pi,pij,i,j,k:   NativeInt;
Begin
  cnt := 0;
  pPrimes := @primes[0];
  pChkPrimes := @Chkprimes[0];
  For i := 0 to pc do
  Begin
    pi := pPrimes[i];
    For j := i+1 to pc do
    begin
      pij := pi+pPrimes[j];
      For k := j+1 to pc do
        inc(cnt,pChkPrimes^[pij+pPrimes[k]]);
    end;
  end;
  count := cnt;
end;

procedure Check_Limit(lmt:NativeInt);
Begin
  If lmt>primes[primecount] then
    lmt := MaxZahl;
  write('Limit = ',lmt,' count: ');
  Count_Check(GetMaxPrimeIdx(lmt));
  writeln(count);
end;

BEGIN
  InitPrimes;
  Out_Check(30);
  Check_Limit(100);
  Check_Limit(1000);
  Check_Limit(10000);
//Check_Limit(MAXZAHL);
END.
