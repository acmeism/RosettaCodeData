Program HappyNumbers (output);
{$IFDEF FPC}
  {$MODE DELPHI}
  {$OPTIMIZATION ON,All}
{$ELSE}
  {$APPLICATION CONSOLE}
{$ENDIF}
//{$DEFINE Use1E9}
uses
  sysutils,//Timing
  strutils;//Numb2USA

const
  base = 10;
  HighCache = 20*(sqr(base-1));//sum of sqr digit of Uint64
{$IFDEF Use1E9}
  cDigit1  = sqr(base)*sqr(base);//must be power of base
  cDigit2  = Base*sqr(cDigit1);// 1e9
  cMaxPot  = 18;
{$ELSE}
  cDigit1  = base*sqr(base);//must be power of base
  cDigit2  = sqr(cDigit1);// 1e6
  cMaxPot  = 14;
{$ENDIF}

type
  tSumSqrDgts    = array[0..cDigit2] of word;
  tCache         = array[0..2*HighCache] of word;
  tSqrdSumCache  = array[0..2*HighCache] of Uint32;

var
  SumSqrDgts :tSumSqrDgts;
  Cache : tCache;

  SqrdSumCache1,
  SqrdSumCache2 :tSqrdSumCache;

  T1,T0 : TDateTime;
  MAX2,Max1 : NativeInt;

procedure InitSumSqrDgts;
//calc all sum of squared digits 0..cDigits2
//using already calculated values
var
  i,j,n,sq,Base1: NativeInt;
begin
  For i := 0 to Base-1 do
    SumSqrDgts[i] := i*i;
  Base1 := Base;
  n := Base;
  repeat
    For i := 1 to base-1 do
    Begin
      sq := SumSqrDgts[i];
      For j := 0 to base1-1 do
      Begin
        SumSqrDgts[n] := sq+SumSqrDgts[j];
        inc(n);
      end;
    end;
    Base1 := Base1*base;
  until Base1 >= cDigit2;
  SumSqrDgts[n] := 1;
end;

function SumSqrdDgt(n: Uint64):NativeUint;inline;
var
  r: Uint64;
begin
  result := 0;
  while n>cDigit2 do
  Begin
    r := n;
    n := n div cDigit2;
    r := r-n*cDigit2;
    inc(result,SumSqrDgts[r]);
  end;
  inc(result,SumSqrDgts[n]);
end;

procedure CalcSqrdSumCache1;
var
  Count : tSqrdSumCache;
  i,sq,result : NativeInt;
begin
  For i :=High(Count) downto 0 do
    Count[i] := 0;
  //count the manifold
  For i := cDigit1-1 downto 0 do
    inc(count[SumSqrDgts[i]]);
  For i := High(Count) downto 0 do
    if count[i] <> 0 then
    Begin
      Max1 := i;
      BREAK;
    end;
  For sq := 0 to (20-3)*81 do
  Begin
    result := 0;
    For i := Max1 downto 0 do
      inc(result,Count[i]*Cache[sq+i]);
    SqrdSumCache1[sq] := result;
  end;
end;

procedure CalcSqrdSumCache2;
var
  Count : tSqrdSumCache;
  i,sq,result : NativeInt;
begin
  For i :=High(Count) downto 0 do
    Count[i] := 0;
  For i := cDigit2-1 downto 0 do
    inc(count[SumSqrDgts[i]]);
  For i := High(Count) downto 0 do
    if count[i] <> 0 then
    Begin
      Max2 := i;
      BREAK;
    end;
  For sq := 0 to (20-6)*81 do
  Begin
    result := 0;
    For i := Max2 downto 0 do
      inc(result,Count[i]*Cache[sq+i]);
    SqrdSumCache2[sq] := result;
  end;
end;

procedure Inithappy;
var
  n,s,p : NativeUint;
Begin
  fillchar(SqrdSumCache1,SizeOf(SqrdSumCache1),#0);
  fillchar(SqrdSumCache2,SizeOf(SqrdSumCache2),#0);
  InitSumSqrDgts;
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
  //mark all unhappy numbers with 0
  For n := 1 to High(Cache) do
    If Cache[n] <> 1 then
      Cache[n] := 0;
   CalcSqrdSumCache1;
   CalcSqrdSumCache2;
end;

function is_happy(n: NativeUint): boolean;inline;
begin
  is_happy := Boolean(Cache[SumSqrdDgt(n)])
end;

function nthHappy(Limit: Uint64):Uint64;
var
  d,e,sE: NativeUint;
begin
  result := 0;
  d := 0;
  e := 0;
  sE := SumSqrDgts[e];
  //big steps
  while Limit >= cDigit2 do
  begin
    dec(Limit,SqrdSumCache2[SumSqrDgts[d]+sE]);
    inc(result,cDigit2);
    inc(d);
    IF d >=cDigit2 then
    Begin
      inc(e);
      sE := SumSqrdDgt(e);//SumSqrDgts[e];
      d :=0;
    end;
  end;
  //small steps
  while Limit >= cDigit1 do
  Begin
    dec(Limit,SqrdSumCache1[SumSqrdDgt(result)]);
    inc(result,cDigit1);
  end;
  //ONE BY ONE
  while Limit > 0 do
  begin
    dec(Limit,Cache[SumSqrdDgt(result)]);
    inc(result);
  end;
  result -= 1;
end;

var
  n, count :Uint64;
  Limit: NativeUint;
begin
  write('cDigit1 = ',Numb2USA(IntToStr(cDigit1)));
  writeln('  cDigit2 = ',Numb2USA(IntToStr(cDigit2)));
  T0 := now;
  Inithappy;
  writeln('Init takes ',FormatDateTime(' HH:NN:SS.ZZZ',now-T0));
  n := 1;
  count := 0;
  while count < 10  do
  begin
    if is_happy(n) then
    begin
      inc(count);
      write(n, ' ');
    end;
    inc(n);
  end;
  writeln;

  T0 := now;
  T1 := T0;
  n := 1;
  Limit := 10;
  repeat
    writeln('1E',n:2,' n.th happy number ',Numb2USA(IntToStr(nthHappy(Limit))):26,
      FormatDateTime(' HH:NN:SS.ZZZ',now-T1));
    T1 := now;
    inc(n);
    Limit := limit*10;
  until n> cMaxPot;
  writeln('Total time counting ',FormatDateTime('HH:NN:SS.ZZZ',now-T0));
end.
