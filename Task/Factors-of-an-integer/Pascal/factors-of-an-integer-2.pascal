program FacOfInteger;
{$IFDEF FPC}
//  {$R+,O+} debuging purpose
  {$MODE DELPHI}
  {$Optimization ON,ALL}
  {$CodeAlign proc=8}
{$ELSE}
   {$APPTYPE CONSOLE}
{$ENDIF}
uses
  sysutils;

type
  tPot = record
           potPrim,
           potMax :Uint32;
         end;

  tprimeFac = record
                 pfPrims : array[0..13] of tPot;
                 pfCnt,
                 pfDivCnt,
                 pfSumOfDivs,
                 pfNum    : Uint32;
               end;

  tSmallPrimes = array[0..6541] of Word;
  tItem     = NativeUint;
  tDivisors = array of tItem;
  tpDivisor = pNativeUint;
var
  SmallPrimes: tSmallPrimes;
  primeDecomp: tprimeFac;

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
  pr,testPr,j,maxprimidx: Uint32;
  isPrime : boolean;
Begin
  maxprimidx := 0;
  SmallPrimes[0] := 2;
  pr := 3;
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
    inc(pr,2);
  until pr > 1 shl 16 -1;
end;

procedure PrimeFacOut(proper:Boolean=true);
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

function DivCount(const primeDecomp:tprimeFac):NativeUInt;inline;
begin
  result := primeDecomp.pfDivCnt;
end;

function SumOfDiv(const primeDecomp:tprimeFac):NativeUInt;inline;
begin
  result := primeDecomp.pfSumOfDivs;
end;

procedure PrimeDecomposition(n:Uint32;var res:tprimeFac);
var
  i,pr,fac,cnt,DivCnt,quot{to minimize divisions} : NativeUint;
Begin
  res.pfNum := n;
  cnt := 0;
  DivCnt := 1;
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
    end;
  res.pfCnt:= cnt;
  res.pfDivCnt := DivCnt;
  res.pfSumOfDivs := 0;
end;

procedure GetDivs(var primeDecomp:tprimeFac;var Divs:tDivisors);
var
  pDivs : tpDivisor;
  i,len,j,l,p,pPot,k,sum: NativeInt;
Begin
  i := DivCount(primeDecomp);
  IF i > Length(Divs) then
    setlength(Divs,i);
  pDivs := @Divs[0];
  pDivs[0] := 1;
  len := 1;
  l := len;
  sum := 1;
  For i := 0 to primeDecomp.pfCnt-1 do
    with primeDecomp.pfPrims[i] do
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
          sum += pDivs[l];
          inc(l);
        end;
        dec(k);
      until k<0;
      len := l;
    end;
  primeDecomp.pfSumOfDivs := sum;
  //Sort. Insertsort much faster than QuickSort in this special case
  InsertSort(pDivs,0,len-1);
end;

Function GetDivisors(n:Uint32;var Divs:tDivisors):Int32;
var
  i:Int32;
Begin
  PrimeDecomposition(n,primeDecomp);
  i := DivCount(primeDecomp);
  IF i > Length(Divs) then
    setlength(Divs,i+1);
  GetDivs(primeDecomp,Divs);
  result := DivCount(primeDecomp);
end;

procedure AllFacsOut(n: Uint32;Divs:tDivisors;proper:boolean=true);
var
  k,j: Int32;
Begin
  k := GetDivisors(n,Divs)-1;// zero based
  PrimeFacOut(proper);
  IF proper then
    dec(k);
  IF k > 0 then
  Begin
    For j := 0 to k-1 do
      write(Divs[j],',');
    writeln(Divs[k]);
  end;
end;

procedure SpeedTest(Limit:Uint32);
var
  Ticks,SumDivCnt : Int64;
  Divisors : tDivisors;
  number: UInt32;
Begin
  Ticks := GetTickCount64;
  SumDivCnt := 0;
  For number := 1 to Limit do
    inc(SumDivCnt,GetDivisors(number,Divisors));
  writeln('SpeedTest ',(GetTickCount64-Ticks)/1000:0:3,' secs for 1..',Limit);
  writeln('mean count of divisors ',SumDivCnt/limit:0:3);
  writeln;
end;

var
  Divisors : tDivisors;
  number: Int32;
BEGIN
  InitSmallPrimes;
  setlength(Divisors,1);
  SpeedTest(1000*1000);

  writeln('Enter a number between 1 and 4294967295: ');
  writeln('3491888400 is a nice choice :');
  readln(number);
  IF number >= 0 then
  Begin
    writeln('Proper number version');
    AllFacsOut(number,Divisors);

    writeln('including n version');
    AllFacsOut(number,Divisors,false);
  end;
  //https://en.wikipedia.org/wiki/Highly_composite_number <= HCN
  //http://wwwhomes.uni-bielefeld.de/achim/highly.txt the first 1200 HCN
END.
