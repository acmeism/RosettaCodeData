program prime_sieve;
{$mode objfpc}{$coperators on}
uses
  SysUtils, GVector;
type
  TPrimeList = specialize TVector<DWord>;
function Sieve(aLimit: DWord): TPrimeList;
var
  IsPrime: array of Boolean;
  I, SqrtBound: DWord;
  J: QWord;
begin
  Result := TPrimeList.Create;
  Inc(aLimit, Ord(aLimit < High(DWord))); //not a problem because High(DWord) is composite
  SetLength(IsPrime, aLimit);
  FillChar(Pointer(IsPrime)^, aLimit, Byte(True));
  SqrtBound := Trunc(Sqrt(aLimit));
  for I := 2 to aLimit do
    if IsPrime[I] then
      begin
        Result.PushBack(I);
        if I <= SqrtBound then
          begin
            J := I * I;
            repeat
              IsPrime[J] := False;
              J += I;
            until J > aLimit;
          end;
      end;
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
procedure PrintPrimes(aList: TPrimeList);
var
  I: DWord;
begin
  if aList.Size <> 0 then begin
    if aList.Size > 1 then
      for I := 0 to aList.Size - 2 do
        Write(aList[I], ', ');
    WriteLn(aList[aList.Size - 1]);
  end;
  aList.Free;
end;
begin
  if not ReadLimit then
    PrintUsage;
  try
    PrintPrimes(Sieve(Limit));
  except
    on e: Exception do
      WriteLn('An exception ', e.ClassName, ' occurred with message: ', e.Message);
  end;
end.
