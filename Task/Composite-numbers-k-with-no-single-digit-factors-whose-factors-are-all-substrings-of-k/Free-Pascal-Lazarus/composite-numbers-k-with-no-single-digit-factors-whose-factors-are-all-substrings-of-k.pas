program FacOfInt;
// gets factors of consecutive integers fast
// limited to 1.2e11
{$IFDEF FPC}
  {$MODE DELPHI}  {$OPTIMIZATION ON,ALL}  {$COPERATORS ON}
{$ELSE}
  {$APPTYPE CONSOLE}
{$ENDIF}
uses
  sysutils,
  strutils //Numb2USA
{$IFDEF WINDOWS},Windows{$ENDIF}
  ;
//######################################################################
//prime decomposition
const
//HCN(86) > 1.2E11 = 128,501,493,120     count of divs = 4096   7 3 1 1 1 1 1 1 1
  HCN_DivCnt  = 4096;
type
  tItem     = Uint64;
  tDivisors = array [0..HCN_DivCnt] of tItem;
  tpDivisor = pUint64;
const
  //used odd size for test only
  SizePrDeFe = 32768;//*72 <= 64kb level I or 2 Mb ~ level 2 cache
type
  tdigits = array [0..31] of Uint32;
  //the first number with 11 different prime factors =
  //2*3*5*7*11*13*17*19*23*29*31 = 2E11
  //56 byte
  tprimeFac = packed record
                 pfSumOfDivs,
                 pfRemain  : Uint64;
                 pfDivCnt  : Uint32;
                 pfMaxIdx  : Uint32;
                 pfpotPrimIdx : array[0..9] of word;
                 pfpotMax  : array[0..11] of byte;
               end;
  tpPrimeFac = ^tprimeFac;

  tPrimeDecompField = array[0..SizePrDeFe-1] of tprimeFac;
  tPrimes = array[0..65535] of Uint32;

var
  {$ALIGN 8}
  SmallPrimes: tPrimes;
  {$ALIGN 32}
  PrimeDecompField :tPrimeDecompField;
  pdfIDX,pdfOfs: NativeInt;

procedure InitSmallPrimes;
//get primes. #0..65535.Sieving only odd numbers
const
  MAXLIMIT = (821641-1) shr 1;
var
  pr : array[0..MAXLIMIT] of byte;
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
    if j>MAXLIMIT then
      BREAK;
    d := 2*p+1;
    repeat
      pr[j] := 1;
      j += d;
    until j>MAXLIMIT;
  until false;

  SmallPrimes[1] := 3;
  SmallPrimes[2] := 5;
  j := 3;
  d := 7;
  flipflop := (2+1)-1;//7+2*2,11+2*1,13,17,19,23
  p := 3;
  repeat
    if pr[p] = 0 then
    begin
      SmallPrimes[j] := d;
      inc(j);
    end;
    d += 2*flipflop;
    p+=flipflop;
    flipflop := 3-flipflop;
  until (p > MAXLIMIT) OR (j>High(SmallPrimes));
end;

function OutPots(pD:tpPrimeFac;n:NativeInt):Ansistring;
var
  s: String[31];
  chk,p,i: NativeInt;
Begin
  str(n,s);
  result := Format('%15s : ',[Numb2USA(s)]);

  with pd^ do
  begin
    chk := 1;
    For n := 0 to pfMaxIdx-1 do
    Begin
      if n>0 then
        result += '*';
      p := SmallPrimes[pfpotPrimIdx[n]];
      chk *= p;
      str(p,s);
      result += s;
      i := pfpotMax[n];
      if i >1 then
      Begin
        str(pfpotMax[n],s);
        result += '^'+s;
        repeat
          chk *= p;
          dec(i);
        until i <= 1;
      end;

    end;
    p := pfRemain;
    If p >1 then
    Begin
      str(p,s);
      chk *= p;
      result += '*'+s;
    end;
  end;
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

function IncByBaseInBase(var dgt:tDigits;base:NativeInt):NativeInt;
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

function SieveOneSieve(var pdf:tPrimeDecompField):boolean;
var
  dgt:tDigits;
  i,j,k,pr,fac,n,MaxP : Uint64;
begin
  n := pdfOfs;
  if n+SizePrDeFe >= sqr(SmallPrimes[High(SmallPrimes)]) then
    EXIT(FALSE);
  //init
  for i := 0 to SizePrDeFe-1 do
  begin
    with pdf[i] do
    Begin
      pfDivCnt := 1;
      pfSumOfDivs := 1;
      pfRemain := n+i;
      pfMaxIdx := 0;
      pfpotPrimIdx[0] := 0;
      pfpotMax[0] := 0;
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
      pfMaxIdx := 1;
      pfpotPrimIdx[0] := 0;
      pfpotMax[0] := j;
      pfRemain := (n+i) shr j;
      pfSumOfDivs := (Uint64(1) shl (j+1))-1;
      pfDivCnt := j+1;
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
    if pr*pr > n+SizePrDeFe then
      BREAK;

    //j is power of prime
    j := CnvtoBASE(dgt,n+k,pr);
    repeat
      with pdf[k] do
      Begin
        pfpotPrimIdx[pfMaxIdx] := i;
        pfpotMax[pfMaxIdx] := j;
        pfDivCnt *= j+1;
        fac := pr;
        repeat
          pfRemain := pfRemain DIV pr;
          dec(j);
          fac *= pr;
        until j<= 0;
        pfSumOfDivs *= (fac-1)DIV(pr-1);
        inc(pfMaxIdx);
        k += pr;
        j := IncByBaseInBase(dgt,pr);
      end;
    until k >= SizePrDeFe;
  until false;

  //correct sum of & count of divisors
  for i := 0 to High(pdf) do
  Begin
    with pdf[i] do
    begin
      j := pfRemain;
      if j <> 1 then
      begin
        pfSumOFDivs *= (j+1);
        pfDivCnt *=2;
      end;
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
      EXIT(NIL);
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

var
  s,pr : string[31];
  pPrimeDecomp :tpPrimeFac;

  T0:Int64;
  n,i,cnt : NativeUInt;
  checked : boolean;
Begin
  InitSmallPrimes;

  T0 := GetTickCount64;
  cnt := 0;
  n := 0;
  Init_Sieve(n);
  repeat
    pPrimeDecomp:= GetNextPrimeDecomp;
    with pPrimeDecomp^ do
    begin
      //composite with smallest factor 11
      if (pfDivCnt>=4) AND (pfpotPrimIdx[0]>3) then
      begin
        str(n,s);
        for i := 0 to pfMaxIdx-1 do
        begin
          str(smallprimes[pfpotPrimIdx[i]],pr);
          checked := (pos(pr,s)>0);
          if Not(checked) then
            Break;
        end;
        if checked then
        begin
          //writeln(cnt:4,OutPots(pPrimeDecomp,n));
          if pfRemain >1 then
          begin
            str(pfRemain,pr);
            checked := (pos(pr,s)>0);
          end;
          if checked then
          begin
            inc(cnt);
            writeln(cnt:4,OutPots(pPrimeDecomp,n));
          end;
        end;
      end;
    end;
    inc(n);
  until n > 28118827;//10*1000*1000*1000+1;//
  T0 := GetTickCount64-T0;
  writeln('runtime ',T0/1000:0:3,' s');
end.
