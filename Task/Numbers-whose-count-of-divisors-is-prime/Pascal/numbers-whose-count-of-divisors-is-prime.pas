program FacOfInteger;
{$IFDEF FPC}
//  {$R+,O+} //debuging purpose
  {$MODE DELPHI}
  {$Optimization ON,ALL}
{$ELSE}
   {$APPTYPE CONSOLE}
{$ENDIF}
uses
  sysutils;
//#############################################################################
//Prime decomposition
type
  tPot = record
           potSoD : Uint64;
           potPrim,
           potMax :Uint32;
         end;

  tprimeFac = record
                 pfPrims : array[0..13] of tPot;
                 pfSumOfDivs : Uint64;
                 pfCnt,
                 pfNum,
                 pfDivCnt: Uint32;
               end;

  tSmallPrimes = array[0..6541] of Word;
  tItem     = NativeUint;
  tDivisors = array of tItem;
  tpDivisor = pNativeUint;
var
  SmallPrimes: tSmallPrimes;


procedure InsertSort(pDiv:tpDivisor; Left, Right : NativeInt );
var
  I, J: NativeInt;
  Pivot : tItem;
begin
  for i:= 1 + Left to Right do
  begin
    Pivot:= pDiv[i];
    j:= i - 1;
    while (j >= Left) and (pDiv[j] > Pivot) do
    begin
      pDiv[j+1]:=pDiv[j];
      Dec(j);
    end;
    pDiv[j+1]:= pivot;
  end;
end;

procedure InitSmallPrimes;
var
  pr,testPr,j,maxprimidx,delta: Uint32;
  isPrime : boolean;
Begin
  SmallPrimes[0] := 2;
  SmallPrimes[1] := 3;
  delta := 2;
  maxprimidx := 1;
  pr := 5;
  repeat
    isprime := true;
    j := 0;
    repeat
      testPr := SmallPrimes[j];
      IF testPr*testPr > pr then
        break;
      If pr mod testPr = 0 then
      Begin
        isprime := false;
        break;
      end;
      inc(j);
    until false;

    if isprime then
    Begin
      inc(maxprimidx);
      SmallPrimes[maxprimidx]:= pr;
    end;
    inc(pr,delta);
    delta := 2+4-delta;
  until pr > 1 shl 16 -1;
end;

function isPrime(n:Uint32):boolean;
var
  pr,idx: NativeInt;
begin
  result := n in [2,3];
  if NOT(result) AND (n>4) AND (n AND 1 <> 0 ) then
  begin
    idx := 1;
    repeat
      pr := SmallPrimes[idx];
      result := (n mod pr) <>0;
      inc(idx);
    until NOT(result) or (sqr(pr)>n) or (idx > High(SmallPrimes));
  end;
end;

procedure PrimeFacOut(const primeDecomp:tprimeFac;proper:Boolean=true);
var
  i,k : Int32;
begin
  with primeDecomp do
  Begin
    write(pfNum,' = ');
    k := pfCnt-1;
    For i := 0 to k-1 do
      with pfPrims[i] do
        If potMax = 1 then
          write(potPrim,'*')
        else
          write(potPrim,'^',potMax,'*');
    with pfPrims[k] do
      If potMax = 1 then
        write(potPrim)
      else
        write(potPrim,'^',potMax);
    if proper then
      writeln(' got ',pfDivCnt-1,' proper divisors with sum : ',pfSumOfDivs-pfNum)
    else
      writeln(' got ',pfDivCnt,' divisors with sum : ',pfSumOfDivs);
  end;
end;

procedure PrimeDecomposition(var res:tprimeFac;n:Uint32);
var
  DivSum,fac:Uint64;
  i,pr,cnt,DivCnt,quot{to minimize divisions} : NativeUint;
Begin
  if SmallPrimes[0] <> 2 then
    InitSmallPrimes;
  res.pfNum := n;
  cnt := 0;
  DivCnt := 1;
  DivSum := 1;
  i := 0;
  if n <= 1 then
  Begin
    with res.pfPrims[0] do
    Begin
      potPrim := n;
      potMax  := 1;
    end;
    cnt := 1;
  end
  else
  repeat
    pr := SmallPrimes[i];
    IF pr*pr>n then
      Break;

    quot := n div pr;
    IF pr*quot = n then
      with res do
      Begin
        with pfPrims[Cnt] do
        Begin
          potPrim := pr;
          potMax := 0;
          fac := pr;
          repeat
            n := quot;
            quot := quot div pr;
            inc(potMax);
            fac *= pr;
          until pr*quot <> n;
          DivCnt *= (potMax+1);
          DivSum *= (fac-1)DIV (pr-1);
        end;
        inc(Cnt);
      end;
     inc(i);
  until false;
  //a big prime left over?
  IF n > 1 then
    with res do
    Begin
      with pfPrims[Cnt] do
      Begin
        potPrim := n;
        potMax := 1;
      end;
      inc(Cnt);
      DivCnt *= 2;
      DivSum *= n+1;
    end;
  with res do
  Begin
   pfCnt:= cnt;
   pfDivCnt := DivCnt;
   pfSumOfDivs := DivSum;
  end;
