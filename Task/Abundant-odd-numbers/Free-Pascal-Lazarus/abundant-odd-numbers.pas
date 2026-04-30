program AbundantOddNumbers;
{$IFDEF FPC}
   {$MODE DELPHI}{$OPTIMIZATION ON,ALL}{$CODEALIGN proc=16}{$ALIGN 16}
{$ELSE}
  {$APPTYPE CONSOLE}
{$ENDIF}
{geeksforgeeks
*    1100 = 2^2*5^2*11^1
    (2^0 + 2^1 + 2^2) * (5^0 + 5^1 + 5^2) * (11^0 + 11^1)
    (upto the power of factor in factorization i.e. power of 2 and 5 is 2 and 11 is 1.)
    = (1 + 2 + 2^2) * (1 + 5 + 5^2) * (1 + 11)
    = 7 * 31 * 12
    = 2604
    So, sum of all factors of 1100 = 2604 }
uses
  SysUtils;
var
  //all primes < 2^16=65536
  primes : array[0..6541] of Word;

procedure InitPrimes;
//sieve of erathotenes
var
  p : array[word] of byte;
  i,j : NativeInt;
Begin
  fillchar(p,SizeOf(p),#0);
  p[0] := 1;
  p[1] := 1;
  For i := 2 to high(p) do
    if p[i] = 0 then
    begin
      j := i*i;
      IF j>high(p) then
        BREAK;
      while j <= High(p) do
      begin
        p[j] := 1;
        inc(j,i);
      end;
    end;
  j := 0;
  For i := 2 to high(p) do
    IF p[i] = 0 then
    Begin
      primes[j] := i;
      inc(j);
    end;
end;

function PotToString(N: NativeUint):String;
var
  pN,pr,PowerPr,rest : NativeUint;
begin
  pN := 0; //starting at 2;
  Result := '';
  repeat
    pr := primes[pN];
    rest := N div pr;
    if rest < pr then
      BREAK;
    //same as N MOD PR = 0
    if rest*pr = N then
    begin
      result := result+IntToStr(pr);
      N := rest;
      rest := N div pr;
      PowerPr := 1;
      while rest*pr = N do
      begin
        inc(PowerPr);
        N := rest;
        rest := N div pr;
      end;
      if PowerPr > 1 then
        result := result+'^'+IntToStr(PowerPr);
      if N > 1 then
        result := result +'*';
    end;
    inc(pN);
  until pN > High(Primes);
  //is there a last prime factor of N
  if N <> 1 then
    result := result+IntToStr(N);
end;

function OutNum(N: NativeUint):string;
Begin
  result := Format('%10u= %s', [N,PotToString(N)]);
end;

function SumProperDivisors(N: NativeUint): NativeUint;
var
  pN,pr,PowerPr,SumOfPower,rest,N0 : NativeUint;
begin
  N0 := N;
  pN := 0; //starting at 2;
  Result := 1;
  repeat
    pr := primes[pN];
    rest := N div pr;
    if rest < pr then
      BREAK;
    //same as N MOD PR = 0
    if rest*pr = N then
    begin
//      IF pr=5 then break;
//      IF pr=7 then break;
      PowerPr := 1;
      SumOfPower:= 1;
      repeat
        PowerPr := PowerPr*pr;
        inc(SumOfPower,PowerPr);
        N := rest;
        rest := N div pr;
      until N <> rest*pr;
      result := result*SumOfPower;
    end;
    inc(pN);
  until pN > High(Primes);
  //is there a last prime factor of N
  if N <> 1 then
    result := result*(N+1);
  result := result-N0;
end;

var
  C, N,N0,k: Cardinal;
begin
  InitPrimes;

  k := High(k);
  N := 1;
  N0 := N;
  C := 0;
  while C < 25 do begin
    inc(N, 2);
    if N < SumProperDivisors(N) then begin
      Inc(C);
      WriteLn(Format('%5u: %s', [C,OutNum(N)]));
      IF k > N-N0 then
        k := N-N0;
      N0 := N;
    end;
  end;
  Writeln(' Min Delta ',k);
  writeln;

  while C < 1000 do begin
    Inc(N, 2);
    if N < SumProperDivisors(N) then
    Begin
      Inc(C);
      IF k > N-N0 then
        k := N-N0;
      N0 := N;
    end;
  end;
  WriteLn(' 1000: ',OutNum(N));
  Writeln(' Min Delta ',k);
  writeln;

  while C < 10000 do begin
    Inc(N, 2);
    if N < SumProperDivisors(N) then
    Begin
      Inc(C);
      IF k > N-N0 then
        k := N-N0;
      N0 := N;
    end;
  end;
  WriteLn('10000: ',OutNum(N));
  Writeln(' Min Delta ',k);

  N := 1000000001;
  while N >= SumProperDivisors(N) do
    Inc(N, 2);
  WriteLn('The first abundant odd number above one billion is: ',OutNum(N));
end.
