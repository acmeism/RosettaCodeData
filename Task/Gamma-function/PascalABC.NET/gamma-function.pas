const
  g = 7;
  p: array of real =
        (0.99999999999980993, 676.5203681218851, -1259.1392167224028,
	     771.32342877765313, -176.61502916214059, 12.507343278686905,
	     -0.13857109526572012, 9.9843695780195716e-6, 1.5056327351493116e-7);

function Gamma(z: Complex): Complex;
begin
  if (z.Real < 0.5) then
  begin
    result := pi / (Sin(pi * z) * Gamma(1 - z));
    exit;
  end
  else
  begin
    z -= 1;
    var x: Complex := p[0];
    for var i := 1 to g + 1 do x += p[i] / (z + i);
    var t := z + g + 0.5;
    result := Sqrt(2 * pi) * (Power(t, z + 0.5)) * Exp(-t) * x;
  end;
end;

begin
  writeln('z          Lanczos');
  for var i := 1 to 10 do writeln(i / 3:6:4, gamma(i / 3):25);
end.
