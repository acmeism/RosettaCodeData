program primesieve;
// sieving small ranges of 65536
//{$O+,R+}
{$IFDEF FPC}
  {$MODE DELPHI}{$OPTIMIZATION ON,ALL}{$CODEALIGN proc=32}
  uses
    sysutils;
{$ENDIF}
{$IFDEF WINDOWS}
  {$APPTYPE CONSOLE}
{$ENDIF}

const
  smlPrimes :array [0..10] of Byte = (2,3,5,7,11,13,17,19,23,29,31);
  maxPreSievePrime = 17;
  sieveSize = 1 shl 15;//32768*2 ->max count of FoundPrimes = 6542
type
  tSievePrim = record
                 svdeltaPrime:word;//diff between actual and new prime
                 svSivOfs:word;//-> sieveSize< 1 shl 16
                 svSivNum:LongWord;// 1 shl (16+32) = 2.8e14
               end;
var
{$Align 16}
  //primes up to 1E6-> sieving to 1E12
  sievePrimes : array[0..78497] of tSievePrim;
{$Align 16}
  preSieve :array[0..3*5*7*11*13*17-1] of Byte;
{$Align 16}
  Sieve :array[0..sieveSize-1] of Byte;
{$Align 16}
  FoundPrimes : array[0..6542] of LongWord;
{$Align 16}
  Gaps  : array[0..255] Of Uint64;
{$Align 16}
  Limit,OffSet : Uint64;

  SieveMaxIdx,
  preSieveOffset,
  SieveNum,
  FoundPrimesCnt,
  PrimPos,
  LastInsertedSievePrime :NativeUInt;

procedure CopyPreSieveInSieve;forward;
procedure CollectPrimes;forward;
procedure sieveOneSieve;forward;

procedure preSieveInit;
var
  i,pr,j,umf : NativeInt;
