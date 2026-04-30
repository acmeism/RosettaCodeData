program gammafunction(output);
(* Gamma function *)

const
  pi = 3.1415926535897932384626433832795;

var
  x: real;

  function lngamma(z: real): real;
  var
    lz: array[0..6] of real;
    a, b: real;
    i: integer;
  begin
    lz[0] := 1.00000000019001;
    lz[1] := 76.1800917294715;
    lz[2] := -86.5053203294168;
    lz[3] := 24.0140982408309;
    lz[4] := -1.23173957245015;
    lz[5] := 0.0012086509738662;
    lz[6] := -0.000005395239385;
    if (z < 0.5) then
      lngamma := ln(pi / sin(pi * z)) - lngamma(1.0 - z)
    else
    begin
      z := z - 1.0;
      b := z + 5.5;
      a := lz[0];
      for i := 1 to 6 do
        a := a + lz[i] / (z + i);
      lngamma := (ln(sqrt(2 * pi)) + ln(a) - b) + ln(b) * (z + 0.5);
    end;
  end;

  function gamma(z: real): real;
  begin
    gamma := exp(lngamma(z));
  end;

begin
  x := 0.1;
  while x <= 2.05 do
  begin
    writeln(x, ' ', gamma(x));
    x := x + 0.1;
  end;
end.
