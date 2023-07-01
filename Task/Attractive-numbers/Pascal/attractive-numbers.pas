program AttractiveNumbers;
{ numbers with count of factors = prime
* using modified sieve of erathosthes
* by adding the power of the prime to multiples
* of the composite number }
{$IFDEF FPC}
  {$MODE DELPHI}
{$ELSE}
   {$APPTYPE CONSOLE}
{$ENDIF}
uses
  sysutils;//timing
const
  cTextMany = ' with many factors     ';
  cText2    = ' with only two factors ';
  cText1    = ' with only one factor  ';
type
  tValue = LongWord;
  tpValue = ^tValue;
  tPower = array[0..63] of tValue;//2^64

var
  power : tPower;
  sieve : array of byte;

function NextPotCnt(p: tValue):tValue;
//return the first power <> 0
//power == n to base prim
var
  i : NativeUint;
begin
  result := 0;
  repeat
    i := power[result];
    Inc(i);
    IF i < p then
      BREAK
    else
    begin
      i := 0;
      power[result]  := 0;
      inc(result);
    end;
  until false;
  power[result] := i;
  inc(result);
end;

procedure InitSieveWith2;
//the prime 2, because its the first one, is the one,
//which can can be speed up tremendously, by moving
var
  pSieve : pByte;
  CopyWidth,lmt : NativeInt;
Begin
  pSieve := @sieve[0];
  Lmt := High(sieve);
  sieve[1] := 0;
  sieve[2] := 1; // aka 2^1 -> one factor
  CopyWidth := 2;

  while CopyWidth*2 <= Lmt do
  Begin
    // copy idx 1,2 to 3,4 | 1..4 to 5..8 | 1..8 to 9..16
    move(pSieve[1],pSieve[CopyWidth+1],CopyWidth);
    // 01 -> 0101 -> 01020102-> 0102010301020103
    inc(CopyWidth,CopyWidth);//*2
    //increment the factor of last element by one.
    inc(pSieve[CopyWidth]);
    //idx    12    1234    12345678
    //value  01 -> 0102 -> 01020103-> 0102010301020104
  end;
  //copy the rest
  move(pSieve[1],pSieve[CopyWidth+1],Lmt-CopyWidth);

  //mark 0,1 not prime, 255 factors are today not possible 2^255 >> Uint64
  sieve[0]:= 255;
  sieve[1]:= 255;
  sieve[2]:= 0;   // make prime again
end;

procedure OutCntTime(T:TDateTime;txt:String;cnt:NativeInt);
Begin
   writeln(cnt:12,txt,T*86400:10:3,' s');
end;

procedure sievefactors;
var
  T0 : TDateTime;
  pSieve : pByte;
  i,j,i2,k,lmt,cnt : NativeUInt;
Begin
  InitSieveWith2;
  pSieve := @sieve[0];
  Lmt := High(sieve);

//Divide into 3 section

//first i*i*i<= lmt with time expensive NextPotCnt
  T0 := now;
  cnt := 0;
  //third root of limit calculate only once, no comparison ala while i*i*i<= lmt do
  k := trunc(exp(ln(Lmt)/3));
  For i := 3 to k do
    if pSieve[i] = 0 then
    Begin
      inc(cnt);
      j := 2*i;
      fillChar(Power,Sizeof(Power),#0);
      Power[0] := 1;
      repeat
        inc(pSieve[j],NextPotCnt(i));
        inc(j,i);
      until j > lmt;
    end;
  OutCntTime(now-T0,cTextMany,cnt);
  T0 := now;

//second i*i <= lmt
  cnt := 0;
  i := k+1;
  k := trunc(sqrt(Lmt));
  For i := i to k do
    if pSieve[i] = 0 then
    Begin
      //first increment all multiples of prime by one
      inc(cnt);
      j := 2*i;
      repeat
        inc(pSieve[j]);
        inc(j,i);
      until j>lmt;
      //second increment all multiples prime*prime by one
      i2 := i*i;
      j := i2;
      repeat
        inc(pSieve[j]);
        inc(j,i2);
      until j>lmt;
    end;
  OutCntTime(now-T0,cText2,cnt);
  T0 := now;

//third i*i > lmt -> only one new factor
  cnt := 0;
  inc(k);
  For i := k to Lmt shr 1 do
    if pSieve[i] = 0 then
    Begin
      inc(cnt);
      j := 2*i;
      repeat
        inc(pSieve[j]);
        inc(j,i);
      until j>lmt;
    end;
   OutCntTime(now-T0,cText1,cnt);
end;

const
  smallLmt = 120;
  //needs 1e10 Byte = 10 Gb maybe someone got 128 Gb :-) nearly linear time
  BigLimit = 10*1000*1000*1000;
var
  T0,T : TDateTime;
  i,cnt,lmt : NativeInt;
Begin
  setlength(sieve,smallLmt+1);

  sievefactors;
  cnt := 0;
  For i := 2 to smallLmt do
  Begin
    if sieve[sieve[i]] = 0 then
    Begin
      write(i:4);
      inc(cnt);
      if cnt>19 then
      Begin
        writeln;
        cnt := 0;
      end;
    end;
  end;
  writeln;
  writeln;
  T0 := now;
  setlength(sieve,BigLimit+1);
  T := now;
  writeln('time allocating  : ',(T-T0) *86400 :8:3,' s');
  sievefactors;
  T := now-T;
  writeln('time sieving : ',T*86400 :8:3,' s');
  T:= now;
  cnt := 0;
  i := 0;
  lmt := 10;
  repeat
    repeat
      inc(i);
      {IF sieve[sieve[i]] = 0 then inc(cnt); takes double time is not relevant}
      inc(cnt,ORD(sieve[sieve[i]] = 0));
    until i = lmt;
    writeln(lmt:11,cnt:12);
    lmt := 10*lmt;
  until lmt >High(sieve);
  T := now-T;
  writeln('time counting : ',T*86400 :8:3,' s');
  writeln('time total    : ',(now-T0)*86400 :8:3,' s');
end.
