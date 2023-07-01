program Gamma_function;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Math;

function lanczos7(z: double): Double;
begin
  var t := z + 6.5;
  var x := 0.99999999999980993 + 676.5203681218851 / z - 1259.1392167224028 / (z
    + 1) + 771.32342877765313 / (z + 2) - 176.61502916214059 / (z + 3) +
    12.507343278686905 / (z + 4) - 0.13857109526572012 / (z + 5) +
    9.9843695780195716e-6 / (z + 6) + 1.5056327351493116e-7 / (z + 7);

  Result := Sqrt(2) * Sqrt(pi) * Power(t, z - 0.5) * exp(-t) * x;
end;

begin
  var xs: TArray<double> := [-0.5, 0.1, 0.5, 1, 1.5, 2, 3, 10, 140, 170];
  writeln('    x              Lanczos7');
  for var x in xs do
    writeln(format('%5.1f %24.16g', [x, lanczos7(x)]));
  readln;
end.
