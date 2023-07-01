const
  //make size of sieve using 11 MB of 16MB Level III cache
  SizePrDeFe = 192*1024;
.....
function IsArithmetic(const PrimeFact:tPrimeFac):boolean;inline;
begin
  with PrimeFact do
    IsArithmetic := pfSumOfDivs mod pfDivCnt = 0;
end;

var
  pPrimeDecomp :tpPrimeFac;
  T0:Int64;
  n,lmt,cnt,primeCnt : NativeUInt;
Begin
  InitSmallPrimes;

  T0 := GetTickCount64;
  cnt := 1;
  primeCnt := 1;
  lmt := 10;
  n := 2;
  Init_Sieve(n);
  repeat
    pPrimeDecomp:= GetNextPrimeDecomp;
    if IsArithmetic(pPrimeDecomp^) then
    begin
      inc(cnt);
      if pPrimeDecomp^.pfDivCnt = 2 then
        inc(primeCnt);
    end;
    if cnt = lmt then
    begin
      writeln(lmt:14,n:14,lmt-primeCnt:14);
      lmt := lmt*10;
    end;
    inc(n);
  until lmt>1000*1000*1000;
  T0 := GetTickCount64-T0;
  writeln;
end.
