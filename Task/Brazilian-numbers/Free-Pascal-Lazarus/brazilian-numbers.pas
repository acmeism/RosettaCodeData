program brazilianNumbers;

{$IFDEF FPC}
  {$MODE DELPHI}{$OPTIMIZATION ON,All}
  {$CODEALIGN proc=32,loop=4}
{$ELSE}
  {$APPTYPE CONSOLE}
{$ENDIF}
uses
  SysUtils;

const
  //Must not be a prime
  PrimeMarker = 0;
  SquareMarker = PrimeMarker + 1;
  //MAX =    110468;// 1E5 brazilian
  //MAX =   1084566;// 1E6 brazilian
  //MAX =  10708453;// 1E7 brazilian
  //MAX = 106091516;// 1E8 brazilian
  MAX = 1053421821;// 1E9 brazilian

var
  isprime: array of word;

  procedure MarkSmallestFactor;
  //sieve of erathotenes
  //but saving the smallest factor
  var
    i, j, lmt: NativeUint;
  begin
    lmt := High(isPrime);
    fillWord(isPrime[0], lmt + 1, PrimeMarker);
    //mark even numbers
    i := 2;
    j := i * i;
    isPrime[j] := SquareMarker;
    Inc(j, 2);
    while j <= lmt do
    begin
      isPrime[j] := 2;
      Inc(j, 2);
    end;
    //mark 3 but not 2
    i := 3;
    j := i * i;
    isPrime[j] := SquareMarker;
    Inc(j, 6);
    while j <= lmt do
    begin
      isPrime[j] := 3;
      Inc(j, 6);
    end;

    i := 5;
    while i * i <= lmt do
    begin
      if isPrime[i] = 0 then
      begin
        j := lmt div i;
        if not (odd(j)) then
          Dec(j);
        while j > i do
        begin
          if isPrime[j] = 0 then
            isPrime[i * j] := i;
          Dec(j, 2);
        end;
        //mark square prime
        isPrime[i * i] := SquareMarker;
      end;
      Inc(i, 2);
    end;
  end;

  procedure OutFactors(n: NativeUint);
  var
    divisor, Next, rest: NativeUint;
    pot: NativeUint;
  begin
    divisor := 2;
    Next := 3;
    rest := n;
    Write(n: 10, ' = ');
    while (rest <> 1) do
    begin
      if (rest mod divisor = 0) then
      begin
        Write(divisor);
        pot := 0;
        repeat
          rest := rest div divisor;
          Inc(pot)
        until rest mod divisor <> 0;
        if pot > 1 then
          Write('^', pot);
        if rest > 1 then
          Write('*');
      end;
      divisor := Next;
      Next := Next + 2;
      // cut condition: avoid many useless iterations
      if (rest <> 1) and (rest < divisor * divisor) then
      begin
        Write(rest);
        rest := 1;
      end;
    end;
    Write('  ', #9#9#9);
  end;

  procedure OutToBase(number, base: NativeUint);
  var
    BaseDgt: array[0..63] of NativeUint;
    i, rest: NativeINt;
  begin
    OutFactors(number);
    i := 0;
    while number <> 0 do
    begin
      rest := number div base;
      BaseDgt[i] := number - rest * base;
      number := rest;
      Inc(i);
    end;
    while i > 1 do
    begin
      Dec(i);
      Write(BaseDgt[i]);
    end;
    writeln(BaseDgt[0], ' to base ', base);
  end;

  function PrimeBase(number: NativeUint): NativeUint;
  var
    lnN: extended;
    i, exponent, n: NativeUint;
  begin
    // primes are only brazilian if 111...11 to base > 2
    // the count of "1" must be odd , because brazilian primes are odd
    lnN := ln(number);
    exponent := 4;
    //result := exponent.th root of number
    Result := trunc(exp(lnN*0.25));
    while result >2 do
    Begin
      // calc sum(i= 0 to exponent ) base^i;
      n := Result + 1;
      i := 2;
      repeat
        Inc(i);
        n := n*result + 1;
      until i > exponent;
      if n = number then
        EXIT;
      Inc(exponent,2);
      Result := trunc(exp(lnN/exponent));
    end;
    //not brazilian
    Result := 0;
  end;

  function GetPrimeBrazilianBase(number: NativeUint): NativeUint;
    //result is base
  begin
    // prime of 2^n - 1
    if (Number and (number + 1)) = 0 then
      Result := 2
    else
    begin
      Result := trunc(sqrt(number));
      //most of the brazilian primes are of this type base^2+base+1
      IF (sqr(result)+result+1) <> number then
        result := PrimeBase(number);
    end;
  end;

  function GetBrazilianBase(number: NativeUInt): NativeUint; inline;
  begin
    Result := isPrime[number];
    if Result > SquareMarker then
      Result := (number div Result) - 1
    else
    begin
      if Result = SquareMarker then
      begin
        if number = 121 then
          Result := 3
        else
          Result := 0;
      end
      else
        Result := GetPrimeBrazilianBase(number);
    end;
  end;

  procedure First20Brazilian;
  var
    i, n, cnt: NativeUInt;
  begin
    writeln('first 20 brazilian numbers');
    i := 7;
    cnt := 0;
    while cnt < 20 do
    begin
      n := GetBrazilianBase(i);
      if n <> 0 then
      begin
        Inc(cnt);
        OutToBase(i, n);
      end;
      Inc(i);
    end;
    writeln;
  end;

  procedure First33OddBrazilian;
  var
    i, n, cnt: NativeUInt;
  begin
    writeln('first 33 odd brazilian numbers');
    i := 7;
    cnt := 0;
    while cnt < 33 do
    begin
      n := GetBrazilianBase(i);
      if N <> 0 then
      begin
        Inc(cnt);
        OutToBase(i, n);
      end;
      Inc(i, 2);
    end;
    writeln;
  end;

  procedure First20BrazilianPrimes;
  var
    i, n, cnt: NativeUInt;
  begin
    writeln('first 20 brazilian prime numbers');
    i := 7;
    cnt := 0;
    while cnt < 20 do
    begin
      IF isPrime[i] = PrimeMarker then
      Begin
        n := GetBrazilianBase(i);
        if n <> 0 then
        begin
          Inc(cnt);
          OutToBase(i, n);
        end;
      end;
      Inc(i);
    end;
    writeln;
  end;

var
  T1, T0: TDateTime;
  i, n, cnt, lmt: NativeUInt;
begin
  lmt := MAX;
  setlength(isPrime, lmt + 1);
  MarkSmallestFactor;

  First20Brazilian;
  First33OddBrazilian;
  First20BrazilianPrimes;

  Write('count brazilian numbers up to ', lmt, ' = ');
  T0 := now;
  i := 7;
  cnt := 0;
  n := 0;

  while (i <= lmt) do
  begin
    Inc(n, Ord(isPrime[i] = PrimeMarker));
    if GetBrazilianBase(i) <> 0 then
      Inc(cnt);
    Inc(i);
  end;

  T1 := now;

  writeln(cnt);
  writeln('Count of primes ', n: 11+13);
  writeln((T1 - T0) * 86400 * 1000: 10: 0, ' ms');

  setlength(isPrime, 0);
end.
