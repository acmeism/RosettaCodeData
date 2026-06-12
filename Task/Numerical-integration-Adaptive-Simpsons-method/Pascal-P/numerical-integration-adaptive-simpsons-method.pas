program simpson(output);
(* Numerical integration/Adaptive Simpson's method *)

var
  q: real;

  function f(x: real): real;
  begin
    f := sin(x);
  end;

  procedure simpsonrule(a, fa, b, fb: real; var m, fm, quadval: real);
  begin
    m := (a + b) / 2;
    fm := f(m);
    quadval := ((b - a) / 6) * (fa + (4 * fm) + fb);
  end;

  function recursion(a, fa, b, fb, tol, whole, m, fm: real; depth: integer): real;
  var
    lm, flm, left, rm, frm, right, delta, tol2: real;
  begin
    simpsonrule(a, fa, m, fm, lm, flm, left);
    simpsonrule(m, fm, b, fb, rm, frm, right);
    delta := left + right - whole;
    tol2 := tol / 2;
    if (depth <= 0) or (tol2 = tol) or (abs(delta) <= 15 * tol) then
      recursion := left + right + (delta / 15)
    else
      recursion :=
        recursion(a, fa, m, fm, tol2, left, lm, flm, depth - 1) +
        recursion(m, fm, b, fb, tol2, right, rm, frm, depth - 1);
  end;

  function quadasr(a, b, tol: real; depth: integer): real;
  var
    fa, fb, m, fm, whole: real;
  begin
    fa := f(a);
    fb := f(b);
    simpsonrule(a, fa, b, fb, m, fm, whole);
    quadasr := recursion(a, fa, b, fb, tol, whole, m, fm, depth);
  end;

begin
  q := quadasr(0, 1, 0.000001, 1000);
  write('Estimated definite integral of sin(x) ');
  writeln('for x from 0 to 1: ', q: 12);
  (* readln; *)
end.
