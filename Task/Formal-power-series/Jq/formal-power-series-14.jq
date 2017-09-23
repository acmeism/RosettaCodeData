# evaluate p(x) based on the first k terms of polynomial p, where x is the input
def ps_eval(p; k):
  . as $x
  | reduce range(0;k) as $i
    # state: [sum, x^i]
      ([0, 1];
       .[1] as $xn
       | ($i|p) as $coeff
       | [ .[0] + $coeff * $xn, $x * $xn])
  | .[0];

# If |x| < 1 then ps_evaluate(x) will evaluate to p(x) with high precision
# if the coefficients of the polynomial are eventually bounded.
#
# WARNING: ps_evaluate(p) will not detect divergence and is not intended to
# produce accurate results unless the terms of p(x) are reasonably well-behaved.
# For |x| > 1, the result will be null if x^n overflows before convergence is achieved.
#
def ps_evaluate(p):
  def abs: if . < 0 then -. else . end;
  def eval(p;x):
    # state: [i, x^i, sum of i terms, delta, prevdelta]
    recurse(
      .[0] as $i
      | .[1] as $xi
      | .[2] as $sum
      | .[3] as $delta
      | .[4] as $prevdelta
      | if $delta < 1e-17 and $prevdelta < 1e-17
           and ( $xi < 1e-100
                 or ( $sum != 0 and
                      (($delta/$sum) | abs) < 1e-10 and
                      (($prevdelta/$sum) | abs) < 1e-10) )
        then empty
        else
          ($xi * ($i|p)) as $newdelta
        | [ $i + 1,
            x*$xi,
            $sum+$newdelta,
            ($newdelta|abs), $delta]
        end ) ;
   . as $x
   | [0, 1, 0, 1, 1]
   | reduce eval(p; $x) as $vector (0; $vector[2]);
