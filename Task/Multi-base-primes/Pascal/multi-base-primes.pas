program MAXBaseStringIsPrimeInBase;
{$IFDEF FPC}
  {$MODE DELPHI}
  {$OPTIMIZATION ON,ALL}
{$ELSE}
  {$APPTYPE CONSOLE}
{$ENDIF}
uses
  sysutils;
const
  CharOfBase= '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
  MINBASE = 2;
  MAXBASE = 62;//36;//62;
  MAXDIGITCOUNT = 5;//6;
type
  tdigits    = packed record
                 dgtDgts : array [0..13] of byte;
                 dgtMaxIdx,
                 dgtMaxDgtVal :byte;
                 dgtNum  : Uint64;
               end;
  tSol       = array of Uint64;
var
  BoolPrimes: array  of boolean;

function BuildWheel(primeLimit:Int64):NativeUint;
var
  myPrimes : pBoolean;
  wheelprimes :array[0..31] of byte;
  wheelSize,wpno,
  pr,pw,i, k: NativeUint;
begin
  myPrimes := @BoolPrimes[0];
  pr := 1;
  myPrimes[1]:= true;
  WheelSize := 1;
  wpno := 0;
  repeat
    inc(pr);
    pw := pr;
    if pw > wheelsize then
      dec(pw,wheelsize);
    If myPrimes[pw] then
    begin
      k := WheelSize+1;
      for i := 1 to pr-1 do
      begin
        inc(k,WheelSize);
        if k<primeLimit then
          move(myPrimes[1],myPrimes[k-WheelSize],WheelSize)
        else
        begin
          move(myPrimes[1],myPrimes[k-WheelSize],PrimeLimit-WheelSize*i);
          break;
        end;
      end;
      dec(k);
      IF k > primeLimit then
        k := primeLimit;
      wheelPrimes[wpno] := pr;
      myPrimes[pr] := false;
      inc(wpno);
      WheelSize := k;
      i:= pr;
      i := i*i;
      while i <= k do
      begin
        myPrimes[i] := false;
        inc(i,pr);
      end;
    end;
  until WheelSize >= PrimeLimit;

  while wpno > 0 do
  begin
    dec(wpno);
    myPrimes[wheelPrimes[wpno]] := true;
  end;
  myPrimes[0] := false;
  myPrimes[1] := false;
  BuildWheel  := pr+1;
end;

procedure Sieve(PrimeLimit:Uint64);
var
  myPrimes : pBoolean;
  sieveprime,
  fakt : NativeUint;
begin
  setlength(BoolPrimes,PrimeLimit+1);

  myPrimes := @BoolPrimes[0];
  sieveprime := BuildWheel(PrimeLimit);
  repeat
    if myPrimes[sieveprime] then
    begin
      fakt := PrimeLimit DIV sieveprime;
      IF fakt < sieveprime then
        BREAK;
      repeat
        myPrimes[sieveprime*fakt] := false;
        repeat
          dec(fakt);
        until myPrimes[fakt];
      until fakt < sieveprime;
    end;
    inc(sieveprime);
  until false;
  myPrimes[1] := false;
end;

procedure CnvtoBASE(var dgt:tDigits;n:Uint64;base:NativeUint);
var
  q,r: Uint64;
  i : Int32;
