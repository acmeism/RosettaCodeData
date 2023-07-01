program SemiPrime;
{$IFDEF FPC}
  {$Mode objfpc}// compiler switch to use result
{$ELSE}
  {$APPTYPE CONSOLE} // for Delphi
{$ENDIF}
uses
  primTrial;

function isSemiprime(n: longWord;doWrite:boolean): boolean;
var
  fac1 : LongWord;
begin
  //a simple isAlmostPrime(n,2) would do without output;
  fac1 := SmallFactor(n);
  IF fac1 < n then
  Begin
    n := n div fac1;
    result := SmallFactor(n) = n;
    if result AND doWrite then
      write(fac1:10,'*',n:11)
  end
  else
    result := false;
end;
var
  i,k : longWord;
BEGIN
  For i := 2 to 97 do
    IF isSemiPrime(i,false) then
      write(i:3);
  writeln;
  //test for big numbers
  k := 4000*1000*1000;
  i := k-100;
  repeat
    IF isSemiPrime(i,true) then
      writeln(' = ',i:10);
    inc(i);
  until i> k;
END.
