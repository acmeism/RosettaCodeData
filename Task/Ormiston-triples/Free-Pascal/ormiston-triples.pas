program Ormiston;
{$IFDEF FPC}{$MODE DELPHI} {$OPTIMIZATION ON,ALL}{$ENDIF}
{$IFDEF WINDOWS}{$APPLICATION CONSOLE}{$ENDIF}

uses
  sysutils,strUtils;

//********* segmented sieve of erathostenes *********
{segmented sieve of Erathostenes using only odd numbers}
{using presieved sieve of small primes, to reduce the most time consuming}
const
  smlPrimes :array [0..10] of Byte = (2,3,5,7,11,13,17,19,23,29,31);
  maxPreSievePrimeNum = 7;
  maxPreSievePrime = 17;//smlPrimes[maxPreSievePrimeNum];
  cSieveSize = 4*16384;//<= High(Word)+1 // Level I Data Cache
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
  FoundPrimes : array[0..12252] of Word;
{$ALIGN 32}
  sievePrimes : array[0..1077863] of tSievePrim;
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
  j    :NativeUINt;
  i,pr : NativeUInt;
begin
  i := 0;
  //ignore first primes already sieved with
  if SieveNum = 0 then
    i := maxPreSievePrimeNum;
  pr :=0;
  j := Uint64(SieveNum)*cSieveSize*2-LastInsertedSievePrime;
  with sievePrimes[PrimPos] do
  Begin
    pr := FoundPrimes[i]*2+1;
    svdeltaPrime := pr+j;
    j := pr;
  end;
  inc(PrimPos);
  for i := i+1 to FoundPrimesCnt-1 do
  Begin
    IF PrimPos > High(sievePrimes) then
      BREAK;
    with sievePrimes[PrimPos] do
    Begin
      pr := FoundPrimes[i]*2+1;
      svdeltaPrime := (pr-j);
      j := pr;
    end;
    inc(PrimPos);
  end;
  LastInsertedSievePrime :=Uint64(SieveNum)*cSieveSize*2+pr;
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
  //normal sieving of first sieve
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
  LastInsertedSievePrime := FoundPrimes[PrimPos]*2+1;

  IF PrimPos < High(sievePrimes) then
  Begin
    Init0Sieve;
    sieveOneBlock;
    repeat
      sieveOneBlock;
      dec(SieveNum);
      PrimPos := InsertSievePrimes(PrimPos);
      inc(SieveNum);
   until PrimPos > High(sievePrimes);
  end;
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
  FoundPrimesOffset := SieveNum*2*cSieveSize;
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

procedure SieveOneBlock;
begin
  CopyPreSieveInSieve;
  sieveOneSieve;
  CollectPrimes;
  inc(SieveNum);
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

procedure InitPrime;
Begin
  Init0Sieve;
  SieveOneBlock;
end;
//********* segmented sieve of erathostenes *********

const
  Limit= 10*1000*1000*1000;
type
  tDigits10 = array[0..15] of byte;
  td10_UsedDgts2 = array[0..3] of  Uint32;
  td10_UsedDgts3 = array[0..1] of  Uint64;
  tpd10_UsedDgts3 = ^td10_UsedDgts3;

procedure OutIn(cnt,p1:NativeInt);
Begin
  write(Numb2USA(IntToStr(p1)):13,' ');
  if cnt MOD 5 = 0 then
     writeln;
end;

function OutByPot10(cnt,prLimit:NativeInt):NativeInt;
Begin
  writeln(Numb2USA(IntToStr(cnt)):12,' Ormiston triples before ',Numb2USA(IntToStr(prLimit)):14);
  result := 10*prLimit;
end;

function Convert2Digits10(p:NativeUint):Uint64;inline;
const
  smlPrimes : array[0..9] of integer = (2,3,5,7,11,13,17,19,23,29);
var
  r : NativeUint;
begin
  result := 1;
  repeat
    r := p DIV 10;
    result := result*smlPrimes[p-10*r];
    p := r;
  until r = 0;
end;
{$align 32}
var
  IsMod18 : array[0..(1000 DIV 18)*18] of boolean;
procedure OneRun;
var
{$align 32}
  p1 : Uint64;
  pr1,pr2,pr3,prLimit :nativeUInt;
  cnt,prCnt : NativeUint;
begin
  pr1 := 0;
  pr2 := 0;
  prCnt := 0;
  prLimit := 10*1000*1000;
  repeat
    inc(prCnt);
    pr3 := pr2;
    pr2 := pr1;
    pr1 := nextprime;
  until pr1 > prLimit;
  prLimit *= 10;

  cnt := 0;
  repeat
    inc(prCnt);
    if IsMod18[pr2-pr3] then
    begin
      p1 := Convert2Digits10(pr3);
      if Convert2Digits10(pr2) = p1 then
        if IsMod18[pr1-pr2] then
        begin
          if Convert2Digits10(pr1) =p1 then
          begin
            inc(cnt);
            IF cnt <= 25 then
              OutIn(cnt,pr1);
          end
        end
    end;
    if pr1 >=prLimit then
      prlimit:= OutByPot10(cnt,prlimit);
    pr3 := pr2;
    pr2 := pr1;
    pr1 := nextprime;
  until pr2 > limit;
  writeln(' prime count ',prCnt);
  writeln(' last primes ',pr3:12,pr2:12,pr1:12);
end;

var
  j :Int32;
Begin
  preSieveInit;
  sievePrimesInit;
  InitPrime;

  j := 0;
  while j < High(IsMod18)do
  Begin
    IsMod18[j] := true;
    j += 18;
  end;

  OneRun;
end.
