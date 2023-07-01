program PrimePyramid;
{$IFDEF FPC}
  {$MODE delphi}{$Optimization ON,ALL}{$CodeAlign proc=32}
{$IFEND}
const
  MAX = 21;//max 8 different  SumToPrime : array[0..MAX,0..7] of byte;
  //MAX = 57;//max 16 different SumToPrime : array[0..MAX,0..15] of byte;
  cMaxAlign32 = (((MAX-1)DIV 32)+1)*32-1;//MAX > 0
type
  tPrimeRange = set of 0..127;
var
  SetOfPrimes :tPrimeRange =[2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,
                             53,59,61,67,71,73,79,83,89,97,101,103,107,
                             109,113,127];

  SumToPrime : array[0..cMaxAlign32,0..7] of byte;
//  SumToPrime : array[0..MAX,0..15] of byte;
  SumToPrimeMaxIdx,
  SumMaxIdx,
  Solution,
  FirstSolution    : array[0..cMaxAlign32] of byte;

  free : array[0..cMaxAlign32] of boolean;

  maxused : integer;
  digitcount,SolCount : integer;

procedure InitSumToPrime;
var
  i,j,idx : integer;
begin
  For i := 1 to MAX do
  Begin
    idx := 0;
    For j := 1 to MAX do
      If (i+j) in SetOfPrimes then
      Begin
        SumToPrime[i,idx] := j;
        inc(idx);
      end;
    SumToPrimeMaxIdx[i] := idx;
  end;
end;

procedure InitFree(maxused : integer);
var
  i,j : Integer;
begin
  For i := 0 to 1 do
    Free[i] := false;
  For i := 2 to maxused-1 do
    Free[i] := true;
  For i := maxused to MAX do
    Free[i] := false;
  // search maxidx of max neighour sum to prime
  For i := 1 to maxused-1 do
  begin
    j := SumToPrimeMaxIdx[i]-1;
    while SumToPrime[i,j] > maxused-1 do
      j -= 1;
    SumMaxIdx[i] := j+1;
  end;
end;

procedure CountSolution(digit:integer);
begin
  // check if maxused can follow
  if (digit+maxused) in SetOfPrimes then
  Begin
    if solcount = 0 then
       FirstSolution := Solution;
    inc(solCount);
  end;
end;

procedure checkDigits(digit:integer);
var
  idx,nextDigit: integer;
begin
  idx := 0;
  repeat
    nextDigit := SumToPrime[digit,idx];
    if Free[nextdigit] then
    Begin
      Solution[digitcount] := nextDigit;
      dec(digitcount);
      IF digitcount = 0 then
        CountSolution(nextDigit);
      free[nextdigit]:= false;
      checkDigits(nextdigit);
      inc(digitcount);
      free[nextdigit]:= true;
    end;
    inc(idx);
  until idx >= SumMaxIdx[digit];
end;

var
  i,j : integer;
Begin
  InitSumToPrime;
  writeln('number|   count|  first solution');
  writeln('   2|         1|  1  2');
  For i := 3 to 20 do
  Begin
    maxused := i;
    InitFree(i);
    digitcount := i-2;
    solCount := 0;
    checkDigits(1);
    write(i:4,'|',solcount:10,'|  1');
    For j := i-2 downto 1 do
      write( FirstSolution[j]:3);
    writeln(i:3);
  end;
end.