end;

function isAbundant(const pD:tprimeFac):boolean;inline;
begin
  with pd do
    result := pfSumOfDivs-pfNum > pfNum;
end;

function DivCount(const pD:tprimeFac):NativeUInt;inline;
begin
  result := pD.pfDivCnt;
end;

function SumOfDiv(const primeDecomp:tprimeFac):NativeUInt;inline;
begin
  result := primeDecomp.pfSumOfDivs;
end;

procedure GetDivs(var pD:tprimeFac;var Divs:tDivisors);
var
  pDivs : tpDivisor;
  i,len,j,l,p,pPot,k: NativeInt;
Begin
  i := DivCount(pD);
  IF i > Length(Divs) then
    setlength(Divs,i);
  pDivs := @Divs[0];
  pDivs[0] := 1;
  len := 1;
  l := len;
  For i := 0 to pD.pfCnt-1 do
    with pD.pfPrims[i] do
    Begin
      //Multiply every divisor before with the new primefactors
      //and append them to the list
      k := potMax-1;
      p := potPrim;
      pPot :=1;
      repeat
        pPot *= p;
        For j := 0 to len-1 do
        Begin
          pDivs[l]:= pPot*pDivs[j];
          inc(l);
        end;
        dec(k);
      until k<0;
      len := l;
    end;
  //Sort. Insertsort much faster than QuickSort in this special case
  InsertSort(pDivs,0,len-1);
end;

Function GetDivisors(var pD:tprimeFac;n:Uint32;var Divs:tDivisors):Int32;
var
  i:Int32;
Begin
  if pD.pfNum <> n then
    PrimeDecomposition(pD,n);
  i := DivCount(pD);
  IF i > Length(Divs) then
    setlength(Divs,i+1);
  GetDivs(pD,Divs);
  result := DivCount(pD);
end;

procedure AllFacsOut(var pD:tprimeFac;n: Uint32;Divs:tDivisors;proper:boolean=true);
var
  k,j: Int32;
Begin
  k := GetDivisors(pD,n,Divs)-1;// zero based
  PrimeFacOut(pD,proper);
  IF proper then
    dec(k);
  IF k > 0 then
  Begin
    For j := 0 to k-1 do
      write(Divs[j],',');
    writeln(Divs[k]);
  end;
end;
//Prime decomposition
//#############################################################################
procedure SpeedTest(var pD: tprimeFac;Limit:Uint32);
var
  Ticks : Int64;
  number,numSqr,Cnt: UInt32;
Begin
  Ticks := GetTickCount64;
  Cnt := 0;
  number := 1;
  numSqr:=1;
  repeat
    number += 1;
    numSqr := sqr(number);
    PrimeDecomposition(pD,numSqr);
    IF DivCount(pD)>2 then
      if isPrime(DivCount(pD)) then
        inc(cnt);//writeln(number:5,numSqr:10,DivCount(pD):5);
  until numSqr>= Limit;
  writeln('SpeedTest ',(GetTickCount64-Ticks)/1000:0:3,' secs for 1..',Limit,' found ',Cnt);
  writeln;
end;

var
  pD: tprimeFac;
  Divisors : tDivisors;
  numroot,num,cnt : Uint32;
BEGIN
  InitSmallPrimes;
  setlength(Divisors,1);

  write('':4);
  for cnt := 1 to 10 do
    write(cnt:7);
  writeln;

  cnt := 0;
  write(cnt:3,':');
  For numroot := 2 to 1000 do
  begin
    num := sqr(numroot);
    PrimeDecomposition(pD,num);
    IF DivCount(pD)>2 then
      if isPrime(DivCount(pD)) then
      begin
        write(num:7);
        inc(cnt);
        if cnt MOD 10 =0 then
        Begin
          writeln;write(cnt:3,':');
        end;
      end;
  end;
  if cnt MOD 8 <>0 then
    writeln;
  writeln;
  SpeedTest(pD,4000*1000*1000);
END.
