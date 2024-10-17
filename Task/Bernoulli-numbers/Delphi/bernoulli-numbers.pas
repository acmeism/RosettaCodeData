program Bernoulli_numbers;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  Velthuis.BigRationals;

function b(n: Integer): BigRational;
begin
  var a: TArray<BigRational>;
  SetLength(a, n + 1);
  for var m := 0 to High(a) do
  begin
    a[m] := BigRational.Create(1, m + 1);
    for var j := m downto 1 do
    begin
      a[j - 1] := (a[j - 1] - a[j]) * j;
    end;
  end;
  Result := a[0];
end;

begin
  for var n := 0 to 60 do
  begin
    var bb := b(n);
    if bb.Numerator.BitLength > 0 then
      writeln(format('B(%2d) =%45s/%s', [n, bb.Numerator.ToString, bb.Denominator.ToString]));
  end;
  readln;
end.
