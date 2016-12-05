program Midl3dig;
{$IFDEF FPC}
  {$MODE Delphi} //result /integer => Int32 aka longInt etc..
{$ELSE}
  {$APPTYPE console} // Delphi
{$ENDIF}
uses
  sysutils;   //IntToStr
function GetMid3dig(i:NativeInt):Ansistring;
var
  n,l: NativeInt;
Begin
  setlength(result,0);
  //n = |i| jumpless abs
  n := i-((ORD(i>0)-1)AND (2*i));
  //calculate digitcount
  IF n > 0 then
    l := trunc(ln(n)/ln(10))+1
  else
    l := 1;
  if l<3 then Begin  write('got too few digits');  EXIT; end;
  If Not(ODD(l)) then Begin write('got even number of digits'); EXIT; end;
  result:= copy(IntToStr(n),l DIV 2,3);
end;
const
  Test : array [0..16] of NativeInt =
    ( 123,12345,1234567,987654321,10001,-10001,
    -123,-100,100,-12345,1,2,-1,-10,2002,-2002,0);
var
  i,n : NativeInt;
Begin
  For i := low(Test) to High(Test) do
  Begin
    n := Test[i];
    writeln(n:9,': ',GetMid3dig(Test[i]));
  end;
end.
