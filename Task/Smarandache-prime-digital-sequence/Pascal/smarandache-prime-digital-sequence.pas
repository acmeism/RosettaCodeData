program Smarandache;

uses
  sysutils,primsieve;// http://rosettacode.org/wiki/Extensible_prime_generator#Pascal
const
  Digits : array[0..3] of Uint32 = (2,3,5,7);
var
  i,j,pot10,DgtLimit,n,DgtCnt,v,cnt,LastPrime,Limit : NativeUint;

procedure Check(n:NativeUint);
var
  p : NativeUint;
Begin
  p := LastPrime;
  while p< n do
    p := nextprime;
  if p = n then
  begin
    inc(cnt);
    IF (cnt <= 25) then
    Begin
      IF cnt = 25 then
      Begin
        writeln(n);
        Limit := 100;
      end
      else
        Write(n,',');
    end
    else
      IF cnt = Limit then
      Begin
        Writeln(cnt:9,n:16);
        Limit *=10;
        if Limit > 10000 then
          HALT;
      end;
   end;
   LastPrime := p;
end;

Begin
  Limit := 25;
  LastPrime:=1;

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
     repeat
       n += pot10*Digits[j MOD 4];
       j := j DIV 4;
       pot10 *=10;
       inc(DgtCnt);
     until DgtCnt = DgtLimit;
     Check(n);
     inc(i);
   until i=v;
   //one more digit
   v *=4;
   i :=0;
   inc(DgtLimit);
 until DgtLimit= 12;
end.
