program DeceptiveNumbers;
{$IfDef FPC} {$Optimization ON,ALL} {$ENDIF}
{$IfDef Windows} {$APPTYPE CONSOLE} {$ENDIF}
uses
  sysutils;
const
  LIMIT = 100000;//1E6 at home takes over (5 min) now 1m10s
  RepInitLen = 13; //Uint64 19 decimal digits -> max 6 digits divisor
  DecimalDigits = 10*1000*1000*1000*1000;//1E13
  RepLimit = (DecimalDigits-1)DIV 9;//RepInitLen '1'

type
  tmyUint64 = array[0..Limit DIV RepInitLen+1] of Uint64;
var
  {$Align 32}
  K: tmyUint64;
  {$Align 32}
  MaxKIdx : Int32;

procedure OutK(const K:tmyUint64);
var
  i : Uint32;
begin
  For i := MaxKidx downto 0 do
  begin
    write(k[i]:13);
  end;
  writeln;
end;

function isPrime(n: UInt64):boolean;
var
 p: Uint64;
begin
  if n in [2,3,5,7,11,13,17,19,23,29] then
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

procedure ExtendRep(var K:tmyUint64;n:NativeUint);
var
  q : Uint64;
  i : Int32;
begin
  n -= MaxKidx*RepInitLen;
  i := MaxKidx;
  while RepInitLen<=n do
  begin
    K[i] := RepLimit;
    inc(i);
    dec(n,RepInitLen);
  end;
  if n = 0 then
    Exit;
  MaxKidx := i;
  q := 1;
  while n<RepInitLen do
  begin
    q *= 10;
    inc(n);
  end;
  K[i] := RepLimit DIV q;
end;

function GetModK(const K:tmyUint64;n:Uint64):NativeUint;
var
  r,q : Uint64;
  i : Uint32;
Begin
  r := 0;
  For i := MaxKidx downto 0 do
  begin
    q := K[i]+r*DecimalDigits;
    r := q MOD n;
  end;
  Exit(r)
end;

const
  NextNotMulOF35 : array[0..7] of byte = (6,4,2,4,2,4,6,2);
var
  i,cnt,idx35 : UInt64;
BEGIN
  fillchar(K,SizeOF(K),#0);
  MaxKIdx:= 0;
  cnt := 0;
  i := 1;
  idx35 := 0;
  repeat
    inc(i,NextNotMulOF35[idx35]);
    IF i > LIMIT then
      BREAK;
    idx35 := (idx35+1) AND 7;
    if isprime(i) then
      continue;
    ExtendRep(k,i-1);
    IF GetModK(K,i)=0 then
    Begin
      inc(cnt);
      write(i:6,',');
      if cnt Mod 10 = 0 then
        writeln;
    end;
  until false;
 {$IfDef Windows}
 readln;
 {$ENDIF}
END.
