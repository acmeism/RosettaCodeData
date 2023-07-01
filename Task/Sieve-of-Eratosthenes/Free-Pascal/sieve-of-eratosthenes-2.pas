program prime_sieve;
{$mode objfpc}{$coperators on}
uses
  SysUtils, Math;
type
  TPrimeList = array of DWord;
function OddSegmentSieve(aLimit: DWord): TPrimeList;
  function EstimatePrimeCount(aLimit: DWord): DWord;
  begin
    case aLimit of
      0..1:   Result := 0;
      2..200: Result := Trunc(1.6 * aLimit/Ln(aLimit)) + 1;
    else
      Result := Trunc(aLimit/(Ln(aLimit) - 2)) + 1;
    end;
  end;
  function Sieve(aLimit: DWord; aNeed2: Boolean): TPrimeList;
  var
    IsPrime: array of Boolean;
    I: DWord = 3;
    J, SqrtBound: DWord;
    Count: Integer = 0;
  begin
    if aLimit < 2 then
      exit(nil);
    SetLength(IsPrime, (aLimit - 1) div 2);
    FillChar(Pointer(IsPrime)^, Length(IsPrime), Byte(True));
    SetLength(Result, EstimatePrimeCount(aLimit));
    SqrtBound := Trunc(Sqrt(aLimit));
    if aNeed2 then
      begin
        Result[0] := 2;
        Inc(Count);
      end;
    for I := 0 to High(IsPrime) do
      if IsPrime[I] then
        begin
          Result[Count] := I * 2 + 3;
          if Result[Count] <= SqrtBound then
            begin
              J := Result[Count] * Result[Count];
              repeat
                IsPrime[(J - 3) div 2] := False;
                J += Result[Count] * 2;
              until J > aLimit;
            end;
          Inc(Count);
        end;
    SetLength(Result, Count);
  end;
const
  PAGE_SIZE = $8000;
var
  IsPrime: array[0..Pred(PAGE_SIZE)] of Boolean; //current page
  SmallPrimes: TPrimeList = nil;
  I: QWord;
  J, PageHigh, Prime: DWord;
  Count: Integer;
begin
  if aLimit < PAGE_SIZE div 4 then
    exit(Sieve(aLimit, True));
  I := Trunc(Sqrt(aLimit));
  SmallPrimes := Sieve(I + 1, False);
  Count := Length(SmallPrimes) + 1;
  I += Ord(not Odd(I));
  SetLength(Result, EstimatePrimeCount(aLimit));
  while I <= aLimit do
    begin
      PageHigh := Min(Pred(PAGE_SIZE * 2), aLimit - I);
      FillChar(IsPrime, PageHigh div 2 + 1, Byte(True));
      for Prime in SmallPrimes do
        begin
          J := DWord(I) mod Prime;
          if J <> 0 then
            J := Prime shl (1 - J and 1) - J;
          while J <= PageHigh do
            begin
              IsPrime[J div 2] := False;
              J += Prime * 2;
            end;
        end;
      for J := 0 to PageHigh div 2 do
        if IsPrime[J] then
          begin
            Result[Count] := J * 2 + I;
            Inc(Count);
          end;
      I += PAGE_SIZE * 2;
    end;
  SetLength(Result, Count);
  Result[0] := 2;
  Move(SmallPrimes[0], Result[1], Length(SmallPrimes) * SizeOf(DWord));
end;

  //usage

var
  Limit: DWord = 0;
function ReadLimit: Boolean;
var
  Lim: Int64;
begin
  if (ParamCount = 1) and Lim.TryParse(ParamStr(1), Lim) then
    if (Lim >= 0) and (Lim <= High(DWord)) then
      begin
        Limit := DWord(Lim);
        exit(True);
      end;
  Result := False;
end;
procedure PrintUsage;
begin
  WriteLn('Usage: prime_sieve Limit');
  WriteLn('  where Limit in the range [0, ', High(DWord), ']');
  Halt;
end;
procedure PrintPrimes(const aList: TPrimeList);
var
  I: DWord;
begin
  for I := 0 to Length(aList) - 2 do
    Write(aList[I], ', ');
  if aList <> nil then
    WriteLn(aList[High(aList)]);
end;
begin
  if not ReadLimit then
    PrintUsage;
  PrintPrimes(OddSegmentSieve(Limit));
end.
