import std.math;
import std.stdio;
import std.typecons;

double
quad_asr (double function (double) f, double a, double b,
          double tol, int depth)
{
   auto quad_asr_simpsons_ (double a, double fa, double b, double fb)
   {
     auto m = 0.5 * (a + b);
     auto fm = f(m);
     auto h = b - a;
     return tuple!("m", "fm", "quadval")
       (m, fm, (h / 6) * (fa + 4*fm + fb));
   }

   double quad_asr_ (double a, double fa, double b, double fb,
                     double tol, double whole, double m, double fm,
                     int depth)
   {
     //
     // Please do not ask why I do not use multiple return
     // statements. Finding reasons why is left as an exercise.
     //
     auto retval = NaN (0);
     auto left = quad_asr_simpsons_ (a, fa, m, fm);
     auto right = quad_asr_simpsons_ (m, fm, b, fb);
     auto delta = left.quadval + right.quadval - whole;
     auto tol_ = 0.5 * tol;
     if (depth <= 0 || tol_ == tol || abs (delta) <= 15 * tol)
       retval = left.quadval + right.quadval + (delta / 15);
     else
       retval = (quad_asr_ (a, fa, m, fm, tol_, left.quadval,
                           left.m, left.fm, depth - 1)
                 + quad_asr_ (m, fm, b, fb, tol_, right.quadval,
                              right.m, right.fm, depth - 1));
     return retval;
   }

   auto fa = f(a);
   auto fb = f(b);
   auto whole = quad_asr_simpsons_ (a, fa, b, fb);
   return quad_asr_ (a, fa, b, fb, tol, whole.quadval,
                     whole.m, whole.fm, depth);
}

int
main ()
{
  auto result = quad_asr (&sin, 0.0, 1.0, 1e-9, 1000);
  printf ("estimate of ∫ sin x dx from 0 to 1: %lf\n", result);
  return 0;
}
