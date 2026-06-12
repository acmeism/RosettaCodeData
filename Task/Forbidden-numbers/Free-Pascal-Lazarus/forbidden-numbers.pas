program ForbiddenNumbers;
{$IFDEF FPC}{$MODE DELPHI}{$OPTIMIZATION ON,ALL}{$ENDIF}
{$IFDEF WINDOWS}{$APPTYPE CONSOLE}{$ENDIF}
uses
  sysutils,strutils;

function isForbidden(n:NativeUint):boolean;inline;
// no need for power or div Only shr & AND when using Uint
// n > 7 => if n <= 7 -> only 4/0 would div 4 -> no forbidden number
Begin
  while (n > 7) AND (n MOD 4 = 0) do
    n := n DIV 4;
  result := n MOD 8 = 7;
end;

function CntForbiddenTilLimit(lmt:NativeUint):NativeUint;
//forNmb = 4^i * (8*j + 7) | i,j >= 0
//forNmb = Power4 *  8*j + Power4 * 7
//forNmb =  delta* j     + n
var
  Power4,delta,n : NativeUint;
begin
 result := 0;
 power4 := 1;
 repeat
   delta := Power4*8;// j = 1
   n := Power4*7;
   if n > lmt then
     Break;
   //max j to reach limit
   inc(result,(lmt-n) DIV delta+1);
   Power4 *= 4;
 until false;
end;

var
  lmt,n,cnt: NativeUint;
BEGIN
  writeln('First fifty forbidden numbers:');
  n := 1;
  lmt := 0;
  repeat;
    if isForbidden(n) then
    Begin
      write(n:4);
      inc(lmt);
      if LMT MOD 20 = 0 THEN
        writeln;
    end;
    n +=1;
  until lmt >= 50;
  writeln;
  writeln;

  writeln('count of forbidden numbers below iterative');
  n := 1;
  cnt := 0;
  lmt := 5;
  repeat
    repeat;
      //if isForbidden(n) then cnt+=1 takes to long  100% -> 65% of time
      inc(cnt,ORD(isForbidden(n)));
      n += 1;
    until n >= lmt;
    writeln(Numb2USA(IntToStr(lmt)):30,Numb2USA(IntToStr(Cnt)):25);
    lmt *= 10;
  until lmt > 500*1000*1000;
  writeln;

  writeln('count of forbidden numbers below ');
  lmt := 5;
  repeat
    writeln(Numb2USA(IntToStr(lmt)):30,Numb2USA(IntToStr(CntForbiddenTilLimit(lmt))):25);
    lmt *= 10;
  until lmt > High(lmt) DIV 4;
END.
