program FactorialPrimes;
{$mode ObjFPC}{$H+}
uses
  {$ifdef unix} cthreads, {$endif} SysUtils, Math;

type
  TArr = array of UInt32;

const
  Numbers: array[0..5] of UInt32 = (12757923, 197622519, 12878611, 12757923, 15808973, 15780709);

var
  Finished: UInt32;
  PrimeFactors: array[0..5] of TArr;

function GetPrimes(n: UInt32): TArr;
var
  Divisor, Next, Rest: UInt32;
begin
  Divisor := 2;
  Next := 3;
  Rest := n;
  while (Rest <> 1) do
  begin
    while (Rest mod Divisor = 0) do
    begin
      SetLength(Result, Length(Result) + 1);
      Result[High(Result)] := Divisor;
      Rest := Rest div Divisor;
    end;
    Divisor := Next;
    Next := Next + 2;
  end;
end;

function FindPrimeFactors(p: Pointer): PtrInt;   {threaded function}
var
  Index: UInt32;
begin
  Index := UInt32(p);
  PrimeFactors[Index] := GetPrimes(Numbers[Index]);
  InterLockedIncrement(Finished);
  Result := 0;
end;

function LowestFactor(factors: TArr): UInt32;
var
  Factor: UInt32;
begin
  Result := factors[0];
  for Factor in factors do
    Result := Min(Result, Factor);
end;

var
  ThreadCount, i, MinFactorIndex, MaxMinFactor, Factor: UInt32;
begin
  Finished := 0;
  ThreadCount := Length(Numbers);

  for i := 0 to High(Numbers) do
    BeginThread(@FindPrimeFactors, Pointer(i));

  while Finished < ThreadCount do;

  MaxMinFactor := 0;
  MinFactorIndex := 0;

  for i := 0 to High(Numbers) do
  begin
    Factor := LowestFactor(PrimeFactors[i]);
    if Factor > MaxMinFactor then
    begin
      MaxMinFactor := Factor;
      MinFactorIndex := i;
    end;
  end;

  Writeln('Number ', Numbers[MinFactorIndex], ' has the largest minimal factor:');
  for Factor in PrimeFactors[MinFactorIndex] do
    Write(' ', Factor);
end.
