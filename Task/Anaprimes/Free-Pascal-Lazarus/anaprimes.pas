program AnaPrimes;
{$IFDEF FPC}
  {$MODE DELPHI}
  {$OPTIMIZATION ON,ALL}
{$ELSE}
  {$APPLICATION CONSOLE}
{$ENDIF}
uses
  sysutils;
const
  Limit= 100*1000*1000;

type
  tPrimesSieve = array of boolean;
  tElement = Uint64;
  tarrElement = array of tElement;
  tpPrimes = pBoolean;

const
  cTotalSum = 16;
  cMaxCardsOnDeck = cTotalSum;
  CMaxCardsUsed   = cTotalSum;

type
  tDeckIndex     = 0..cMaxCardsOnDeck-1;
  tSequenceIndex = 0..CMaxCardsUsed;
  tDiffCardCount = Byte;

  tSetElem     = packed record
                   Elemcount : tDeckIndex;
                   Elem  : tDiffCardCount;
                 end;
  tSetRange  = low(tDeckIndex)..High(tDeckIndex);
  tRemSet = array [low(tDeckIndex)..High(tDeckIndex)] of tSetElem;
  tpRemSet = ^tRemSet;
  tRemainSet      = array [tSequenceIndex] of tRemSet;
  tCardSequence   = array [tSequenceIndex] of tDiffCardCount;

  tChain = record
             StartNum,
             EndNum,
             chainLength : Int64;
           end;
var
  PrimeSieve : tPrimesSieve;
  gblTestChain : tChain;
//*********** Sieve of erathostenes
  procedure ClearAll;
  begin
    setlength(PrimeSieve,0);
  end;

  function BuildWheel(pPrimes:tpPrimes;lmt:Uint64): Uint64;
  var
    wheelSize, wpno, pr, pw, i, k: NativeUint;
    wheelprimes: array[0..15] of byte;
  begin
    pr := 1;//the mother of all numbers 1 ;-)
    pPrimes[1] := True;
    WheelSize := 1;

    wpno := 0;
    repeat
      Inc(pr);
      //pw = pr projected in wheel of wheelsize
      pw := pr;
      if pw > wheelsize then
        Dec(pw, wheelsize);
      if pPrimes[pw] then
      begin
        k := WheelSize + 1;
        //turn the wheel (pr-1)-times
        for i := 1 to pr - 1 do
        begin
          Inc(k, WheelSize);
          if k < lmt then
            move(pPrimes[1], pPrimes[k - WheelSize], WheelSize)
          else
          begin
            move(pPrimes[1], pPrimes[k - WheelSize], Lmt - WheelSize * i);
            break;
          end;
        end;
        Dec(k);
        if k > lmt then
          k := lmt;
        wheelPrimes[wpno] := pr;
        pPrimes[pr] := False;
        Inc(wpno);

        WheelSize := k;//the new wheelsize
        //sieve multiples of the new found prime
        i := pr;
        i := i * i;
        while i <= k do
        begin
          pPrimes[i] := False;
          Inc(i, pr);
        end;
      end;
    until WheelSize >= lmt;

    //re-insert wheel-primes 1 still stays prime
    while wpno > 0 do
    begin
      Dec(wpno);
      pPrimes[wheelPrimes[wpno]] := True;
    end;
    result := pr;
  end;

  procedure Sieve(pPrimes:tpPrimes;lmt:Uint64);
  var
    sieveprime, fakt, i: UInt64;
  begin
    sieveprime := BuildWheel(pPrimes,lmt);
    repeat
      repeat
        Inc(sieveprime);
      until pPrimes[sieveprime];
      fakt := Lmt div sieveprime;
      while Not(pPrimes[fakt]) do
        dec(fakt);
      if fakt < sieveprime then
        BREAK;
      i := (fakt + 1) mod 6;
      if i = 0 then
        i := 4;
      repeat
        pPrimes[sieveprime * fakt] := False;
        repeat
          Dec(fakt, i);
          i := 6 - i;
        until pPrimes[fakt];
        if fakt < sieveprime then
          BREAK;
      until False;
    until False;
    pPrimes[1] := False;//remove 1
  end;

