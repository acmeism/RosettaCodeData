program Radical;
{$IFDEF FPC}  {$MODE DELPHI}{$Optimization ON,ALL} {$ENDIF}
{$IFDEF WINDOWS}{$APPTYPE CONSOLE}{$ENDIF}
//much faster would be
//https://rosettacode.org/wiki/Factors_of_an_integer#using_Prime_decomposition
const
  LIMIT = 1000*1000;
  DeltaMod235 : array[0..7] of Uint32 = (4, 2, 4, 2, 4, 6, 2, 6);

type
  tRadical = record
               number,radical,PrFacCnt: Uint64;
               isPrime : boolean;
             end;
  function GetRadical(n: UInt32):tRadical;forward;

function CommaUint(n : Uint64):AnsiString;
//commatize only positive Integers
var
  fromIdx,toIdx :Int32;
  pRes : pChar;
Begin
  str(n,result);
  fromIdx := length(result);
  toIdx := fromIdx-1;
  if toIdx < 3 then
    exit;

  toIdx := 4*(toIdx DIV 3)+toIdx MOD 3 +1 ;
  setlength(result,toIdx);
  pRes := @result[1];
  dec(pRes);
  repeat
    pRes[toIdx]   := pRes[FromIdx];
    pRes[toIdx-1] := pRes[FromIdx-1];
    pRes[toIdx-2] := pRes[FromIdx-2];
    pRes[toIdx-3] := ',';
    dec(toIdx,4);
    dec(FromIdx,3);
  until FromIdx<=3;
  while fromIdx>=1 do
  Begin
    pRes[toIdx] := pRes[FromIdx];
    dec(toIdx);
    dec(fromIdx);
  end;
end;

procedure OutRadical(n: Uint32);
Begin
  writeln('Radical for ',CommaUint(n):8,':',CommaUint(GetRadical(n).radical):8);
end;

function GetRadical(n: UInt32):tRadical;
var
  q,divisor, rest: UInt32;
  nxt : Uint32;
begin
  with result do
  Begin
    number := n;
    radical := n;
    PrFacCnt := 1;
    isPrime := false;
  end;

  if n <= 1 then
    EXIT;

  if n in [2,3,5,7,11,13,17,19,23,29,31] then
  Begin
    with result do
    Begin
      isprime := true;
      PrFacCnt := 1;
    end;
    EXIT;
  end;

  with result do
  Begin
    radical := 1;
    PrFacCnt := 0;
  end;

  rest := n;
  if rest AND 1 = 0 then
  begin
    with result do begin radical := 2; PrFacCnt:= 1;end;
    repeat
      rest := rest shr 1;
    until rest AND 1 <> 0;
  end;

  if rest < 3 then
    EXIT;
  q := rest DIV 3;
  if rest-q*3= 0 then
  begin
    with result do begin radical *= 3; inc(PrFacCnt);end;
    repeat
      rest := q;
      q := rest DIV 3;
    until rest-q*3 <> 0;
  end;

  if rest < 5 then
    EXIT;
  q := rest DIV 5;
  if rest-q*5= 0 then
  begin
    with result do begin radical *= 5;inc(PrFacCnt);end;
    repeat
      rest := q;
      q := rest DIV 5;
    until rest-q*5 <> 0;
  end;

  divisor := 7;
  nxt := 0;
  repeat;
    if rest < sqr(divisor) then
      BREAK;
    q := rest DIV divisor;
    if rest-q*divisor= 0 then
    begin
      with result do begin radical *= divisor; inc(PrFacCnt);end;
      repeat
        rest := q;
        q := rest DIV divisor;
      until rest-q*divisor <> 0;
    end;
    divisor += DeltaMod235[nxt];
    nxt := (nxt+1) AND 7;
  until false;
  //prime ?
  if rest = n then
    with result do begin radical := n;PrFacCnt:=1;isPrime := true; end
  else
    if rest >1 then
      with result do begin radical *= rest;inc(PrFacCnt);end;
end;

var
  Rad:tRadical;
  CntOfPrFac : array[0..9] of Uint32;
  j,sum,countOfPrimes,CountOfPrimePowers: integer;

begin
  writeln('The radicals for the first 50 positive integers are:');
  for j := 1 to 50 do
  Begin
    write (GetRadical(j).radical:4);
    if j mod 10 = 0 then
      Writeln;
  end;
  writeln;

  OutRadical( 99999);
  OutRadical(499999);
  OutRadical(999999);
  writeln;

  writeln('Breakdown of numbers of distinct prime factors');
  writeln('for positive integers from 1 to ',CommaUint(LIMIT));

  countOfPrimes:=0;
  CountOfPrimePowers :=0;
  For j := Low(CntOfPrFac) to High(CntOfPrFac) do
    CntOfPrFac[j] := 0;
  For j := 1 to LIMIT do
  Begin
    Rad := GetRadical(j);
    with rad do
    Begin
      IF isPrime then
        inc(countOfPrimes)
      else
        if (j>1)AND(PrFacCnt= 1) then
          inc(CountOfPrimePowers);
    end;
    inc(CntOfPrFac[Rad.PrFacCnt]);
  end;

  sum := 0;
  For j := Low(CntOfPrFac) to High(CntOfPrFac) do
    if CntOfPrFac[j] > 0 then
    Begin
      writeln(j:3,': ',CommaUint(CntOfPrFac[j]):10);
      inc(sum,CntOfPrFac[j]);
    end;
    writeln('sum: ',CommaUint(sum):10);
  writeln;
  sum := countOfPrimes+CountOfPrimePowers+1;
  writeln('For primes or powers (>1) there of <= ',CommaUint(LIMIT));
  Writeln('  Number of primes       =',CommaUint(countOfPrimes):8);
  Writeln('  Number of prime powers =',CommaUint(CountOfPrimePowers):8);
  Writeln('  Add 1 for number       =       1');
  Writeln('  sums to                =',CommaUint(sum):8);
  {$IFDEF WINDOWS}readln;{$ENDIF}
end.