Begin
  fillchar(preSieve[0],SizeOf(preSieve),#1);
  i := 1;// starts with pr = 3
  umf := 1;
  repeat
    IF preSieve[i] <> 0 then
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
  until umf>High(preSieve);
  preSieveOffset := 0;
end;

procedure CalcSievePrimOfs(lmt:NativeUint);
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
      IF sqr(pr)  < (SieveSize*2) then
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
      svSivNum := sq DIV (2*SieveSize);
      svSivOfs := ( (sq - Uint64(svSivNum)*(2*SieveSize))-1)DIV 2;
    end;
  end;
end;

procedure InitSieve;
begin
  preSieveOffset := 0;
  SieveNum :=0;
  CalcSievePrimOfs(PrimPos-1);
end;

procedure InsertSievePrimes;
var
  j    :NativeUINt;
  i,pr : NativeUInt;
begin
  i := 0;
  //ignore first primes already sieved with
  if SieveNum = 0 then
    repeat
      inc(i);
    until FoundPrimes[i] > maxPreSievePrime;

  pr :=0;
  j := Uint64(SieveNum)*SieveSize*2-LastInsertedSievePrime;
  with sievePrimes[PrimPos] do
  Begin
    pr := FoundPrimes[i];
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
      pr := FoundPrimes[i];
      svdeltaPrime := (pr-j);
      j := pr;
    end;
    inc(PrimPos);
  end;
  LastInsertedSievePrime :=Uint64(SieveNum)*(SieveSize*2)+pr;
end;

procedure sievePrimesInit;
var
  i,j,pr:NativeInt;
Begin
  LastInsertedSievePrime := 0;

  PrimPos := 0;
  preSieveOffset := 0;
  SieveNum :=0;
  CopyPreSieveInSieve;
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
  InsertSievePrimes;
  IF PrimPos < High(sievePrimes) then
  Begin
    InitSieve;
    //Erste Sieb nochmals, aber ohne Eintrag
    CopyPreSieveInSieve;
    sieveOneSieve;
    repeat
      inc(SieveNum);
      CopyPreSieveInSieve;
      sieveOneSieve;
      CollectPrimes;
      InsertSievePrimes;
   until PrimPos > High(sievePrimes);
  end;
end;

procedure OutGaps(g1,g2,delta:NativeUint);
begin
  if g2= 0  then
    writeln(2*g1:4,2*g1+2:4,delta:13,Gaps[g1]:13,Gaps[g1+1]:13)
  else
   writeln(2*g2-1:4,2*g1:4,delta:13,Gaps[g1-1]:13,Gaps[g1]:13);
end;
function GetDiffval(val1,val2: NativeInt): NativeInt;
begin
  if val1*val2 = 0 then
    EXIT(0);
  dec(val1,val2);
  if val1<0 then
    val1 :=-val1;
  GetDiffval := val1;
end;

procedure CheckGaps;
var
  val1,val2,val3,i,DekaLimit : NativeInt;
Begin
  writeln('Gap1 Gap2   difference       first       second  prime');
  dekaLimit := 10;
  i := 1;
  repeat
    val1 := Gaps[i];
    if val1 <> 0 then
    Begin
      val2 := GetDiffval(val1,Gaps[i-1]);
      val3 := GetDiffval(val1,Gaps[i+1]);
      while (val2>DekaLimit) or (val3>DekaLimit) do
      begin
        writeln(DekaLimit:21,'<');
        if val2 = 0 then
        begin
          if val3 > 0 then
            OutGaps(i,0,val3);
        end
        else
        begin
          if val3 = 0 then
            OutGaps(i,1,val2)
          else
          Begin
            if val3 > val2 then
              OutGaps(i,0,val3)
            else
              OutGaps(i,1,val2);
          end;
        end;
        DekaLimit := 10*DekaLimit;
      end;
    end;
    inc(i);
  until i>=254;
end;

procedure CopyPreSieveInSieve;
var
  lmt : NativeInt;
Begin
  lmt := preSieveOffset+sieveSize;
  lmt := lmt-(High(preSieve)+1);
  IF lmt<= 0 then
  begin
    Move(preSieve[preSieveOffset],Sieve[0],sieveSize);
    if lmt <> 0 then
      inc(preSieveOffset,sieveSize)
    else
      preSieveOffset := 0;
  end
  else
  begin
    Move(preSieve[preSieveOffset],Sieve[0],sieveSize-lmt);
    Move(preSieve[0],Sieve[sieveSize-lmt],lmt);
    preSieveOffset := lmt
  end;
end;

procedure CollectPrimes;
var
   pSieve : pbyte;
   pFound : pLongWord;
   i,idx : NativeInt;
Begin
  pFound := @FoundPrimes[0];
  idx := 0;
  i := 0;
  IF SieveNum = 0 then
  Begin
    repeat
      pFound[idx] := smlPrimes[idx];
      inc(idx);
    until smlPrimes[idx]>maxPreSievePrime;
    i := (smlPrimes[idx] -1) DIV 2;
  end;

  pSieve := @Sieve[0];
  repeat
    pFound[idx]:= 2*i+1;
    inc(idx,pSieve[i]);
    inc(i);
  until i>High(Sieve);
  FoundPrimesCnt:= idx;
end;

procedure sieveOneSieve;
var
  i,j,pr,dSievNum :NativeUint;
Begin
  pr := 0;
  For i := 0 to SieveMaxIdx do
    with sievePrimes[i] do
    begin
      pr := pr+svdeltaPrime;
      IF svSivNum = sieveNum then
      Begin
        j := svSivOfs;
        repeat
          Sieve[j] := 0;
          inc(j,pr);
        until j > High(Sieve);

        dSievNum := j DIV SieveSize;
        svSivOfs := j-dSievNum*SieveSize;
        inc(svSivNum,dSievNum);
      end;
    end;

  i := SieveMaxIdx+1;
  repeat
    if i > High(SievePrimes) then
      BREAK;
    with sievePrimes[i] do
    begin
      if svSivNum > sieveNum then
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
      dSievNum := j DIV SieveSize;
      svSivOfs := j-dSievNum*SieveSize;
      inc(svSivNum,dSievNum);
      inc(i);
    end;
  until false;
end;

var
  T1,T0,CNT,ActPrime,LastPrime,delta : Int64;
  i: Int32;

begin
  T0 := GetTickCount64;
  Limit := 10*1000*1000*1000;//158*1000*1000*1000;
  preSieveInit;
  sievePrimesInit;

  InitSieve;
  offset := 0;
  Cnt := 1;//==2
  LastPrime := 2;


  repeat
    CopyPreSieveInSieve;sieveOneSieve;CollectPrimes;
    inc(Cnt,FoundPrimesCnt);
    //collect first occurrence of gap
    i := 0;
    repeat
      ActPrime := Offset+FoundPrimes[i];
      delta := (ActPrime - LastPrime) shr 1;
      If Gaps[delta] = 0 then
        Gaps[delta] := LastPrime;
      LastPrime := ActPrime;
      inc(i);
    until (i >= FoundPrimesCnt);

    inc(SieveNum);
    inc(offset,2*SieveSize);
  until SieveNum > (Limit DIV (2*SieveSize));
  CheckGaps;
  T1 := GetTickCount64;
  OffSet := Uint64(SieveNum-1)*(2*SieveSize);


  i := FoundPrimesCnt;
  repeat
    dec(i);
    dec(cnt);
  until (i = 0) OR (OffSet+FoundPrimes[i]<Limit);
  writeln;
  writeln(cnt,' in ',Limit,' takes ',T1-T0,' ms');
  {$IFDEF WINDOWS}
  writeln('Press <Enter>');readln;
  {$ENDIF}
end.
