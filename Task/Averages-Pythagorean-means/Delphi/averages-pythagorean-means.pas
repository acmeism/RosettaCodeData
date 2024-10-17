program AveragesPythagoreanMeans;

{$APPTYPE CONSOLE}

uses Types, Math;

function ArithmeticMean(aArray: TDoubleDynArray): Double;
var
  lValue: Double;
begin
  Result := 0;
  for lValue in aArray do
    Result := Result + lValue;
  if Result > 0 then
    Result := Result / Length(aArray);
end;

function GeometricMean(aArray: TDoubleDynArray): Double;
var
  lValue: Double;
begin
  Result := 1;
  for lValue in aArray do
    Result := Result * lValue;
  Result := Power(Result, 1 / Length(aArray));
end;

function HarmonicMean(aArray: TDoubleDynArray): Double;
var
  lValue: Double;
begin
  Result := 0;
  for lValue in aArray do
    Result := Result + 1 / lValue;
  Result := Length(aArray) / Result;
end;

var
  lSourceArray: TDoubleDynArray;
  AMean, GMean, HMean: Double;
begin
  lSourceArray := TDoubleDynArray.Create(1,2,3,4,5,6,7,8,9,10);
  AMean := ArithmeticMean(lSourceArray));
  GMean := GeometricMean(lSourceArray));
  HMean := HarmonicMean(lSourceArray));
  if (AMean >= GMean) and (GMean >= HMean) then
    Writeln(AMean, " ≥ ", GMean, " ≥ ", HMean)
  else
    writeln("Error!");
end.
