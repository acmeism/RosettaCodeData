program UntouchableNumbers;
program UntouchableNumbers;
{$IFDEF FPC}
  {$MODE DELPHI}  {$OPTIMIZATION ON,ALL}  {$COPERATORS ON}
  {$CODEALIGN proc=16,loop=4}
{$ELSE}
  {$APPTYPE CONSOLE}
{$ENDIF}
uses
  sysutils,strutils
{$IFDEF WINDOWS},Windows{$ENDIF}
  ;
const
  MAXPRIME = 1742537;
  //sqr(MaxPrime) = 3e12
  LIMIT =  5*1000*1000;
  LIMIT_mul = trunc(exp(ln(LIMIT)/3))+1;

const
  SizePrDeFe = 16*8192;//*size of(tprimeFac) =16 byte  2 Mb ~ level 3 cache
type
  tdigits = array [0..31] of Uint32;
  tprimeFac = packed record
                 pfSumOfDivs,
                 pfRemain : Uint64;
               end;
  tpPrimeFac = ^tprimeFac;

  tPrimeDecompField = array[0..SizePrDeFe-1] of tprimeFac;

  tPrimes = array[0..1 shl 17-1] of Uint32;

var
  {$ALIGN 16}
  PrimeDecompField :tPrimeDecompField;
  {$ALIGN 16}
  SmallPrimes: tPrimes;
  pdfIDX,pdfOfs: NativeInt;
  TD : Int64;

procedure OutCounts(pUntouch:pByte);
var
  n,cnt,lim,deltaLim : NativeInt;
Begin
  n := 0;
  cnt := 0;
  deltaLim := 100;
  lim := deltaLim;
  repeat
    cnt += 1-pUntouch[n];
    if n = lim then
    Begin
      writeln(Numb2USA(IntToStr(lim)):13,' ',Numb2USA(IntToStr(cnt)):12);
      lim += deltaLim;
      if lim = 10*deltaLim then
      begin
        deltaLim *=10;
        lim := deltaLim;
        writeln;
      end;
    end;

    inc(n);
  until n > LIMIT;
end;

