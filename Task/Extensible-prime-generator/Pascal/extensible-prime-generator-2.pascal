program test;
uses
  primsieve;

var
  i : NativeInt;
  cnt : Uint64;
Begin
  writeln('First 25 primes');
  For i := 1 to 25 do
    write(Nextprime:3);
  writeln;
Writeln;
  writeln('Primes betwenn 100 and 150');
  repeat
    i := NextPrime
  until i > 100;
  repeat
    write(i:4);
    i := NextPrime;
  until i>150;
  writeln;
Writeln;
  repeat
    i := NextPrime
  until i > 7700;
  cnt := 0;
  repeat
    inc(cnt);
    i := NextPrime;
  until i> 8000;
  writeln('between 7700 and 8000 are ',cnt,' primes');
Writeln;
  writeln('      i.th       prime');
  cnt := 10000;
  repeat
    while TotalCount < cnt do
      NextSieve;
    repeat
      i := NextPrime;
    until PosOfPrime = cnt;
    writeln(cnt:10,i:12);
    cnt := cnt*10;
  until cnt >100*1000*1000;
end.
