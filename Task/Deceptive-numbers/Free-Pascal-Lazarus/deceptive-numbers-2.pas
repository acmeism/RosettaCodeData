program DeceptiveNumbers;
{$IfDef FPC} {$MODE DELPHI}{$Optimization ON,ALL} {$ENDIF}
{$IfDef Windows} {$APPTYPE CONSOLE} {$ENDIF}
uses
  sysutils;
const
  LIMIT = 1000;

function OutN(n,count:Uint64):Uint64;
begin
  result := count;
  If result mod  8 = 0 then
    write(#13#10,count:6);
  write(n:10);
  inc(result);
end;

function isPrime(n: UInt64):boolean;
var
 p: Uint64;
begin
  if n <32 then
    if n in [2,3,5,7,11,13,17,19,23,29,31] then
      EXIT(true);

  if Not ODD(n) OR ( n MOD 3 = 0) then
    EXIT(false);
  p := 5;
  repeat
    if (n mod p=0)or(n mod(p+2)=0) then
      EXIT(false);
    p +=6;
  until p*p>n;
  Exit(true);
end;

function powMod(n,pow,rest: Uint64): Uint64;
begin
  result := 1;
  while pow > 0 do
  begin
    if pow mod 2 <> 0 then
      result := (result * n) mod rest;
    pow := pow div 2;
    n := sqr(n) mod rest;
  end;
end;

const
  NextNotMulOf235 : array[0..7] of Uint32 = (6,4,2,4,2,4,6,2);
var
   n,count,idx235:Uint64;
begin
  idx235 := 0;
  n := 1;
  count := 0;
   writeln(' count        +1         2         3         4         5         6         7         8');
  repeat
    //simple isprime takes mostly more time than powMod
    if  (powMod(10, n-1, n) = 1) AND Not(isPrime(n)) then
      count := OutN(n,count);
    inc(n,NextNotMulOf235[idx235]);
    idx235 :=(idx235+1) AND 7;
  until count >=LIMIT;

  writeln;
END.
