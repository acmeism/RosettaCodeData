Program HappyNumbers (output);
// NativeUInt: LongWord 32-Bit-OS/ Uint64 64-Bit-OS
{$IFDEF FPC}
  {$MODE DELPHI}
  {$OPTIMIZATION ON,Regvar,PEEPHOLE,CSE,ASMCSE}
  {$CODEALIGN proc=32}
{$ELSE}
  //for Delphi
  {$APPLICATION CONSOLE}
{$ENDIF}
const
  HighCache = 19*(9*9);//sum sqrdigt of Uint64
  cDigit  = 1000;
type
  tCache     = array[0..HighCache] of Word;
  tSqrdCache = array[0..cDigit] of Word;
  tSqrdSumCache = array[0..HighCache] of Word;
var
  Cache : tCache;
  SqrdCache :tSqrdCache;
  SqrdSumCache :tSqrdSumCache;

function find(n: NativeUint;const cache: tCache): boolean;
var
  i: NativeUint;
begin
  find := false;
  for i := low(cache) to high(cache) do
    if cache[i] = n then
      find := true;
  writeln(i:10,n:10);
end;

procedure InitSqrdCache;
var
  i,n,sum,r: NativeUint;
begin
  For i := 0 to  cDigit do
  Begin
    sum := 0;
    n := i;
    while n > 0 do
    begin
      r := n;
      n := n div 10;
      r := r-10*n;
      sum := sum + r*r;
    end;
    SqrdCache[i] := sum;
  end;
end;

function SumSqrdDgt(n: NativeUint): NativeUint;
var
  sum,r: NativeUint;
begin
  sum := 0;
  while n > cDigit do
  begin
    r := n;
    n := n div cDigit;
    r := r-cDigit*n;
    sum := sum + SqrdCache[r];
  end;
  SumSqrdDgt := sum + SqrdCache[n];
end;


procedure Inithappy;
var
  n,s,p : NativeUint;
Begin
  fillchar(SqrdSumCache,SizeOf(SqrdSumCache),#0);
  InitSqrdCache;
  fillChar(Cache,SizeOf(Cache),#0);
  Cache[1] := 1;
  For n := 1 to High(Cache) do
  Begin
    If Cache[n] = 0 then
    Begin
      //start a linked list
      Cache[n] := n;
      p := n;
      s := SumSqrdDgt(p);
      while Cache[s] = 0 do
      Begin
        Cache[s] := p;
        p := s;
        s := SumSqrdDgt(p);
      end;
      //mark linked list backwards as happy number
      IF Cache[s] = 1 then
      Begin
        repeat
          s := Cache[p];
          Cache[p] := 1;
          p := s;
        until s = n;
        Cache[n] := 1;
      end;
    end;
  end;
end;

function nextCdigits(sqSum: NativeUint):NativeUint;
var
  i,cnt : LongInt;
Begin
  cnt:= SqrdSumCache[sqSum];
  If cnt = 0 then
  Begin
    For i := 0 to Cdigit-1 do
      cnt := cnt + Ord(Cache[sqSum+SqrdCache[i]]=1);
    //saving calculation->speed up x100
    SqrdSumCache[sqSum] := cnt;
  end;
  nextCdigits := cnt;
end;

function is_happy(n: NativeUint): boolean;inline;
begin
  is_happy := Cache[SumSqrdDgt(n)]=1
end;

function nthHappy(Limit: NativeUint):NativeUint;
var
  n,
  count : NativeUint;
begin
  n:= 0;
  count := 0;
  // big steps
  IF limit>cDigit then
    repeat
      inc(count,nextCdigits(SumSqrdDgt(n)));
      inc(n,cDigit);
    until count >= Limit-cDigit;
  // small steps
  repeat
    if is_happy(n) then
      inc(count);
    inc(n);
  until count >= Limit;
  nthHappy:= n-1;
end;

var
  n, count,Limit: NativeUint;
begin
  Inithappy;
  n := 1;
  count := 0;
  while count < 8 do
  begin
    if is_happy(n) then
    begin
      inc(count);
      write(n, ' ');
    end;
    inc(n);
  end;
  writeln;

  n := 1;
  Limit := 10;// 1En
  repeat
    writeln('10e',n,' nth happy number ',nthHappy(limit):13);
    inc(n);
    Limit := limit*10;
  until n> 8;
end.
