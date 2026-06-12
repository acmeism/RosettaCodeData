program SpecialPrimes;
// modified smarandache
{$IFDEF FPC}{$MODE DELPHI}{$OPTIMIZATION ON,ALL}{$ENDIF}
{$IFDEF WINDOWS}{$APPTYPE CONSOLE}{$ENDIF}
uses
  sysutils;
const
  Digits : array[0..3] of Uint32 = (2,3,5,7);

var
//circular buffer
  Last64 : array[0..63] of Uint64;
  cnt,Limit : NativeUint;
  LastIdx: Int32;

procedure OutLast(i:Int32);
var
  idx: Int32;
begin
  idx := LastIdx-i;
  If idx < Low(Last64) then
    idx += High(Last64)+1;
  For i := i downto 1 do
  begin
    write(Last64[idx]:12);
    inc(idx);
    if idx > High(Last64) then
      idx := Low(Last64);
  end;
  writeln;
end;

function isSmlPrime64(n:UInt32):boolean;inline;
//n must be >=0 and <=180 = 20 times digit 9, uses 80x86 BIT TEST
begin
  EXIT(n in [2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,
             79,83,89,97,101,103,107,109,113,127,131,137,139,149,151,
             157,163,167,173,179])
end;

function isPrime(n:UInt64):boolean;
const
  deltaWheel : array[0..7] of byte =( 2, 6, 4, 2, 4, 2, 4, 6);
var
  p : NativeUint;
  WheelIdx : Int32;
begin
  if n < 180 then
    EXIT(isSmlPrime64(n));

  result := false;

  if n mod 2 = 0 then EXIT;
  if n mod 3 = 0 then EXIT;
  if n mod 5 = 0 then EXIT;

  p := 1;
  WheelIdx := High(deltaWheel);
  repeat
    inc(p,deltaWheel[WheelIdx]);
    if p*p > n then
      BREAK;
    if n mod p = 0 then
      EXIT;
    dec(WheelIdx);
    IF WheelIdx< Low(deltaWheel) then
      wheelIdx := High(deltaWheel);
  until false;
  result := true;
end;

procedure Check(n:NativeUint);

Begin
  if isPrime(n) then
  begin
    Last64[LastIdx] := n;
    inc(LastIdx);
    If LastIdx>High(Last64) then
      LastIdx := Low(Last64);
    inc(cnt);
    IF (n < 10000) then
    Begin
      write(n:5,',');
      if cnt mod 10 = 0 then
        writeln;
      if cnt = 36 then
        writeln;
    end
    else
      IF n > Limit then
      Begin
        OutLast(7);
        Limit *=10;
      end;
   end;
end;

var
  i,j,pot10,DgtLimit,n,DgtCnt,v : NativeUint;
  dgt,
  dgtsum : Int32;
Begin
  Limit := 100000;
  cnt := 0;
  LastIdx := 0;
//Creating the numbers not the best way but all upto 11 digits take 0.05s
//here only 9 digits
  i := 0;
  pot10 := 1;
  DgtLimit := 1;
  v := 4;
  repeat
    repeat
     j := i;
     DgtCnt := 0;
     pot10 := 1;
     n := 0;
     dgtsum := 0;
     repeat
       dgt := Digits[j MOD 4];
       dgtsum += dgt;
       n += pot10*Dgt;
       j := j DIV 4;
       pot10 *=10;
       inc(DgtCnt);
     until DgtCnt = DgtLimit;
     if isPrime(dgtsum) then   Check(n);
     inc(i);
   until i=v;
   //one more digit
   v *=4;
   i :=0;
   inc(DgtLimit);
 until DgtLimit= 12;
 inc(LastIdx);
 OutLast(7);
 writeln('count: ',cnt);
end.
