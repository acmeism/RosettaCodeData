with ada.text_io; use ada.text_io;
with ada.numerics; use ada.numerics;

with ada.numerics.elementary_functions;
use ada.numerics.elementary_functions;

procedure adaptive_simpson_task is

  subtype flt is float;
  type function_flt_to_flt is
    access function (x : in flt) return flt;

  procedure simpson_rule (f : in function_flt_to_flt;
                          a, fa, b, fb : in flt;
                          m, fm, quadval : out flt) is
  begin
    m := 0.5 * (a + b);
    fm := f(m);
    quadval := ((b - a) / 6.0) * (fa + (4.0 * fm) + fb);
  end;

  function recursive_simpson (f : in function_flt_to_flt;
                              a, fa, b, fb : in flt;
                              tol, whole, m, fm : in flt;
                              depth : in integer) return flt is
    lm, flm, left : flt;
    rm, frm, right : flt;
    diff, tol2, quadval : flt;
  begin
    simpson_rule (f, a, fa, m, fm, lm, flm, left);
    simpson_rule (f, m, fm, b, fb, rm, frm, right);
    diff := left + right - whole;
    tol2 := 0.5 * tol;
    if depth <= 0 or tol2 = tol or abs (diff) <= 15.0 * tol then
      quadval := left + right + (diff / 15.0);
    else
      quadval := recursive_simpson (f, a, fa, m, fm, tol2,
                                    left, lm, flm, depth - 1)
                    + recursive_simpson (f, m, fm, b, fb, tol2,
                                         right, rm, frm, depth - 1);
    end if;
    return quadval;
  end;

  function quad_asr (f : in function_flt_to_flt;
                     a, b, tol : in flt;
                     depth : in integer) return flt is
    fa, fb, m, fm, whole : flt;
  begin
    fa := f(a);
    fb := f(b);
    simpson_rule (f, a, fa, b, fb, m, fm, whole);
    return recursive_simpson (f, a, fa, b, fb, tol,
                              whole, m, fm, depth);
  end;

  function sine (x : in flt) return flt is
  begin
    return sin (x);
  end;

  quadval : flt;

begin
  quadval := quad_asr (sine'access, 0.0, 1.0, 1.0e-5, 100);
  put ("estimate of ∫ sin x dx from 0 to 1:");
  put_line (quadval'image);
end;

-- local variables:
-- mode: indented-text
-- tab-width: 2
-- end:
