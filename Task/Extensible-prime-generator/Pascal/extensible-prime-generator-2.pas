program test;
{$IFDEF FPC}
  {$MODE objFPC}{$Optimization ON,ALL}
{$IFEND}

uses
  primsieve;
var
  cnt,p,lmt : Uint64;
Begin
  lmt := 1000*1000*1000;
  p := 0;
  while TotalCount < lmt do
  Begin
    NextSieve;
    inc(p);
    If p AND (4096-1) = 0 then
      write(p:8,TotalCount:15,#13);
  end;
  cnt := StartCount;
  repeat
    p := NextPrime;
    inc(cnt);
  until cnt >= lmt;
  writeln(cnt:14,p:14);
end.
{
10^n   primecount
#  1            4
#  2           25
#  3          168
#  4         1229
#  5         9592
#  6        78498
#  7       664579
#  8      5761455
#  9     50847534
# 10    455052511
# 11   4118054813
# 12  37607912018
}
