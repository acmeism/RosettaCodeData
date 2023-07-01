program AntiPrimesPlus;
{$IFDEF FPC}
  {$MODE Delphi}
{$ELSE}
  {$APPTYPE CONSOLE} // delphi
{$ENDIF}
uses
  sysutils,math;
const
  MAX =32;

function getDividersCnt(n:Uint32):Uint32;
// getDividersCnt by dividing n into its prime factors
// aka n = 2250 = 2^1*3^2*5^3 has (1+1)*(2+1)*(3+1)= 24 dividers
var
  divi,quot,deltaRes,rest : Uint32;
begin
  result := 1;

  //divi  := 2; //separat without division
  while Not(Odd(n)) do
  Begin
    n := n SHR 1;
    inc(result);
  end;

  //from now on only odd numbers
  divi  := 3;
  while (sqr(divi)<=n) do
  Begin
    DivMod(n,divi,quot,rest);
    if rest = 0 then
    Begin
      deltaRes := 0;
      repeat
        inc(deltaRes,result);
        n := quot;
        DivMod(n,divi,quot,rest);
      until rest <> 0;
      inc(result,deltaRes);
    end;
    inc(divi,2);
  end;
  //if last factor of n is prime
  IF n <> 1 then
    result := result*2;
end;

var
  T0 : Int64;
  i,next,DivCnt: Uint32;
begin
  writeln('The first ',MAX,' anti-primes plus are:');
  T0:= GetTickCount64;
  i := 1;
  next := 1;
  repeat
    DivCnt := getDividersCnt(i);
    IF DivCnt= next then
    Begin
      write(i,' ');
      inc(next);
      //if next is prime then only prime( => mostly 2 )^(next-1) is solution
      IF (next > 4) AND (getDividersCnt(next) = 2) then
        i := 1 shl (next-1) -1;// i is incremented afterwards
    end;
    inc(i);
  until Next > MAX;
  writeln;
  writeln(GetTickCount64-T0,' ms');
end.
