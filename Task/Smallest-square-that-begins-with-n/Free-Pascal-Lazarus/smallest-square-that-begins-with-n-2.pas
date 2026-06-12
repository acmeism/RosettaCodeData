program smsq;
{$IFDEF FPC}{$MODE DELPHI}{$OPTIMIZATION ON,ALL}{$ENDIF}
uses
  sysutils;
type
 tRes = array of Uint32;

var
  maxTestVal : Uint32;
function smsq(n:Uint32):tRes;
// limit n is ~ 1.358E9
var
  square,nxtSqr,Pow10 : Uint64;
  n_run,testSqr,found : Uint32;
begin
  setlength(result,n+1);
  fillchar(result[0],length(result)*Sizeof(result[0]),#0);
  found  := 0;
  square := 0;
  n_run  := 0;
  Pow10  := 1;
  nxtSqr := 1;//sqr(n_run)+1;
  while found < n do
  begin
    repeat
      n_run +=1;
      square := sqr(n_run);
    until square >= nxtSqr;
    //bring square into the right place
    testSqr := square div pow10;
    while testSqr > n do
    Begin
      pow10 *=10;
      testSqr := testSqr div 10;
    end;
    //next square must increase by one digit
    nxtSqr := (testSqr+1)*pow10;
    repeat
      //no need to test any more
      //if found ex. 4567 than 456,45 and 4 already marsquareed
      if result[testSqr] <> 0 then
        BREAK;
      result[testSqr] := n_run;
      found += 1;
      testSqr := testSqr div 10;
    until testSqr = 0;
  end;
  maxTestVal := n_run;
end;

var
  t0 : Int64;
  n,i : Uint32;
  results : tRes;
BEGIN
  n := 49;
  results := smsq(n);
  For i := 1 to n do
  begin
    write(sqr(results[i]):6);
    if i mod 10 = 0 then
      Writeln;
  end;
  writeln;
  writeln('Max test value : ',maxTestVal); ;
  writeln;

  n := 10*1000*1000;
  // speed up cpu
  smsq(n);
  t0 := GetTickCount64;
  smsq(n);
  t0 := GetTickCount64-t0;
 writeln('check 1..',n,' in ', T0,' ms. Max test value : ',maxTestVal);
END.
