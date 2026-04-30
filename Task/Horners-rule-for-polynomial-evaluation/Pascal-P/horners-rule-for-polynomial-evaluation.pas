program horner(output);

  (* Horner's rule for polynomial evaluation *)
const
  nmax = 10;
type
  tcoeffs = array[0 .. nmax] of real;
var
  coeffs: tcoeffs;
  x: real;

  function poly(c: tcoeffs; n: integer; x: real): real;
  var
    i: integer;
    h: real;
  begin
    h := 0;
    for i := n downto 0 do
      h := c[i] + (h * x);
    poly := h;
  end;

begin
  (* coefficients of all x^0..x^n *)
  coeffs[0] := -19;
  coeffs[1] := 7;
  coeffs[2] := -4;
  coeffs[3] := 6;
  x := 3.0;
  writeln('Value of (', coeffs[3]: 10, ')*x^3 + (', coeffs[2]: 10,
    ')*x^2 + (', coeffs[1]: 10, ')*x + (', coeffs[0]: 10, ')');
  writeln('at x = ', x: 10, ': ', poly(coeffs, 3, 3.0): 10);
  (* readln; *)
end.
