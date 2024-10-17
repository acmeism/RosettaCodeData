program Sparkline_in_unicode;

{$APPTYPE CONSOLE}

//Translated from: https://www.arduino.cc/reference/en/language/functions/math/map/
function map(x, in_min, in_max, out_min, out_max: Double): Double;
begin
  Result := ((x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min);
end;

procedure Normalize(var Values: TArray<Double>; outMin, outMax: Double);
var
  i: Integer;
  inMax, inMin, value: Double;
begin
  if Length(Values) = 0 then
    Exit;

  inMin := Values[0];
  inMax := Values[0];

  for value in Values do
  begin
    if value > inMax then
      inMax := value;
    if value < inMin then
      inMin := value;
  end;

  for i := 0 to High(Values) do
    Values[i] := map(Values[i], inMin, inMax, outMin, outMax);
end;

function Sparkline(Values: TArray<Double>): UnicodeString;
var
  value: Double;
const
  CHARS: UnicodeString = #$2581#$2582#$2583#$2584#$2585#$2586#$2587#$2588;
begin
  Result := '';
  Normalize(Values, 1, 8);
  for value in Values do
    Result := Result + CHARS[Trunc(value)];
end;

begin
  writeln(Sparkline([1, 2, 3, 4, 5, 6, 7, 8, 7, 6, 5, 4, 3, 2, 1]));
  writeln(Sparkline([1.5, 0.5, 3.5, 2.5, 5.5, 4.5, 7.5, 6.5]));
  Readln;
end.
