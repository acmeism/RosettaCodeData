program zumkeller;
//https://oeis.org/A083206/a083206.txt
{$IFDEF FPC}
  {$MODE DELPHI}  {$OPTIMIZATION ON,ALL}  {$COPERATORS ON}
//  {$O+,I+}
{$ELSE}
  {$APPTYPE CONSOLE}
{$ENDIF}
uses
  sysutils
{$IFDEF WINDOWS},Windows{$ENDIF}
  ;
//######################################################################
//prime decomposition
const
//HCN(86) > 1.2E11 = 128,501,493,120     count of divs = 4096   7 3 1 1 1 1 1 1 1
  HCN_DivCnt  = 4096;
//stop never ending recursion
  RECCOUNTMAX = 100*1000*1000;
  DELTAMAX    = 1000*1000;
type
  tItem     = Uint64;
  tDivisors = array [0..HCN_DivCnt-1] of tItem;
  tpDivisor = pUint64;
const
  SizePrDeFe = 12697;//*72 <= 1 or 2 Mb ~ level 2 cache -32kB for DIVS
type
  tdigits    = packed record
                 dgtDgts : array [0..31] of Uint32;
               end;

  //the first number with 11 different divisors =
  // 2*3*5*7*11*13*17*19*23*29*31 = 2E11
  tprimeFac = packed record
                 pfSumOfDivs,
                 pfRemain  : Uint64;  //n div (p[0]^[pPot[0] *...) can handle primes <=821641^2 = 6.7e11
                 pfpotPrim : array[0..9] of UInt32;//+10*4 = 56 Byte
                 pfpotMax  : array[0..9] of byte;  //10  = 66
                 pfMaxIdx  : Uint16; //68
                 pfDivCnt  : Uint32; //72
               end;

  tPrimeDecompField = array[0..SizePrDeFe-1] of tprimeFac;
  tPrimes = array[0..65535] of Uint32;

var
  SmallPrimes: tPrimes;
//######################################################################
//prime decomposition
procedure InitSmallPrimes;
//only odd numbers
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
  flipflop := 3-1;
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

function OutPots(const pD:tprimeFac;n:NativeInt):Ansistring;
var
  s: String[31];
Begin
  str(n,s);
  result := s+' :';
  with pd do
  begin
    str(pfDivCnt:3,s);
    result += s+' : ';
    For n := 0 to pfMaxIdx-1 do
    Begin
      if n>0 then
        result += '*';
      str(pFpotPrim[n],s);
      result += s;
      if pfpotMax[n] >1 then
      Begin
        str(pfpotMax[n],s);
        result += '^'+s;
      end;
    end;
    If pfRemain >1 then
    Begin
      str(pfRemain,s);
      result += '*'+s;
    end;
    str(pfSumOfDivs,s);
    result += '_SoD_'+s+'<';
  end;
end;

function CnvtoBASE(var dgt:tDigits;n:Uint64;base:NativeUint):NativeInt;
//n must be multiple of base
var
  q,r: Uint64;
  i : NativeInt;
