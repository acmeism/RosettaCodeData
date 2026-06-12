program adaptive_simpson_task;

type function_real_to_real = function(value : real) : real;
var fa, fb, m, fm, whole : real;

  function quad_asr (f         : function_real_to_real;
                     a, b, tol : real;
                     depth     : integer) : real;

    procedure quad_asr_simpsons_ (    a, fa, b, fb   : real;
                                  var m, fm, quadval : real);
    begin
      m := (a + b) / 2;
      fm := f(m);
      quadval := ((b - a) / 6) * (fa + (4 * fm) + fb)
    end;

    function quad_asr_ (a, fa, b, fb      : real;
                        tol, whole, m, fm : real;
                        depth             : integer) : real;
    var
      lm, flm, left  : real;
      rm, frm, right : real;
      delta, tol_    : real;
    begin
      quad_asr_simpsons_ (a, fa, m, fm, lm, flm, left);
      quad_asr_simpsons_ (m, fm, b, fb, rm, frm, right);
      delta := left + right - whole;
      tol_ := tol / 2;
      if (depth <= 0) or (tol_ = tol) or (abs(delta) <= 15 * tol) then
        quad_asr_ := left + right + (delta / 15)
      else
        quad_asr_ := (quad_asr_ (a, fa, m, fm, tol_,
                      left , lm, flm, depth - 1)
                      + quad_asr_ (m, fm, b, fb, tol_,
                      right, rm, frm, depth - 1))
    end;

  begin
    fa := f(a);
    fb := f(b);
    quad_asr_simpsons_ (a, fa, b, fb, m, fm, whole);
    quad_asr := quad_asr_ (a, fa, b, fb, tol, whole, m, fm, depth)
  end;

  function sine (x : real) : real;
  begin
    sine := sin (x);
  end;

begin
  writeln ('estimated definite integral of sin(x) ',
           'for x from 0 to 1: ', quad_asr (@sine, 0, 1, 1e-9, 1000))
end.
