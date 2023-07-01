program Magnanimous;
//Magnanimous Numbers
//algorithm find only numbers where all digits are even except the last
//or where all digits are odd except the last
//so 1,11,20,101,1001 will not be found
//starting at 100001  "1>"+x"0"+"1" is not prime because of 1001 not prime
{$IFDEF FPC}
  {$MODE DELPHI}
  {$Optimization ON}
  {$CODEALIGN proc=16}
{$ELSE}
  {$APPTYPE CONSOLE}
{$ENDIF}
{$DEFINE USE_GMP}
uses
  //strUtils, // commatize Numb2USA
  {$IFDEF USE_GMP}gmp,{$ENDIF}
  SysUtils;
const
  MaxLimit = 10*1000*1000 +10;
  MAXHIGHIDX = 10;
type
   tprimes = array of byte;
   tBaseType = Byte;
   tpBaseType = pByte;
   tBase =array[0..15] of tBaseType;
   tNumType = NativeUint;
   tSplitNum = array[0..15] of tNumType;
   tMagList  = array[0..1023] of Uint64;
var
  {$ALIGN 32}
  MagList : tMagList;

  dgtBase5,  // count in Base 5
  dgtORMask, //Mark of used digit (or (1 shl Digit ))
  dgtEvenBase10,
  dgtOddBase10: tbase;

  primes : tprimes;
  {$IFDEF USE_GMP} z : mpz_t;gmp_count :NativeUint;{$ENDIF}
  pPrimes0 : pByte;
  T0: int64;
  HighIdx,num,MagIdx,count,cnt: NativeUint;

  procedure InitPrimes;
  const
    smallprimes :array[0..5] of byte = (2,3,5,7,11,13);
  var
    pPrimes : pByte;
    p,i,j,l : NativeUint;
  begin
    l := 1;
    for j := 0 to High(smallprimes) do
      l*= smallprimes[j];
    //scale primelimit to be multiple of l
    i :=((MaxLimit-1) DIV l+1)*l+1;//+1 should suffice
    setlength(primes,i);
    pPrimes := @primes[0];

    for j := 0 to High(smallprimes) do
    begin
      p := smallprimes[j];
      i := p;
      if j <> 0 then
        p +=p;
      while i <= l do
      begin
        pPrimes[i] := 1;
        inc(i,p)
      end;
    end;
    //turn the prime wheel
    for p := length(primes) div l -1 downto 1 do
      move(pPrimes[1],pPrimes[p*l+1],l);

    l := High(primes);
    //reinsert smallprimes
    for j := 0 to High(smallprimes) do
      pPrimes[smallprimes[j]] := 0;
    pPrimes[1]:=1;
    pPrimes[0]:=1;

    p := smallprimes[High(smallprimes)];
    repeat
      repeat
        inc(p)
      until pPrimes[p] = 0;
      j :=  l div p;
      while (pPrimes[j]<> 0) AND (j>=p) do
        dec(j);
      if j<p then
        BREAK;
      //delta  going downwards no factor 2,3 :-2 -4 -2 -4
      i := (j+1) mod 6;
      if i = 0 then
        i :=4;
      repeat
        while (pPrimes[j]<> 0) AND (j>=p) do
        begin
          dec(j,i);
          i := 6-i;
        end;
        if j<p then
          BREAK;
        pPrimes[j*p] := 1;
        dec(j,i);
        i := 6-i;
      until j<p;
    until false;

    pPrimes0 := pPrimes;
  end;

  procedure InsertSort(pMag:pUint64; Left, Right : NativeInt );
  var
    I, J: NativeInt;
    Pivot : Uint64;
  begin
    for i:= 1 + Left to Right do
    begin
      Pivot:= pMag[i];
      j:= i - 1;
      while (j >= Left) and (pMag[j] > Pivot) do
      begin
        pMag[j+1]:=pMag[j];
        Dec(j);
      end;
      pMag[j+1]:= pivot;
    end;
  end;

  procedure OutBase5;
  var
    pb: tpBaseType;
    i : NativeUint;
  begin
    write(count :10);
    pb:= @dgtBase5[0];
    for i := HighIdx downto 0 do
      write(pb[i]:3);
    write(' : ' );
    pb:= @dgtORMask[0];
    for i := HighIdx downto 0 do
      write(pb[i]:3);
  end;

  function Base10toNum(var dgtBase10: tBase):NativeUint;
  var
    i : NativeInt;
  begin
    Result := 0;
    for i := HighIdx downto 0 do
      Result := Result * 10 + dgtBase10[i];
  end;

  procedure OutSol(cnt:Uint64);
  begin
    writeln(MagIdx:4,cnt:13,Base10toNum(dgtOddBase10):20,
           (Gettickcount64-T0) / 1000: 10: 3, ' s');
  end;

  procedure CnvEvenBase10(lastIdx:NativeInt);
  var
    pdgt : tpBaseType;
    idx: nativeint;
  begin
    pDgt := @dgtEvenBase10[0];
    for idx := lastIdx downto 1 do
      pDgt[idx] := 2 * dgtBase5[idx];
    pDgt[0] := 2 * dgtBase5[0]+1;
  end;

  procedure CnvOddBase10(lastIdx:NativeInt);
  var
    pdgt : tpBaseType;
    idx: nativeint;
  begin
    pDgt := @dgtOddBase10[0];
    //make all odd
    for idx := lastIdx downto 1 do
      pDgt[idx] := 2 * dgtBase5[idx] + 1;
    //but the lowest even
    pDgt[0] := 2 * dgtBase5[0];
  end;

  function IncDgtBase5:NativeUint;
  // increment n base 5 until resulting sum of split number
  // can't end in 5
  var
    pb: tpBaseType;
    n,i: nativeint;
  begin
    result := 0;
    repeat
      repeat
        //increment Base5
        pb:= @dgtBase5[0];
         i := 0;
        repeat
          n := pb[i] + 1;
          if n < 5 then
          begin
            pb[i] := n;
            break;
          end;
          pb[i] := 0;
          Inc(i);
        until False;

        if HighIdx < i then
        begin
          HighIdx := i;
          pb[i] := 0;
        end;

        if result < i then
          result := i;

        n := dgtORMask[i+1];
        while i >= 0 do
        begin
          n := n OR (1 shl pb[i]);
          dgtORMask[i]:= n;
          if n = 31 then
            break;
          dec(i);
        end;

        if HighIdx<4 then
          break;

        if (n <> 31) OR (i=0) then
          break;
        //Now there are all digits are used at digit i ( not in last pos)
        //this will always lead to a number ending in 5-> not prime
        //so going on with a number that will change the used below i to highest digit
        //to create an overflow of the next number, to change the digits
        dec(i);
        repeat
          pb[i] := 4;
          dgtORMask[i]:= 31;
          dec(i);
        until i < 0;

      until false;
      if HighIdx<4 then
        break;

      n := dgtORMask[1];
      //ending in 5. base10(base5) for odd 1+4(0,2),3+2(1,1),5+0(2,0)
      i := pb[0];
      if i <= 2 then
      begin
        i := 1 shl (2-i);
      end
      else
      Begin
        //ending in 5 7+8(3,4),9+6(4,3)
        i := 1 shl (4-i);
        n := n shr 3;
      end;
      if (i AND n) = 0 then
        BREAK;
    until false;
  end;

  procedure CheckMagn(var dgtBase10: tBase);
  //split number into sum of all "partitions" of digits
  //check if sum is always prime
  //1234 -> 1+234,12+34 ;123+4
  var
    LowSplitNum : tSplitNum;
    i,fac,n: NativeInt;
    isMagn : boolean;
  Begin
    n := 0;
    fac := 1;
    For i := 0 to HighIdx-1 do
    begin
      n := fac*dgtBase10[i]+n;
      fac *=10;
      LowSplitNum[HighIdx-1-i] := n;
    end;

    n := 0;
    fac := HighIdx;
    isMagn := true;

    For i := 0 to fac-1 do
    begin
      //n = HighSplitNum[i]
      n := n*10+dgtBase10[fac-i];
      LowSplitNum[i] += n;
      if LowSplitNum[i]<=MAXLIMIT then
      begin
        isMagn := isMagn AND (pPrimes0[LowSplitNum[i]] = 0);
        if NOT(isMagn) then
          EXIT;
      end;
    end;
    {$IFDEF USE_GMP}
    For i := 0 to fac-1 do
    begin
      n := LowSplitNum[i];
      if n >MAXLIMIT then
      Begin