Begin
  with dgt do
  Begin
    fillchar(dgtDgts,SizeOf(dgtDgts),#0);
    i := 0;
//    dgtNum:= n;
    n := n div base;
    result := 0;
    repeat
      r := n;
      q := n div base;
      r  -= q*base;
      n := q;
      dgtDgts[i] := r;
      inc(i);
    until (q = 0);

    result := 0;
    while (result<i) AND (dgtDgts[result] = 0) do
      inc(result);
    inc(result);
  end;
end;

function IncByBaseInBase(var dgt:tDigits;base:NativeInt):NativeInt;
var
  q :NativeInt;
Begin
  with dgt do
  Begin
    result := 0;
    q := dgtDgts[result]+1;
//    inc(dgtNum,base);
    if q = base then
    begin
      repeat
        dgtDgts[result] := 0;
        inc(result);
        q := dgtDgts[result]+1;
      until q <> base;
    end;
    dgtDgts[result] := q;
    result +=1;
  end;
end;

procedure SieveOneSieve(var pdf:tPrimeDecompField;n:nativeUInt);
var
  dgt:tDigits;
  i, j, k,pr,fac : NativeUInt;
begin
  //init
  for i := 0 to High(pdf) do
    with pdf[i] do
    Begin
      pfDivCnt := 1;
      pfSumOfDivs := 1;
      pfRemain := n+i;
      pfMaxIdx := 0;
    end;

  //first 2 make n+i even
  i := n AND 1;
  repeat
    with pdf[i] do
      if n+i > 0 then
      begin
        j := BsfQWord(n+i);
        pfMaxIdx := 1;
        pfpotPrim[0] := 2;
        pfpotMax[0] := j;
        pfRemain := (n+i) shr j;
        pfSumOfDivs := (1 shl (j+1))-1;
        pfDivCnt := j+1;
      end;
    i += 2;
  until i >High(pdf);

  // i now index in SmallPrimes
  i := 0;
  repeat
    //search next prime that is in bounds of sieve
    repeat
      inc(i);
      if i >= High(SmallPrimes) then
        BREAK;
      pr := SmallPrimes[i];
      k := pr-n MOD pr;
      if (k = pr) AND (n>0) then
        k:= 0;
      if k < SizePrDeFe then
        break;
    until false;
    if i >= High(SmallPrimes) then
      BREAK;
    //no need to use higher primes
    if pr*pr > n+SizePrDeFe then
      BREAK;

    // j is power of prime
    j := CnvtoBASE(dgt,n+k,pr);
    repeat
      with pdf[k] do
      Begin
        pfpotPrim[pfMaxIdx] := pr;
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
      end;
      k += pr;
      j := IncByBaseInBase(dgt,pr);
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
end;
//prime decomposition
//######################################################################
procedure Init_Check_rec(const pD:tprimeFac;var Divs,SumOfDivs:tDivisors);forward;

var
{$ALIGN 32}
  PrimeDecompField:tPrimeDecompField;
{$ALIGN 32}
  Divs :tDivisors;
  SumOfDivs : tDivisors;
  DivUsedIdx : tDivisors;

  pDiv :tpDivisor;
  T0: Int64;
  count,rec_Cnt: NativeInt;
  depth : Int32;
  finished :Boolean;

procedure Check_rek_depth(SoD : Int64;i: NativeInt);
var
  sum : Int64;
begin
  if finished then
    EXIT;
  inc(rec_Cnt);

  WHILE (i>0) AND (pDiv[i]>SoD) do
    dec(i);

  while i >= 0 do
  Begin
    DivUsedIdx[depth] := pDiv[i];
    sum := SoD-pDiv[i];
    if sum = 0 then
    begin
      finished := true;
      EXIT;
    end;
    dec(i);
    inc(depth);
    if (i>= 0) AND (sum <= SumOfDivs[i]) then
      Check_rek_depth(sum,i);
    if finished then
      EXIT;
//  DivUsedIdx[depth] := 0;
    dec(depth);
  end;
end;

procedure Out_One_Sol(const pd:tprimefac;n:NativeUInt;isZK : Boolean);
var
  sum : NativeInt;
Begin
  if n< 7 then
    exit;
  with pd do
  begin
    writeln(OutPots(pD,n));
    if isZK then
    Begin
      Init_Check_rec(pD,Divs,SumOfDivs);
      Check_rek_depth(pfSumOfDivs shr 1-n,pFDivCnt-1);
      write(pfSumOfDivs shr 1:10,' = ');
      sum := n;
      while depth >= 0 do
      Begin
        sum += DivUsedIdx[depth];
        write(DivUsedIdx[depth],'+');
        dec(depth);
      end;
      write(n,' =  ',sum);
    end
    else
      write(' no zumkeller ');
  end;
end;

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

procedure GetDivs(const pD:tprimeFac;var Divs,SumOfDivs:tDivisors);
var
  pDivs : tpDivisor;
  pPot : UInt64;
  i,len,j,l,p,k: Int32;
Begin
  i := pD.pfDivCnt;
  pDivs := @Divs[0];
  pDivs[0] := 1;
  len := 1;
  l   := 1;
  with pD do
  Begin
    For i := 0 to pfMaxIdx-1 do
    begin
      //Multiply every divisor before with the new primefactors
      //and append them to the list
      k := pfpotMax[i];
      p := pfpotPrim[i];
      pPot :=1;
      repeat
        pPot *= p;
        For j := 0 to len-1 do
        Begin
          pDivs[l]:= pPot*pDivs[j];
          inc(l);
        end;
        dec(k);
      until k<=0;
      len := l;
    end;
    p := pfRemain;
    If p >1 then
    begin
      For j := 0 to len-1 do
      Begin
        pDivs[l]:= p*pDivs[j];
        inc(l);
      end;
      len := l;
    end;
  end;
  //Sort. Insertsort much faster than QuickSort in this special case
  InsertSort(pDivs,0,len-1);

  pPot := 0;
  For i := 0 to len-1 do
  begin
    pPot += pDivs[i];
    SumOfDivs[i] := pPot;
  end;
end;

procedure Init_Check_rec(const pD:tprimeFac;var Divs,SumOfDivs:tDivisors);
begin
  GetDivs(pD,Divs,SUmOfDivs);
  finished := false;
  depth := 0;
  pDiv := @Divs[0];
end;

procedure Check_rek(SoD : Int64;i: NativeInt);
var
  sum : Int64;
begin
  if finished then
    EXIT;
  if rec_Cnt >RECCOUNTMAX then
  begin
    rec_Cnt := -1;
    finished := true;
    exit;
  end;
  inc(rec_Cnt);

  WHILE (i>0) AND (pDiv[i]>SoD) do
    dec(i);

  while i >= 0 do
  Begin
    sum := SoD-pDiv[i];
    if sum = 0 then
    begin
      finished := true;
      EXIT;
    end;
    dec(i);
    if (i>= 0) AND (sum <= SumOfDivs[i]) then
      Check_rek(sum,i);
    if finished then
      EXIT;
 end;
end;

function GetZumKeller(n: NativeUint;var pD:tPrimefac): boolean;
var
  SoD,sum : Int64;
  Div_cnt,i,pracLmt: NativeInt;
begin
  rec_Cnt := 0;
  SoD:= pd.pfSumOfDivs;
  //sum must be even and n not deficient
  if Odd(SoD) or (SoD<2*n) THEN
    EXIT(false);
//if Odd(n) then Exit(Not(odd(sum)));// to be tested

  SoD := SoD shr 1-n;
  If SoD < 2 then //0,1 is always true
    Exit(true);

  Div_cnt := pD.pfDivCnt;

  if Not(odd(n)) then
    if ((n mod 18) in [6,12]) then
      EXIT(true);

  //Now one needs to get the divisors
  Init_check_rec(pD,Divs,SumOfDivs);

  pracLmt:= 0;
  if Not(odd(n)) then
  begin
    For i := 1 to Div_Cnt do
    Begin
      sum := SumOfDivs[i];
      If (sum+1<Divs[i+1]) AND (sum<SoD) then
      Begin
        pracLmt := i;
        BREAK;
      end;
     IF (sum>=SoD) then break;
    end;
    if pracLmt = 0 then
      Exit(true);
  end;
  //number is practical followed by one big prime
  if pracLmt = (Div_Cnt-1) shr 1 then
  begin
    i := SoD mod Divs[pracLmt+1];
    with pD do
    begin
      if pfRemain > 1 then
        EXIT((pfRemain<=i) OR (i<=sum))
      else
        EXIT((pfpotPrim[pfMaxIdx-1]<=i)OR (i<=sum));
    end;
  end;

  Begin
    IF Div_cnt <= HCN_DivCnt then
    Begin
      Check_rek(SoD,Div_cnt-1);
      IF rec_Cnt = -1 then
        exit(true);
      exit(finished);
    end;
  end;
  result := false;
end;

var
  Ofs,i,n : NativeUInt;
  Max: NativeUInt;

procedure Init_Sieve(n:NativeUint);
//Init Sieve i,oFs are Global
begin
  i := n MOD SizePrDeFe;
  Ofs := (n DIV SizePrDeFe)*SizePrDeFe;
  SieveOneSieve(PrimeDecompField,Ofs);
end;

procedure GetSmall(MaxIdx:Int32);
var
  ZK: Array of Uint32;
  idx: UInt32;
Begin
  If MaxIdx<1 then
    EXIT;
  writeln('The first ',MaxIdx,' zumkeller numbers');
  Init_Sieve(0);
  setlength(ZK,MaxIdx);
  idx := Low(ZK);
  repeat
    if GetZumKeller(n,PrimeDecompField[i]) then
    Begin
      ZK[idx] := n;
      inc(idx);
    end;
    inc(i);
    inc(n);
    If i > High(PrimeDecompField) then
    begin
      dec(i,SizePrDeFe);
      inc(ofs,SizePrDeFe);
      SieveOneSieve(PrimeDecompField,Ofs);
    end;
  until idx >= MaxIdx;
  For idx := 0 to MaxIdx-1 do
  begin
    if idx MOD 20 = 0 then
      writeln;
    write(ZK[idx]:4);
  end;
  setlength(ZK,0);
  writeln;
  writeln;
end;

procedure GetOdd(MaxIdx:Int32);
var
  ZK: Array of Uint32;
  idx: UInt32;
Begin
  If MaxIdx<1 then
    EXIT;
  writeln('The first odd 40 zumkeller numbers');
  n := 1;
  Init_Sieve(n);
  setlength(ZK,MaxIdx);
  idx := Low(ZK);
  repeat
    if GetZumKeller(n,PrimeDecompField[i]) then
    Begin
      ZK[idx] := n;
      inc(idx);
    end;
    inc(i,2);
    inc(n,2);
    If i > High(PrimeDecompField) then
    begin
      dec(i,SizePrDeFe);
      inc(ofs,SizePrDeFe);
      SieveOneSieve(PrimeDecompField,Ofs);
    end;
  until idx >= MaxIdx;
  For idx := 0 to MaxIdx-1 do
  begin
    if idx MOD (80 DIV 8) = 0 then
      writeln;
    write(ZK[idx]:8);
  end;
  setlength(ZK,0);
  writeln;
  writeln;
end;

procedure GetOddNot5(MaxIdx:Int32);
var
  ZK: Array of Uint32;
  idx: UInt32;
Begin
  If MaxIdx<1 then
    EXIT;
  writeln('The first odd 40 zumkeller numbers not ending in 5');
  n := 1;
  Init_Sieve(n);
  setlength(ZK,MaxIdx);
  idx := Low(ZK);
  repeat
    if GetZumKeller(n,PrimeDecompField[i]) then
    Begin
      ZK[idx] := n;
      inc(idx);
    end;
    inc(i,2);
    inc(n,2);
    If n mod 5 = 0 then
    begin
      inc(i,2);
      inc(n,2);
    end;
    If i > High(PrimeDecompField) then
    begin
      dec(i,SizePrDeFe);
      inc(ofs,SizePrDeFe);
      SieveOneSieve(PrimeDecompField,Ofs);
    end;
  until idx >= MaxIdx;
  For idx := 0 to MaxIdx-1 do
  begin
    if idx MOD (80 DIV 8) = 0 then
      writeln;
    write(ZK[idx]:8);
  end;
  setlength(ZK,0);
  writeln;
  writeln;
end;
BEGIN
  InitSmallPrimes;

  T0 := GetTickCount64;
  GetSmall(220);
  GetOdd(40);
  GetOddNot5(40);

  writeln;
  n := 1;//8996229720;//1;
  Init_Sieve(n);
  writeln('Start ',n,' at ',i);
  T0 := GetTickCount64;
  MAX := (n DIV DELTAMAX+1)*DELTAMAX;
  count := 0;
  repeat
    writeln('Count of zumkeller numbers up to ',MAX:12);
    repeat
      if GetZumKeller(n,PrimeDecompField[i]) then
        inc(count);
      inc(i);
      inc(n);
      If i > High(PrimeDecompField) then
      begin
        dec(i,SizePrDeFe);
        inc(ofs,SizePrDeFe);
        SieveOneSieve(PrimeDecompField,Ofs);
      end;
    until n > MAX;
    writeln(n-1:10,' tested found ',count:10,' ratio ',count/n:10:7);
    MAX += DELTAMAX;
  until MAX>10*DELTAMAX;
  writeln('runtime ',(GetTickCount64-T0)/1000:8:3,' s');
  writeln;
  writeln('Count of recursion 59,641,327 for 8,996,229,720');
  n := 8996229720;
  Init_Sieve(n);
  T0 := GetTickCount64;
  Out_One_Sol(PrimeDecompField[i],n,true);
  writeln;
  writeln('runtime ',(GetTickCount64-T0)/1000:8:3,' s');
END.