procedure InitAndGetPrimes;
begin
  setlength(PrimeSieve,Limit+1);
  Sieve(@PrimeSieve[0],Limit);
end;
//*********** End Sieve of erathostenes
{$ALIGN 32}
type
  tCol = Int32;
  tFreeCol =  Array[0..CMaxCardsUsed] of tCol;
var

  RemainSets    : tRemainSet;
  PrmDgts :tFreeCol;
  maxDgt,
  gblMaxCardsUsed,
  gblMaxUsedIdx,
  gblPermCount : NativeInt;

//**************** Permutator
procedure EvaluatePerm;
var
  j,k : NativeUint;
Begin
  j := PrmDgts[0];
  for k := 1 to maxDgt do
    j := 10*j+PrmDgts[k];
  If PrimeSieve[j] then
  begin
    PrimeSieve[j] := false;
    with gblTestChain do
    begin
      EndNum := j;
      inc(ChainLength);
    end;
  end;
end;

function shouldSwap(var PrmDgts:tFreeCol;start,curr :int32):boolean;
begin
  for start := start to curr-1 do
    if PrmDgts[start] = PrmDgts[curr] then
      EXIT(false);
  result := true;
end;

procedure Permutate(var PrmDgts:tFreeCol;index:Int32);
const
  mask = (1 shl 1) OR (1 shl 3) OR (1 shl 7) OR (1 shl 9);
var
  i : Int32;
  tmp : tCol;
begin
   if index < maxDgt then
   begin
     for i := index to maxDgt do
       if shouldSwap(PrmDgts, index, i) then
       begin
         tmp:= PrmDgts[i];PrmDgts[i] := PrmDgts[index];PrmDgts[index]:= tmp;
         Permutate(PrmDgts, index+1);
         tmp:= PrmDgts[i];PrmDgts[i] := PrmDgts[index];PrmDgts[index]:= tmp;
       end;
  end
  else
    if PrmDgts[0] <> 0 then
      if (1 shl PrmDgts[maxDgt]) AND mask <> 0 then
      Begin
        inc(gblpermCount);
        EvaluatePerm;
      end;
end;

procedure CheckChain(n,dgtcnt:Uint64);
var
  dgts : array[0..9] of Uint32;
  i,k,idx : Int32;
begin
  gblTestChain.StartNum := n;
  gblTestChain.chainLength := 0;
  fillChar(dgts,SizeOF(dgts),#0);
  fillChar(PrmDgts,SizeOF(PrmDgts),#0);
  For i := 1 to dgtcnt do
  Begin
    inc(dgts[n MOD 10]);
    n := n div 10;
  end;
  idx := 0;
  For i := 0 to 9 do
    For k := dgts[i] downto 1  do
    begin
      PrmDgts[idx]:= i;
      inc(idx);
    end;
  Permutate(PrmDgts,0);
end;

var
  T1,T0: TDateTime;
  MaxChain : tChain;
  dgtCount : LongInt;
  pr,lmt :nativeInt;

Begin
  T0 := now;
  InitAndGetPrimes;
  T1 := now;
  Writeln('time for sieving ',FormatDateTime('NN:SS.ZZZ',T1-T0));
  dgtCount := 2;
  lmt := 99;
  pr := 10;
  repeat
    write(dgtCount:2);
    maxDgt := dgtCount-1;
    MaxChain.Chainlength := 0;
    gblpermCount := 0;
    repeat
      while (pr<lmt) AND Not primeSieve[pr] do
        inc(pr);
      if pr >lmt then
        BREAK;
      CheckChain(pr,dgtCount);
      If gblTestChain.chainLength > MaxChain.chainLength then
        MaxChain := gblTestChain;
      inc(pr);
    until pr>lmt;
    with MaxChain do
      writeln(StartNUm:12,EndNum:12,ChainLength:8);
    inc(dgtCount);
    lmt := lmt*10+9;
  until lmt>LIMIT;

end.
