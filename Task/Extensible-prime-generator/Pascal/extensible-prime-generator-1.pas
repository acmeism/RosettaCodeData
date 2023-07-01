unit primsieve;
{$IFDEF FPC}
  {$MODE objFPC}{$Optimization ON,ALL}
{$IFEND}
{segmented sieve of Erathostenes using only odd numbers}
{using presieved sieve of small primes, to reduce the most time consuming}
interface
  procedure InitPrime;
  procedure NextSieve;
  function SieveStart:Uint64;
  function SieveSize :LongInt;
  function Nextprime: Uint64;
  function StartCount :Uint64;
  function TotalCount :Uint64;
  function PosOfPrime: Uint64;

implementation
uses
  sysutils;
const
  smlPrimes :array [0..10] of Byte = (2,3,5,7,11,13,17,19,23,29,31);
  maxPreSievePrimeNum = 7;
  maxPreSievePrime = 17;//smlPrimes[maxPreSievePrimeNum];
  cSieveSize = 16384 * 4; //<= High(Word)+1 // Level I Data Cache
type
  tSievePrim = record
                 svdeltaPrime:word;//diff between actual and new prime
                 svSivOfs:word;    //Offset in sieve
                 svSivNum:LongWord;//1 shl (1+16+32) = 5.6e14
               end;
  tpSievePrim = ^tSievePrim;

var
//sieved with primes 3..maxPreSievePrime.here about 255255 Byte
{$ALIGN 32}
  preSieve :array[0..3*5*7*11*13*17-1] of Byte;//must be > cSieveSize
{$ALIGN 32}
  Sieve :array[0..cSieveSize-1] of Byte;
{$ALIGN 32}
//prime = FoundPrimesOffset + 2*FoundPrimes[0..FoundPrimesCnt]
  FoundPrimes : array[0..cSieveSize] of word;
{$ALIGN 32}
  sievePrimes : array[0..78498] of tSievePrim;// 1e6^2 ->1e12
//  sievePrimes : array[0..664579] of tSievePrim;// maximum 1e14
  FoundPrimesOffset : Uint64;
  FoundPrimesCnt,
  FoundPrimesIdx,
  FoundPrimesTotal,
  SieveNum,
  SieveMaxIdx,
  preSieveOffset,
  LastInsertedSievePrime :NativeUInt;

procedure CopyPreSieveInSieve; forward;
procedure CollectPrimes; forward;
procedure sieveOneSieve; forward;
procedure Init0Sieve; forward;
procedure SieveOneBlock; forward;

//****************************************
procedure preSieveInit;
var
  i,pr,j,umf : NativeInt;
