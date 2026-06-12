Program nth_prime;

Function nthprime(x : uint32): uint32;
Var primes : array Of uint32;
  i,pr,count : uint32;
  found : boolean;
Begin
  setlength(primes, x);
  primes[1] := 2;
  count := 1;
  i := 3;
  Repeat
    found := FALSE;
    pr := 0;
    Repeat
      inc(pr);
      found := i Mod primes[pr] = 0;
    Until (primes[pr]*primes[pr] > i) Or found;
    If Not found Then
      Begin
        inc(count);
        primes[count] := i;
      End;
    inc(i,2);
  Until count = x;
  nthprime := primes[x];
End;

Begin
  writeln(nthprime(10001));
End.
