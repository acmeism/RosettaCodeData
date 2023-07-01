program WeakPrim;
{$IFNDEF FPC}
  {$AppType CONSOLE}
{$ENDIF}
const
  PrimeLimit = 1000*1000*1000;//must be >= 2*3;
type
  tLimit = 0..(PrimeLimit-1) DIV 2;
  tPrimCnt = 0..51*1000*1000;
  tWeakStrong = record
                   strong,
                   balanced,
                   weak : NativeUint;
                end;
var
  primes: array [tLimit] of byte; //always initialized with 0 at startup
  delta : array [tPrimCnt] of byte;
  cntWS : tWeakStrong;
  deltaCnt :NativeUint;

procedure sieveprimes;
//Only odd numbers, minimal count of strikes
var
  spIdx,sieveprime,sievePos,fact :NativeUInt;
begin
  spIdx := 1;
  repeat
    if primes[spIdx]=0 then
    begin
      sieveprime := 2*spIdx+1;
      fact := PrimeLimit DIV sieveprime;
      if Not(odd(fact)) then
        dec(fact);
      IF fact < sieveprime then
        BREAK;
      sievePos := ((fact*sieveprime)-1) DIV 2;
      fact := (fact-1) DIV 2;
      repeat
        primes[sievePos] := 1;
        repeat
          dec(fact);
          dec(sievePos,sieveprime);
        until primes[fact]= 0;
      until fact < spIdx;
    end;
    inc(spIdx);
  until false;
end;
{ Not neccessary for this small primes.
procedure EmergencyStop(i:NativeInt);
Begin
  Writeln( 'STOP at ',i,'.th prime');
  HALT(i);
end;
}
function GetDeltas:NativeUint;
//Converting prime positions into distance
var
  i,j,last : NativeInt;
Begin
  j :=0;
  i := 1;
  last :=1;
  For i := 1 to High(primes) do
    if primes[i] = 0 then
    Begin
      //IF i-last > 255 {aka delta prim > 512} then  EmergencyStop (j);
      delta[j] := i-last;
      last := i;
      inc(j);
   end;
   GetDeltas := j;
end;

procedure OutHeader;
Begin
  writeln('Limit':12,'Strong':10,'balanced':12,'weak':10);
end;

procedure OutcntWS (const cntWS : tWeakStrong;Lmt:NativeInt);
Begin
  with cntWS do
    writeln(lmt:12,Strong:10,balanced:12,weak:10);
end;

procedure CntWeakStrong10(var Out:tWeakStrong);
// Output a table of values for strang/balanced/weak for 10^n
var
  idx,diff,prime,lmt :NativeInt;
begin
  OutHeader;
  lmt := 10;
  fillchar(Out,SizeOf(Out),#0);
  idx := 0;
  prime:=3;
  repeat
    dec(prime,2*delta[idx]);
    while idx < deltaCnt do
    Begin
      inc(prime,2*delta[idx]);
      IF prime > lmt then
         BREAK;

      diff := delta[idx] - delta[idx+1];
      if diff>0 then
        inc(Out.strong)
      else
        if diff< 0 then
          inc(Out.weak)
        else
          inc(Out.balanced);

      inc(idx);
    end;
    OutcntWS(Out,Lmt);
    lmt := lmt*10;
  until Lmt >  PrimeLimit;
end;

procedure WeakOut(cnt:NativeInt);
var
  idx,prime : NativeInt;
begin
  Writeln('The first ',cnt,' weak primes');
  prime:=3;
  idx := 0;
  repeat
    inc(prime,2*delta[idx]);
    if delta[idx] - delta[idx+1]< 0 then
    Begin
      write(prime,' ');
      dec(cnt);
      IF cnt <=0 then
        BREAK;
    end;
    inc(idx);
  until idx >= deltaCnt;
  Writeln;
end;

procedure StrongOut(cnt:NativeInt);
var
  idx,prime : NativeInt;
begin
  Writeln('The first ',cnt,' strong primes');
  prime:=3;
  idx := 0;
  repeat
    inc(prime,2*delta[idx]);
    if delta[idx] - delta[idx+1]> 0 then
    Begin
      write(prime,' ');
      dec(cnt);
      IF cnt <=0 then
        BREAK;
    end;
    inc(idx);
  until idx >= deltaCnt;
  Writeln;
end;

begin
  sieveprimes;
  deltaCnt := GetDeltas;

  StrongOut(36);
  WeakOut(37);
  CntWeakStrong10(CntWs);
end.
