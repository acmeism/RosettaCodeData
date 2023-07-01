program munchhausennumber;
{$IFDEF FPC}{$MODE objFPC}{$Optimization,On,all}{$ELSE}{$APPTYPE CONSOLE}{$ENDIF}
uses
  sysutils;
type
  tdigit  = byte;
const
  MAXBASE = 17;

var
  DgtPotDgt : array[0..MAXBASE-1] of NativeUint;
  dgtCnt : array[0..MAXBASE-1] of NativeInt;
  cnt: NativeUint;

function convertToString(n:NativeUint;base:byte):AnsiString;
const
  cBASEDIGITS = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvxyz';
var
  r,dgt: NativeUint;
begin
  IF base > length(cBASEDIGITS) then
    EXIT('Base to big');
  result := '';
  repeat
    r := n div base;
    dgt := n-r*base;
    result := cBASEDIGITS[dgt+1]+result;
    n := r;
  until n =0;
end;

function CheckSameDigits(n1,n2,base:NativeUInt):boolean;
var

  i : NativeUInt;
Begin
  fillchar(dgtCnt,SizeOf(dgtCnt),#0);
  repeat
    //increment digit of n1
    i := n1;n1 := n1 div base;i := i-n1*base;inc(dgtCnt[i]);
    //decrement digit of n2
    i := n2;n2 := n2 div base;i := i-n2*base;dec(dgtCnt[i]);
  until (n1=0) AND (n2= 0);
  result := true;
  For i := 2 to Base-1 do
    result := result AND (dgtCnt[i]=0);
  result := result AND (dgtCnt[0]+dgtCnt[1]=0);

end;

procedure Munch(number,DgtPowSum,minDigit:NativeUInt;digits,base:NativeInt);
var
  i: NativeUint;
  s1,s2: AnsiString;
begin
  inc(cnt);
  number := number*base;
  IF digits > 1 then
  Begin
    For i := minDigit to base-1 do
      Munch(number+i,DgtPowSum+DgtPotDgt[i],i,digits-1,base);
  end
  else
    For i := minDigit to base-1 do
      //number is always the arrangement of the digits leading to smallest number
      IF (number+i)<= (DgtPowSum+DgtPotDgt[i]) then
        IF CheckSameDigits(number+i,DgtPowSum+DgtPotDgt[i],base) then
          iF number+i>0 then
          begin
            s1 := convertToString(DgtPowSum+DgtPotDgt[i],base);
            s2 := convertToString(number+i,base);
            If length(s1)= length(s2) then
              writeln(Format('%*d %*s  %*s',[Base-1,DgtPowSum+DgtPotDgt[i],Base-1,s1,Base-1,s2]));
          end;
end;

//factorions
procedure InitDgtPotDgt(base:byte);
var
  i: NativeUint;
Begin
  DgtPotDgt[0]:= 1;
  For i := 1 to Base-1 do
    DgtPotDgt[i] := DgtPotDgt[i-1]*i;
  DgtPotDgt[0]:= 0;
end;
{
//Munchhausen numbers
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
}
var
  base : byte;
begin
  cnt := 0;
  For base := 2 to MAXBASE do
  begin
    writeln('Base = ',base);
    InitDgtPotDgt(base);
    Munch(0,0,0,base,base);
  end;
  writeln('Check Count ',cnt);
end.
