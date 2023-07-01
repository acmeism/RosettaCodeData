program Sophie;
{ Find and count Sophie Germain primes }
{ uses unit mp_prime out of mparith of Wolfgang Ehrhardt
* http://wolfgang-ehrhardt.de/misc_en.html#mparith
  http://wolfgang-ehrhardt.de/mp_intro.html }
{$APPTYPE CONSOLE}
uses
 mp_prime,sysutils;
var
  pS0,pS1:TSieve;
procedure SafeOrNoSavePrimeOut(totCnt:NativeInt;CntSafe:boolean);
var
  cnt,pr,pSG,testPr : NativeUint;
begin
  prime_sieve_reset(pS0,1);
  prime_sieve_reset(pS1,1);
  cnt := 0;
// memorize prime of the sieve, because sometimes prime_sieve_next(pS1) is to far ahead.
  testPr := prime_sieve_next(pS1);
  IF CntSafe then
  Begin
    writeln('First ',totCnt,' safe primes');
    repeat
      pr := prime_sieve_next(pS0);
      pSG := 2*pr+1;
      while testPr< pSG do
        testPr := prime_sieve_next(pS1);
      if pSG = testPr then
      begin
        write(pSG,',');
        inc(cnt);
      end;
    until cnt >= totCnt
  end
  else
  Begin
    writeln('First ',totCnt,' unsafe primes');
    repeat
      pr := prime_sieve_next(pS0);
      pSG := (pr-1) DIV 2;
      while testPr< pSG do
        testPr := prime_sieve_next(pS1);
      if pSG <> testPr then
      begin
        write(pr,',');
        inc(cnt);
      end;
    until cnt >= totCnt;
  end;
  writeln(#8,#32);
end;

function CountSafePrimes(Limit:NativeInt):NativeUint;
var
  cnt,pr,pSG,testPr : NativeUint;
begin
  prime_sieve_reset(pS0,1);
  prime_sieve_reset(pS1,1);
  cnt := 0;
  testPr := 0;
  repeat
    pr := prime_sieve_next(pS0);
    pSG := 2*pr+1;
    while testPr< pSG do
      testPr := prime_sieve_next(pS1);
    if pSG = testPr then
      inc(cnt);
  until pSG >= Limit;
  CountSafePrimes := cnt;
end;

procedure CountSafePrimesOut(Limit:NativeUint);
Begin
  writeln('there are ',CountSafePrimes(limit),' safe primes out of ',
          primepi32(limit),' primes up to ',Limit);
end;

procedure CountUnSafePrimesOut(Limit:NativeUint);
var
  prCnt: NativeUint;
Begin
  prCnt := primepi32(limit);
  writeln('there are ',prCnt-CountSafePrimes(limit),' unsafe primes out of ',
          prCnt,' primes up to ',Limit);
end;

var
  T1,T0 : INt64;
begin
  T0 :=gettickcount64;
  prime_sieve_init(pS0,1);
  prime_sieve_init(pS1,1);
//Find and display (on one line) the first  35  safe primes.
  SafeOrNoSavePrimeOut(35,true);
//Find and display the  count  of the safe primes below  1,000,000.
  CountSafePrimesOut(1000*1000);
//Find and display the  count  of the safe primes below 10,000,000.
  CountSafePrimesOut(10*1000*1000);
//Find and display (on one line) the first  40  unsafe primes.
  SafeOrNoSavePrimeOut(40,false);
//Find and display the  count  of the unsafe primes below  1,000,000.
  CountUnSafePrimesOut(1000*1000);
//Find and display the  count  of the unsafe primes below 10,000,000.
  CountUnSafePrimesOut(10*1000*1000);
  writeln;
  CountSafePrimesOut(1000*1000*1000);
  T1 :=gettickcount64;
  writeln('runtime ',T1-T0,' ms');
end.
