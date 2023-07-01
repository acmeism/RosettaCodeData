program ArithmeticNumbers;
{$OPTIMIZATION ON,ALL}
type
  tPrimeFact = packed record
                 pfSumOfDivs,
                 pfRemain  : Uint64;
                 pfDivCnt  : Uint32;
                 pfMaxIdx  : Uint32;
                 pfpotPrimIdx : array[0..9] of word;
                 pfpotMax  : array[0..11] of byte;//11 instead of 9 for alignment
               end;
var
  SmallPrimes : array[0..6541] of word;

procedure InitSmallPrimes;
var
  testPrime,j,p,idx:Uint32;
begin
  SmallPrimes[0] := 2;
  SmallPrimes[1] := 3;
  idx := 1;
  testPrime := 5;
  repeat
    For j := 1 to idx do
    begin
      p := SmallPrimes[j];
      if p*p>testPrime then
        BREAK;
      if testPrime mod p = 0 then
      Begin
        p := 0;
        BREAK;
      end;
    end;
    if p <> 0 then
    begin
      inc(idx);
      SmallPrimes[idx]:= testPrime;
    end;
    inc(testPrime,2);
  until testPrime >= 65535;
end;

procedure smplPrimeDecomp(var PrimeFact:tPrimeFact;n:Uint32);
var
  pr,i,pot,fac,q :NativeUInt;
Begin
  with PrimeFact do
  Begin
    pfDivCnt := 1;
    pfSumOfDivs := 1;
    pfRemain := n;
    pfMaxIdx := 0;
    pfpotPrimIdx[0] := 1;
    pfpotMax[0] := 0;

    i := 0;
    while i < High(SmallPrimes) do
    begin
      pr := SmallPrimes[i];
      q := n DIV pr;
      //if n < pr*pr
      if pr > q then
         BREAK;
      if n = pr*q then
      Begin
        pfpotPrimIdx[pfMaxIdx] := i;
        pot := 0;
        fac := pr;
        repeat
          n := q;
          q := n div pr;
          pot+=1;
          fac *= pr;
        until n <> pr*q;
        pfpotMax[pfMaxIdx] := pot;
        pfDivCnt *= pot+1;
        pfSumOfDivs *= (fac-1)DIV(pr-1);
        inc(pfMaxIdx);
      end;
      inc(i);
    end;
    pfRemain := n;
    if n > 1 then
    Begin
      pfDivCnt *= 2;
      pfSumOfDivs *= n+1
    end;
  end;
end;

function IsArithmetic(const PrimeFact:tPrimeFact):boolean;inline;
begin
  with PrimeFact do
    IsArithmetic := pfSumOfDivs mod pfDivCnt = 0;
end;

var
  pF :TPrimeFact;
  i,cnt,primeCnt,lmt : Uint32;
begin
  InitSmallPrimes;

  writeln('First 100 arithemetic numbers');
  cnt := 0;
  i := 1;
  repeat
    smplPrimeDecomp(pF,i);
    if IsArithmetic(pF) then
    begin
      write(i:4);
      inc(cnt);
      if cnt MOD 20 =0 then
        writeln;
    end;
    inc(i);
  until cnt = 100;
  writeln;

  writeln('   Arithemetic numbers');
  writeln('   Index   number composite');
  cnt := 0;
  primeCnt := 0;
  lmt := 10;
  i := 1;
  repeat
    smplPrimeDecomp(pF,i);
    if IsArithmetic(pF) then
    begin
      inc(cnt);
      if pF.pfRemain = i then
        inc(primeCnt);
    end;
    if cnt = lmt then
    begin
      writeln(lmt:8,i:9,lmt-primeCnt:10);
      lmt := lmt*10;
    end;
    inc(i);
  until lmt>1000000;
  {$IFdef WINDOWS}
  WriteLn('Hit <ENTER>');ReadLn;
  {$ENDIF}
end.
