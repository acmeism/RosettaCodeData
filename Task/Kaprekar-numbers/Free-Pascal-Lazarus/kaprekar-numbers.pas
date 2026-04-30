program Kaprekar;
{$COPERATORS ON}{$OPTIMIZATION ON,ALL}{$MODE Delphi}
uses
  sysutils;
function IsKaprekar(N,base: integer;doOutPut:Boolean): boolean;
{Return true if N is a Kaperkar number}
//see wikipedia for kaprekar numbers
//A =  frontdigits of n*n , B = remainig digits
var
  A,B,N2,BasePow: Uint64;
  SplitPos: Int32;
begin
  if N=1 then
  begin
    if doOutPut then
      write(1:12,1:20,'':33);
    exit(true);
  end;
  if n MOD (Base-1) in [0,1] then
  Begin
    N2 := n*n;
    A  := n2;
    SplitPos := 0;
    BasePow := Base;
    while BasePow <n2 do
    begin
      inc(SplitPos);
      //remove last digit in Base
      A := A div base;
      B := n2-A*BasePow;//B := n*n MOD BasePow;
      If (A*B <> 0) AND (B+A = N) then
      begin
        if doOutPut then
          write(n:12,N2:20,A:12,b:12,SplitPos:9);
        EXIT(true);
      end;
      BasePow *= Base;
    end;
  end;
  Exit(false);
end;

procedure ShowKaprekarNumbers;
{Find all Kaprekar numbers less than 10,000}
var
  I,cnt: integer;
begin
  writeln('           n|                n*n|          A|   +      B| SplitPos    ');
  cnt := 0;
  for I:=1 to 1000*10 do
  begin
    if IsKaprekar(I,10,true) then
    begin
      inc(cnt);
      writeln(' cnt ',cnt);
    end;
  end;
  cnt := 0;
  for I:=1 to 1000*1000 do
    if IsKaprekar(I,10,false) then
      inc(cnt);
   writeln('Found ',cnt,' kaprekar numbers below ',i);
  cnt := 0;
  for I:=1 to 100*1000*1000 do
    if IsKaprekar(I,10,false) then
      inc(cnt);
   writeln('Found ',cnt,' kaprekar numbers below ',i);
end;

Begin
 ShowKaprekarNumbers;
end.
