program Cousin_primes;
//Free Pascal Compiler version 3.2.1 [2020/11/03] for x86_64fpc
{$IFDEF FPC}
  {$MODE DELPHI}
  {$Optimization ON,ALL}
{$ELSE}
  {$APPTYPE CONSOLE}
{$ENDIF}
const
  MAXNUMBER = 100*1000*1000;// > 3
  MAXLIMIT = (MAXNUMBER-1) DIV 2;

type
  tChkprimes = array of byte;//prime == 1 , nonprime == 0
  tPrimes = array of Uint32;

var
  primes :tPrimes; //here starting with 3
procedure OutCount(lmt,cnt:NativeInt);
Begin
  writeln(cnt,' cousin primes up to ',lmt);
end;

procedure InitPrimes;
var
  Chkprimes:tChkprimes;
//NativeUInt i DIV 2 is only SHR 1,otherwise extension to Int64
  i,j,CountOfPrimes : NativeUInt;
begin
  SetLength(Chkprimes,MAXLIMIT+1);
  fillchar(Chkprimes[0],length(Chkprimes),#1);
  //estimate count of primes
  CountOfPrimes := trunc(MAXNUMBER/(ln(MAXNUMBER)-1.08))+100;
  SetLength(primes,CountOfPrimes+1);

  //sieve of eratosthenes only odd numbers
  // i = 2*j+1
  Chkprimes[0] := 0;// 0 -> 2*0+1 = 1
  i := 1;
  repeat
    if Chkprimes[(i-1) DIV 2] <> 0 then
    Begin
      // convert i*i into j
      j := (i*i-1) DIV 2;
      if j> MAXLIMIT then
        break;
      repeat
        Chkprimes[j]:= 0;
        inc(j,i);
      until j> MAXLIMIT;
    end;
    inc(i,2);
  until false;

  j := 0;
  For i := 1 to MAXLIMIT do
    IF Chkprimes[i]<>0 then
    Begin
      primes[j] := 2*i+1;
      inc(j);
      if j>CountOfPrimes then
      Begin
        CountOfPrimes += 400;
        setlength(Primes,CountOfPrimes);
      end;
    end;
  setlength(primes,j);

  setlength(Chkprimes,0);
end;

var
  i,lmt,cnt,primeCount : NativeInt;
BEGIN
  InitPrimes;
  //only exception, that the index difference is greater 1
  write(primes[0]:3,':',primes[2]:3,' ');
  cnt := 1;
  lmt := 1000;
  For i := 1 to High(primes) do
  Begin
    if primes[i] >lmt then
      break;
    IF primes[i]-primes[i-1] = 4 then
    Begin
      write(primes[i-1]:3,':',primes[i]:3,' ');
      inc(cnt);
      If cnt MOD 6 = 0 then
        writeln;
    end;
  end;
  writeln;
  OutCount(lmt,cnt);

  writeln;
  cnt := 1;
  lmt *= 10;
  primeCount := High(primes);
  For i := 1 to primeCount do
  Begin
    if primes[i] >lmt then
    Begin
      OutCount(lmt,cnt);
      lmt *= 10;
    end;
    inc(cnt,ORD(primes[i]-primes[i-1] = 4));
  end;
  OutCount(MAXNUMBER,cnt);

  setlength(primes,0);
END.
