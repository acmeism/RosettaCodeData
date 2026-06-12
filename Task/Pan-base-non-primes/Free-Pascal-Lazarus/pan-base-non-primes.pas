program PanBaseNonPrime;
  // Check Pan-Base Non-Prime
  {$IFDEF FPC}{$MODE DELPHI}{$OPTIMIZATION ON,ALL}{$ENDIF}
  {$IFDEF WINDOWS}{$APPTYPE CONSOLE}{$ENDIF}
// MAXLIMIT beyond 10000 gets really slow 5 digits, depends on isPrime
//10004 checked til base 10003 -> 10003⁴+3 = 1.0012e16, takes >1 s longer
//real   0m1,307s
// 9999 checked til base  9998 -> 8,99555E12 much smaller
//real   0m0,260s
type
  tDgts = 0..31;// Int32 is faster than 0..9 -> word
  tUsedDgts = set of tDgts;
  tDecDigits = packed record
                 decdgts   :array[0..20] of byte;
                 decmaxIdx :byte;
                 decmaxDgt :byte;
                 decUsedDgt :tUsedDgts;
               end;
const
  MAXLIMIT = 2500;
  WithGCDNotOne : array[0..24] of tUsedDgts =
      //all the same digits
     ([0],[2],[3],[4],[5],[6],[7],[8],[9],
      //all even
      [2,4],[2,6],[2,8],
      [2,4,6],[2,4,8],[2,6,8],
      [2,4,6,8],
      [4,6],[4,8],
      [4,6,8],[2,4,6,8],
      [6,8],
      //all divible 3
      [3,6],[3,9],
      [3,6,9],
      [6,9]);
var
  gblCnt,
  gblOddCnt :NativeINt;

procedure OutDecDigits(var Dgts:tDecDigits);
var
  idx : nativeInt;
begin
  with Dgts do
  begin
    idx := decMaxIDx;
    repeat
      dec(idx);
      write(decdgts[idx]);
    until idx <= 0;
    write(decmaxdgt:3);
    writeln;
  end;
end;

procedure CountOne(n:NativeInt);inline;
Begin
  inc(gblCnt);
  If odd(n) then
    inc(gblOddCnt);
end;

procedure OutCountOne(n:NativeInt);
begin
  CountOne(n);
  write(n:5);
  if gblCnt mod 10 = 0 then
    writeln;
end;

function CheckGCD(var Dgts:tDecDigits):boolean;
var
  idx: NativeInt;
  UsedDgts:tUsedDgts;
begin
  UsedDgts := Dgts.decUsedDgt;
  For idx := Low(WithGCDNotOne) to High(WithGCDNotOne) do
    if UsedDgts = WithGCDNotOne[idx] then
      Exit(true);
  Exit(false);
end;

procedure ConvToDecDgt(n : NativeUint;out Dgts:tDecDigits);//inline;
var
  dgt,maxdgt,idx,q :NativeInt;
  UsedDgts : tUsedDgts;
begin
  UsedDgts := [];
  maxdgt := 0;
  idx := 0;
  repeat
    q := n div 10;
    dgt := n-q*10;
    Dgts.decdgts[idx]:= dgt;
    include(UsedDgts,dgt);
    IF maxdgt<dgt then
      maxdgt := dgt;
    inc(idx);
    n := q;
  until n = 0;

  with Dgts do
  Begin
    decMaxIDx := idx;
    decMaxdgt := maxDgt;
    decUsedDgt := UsedDgts;
  end;
end;

function ConvDgtToBase(var Dgts:tDecDigits;base:NativeInt):NativeUInt;
var
  idx :NativeInt;
begin
  result := 0;
  if base<= Dgts.decMaxdgt then
    EXIT;

  with Dgts do
  Begin
    idx := decMaxIDx;
    repeat
      dec(idx);
      result := result*base+decdgts[idx];
    until idx <= 0;
  end;
end;

function isPrime(n: NativeInt):boolean;
//simple trial division
var
  j : nativeInt;
begin
  if n in [2,3,5,7,11,13,17,19,23,29,31] then
    EXIT(true);
  if n<32 then
    EXIT(false);
  if not(odd(n)) then
    EXIT(false);
  if n mod 3 = 0 then
    EXIT(false);
  if n mod 5 = 0 then
    EXIT(false);
  j := 7;
  while j*j<=n do
  begin
    if n mod j = 0 then
      EXIT(false);
    inc(j,4);
    if n mod j = 0 then
      EXIT(false);
    inc(j,2);
  end;
  EXIT(true);
end;

function CheckPanBaseNonPrime(n: NativeUint):boolean;
var
  myDecDgts:tDecDigits;
  b,num : NativeInt;
Begin
  result := true;
  ConvToDecDgt(n,myDecDgts);
  if (n>10) then
  Begin
    if (myDecDgts.decdgts[0] = 0) then
      Exit;
    if CheckGCD(myDecDgts) then
      Exit;
  end;

  b := myDecDgts.decmaxdgt+1;
  if b >= n then
  Begin
    if isPrime(n) then
      Exit(false);
  end
  else
  begin
    while b < n do
    begin
      num := ConvDgtToBase(myDecDgts,b);
      if isPrime(num) then
        EXIT(false);
      inc(b);
    end;
  end;
end;
var
  i : NativeInt;

BEGIN
  writeln('First 50 pan-base non-prime numbers ');
  gblCnt := 0;
  gblOddCnt := 0;
  For i := 3 to MAXLIMIT do
  Begin
    if CheckPanBaseNonPrime(i) then
      OutCountOne(i);
    if gblCnt = 50 then
      break;
  end;
  writeln;

  writeln('First 20 pan-base non-prime odd numbers ');
  gblCnt := 0;
  gblOddCnt := 0;
  For i := 3 to MAXLIMIT do
  Begin
    if ODD(i) then
    Begin
      if CheckPanBaseNonPrime(i) then
         OutCountOne(i);
      if gblOddCnt = 20 then
        break;
    end;
  end;
  writeln;

  gblCnt := 0;
  gblOddCnt := 0;
  For i := 3 to MAXLIMIT do
    if CheckPanBaseNonPrime(i) then
      CountOne(i);
  writeln('Count of pan-base composites up to and including ',MAXLIMIT,' : ',gblCnt);
  writeln('odd  up to and including ',MAXLIMIT,' = ',gblOddCnt:4,' equals ',gblOddCnt/gblCnt*100:10:6,'%');
  writeln('even up to and including ',MAXLIMIT,' = ',gblCnt-gblOddCnt:4,' equals ',(gblCnt-gblOddCnt)/gblCnt*100:10:6,'%');

END.