Begin
  i := 0;
  with dgt do
  Begin
    fillchar(dgtDgts,SizeOf(dgtDgts),#0);
    dgtNum:= n;
    repeat
      r := n;
      q := n div base;
      r  -= q*base;
      n := q;
      dgtDgts[i] := r;
      inc(i);
    until (q = 0);
    dec(i);
    dgtMaxIdx := i;

    r := 1;
    repeat
      q := dgtDgts[i];
      if r < q then
        r := q;
      dec(i);
    until i <0 ;
    dgtMaxDgtVal := r;
  end;
end;

function CnvDgtAsInBase(const dgt:tDigits;base:NativeUint):Uint64;
var
  tmpDgt,i: NativeInt;
Begin
  result := 0;
  with dgt do
  Begin
    i:= dgtMaxIdx;
    repeat
      tmpDgt := dgtDgts[i];
      result *= base;
      dec(i);
      result +=tmpDgt;
    until (i< 0);
  end;
end;

procedure IncInBaseDigits(var dgt:tDigits;base:NativeInt);
var
  i,q,tmp :NativeInt;
Begin
  with dgt do
  Begin
    tmp := dgtMaxIdx;
    i := 0;
    repeat
      q := dgtDgts[i]+1;
      q -= (-ORD(q >=base) AND base);
      dgtDgts[i] := q;
      inc(i);
    until q <> 0;
    dec(i);
    if tmp < i then
    begin
      tmp := i;
      dgtMaxIdx := i;
    end;
    i := tmp;
    repeat
      tmp := dgtDgts[i];
      if q< tmp then
        q := tmp;
      dec(i);
    until i <0;
    inc(dgtNum);
    dgtMaxDgtVal := q;
  end;
end;

function CntPrimeInBases(var Digits :tdigits;max:Int32):Uint32;
var
  pr : Uint64;
  base: Uint32;
begin
  result := 0;
  IncInBaseDigits(Digits,MAXBASE);
  base := Digits.dgtMaxDgtVal+1;
  //divisible by every base
  IF Digits.dgtDgts[0] = 0 then
    EXIT;
  IF base < MINBASE then  base := MINBASE;
// if (MAXBASE - Base) <= (max-result)  then  BREAK;
  max := (max+Base-MAXBASE);
  if (max>=0) then
    EXIT;
  for base := base TO MAXBASE do
  begin
    pr := CnvDgtAsInBase(Digits,base);
    inc(result,Ord(boolprimes[pr]));
    //no chance to reach max then exit
    if result<max then
      break;
    inc(max);
  end;
end;

function GetMaxBaseCnt(var dgt:tDigits;MinLmt,MaxLmt:Uint32):tSol;
var
  i : Uint32;
  baseCnt,max,Idx: Int32;
Begin
  setlength(result,0);
  max :=-1;
  Idx:= 0;
  For i := MinLmt to MaxLmt do
  Begin
    baseCnt := CntPrimeInBases(dgt,max);
    if baseCnt = 0 then
      continue;
    if max<=baseCnt then
    begin
      if max = baseCnt then
      begin
        inc(Idx);
        if Idx > High(result) then
          setlength(result,Idx);
        result[idx-1] := i;
      end
      else
      begin
        Idx:= 1;
        setlength(result,1);
        result[0] := i;
        max := baseCnt;
      end;
    end;
  end;
end;

function Out_String(n:Uint64;var s: AnsiString):Uint32;
//out-sourced for debugging purpose
var
  dgt:tDigits;
  sl : string[15];
  base,i: Int32;
Begin
  result := 0;
  CnvtoBASE(dgt,n,MaxBase);
  sl := '';
  with dgt do
  begin
    base:= dgtMaxDgtVal+1;
    IF base < MINBASE then
      base := MINBASE;
    i := dgtMaxIdx;
    while (i>=0)do
    Begin
      sl += CharOfBase[dgtDgts[i]+1];
      dec(i);
    end;
    s := sl+' -> [';
  end;
  For base := base to MAXBASE do
    if boolprimes[CnvDgtAsInBase(dgt,base)] then
    begin
      inc(result);
      str(base,sl);
      s := s+sl+',';
    end;
  s[length(s)] := ']';
end;

procedure Out_Sol(sol:tSol);
var
  s : AnsiString;
  i,cnt : Int32;
begin
  if length(Sol) = 0 then
    EXIT;
  for i := 0 to High(Sol) do
  begin
    cnt := Out_String(sol[i],s);
    if i = 0 then
      writeln(cnt);
    writeln(s);
  end;
  writeln;
  setlength(Sol,0);
end;

var
  dgt:tDigits;
  T0 : Int64;
  i : NativeInt;
  lmt,minLmt : UInt64;
begin
  T0 := GetTickCount64;
  lmt := 0;
  //maxvalue in Maxbase
  for i := 1 to MAXDIGITCOUNT do
    lmt :=lmt*MAXBASE+MAXBASE-1;
  writeln('max prime limit ',lmt);
  Sieve(lmt);
  writeln('Prime sieving ',(GetTickCount64-T0)/1000:6:3,' s');

  T0 := GetTickCount64;
  CnvtoBASE(dgt,0,MAXBASE);
  i := 1;
  minLmt := 1;
  repeat
    write(i:2,' character strings which are prime in count bases = ');
    Out_Sol(GetMaxBaseCnt(dgt,minLmt,MAXBASE*minLmt-1));
    minLmt *= MAXBASE;
    inc(i);
  until i>MAXDIGITCOUNT;
  writeln('   Converting ',(GetTickCount64-T0)/1000:6:3,' s');
  {$IFDEF WINDOWS} readln; {$ENDIF}
end.