Begin
  fillchar(preSieve[0],SizeOf(preSieve),#1);
  i := 1;
  pr := 3;// starts with pr = 3
  umf := 1;
  repeat
    IF preSieve[i] =1 then
    Begin
      pr := 2*i+1;
      j := i;
      repeat
        preSieve[j] := 0;
        inc(j,pr);
      until j> High(preSieve);
      umf := umf*pr;
    end;
    inc(i);
  until (pr = maxPreSievePrime)OR(umf>High(preSieve)) ;
  preSieveOffset := 0;
end;

function InsertSievePrimes(PrimPos:NativeInt):NativeInt;
var
  delta    :NativeInt;
  i,pr,loLmt : NativeUInt;
begin
  i := 0;
  //ignore first primes already sieved with
  if SieveNum = 0 then
    i := maxPreSievePrimeNum;
  pr :=0;
  loLmt := Uint64(SieveNum)*(2*cSieveSize);
  delta := loLmt-LastInsertedSievePrime;
  with sievePrimes[PrimPos] do
  Begin
    pr := FoundPrimes[i]*2+1;
    svdeltaPrime := pr+delta;
    delta := pr;
  end;

  inc(PrimPos);
  for i := i+1 to FoundPrimesCnt-1 do
  Begin
    IF PrimPos > High(sievePrimes) then
      BREAK;
    with sievePrimes[PrimPos] do
    Begin
      pr := FoundPrimes[i]*2+1;
      svdeltaPrime := (pr-delta);
      delta := pr;
    end;
    inc(PrimPos);
  end;
  LastInsertedSievePrime := loLmt+pr;
  result := PrimPos;
end;

procedure CalcSievePrimOfs(lmt:NativeUint);
//lmt High(sievePrimes)
var
  i,pr : NativeUInt;
  sq : Uint64;
begin
  pr := 0;
  i := 0;
  repeat
    with sievePrimes[i] do
    Begin
      pr := pr+svdeltaPrime;
      IF sqr(pr)  < (cSieveSize*2) then
      Begin
        svSivNum := 0;
        svSivOfs := (pr*pr-1) DIV 2;
      end
      else
      Begin
        SieveMaxIdx := i;
        pr := pr-svdeltaPrime;
        BREAK;
      end;
    end;
    inc(i);
  until i > lmt;

  for i := i to lmt do
  begin
    with sievePrimes[i] do
    Begin
      pr := pr+svdeltaPrime;
      sq := sqr(pr);
      svSivNum := sq DIV (2*cSieveSize);
      svSivOfs := ( (sq - Uint64(svSivNum)*(2*cSieveSize))-1)DIV 2;
    end;
  end;
end;

procedure sievePrimesInit;
var
  i,j,pr,PrimPos:NativeInt;
Begin
  LastInsertedSievePrime := 0;
  preSieveOffset := 0;
  SieveNum :=0;
  CopyPreSieveInSieve;
  //normal sieving of first block sieve
  i := 1; // start with 3
  repeat
    while Sieve[i] = 0 do
      inc(i);
    pr := 2*i+1;
    inc(i);
    j := ((pr*pr)-1) DIV 2;
    if j > High(Sieve) then
      BREAK;
    repeat
      Sieve[j] := 0;
      inc(j,pr);
    until j > High(Sieve);
  until false;

  CollectPrimes;
  PrimPos := InsertSievePrimes(0);
  //correct for SieveNum = 0
  CalcSievePrimOfs(PrimPos);
  Init0Sieve;
  sieveOneBlock;
  //now start collect with SieveNum = 1
  IF PrimPos < High(sievePrimes) then
    repeat
      sieveOneBlock;
      CollectPrimes;
      dec(SieveNum);
      PrimPos := InsertSievePrimes(PrimPos);
      inc(SieveNum);
    until PrimPos > High(sievePrimes);
  Init0Sieve;
end;

procedure Init0Sieve;
begin
  FoundPrimesTotal :=0;
  preSieveOffset := 0;
  SieveNum :=0;
  CalcSievePrimOfs(High(sievePrimes));
end;

procedure CopyPreSieveInSieve;
var
  lmt : NativeInt;
Begin
  lmt := preSieveOffset+cSieveSize;
  lmt := lmt-(High(preSieve)+1);
  IF lmt<= 0 then
  begin
    Move(preSieve[preSieveOffset],Sieve[0],cSieveSize);
    if lmt <> 0 then
      inc(preSieveOffset,cSieveSize)
    else
      preSieveOffset := 0;
  end
  else
  begin
    Move(preSieve[preSieveOffset],Sieve[0],cSieveSize-lmt);
    Move(preSieve[0],Sieve[cSieveSize-lmt],lmt);
    preSieveOffset := lmt
  end;
end;

procedure sieveOneSieve;
var
  sp:tpSievePrim;
  pSieve :pByte;
  i,j,pr,sn,dSievNum :NativeUint;

Begin
  pr := 0;
  sn := sieveNum;
  sp := @sievePrimes[0];
  pSieve := @Sieve[0];
  For i := SieveMaxIdx downto 0 do
    with sp^ do
    begin
      pr := pr+svdeltaPrime;
      IF svSivNum = sn then
      Begin
        j := svSivOfs;
        repeat
          pSieve[j] := 0;
          inc(j,pr);
        until j > High(Sieve);
        dSievNum := j DIV cSieveSize;
        svSivOfs := j-dSievNum*cSieveSize;
        svSivNum := sn+dSievNum;
//        svSivNum := svSivNum+dSievNum;
      end;
      inc(sp);
    end;
  i := SieveMaxIdx+1;
  repeat
    if i > High(SievePrimes) then
      BREAK;
    with sp^ do
    begin
      if svSivNum > sn then
      Begin
        SieveMaxIdx := I-1;
        Break;
      end;
      pr := pr+svdeltaPrime;
      j := svSivOfs;
      repeat
        Sieve[j] := 0;
        inc(j,pr);
      until j > High(Sieve);
      dSievNum := j DIV cSieveSize;
      svSivOfs := j-dSievNum*cSieveSize;
      svSivNum := sn+dSievNum;
    end;
    inc(i);
    inc(sp);
  until false;
end;

procedure CollectPrimes;
//extract primes to FoundPrimes

var
   pSieve : pbyte;
   pFound : pWord;
   i,idx : NativeUint;
Begin
  FoundPrimesOffset := SieveNum*(2*cSieveSize);
  FoundPrimesIdx := 0;
  pFound :=@FoundPrimes[0];
  i := 0;
  idx := 0;
  IF SieveNum = 0 then
  //include small primes used to pre-sieve
  Begin
    repeat
      pFound[idx]:= (smlPrimes[idx]-1) DIV 2;
      inc(idx);
    until smlPrimes[idx]>maxPreSievePrime;
    i := (smlPrimes[idx] -1) DIV 2;
  end;
  //grabbing the primes without if then -> reduces time extremly
  //primes are born to let branch-prediction fail.
  pSieve:= @Sieve[Low(Sieve)];
  repeat
    //store every value until a prime aka 1 is found
    pFound[idx]:= i;
    inc(idx,pSieve[i]);
    inc(i);
  until i>High(Sieve);
  FoundPrimesCnt:= idx;
  inc(FoundPrimesTotal,Idx);
end;

procedure SieveOneBlock;inline;
begin
  CopyPreSieveInSieve;
  sieveOneSieve;
  CollectPrimes;
  inc(SieveNum);
end;

procedure NextSieve;inline;
Begin
  SieveOneBlock;
end;

function Nextprime:Uint64;
Begin
  result := FoundPrimes[FoundPrimesIdx]*2+1+FoundPrimesOffset;
  if (FoundPrimesIdx=0) AND (sievenum = 1) then
    inc(result);
  inc(FoundPrimesIdx);
  If FoundPrimesIdx>= FoundPrimesCnt then
    SieveOneBlock;
end;

function PosOfPrime: Uint64;inline;
Begin
  result := FoundPrimesTotal-FoundPrimesCnt+FoundPrimesIdx;
end;

function StartCount : Uint64 ;inline;
begin
  result := FoundPrimesTotal-FoundPrimesCnt;
end;

function TotalCount :Uint64;inline;
begin
  result := FoundPrimesTotal;
end;

function SieveSize :LongInt;inline;
Begin
  result := 2*cSieveSize;
end;

function SieveStart:Uint64;inline;
Begin
  result := (SieveNum-1)*2*cSieveSize;
end;

procedure InitPrime;inline;
Begin
  Init0Sieve;
  SieveOneBlock;
end;

begin
  preSieveInit;
  sievePrimesInit;
  InitPrime;
end.
