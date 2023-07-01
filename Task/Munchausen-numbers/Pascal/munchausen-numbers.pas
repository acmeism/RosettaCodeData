{$IFDEF FPC}{$MODE objFPC}{$ELSE}{$APPTYPE CONSOLE}{$ENDIF}
uses
  sysutils;
type
  tdigit  = byte;
const
  base = 10;
  maxDigits = base-1;// set for 32-compilation otherwise overflow.

var
  DgtPotDgt : array[0..base-1] of NativeUint;
  cnt: NativeUint;

function CheckSameDigits(n1,n2:NativeUInt):boolean;
var
  dgtCnt : array[0..Base-1] of NativeInt;
  i : NativeUInt;
Begin
  fillchar(dgtCnt,SizeOf(dgtCnt),#0);
  repeat
    //increment digit of n1
    i := n1;n1 := n1 div base;i := i-n1*base;inc(dgtCnt[i]);
    //decrement digit of n2
    i := n2;n2 := n2 div base;i := i-n2*base;dec(dgtCnt[i]);
  until (n1=0) AND (n2= 0 );
  result := true;
  For i := 0 to Base-1 do
    result := result AND (dgtCnt[i]=0);
end;

procedure Munch(number,DgtPowSum,minDigit:NativeUInt;digits:NativeInt);
var
  i: NativeUint;
begin
  inc(cnt);
  number := number*base;
  IF digits > 1 then
  Begin
    For i := minDigit to base-1 do
      Munch(number+i,DgtPowSum+DgtPotDgt[i],i,digits-1);
  end
  else
    For i := minDigit to base-1 do
      //number is always the arrangement of the digits leading to smallest number
      IF (number+i)<= (DgtPowSum+DgtPotDgt[i]) then
        IF CheckSameDigits(number+i,DgtPowSum+DgtPotDgt[i]) then
          iF number+i>0 then
            writeln(Format('%*d  %.*d',
             [maxDigits,DgtPowSum+DgtPotDgt[i],maxDigits,number+i]));
end;

procedure InitDgtPotDgt;
var
  i,k,dgtpow: NativeUint;
Begin
  // digit ^ digit ,special case 0^0 here 0
  DgtPotDgt[0]:= 0;
  For i := 1 to Base-1 do
  Begin
    dgtpow := i;
    For k := 2 to i do
      dgtpow := dgtpow*i;
    DgtPotDgt[i] := dgtpow;
  end;
end;

begin
  cnt := 0;
  InitDgtPotDgt;
  Munch(0,0,0,maxDigits);
  writeln('Check Count ',cnt);
end.