function OutN(n:UInt64):UInt64;
begin
  write(Numb2USA(IntToStr(n)):15,' dt ',(GettickCount64-TD)/1000:5:3,' s'#13);
  TD := GettickCount64;
  result := n+LIMIT;
end;

//######################################################################
//gets sum of divisors of consecutive integers fast
procedure InitSmallPrimes;
//get primes. Sieving only odd numbers
var
  pr : array[0..MAXPRIME] of byte;
  p,j,d,flipflop :NativeUInt;
Begin
  SmallPrimes[0] := 2;
  fillchar(pr[0],SizeOf(pr),#0);
  p := 0;
  repeat
    repeat
      p +=1
    until pr[p]= 0;
    j := (p+1)*p*2;
    if j>MAXPRIME then
      BREAK;
    d := 2*p+1;
    repeat
      pr[j] := 1;
      j += d;
    until j>MAXPRIME;
  until false;

  SmallPrimes[1] := 3;
  SmallPrimes[2] := 5;
  j := 3;
  flipflop := (2+1)-1;//7+2*2->11+2*1->13 ,17 ,19 , 23
  p := 3;
  repeat
    if pr[p] = 0 then
    begin
      SmallPrimes[j] := 2*p+1;
      inc(j);
    end;
    p+=flipflop;
    flipflop := 3-flipflop;
  until (p > MAXPRIME) OR (j>High(SmallPrimes));
end;

function CnvtoBASE(var dgt:tDigits;n:Uint64;base:NativeUint):NativeInt;
//n must be multiple of base aka n mod base must be 0
var
  q,r: Uint64;
  i : NativeInt;
Begin
  fillchar(dgt,SizeOf(dgt),#0);
  i := 0;
  n := n div base;
  result := 0;
  repeat
    r := n;
    q := n div base;
    r  -= q*base;
    n := q;
    dgt[i] := r;
    inc(i);
  until (q = 0);
  //searching lowest pot in base
  result := 0;
  while (result<i) AND (dgt[result] = 0) do
    inc(result);
  inc(result);
end;

function IncByOneInBase(var dgt:tDigits;base:NativeInt):NativeInt;
var
  q :NativeInt;
Begin
  result := 0;
  q := dgt[result]+1;
  if q = base then
    repeat
      dgt[result] := 0;
      inc(result);
      q := dgt[result]+1;
    until q <> base;
  dgt[result] := q;
  result +=1;
end;

procedure CalcSumOfDivs(var pdf:tPrimeDecompField;var dgt:tDigits;n,k,pr:Uint64);
var
  fac,s :Uint64;
  j : Int32;
Begin
  //j is power of prime
  j := CnvtoBASE(dgt,n+k,pr);
  repeat
    fac := 1;
    s := 1;
    repeat
      fac *= pr;
      dec(j);
      s += fac;
    until j<= 0;
    with pdf[k] do
    Begin
      pfSumOfDivs *= s;
      pfRemain := pfRemain DIV fac;
    end;
    j := IncByOneInBase(dgt,pr);
    k += pr;
  until k >= SizePrDeFe;
end;

function SieveOneSieve(var pdf:tPrimeDecompField):boolean;
var
  dgt:tDigits;
  i,j,k,pr,n,MaxP : Uint64;
begin
  n := pdfOfs;
  if n+SizePrDeFe >= sqr(SmallPrimes[High(SmallPrimes)]) then
    EXIT(FALSE);
  //init
  for i := 0 to SizePrDeFe-1 do
  begin
    with pdf[i] do
    Begin
      pfSumOfDivs := 1;
      pfRemain := n+i;
    end;
  end;
  //first factor 2. Make n+i even
  i := (pdfIdx+n) AND 1;
  IF (n = 0) AND (pdfIdx<2)  then
    i := 2;

  repeat
    with pdf[i] do
    begin
      j := BsfQWord(n+i);
      pfRemain := (n+i) shr j;
      pfSumOfDivs := (Uint64(1) shl (j+1))-1;
    end;
    i += 2;
  until i >=SizePrDeFe;
  //i now index in SmallPrimes
  i := 0;
  maxP := trunc(sqrt(n+SizePrDeFe))+1;
  repeat
    //search next prime that is in bounds of sieve
    if n = 0 then
    begin
      repeat
        inc(i);
        pr := SmallPrimes[i];
        k := pr-n MOD pr;
        if k < SizePrDeFe then
          break;
      until pr > MaxP;
    end
    else
    begin
      repeat
        inc(i);
        pr := SmallPrimes[i];
        k := pr-n MOD pr;
        if (k = pr) AND (n>0) then
          k:= 0;
        if k < SizePrDeFe then
          break;
      until pr > MaxP;
    end;

    //no need to use higher primes
    if pr > maxP then
      BREAK;

    CalcSumOfDivs(pdf,dgt,n,k,pr);
  until false;

  //correct sum of & count of divisors
  for i := 0 to High(pdf) do
  Begin
    with pdf[i] do
    begin
      j := pfRemain;
      if j <> 1 then
        pfSumOFDivs *= (j+1);
    end;
  end;
  result := true;
end;

function NextSieve:boolean;
begin
  dec(pdfIDX,SizePrDeFe);
  inc(pdfOfs,SizePrDeFe);
  result := SieveOneSieve(PrimeDecompField);
end;

function GetNextPrimeDecomp:tpPrimeFac;
begin
  if pdfIDX >= SizePrDeFe then
    if Not(NextSieve) then
    Begin
      writeln('of limits ');
      EXIT(NIL);
    end;
  result := @PrimeDecompField[pdfIDX];
  inc(pdfIDX);
end;

function Init_Sieve(n:NativeUint):boolean;
//Init Sieve pdfIdx,pdfOfs are Global
begin
  pdfIdx := n MOD SizePrDeFe;
  pdfOfs := n-pdfIdx;
  result := SieveOneSieve(PrimeDecompField);
end;
//gets sum of divisors of consecutive integers fast
//######################################################################

procedure CheckRest(n: Uint64;pUntouch:pByte);
var
  k,lim : Uint64;
begin
  lim := 2*LIMIT;
  repeat
    k := GetNextPrimeDecomp^.pfSumOfDivs-n;
    inc(n);
    if Not(ODD(k)) AND (k<=LIMIT) then
      pUntouch[k] := 1;
  // showing still alive not for TIO.RUN
//    if n >= lim then  lim := OutN(n);
  until n >LIMIT_mul*LIMIT;
end;

var
  Untouch : array of byte;
  pUntouch: pByte;
  puQW  : pQword;
  T0:Int64;
  n,k : NativeInt;
Begin
  if sqrt(LIMIT_mul*LIMIT) >=MAXPRIME then
  Begin
    writeln('Need to extend count of primes > ',
      trunc(sqrt(LIMIT_mul*LIMIT))+1);
    HALT(0);
  end;

  setlength(untouch,LIMIT+8+1);
  pUntouch := @untouch[0];
  //Mark all odd as touchable
  puQW := @pUntouch[0];
  For n := 0 to LIMIT DIV 8 do puQW[n] := $0100010001000100;

  InitSmallPrimes;
  T0 := GetTickCount64;
  writeln('LIMIT = ',Numb2USA(IntToStr(LIMIT)));
  writeln('factor beyond LIMIT ',LIMIT_mul);

  n := 0;
  Init_Sieve(n);

  pUntouch[1] := 1;//all primes
  repeat
    k := GetNextPrimeDecomp^.pfSumOfDivs-n;
    inc(n);//n-> n+1
    if k <= LIMIT then
    begin
      If k <> 1 then
        pUntouch[k] := 1
      else
      begin
        //n-1 is prime p
        //mark p*p
        pUntouch[n] := 1;
        //mark 2*p
        //5 marked by prime 2 but that is p*p, but 4 has factor sum = 3
        pUntouch[n+2] := 1;
      end;
    end;
  until n > LIMIT-2;
  //unmark 5 and mark 0
  puntouch[5] := 0;
  pUntouch[0] := 1;

  //n=limit-1
  k := GetNextPrimeDecomp^.pfSumOfDivs-n;
  inc(n);
  If (k <> 1) AND (k<=LIMIT) then
    pUntouch[k] := 1
  else
    pUntouch[n] := 1;
  //n=limit
  k := GetNextPrimeDecomp^.pfSumOfDivs-n;
  If Not(odd(k)) AND (k<=LIMIT) then
    pUntouch[k] := 1;


  n:= limit+1;
  writeln('runtime for n<= LIMIT ',(GetTickCount64-T0)/1000:0:3,' s');
  writeln('Check the rest ',Numb2USA(IntToStr((LIMIT_mul-1)*Limit)));
  TD := GettickCount64;
  CheckRest(n,pUntouch);
  writeln('runtime ',(GetTickCount64-T0)/1000:0:3,' s');
  T0 := GetTickCount64-T0;

  OutCounts(pUntouch);
end.
