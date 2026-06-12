fun quad_asr (tol, depth) (f, a, b) =
    let
      fun quad_asr_simpsons_ (a, fa, b, fb) =
          let
            val m = 0.5 * (a + b)
            val fm = f (m)
            val h = b - a
          in
            (m, fm, (h / 6.0) * (fa + (4.0 * fm) + fb))
          end

      fun quad_asr_ (a, fa, b, fb, tol, whole, m, fm, depth) =
          let
            val (lm, flm, left) = quad_asr_simpsons_ (a, fa, m, fm)
            and (rm, frm, right) = quad_asr_simpsons_ (m, fm, b, fb)
            val delta = left + right - whole
            and tol_ = 0.5 * tol
          in
            if depth <= 0
               orelse abs (tol_ - tol) <= 0.0 (* <-- SML silliness *)
               orelse Real.abs (delta) <= 15.0 * tol then
              left + right + (delta / 15.0)
            else
              quad_asr_ (a, fa, m, fm, tol_,
                         left, lm, flm, depth - 1)
              + quad_asr_ (m, fm, b, fb, tol_,
                           right, rm, frm, depth - 1)
          end

      val fa = f (a) and fb = f (b)
      val (m, fm, whole) = quad_asr_simpsons_ (a, fa, b, fb)
    in
      quad_asr_ (a, fa, b, fb, tol, whole, m, fm, depth)
    end
;

val quadrature = quad_asr (0.000000001, 1000);

print "estimated definite integral of sin(x) for x from 0 to 1: ";
print (Real.toString (quadrature (Math.sin, 0.0, 1.0)));
print "\n";
