{$IFDEF FPC}
  {$MODE DELPHI}
{$ELSE}
  {$APPTAYPE CONSOLE}
{$ENDIF}
const
 smallprimes : array[0..10] of Uint32 = (2,3,5,7,11,13,17,19,23,29,31);
 MAX = 20;

function getmaxfac(pr: Uint32): Uint32;
//get the pr^highest exponent of prime used in 2 .. MAX
var
  i,fac : integer;
Begin
  result := pr;
  while pr*result <= MAX do
    result *= pr;
end;

var
  n,pr,prIdx : Uint32;
BEGIN
  n := 1;
  prIdx := 0;
  pr := smallprimes[prIdx];
  repeat
    pr := smallprimes[prIdx];
    n *= getmaxfac(pr);
    inc(prIdx);
    pr := smallprimes[prIdx];
  until pr>MAX;
  writeln(n);
{$IFDEF WINDOWS}
  READLN;
{$ENDIF}
END.
