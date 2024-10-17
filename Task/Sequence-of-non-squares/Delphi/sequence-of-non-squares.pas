program Sequence_of_non_squares;

uses
  System.SysUtils, System.Math;

function nonsqr(i: Integer): Integer;
begin
  Result := Trunc(i + Floor(0.5 + Sqrt(i)));
end;

var
  i: Integer;
  j: Double;

begin

  for i := 1 to 22 do
    write(nonsqr(i), ' ');
  Writeln;

  for i := 1 to 999999 do
  begin
    j := Sqrt(nonsqr(i));
    if (j = Floor(j)) then
      Writeln(i, 'Is Square');
  end;
end.