//      IF NOT((n mod 30) in [1,7,11,13,17,19,23,29]) then    EXIT;
        mpz_set_ui(z,n);
        gmp_count +=1;
        isMagn := isMagn AND (mpz_probab_prime_p(z,1) >0);
        if NOT(isMagn) then
          EXIT;
      end;
    end;

   {$ENDIF}
    //insert magnanimous numbers
    num := Base10toNum(dgtBase10);
    MagList[MagIdx] := num;
    inc(MagIdx);
  end;

function Run(StartDgtCount:byte):Uint64;
var
  lastIdx: NativeInt;
begin
  result := 0;
  HighIdx := StartDgtCount;// 7 start with 7 digits
  LastIdx := HighIdx;
  repeat
    if dgtBase5[HighIdx] <> 0 then
    Begin
      CnvEvenBase10(LastIdx);
      CheckMagn(dgtEvenBase10);
    end;
    CnvOddBase10(LastIdx);
    CheckMagn(dgtOddBase10);
    inc(result);
    //output for still running every 16.22 Mio
    IF result AND (1 shl 22-1) = 0 then
      OutSol(result);

    lastIdx := IncDgtBase5;
  until HighIdx > MAXHIGHIDX;

end;

BEGIN
  {$IFDEF USE_GMP}mpz_init_set_ui(z,0);{$ENDIF}
  T0 := Gettickcount64;
  InitPrimes;
  T0 -= Gettickcount64;
  writeln('getting primes ',-T0 / 1000: 0: 3, ' s');
  T0 := Gettickcount64;
  fillchar(dgtBase5,SizeOf(dgtBase5),#0);
  fillchar(dgtEvenBase10,SizeOf(dgtEvenBase10),#0);
  fillchar(dgtOddBase10,SizeOf(dgtOddBase10),#0);
//Magnanimous Numbers that can not be found by this algorithm
  MagIdx := 0;
  MagList[MagIdx] := 1;inc(MagIdx);
  MagList[MagIdx] := 11;inc(MagIdx);
  MagList[MagIdx] := 20;inc(MagIdx);
  MagList[MagIdx] := 101;inc(MagIdx);
  MagList[MagIdx] := 1001;inc(MagIdx);
  //cant be checked easy for ending in 5
  MagList[MagIdx] := 40001;inc(MagIdx);
  {$IFDEF USE_GMP} mpz_init_set_ui(z,0);{$ENDIF}

  count := Run(0);

  writeln;
  CnvOddBase10(highIdx);
  writeln(MagIdx:5,count:12,Base10toNum(dgtOddBase10):18,
           (Gettickcount64-T0) / 1000: 10: 3, ' s');
  InsertSort(@MagList[0],0,MagIdx-1);

  {$IFDEF USE_GMP} mpz_clear(z);writeln('Count of gmp tests ',gmp_count);{$ENDIF}
  For cnt := 0 to MagIdx-1 do
    writeln(cnt+1:3,'   ',MagList[cnt]);
  {$IFDEF WINDOWS}
    readln;
  {$ENDIF}
end.
