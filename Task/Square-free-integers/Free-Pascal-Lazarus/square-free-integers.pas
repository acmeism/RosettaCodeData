program SquareFree;
{$IFDEF FPC}
  {$MODE DELPHI}
{$ELSE}
   {$APPTYPE CONSOLE}
{$ENDIF}
const
  //needs 1e10 Byte = 10 Gb maybe someone got 128 Gb :-) nearly linear time
  BigLimit =   10*1000*1000*1000;
  TRILLION = 1000*1000*1000*1000;
  primeLmt = trunc(sqrt(TRILLION+150));

var
  primes : array of byte;
  sieve : array of byte;

procedure initPrimes;
var
  i,lmt,dp :NativeInt;
Begin
  setlength(primes,80000);
  setlength(sieve,primeLmt);
  sieve[0] := 1;
  sieve[1] := 1;
  i := 2;
  repeat
    IF sieve[i] = 0 then
    Begin
      lmt:= i*i;
      while lmt<primeLmt do
      Begin
        sieve[lmt] := 1;
        inc(lmt,i);
      end;
    end;
    inc(i);
  until i*i>=primeLmt;
  //extract difference of primes
  i := 0;
  lmt := 0;
  dp := 0;
  repeat
    IF sieve[i] = 0 then
    Begin
      primes[lmt] := dp;
      dp := 0;
      inc(lmt);
    end;
    inc(dp);
    inc(i);
  until i >primeLmt;
  setlength(sieve,0);
  setlength(Primes,lmt+1);
end;

procedure SieveSquares;
//mark all powers >=2 of prime  => all powers = 2 is sufficient
var
  pSieve : pByte;
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
      pSieve[k] := 1;
      inc(k,sq);
    until k> BigLimit;
  end;
end;

procedure Count_x10;
var
  pSieve : pByte;
  i,lmt,cnt: NativeInt;
begin
  writeln(' square free     count');
  writeln('[1 to limit]');

  pSieve := @sieve[0];
  lmt := 10;
  i := 1;
  cnt := 0;
  repeat
    while i <= lmt do
    Begin
      inc(cnt,ORD(pSieve[i] = 0));
      inc(i);
    end;
    writeln(lmt:12,'  ',cnt:12);
    IF lmt >= BigLimit then
      BREAK;
    lmt := lmt*10;
    IF lmt >BigLimit then
      lmt := BigLimit;
  until false;
end;

function TestSquarefree(N:Uint64):boolean;
var
  i,prime,sq : NativeUint;
Begin
  prime := 0;
  result := false;
  For i := 0 to High(primes) do
  Begin
    prime := prime+primes[i];
    sq := sqr(prime);
    IF sq> N then
      BREAK;
    IF N MOD sq = 0 then
      EXIT;
  end;
  result := true;
end;
var
  i,k : NativeInt;
Begin
  InitPrimes;
  setlength(sieve,BigLimit+1);
  SieveSquares;

  writeln('Square free numbers from 1 to 145');
  k := 80 div 4;
  For i := 1 to 145 do
    If sieve[i] = 0 then
    Begin
      write(i:4);
      dec(k);
      IF k = 0 then
      Begin
        writeln;
        k := 80 div 4;
      end;
    end;
  writeln;writeln;

  writeln('Square free numbers from ',TRILLION,' to ',TRILLION+145);
  k := 4;
  For i := TRILLION to TRILLION+145 do
  Begin
    if TestSquarefree(i) then
    Begin
      write(i:20);
      dec(k);
      IF k = 0 then
      Begin
        writeln;
        k := 4;
      end;
    end;
  end;
  writeln;writeln;

  Count_x10;
end.
