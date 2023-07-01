program Merten;
{$IFDEF FPC}
  {$MODE DELPHI}
  {$Optimization ON,ALL}
{$ELSE}
   {$APPTYPE CONSOLE}
{$ENDIF}
uses
  sysutils;
const
  BigLimit = 10*1000*1000*1000;//1e10

type
  tSieveElement = Int8;
  tpSieve = pInt8;
  tMoebVal = array[-1..1] of Int64;
var
  MertensValues : array[-40000..50500] of NativeInt;
  primes : array of byte;
  sieve : array of tSieveElement;

procedure CompactPrimes;
//searching for needed primes
//last primes are marked with -1
var
  pSieve : tpSieve;
  i,lmt,dp:NativeInt;
Begin
  setlength(Primes,74500);//suffices for primes to calc square upto 1e12
  //extract difference of primes
  i := 2;
  lmt := 0;
  dp := 2;
  pSieve :=@sieve[0];
  repeat
    IF pSieve[i]= 0 then
    Begin
      //mark for Moebius
      pSieve[i]:= -1;
      primes[lmt] := dp;
      dp := 0;
      inc(lmt);
    end;
    inc(dp);
    inc(i);
  until i*i >BigLimit;
  setlength(Primes,lmt+1);

  repeat
    IF pSieve[i]= 0 then
      //mark for Moebius
      pSieve[i]:= -1;
    inc(i);
  until i >BigLimit;
end;

procedure SieveSquares;
//mark all powers >=2 of prime  => all powers = 2 is sufficient
var
  pSieve : tpSieve;
  i,sq,k,prime : NativeInt;
Begin
  pSieve := @sieve[0];
  prime := 0;
  For i := 0 to High(primes) do
  Begin
    prime := prime+primes[i];
    sq := prime*prime;
    k := sq;
    if sq > BigLimit then
      break;
    repeat
      pSieve[k] := 0;
      inc(k,sq);
    until k> BigLimit;
  end;
end;

procedure initPrimes;
var
  pSieve : tpSieve;
  fakt,
  sieveprime : NativeUint;
begin
  pSieve := @sieve[0];
  sieveprime := 2;
  repeat
    if pSieve[sieveprime]=0 then
    begin
      fakt := sieveprime+sieveprime;
      while fakt <=BigLimit do
      Begin
        //count divisors
        inc(pSieve[fakt]);
        inc(fakt,sieveprime);
      end;
    end;
    inc(sieveprime);
  until sieveprime>BigLimit DIV 2;
  //Möbius of 1
  pSieve[1] := 1;

  //convert to Moebius
  For fakt := 2 to BigLimit do
  Begin
    sieveprime := pSieve[fakt];
    IF sieveprime<>0 then
      pSieve[fakt] := 1-(2*(sieveprime AND 1)) ;
  end;
  CompactPrimes;
  SieveSquares;
end;

procedure OutMerten10(Lmt,ZeroCross:NativeInt;Const MoebVal:tMoebVal);
var
  i,j: NativeInt;
Begin
  Writeln(lmt:11,MoebVal[-1]:11,MoebVal[1]:11,MoebVal[-1]+MoebVal[1]:11,
  MoebVal[-1]-MoebVal[1]:7,MoebVal[0]:11);
  i:= low(MertensValues);
  while MertensValues[i] = 0 do
    inc(i);
  j:= High(MertensValues);
  while MertensValues[j] = 0 do
    dec(j);
  write('Merten min ',i:6,' max ',j:6,' zero''s ',MertensValues[0]:8);
  writeln(' zeroCross ',ZeroCross);
  writeln;
end;

procedure Count_x10;
var
  MoebCount: tMoebVal;
  pSieve : tpSieve;
  i,lmt,Merten,Moebius,LastMert,ZeroCross: NativeInt;
begin
  writeln('[1 to limit]');
  Writeln('Limit        Moeb. odd   Moeb.even  sqr-free Merten     Zero''s');

  pSieve := @sieve[0];
  For i := -1 to 1 do
    MoebCount[i]:=0;
  ZeroCross := 0;
  LastMert :=1;
  Merten :=0;
  lmt := 10;
  i := 1;
  repeat
    while i <= lmt do
    Begin
      Moebius := pSieve[i];
      inc(MoebCount[Moebius]);
      inc(Merten,Moebius);
      inc(MertensValues[Merten]);//MoebCount[1]-MoebCount[-1]]);
      inc(ZeroCross,ORD( (Merten = 0) AND (LastMert <> 0)));
      LastMert := Merten;
      inc(i);
    end;
    OutMerten10(Lmt,ZeroCross,MoebCount);

    IF lmt >= BigLimit then
      BREAK;
    lmt := lmt*10;
    IF lmt >BigLimit then
      lmt := BigLimit;
  until false;
  writeln;
end;

procedure OutMerten(lmt:NativeInt);
var
  i,k,m : NativeInt;
Begin
  iF lmt> BigLimit then
    lmt := BigLimit;
  writeln('Mertens numbers from 1 to ',lmt);
  k := 9;
  write('':3);
  m := 0;
  For i := 1 to lmt do
  Begin
    inc(m,sieve[i]);
    write(m:3);
    dec(k);
    IF k = 0 then
    Begin
      writeln;
      k := 10;
    end;
  end;
  writeln;
end;

procedure OutMoebius(lmt:NativeInt);
var
  i,k : NativeInt;
Begin
  iF lmt> BigLimit then
    lmt := BigLimit;
  writeln('Möbius numbers from 1 to ',lmt);
  k := 19;
  write('':3);
  For i := 1 to lmt do
  Begin
    write(sieve[i]:3);
    dec(k);
    IF k = 0 then
    Begin
      writeln;
      k := 20;
    end;
  end;
  writeln;
end;

Begin
  setlength(sieve,BigLimit+1);
  InitPrimes;
  SieveSquares;
  Count_x10;
  OutMoebius(199);
  OutMerten(99);
  setlength(primes,0);
  setlength(sieve,0);
end.
