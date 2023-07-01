program AntiPrimes;
{$IFdef FPC}
  {$MOde Delphi}
{$IFEND}
function getFactorCnt(n:NativeUint):NativeUint;
var
  divi,quot,pot,lmt : NativeUint;
begin
  result := 1;
  divi  := 1;
  lmt := trunc(sqrt(n));
  while divi < n do
  Begin
    inc(divi);
    pot := 0;
    repeat
      quot := n div divi;
      if n <> quot*divi then
        BREAK;
      n := quot;
      inc(pot);
    until false;
    result := result*(1+pot);
    //IF n= prime leave now
    if divi > lmt then
      BREAK;
  end;
end;

var
  i,Count,FacCnt,lastCnt: NativeUint;
begin
  count := 0;
  lastCnt := 0;
  i := 1;
  repeat
    FacCnt := getFactorCnt(i);
    if  lastCnt < FacCnt then
    Begin
      write(i,'(',FacCnt,'),');
      lastCnt:= FacCnt;
      inc(Count);
      if count = 12 then
        Writeln;
    end;
    inc(i);
  until Count >= 20;
  writeln;
end.
