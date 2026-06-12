//calculate the decimal digits of e and count how many times each #
//digit occurs - based on the B code on the Wikipedia page:       #
//https://en.wikipedia.org/wiki/B_(programming_language) #
program  DigitCntOfE;
uses
  sysutils;
const
  MaxIDx = 2000;
  base = 10;
var
  dcount : array[0..Base-1] of integer = ( 0, 0, 1, 0, 0, 0, 0, 0, 0, 0 );
  v : array[0..MaxIdx-1] of integer;
  n : integer = MaxIdx;
  i,col,
  c, a : Integer;

BEGIN
//# this counts the digits in the fractional part of e so the initial  #
//   # count for 2 is 1, to include the non-fractional digit              #
   FOR i  := Low(v) to High(v) do
     v[i] := 1;

   FOR col := 0 to 2*n do
   Begin
    a := n+1;
    c := 0;
    FOR i  := Low(v) to High(v) do
    Begin
      c += v[i]*10;
      v[i] := c MOD a;
      c := c DIV a;
      a -= 1
    end;
    dcount[ c ] += 1
  end;
  For i := low(dcount) to High(dCount) do
    write(dcount[i]:5);
  writeln;
END.
