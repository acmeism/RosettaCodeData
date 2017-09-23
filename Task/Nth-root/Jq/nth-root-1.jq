# An iterative algorithm for finding: self ^ (1/n) to the given
# absolute precision if "precision" > 0, or to within the precision
# allowed by IEEE 754 64-bit numbers.

# The following implementation handles underflow caused by poor estimates.
def iterative_nth_root(n; precision):
  def abs: if . < 0 then -. else . end;
  def sq: .*.;
  def pow(p): . as $in | reduce range(0;p) as $i (1; . * $in);
    def _iterate: # state: [A, x1, x2, prevdelta]
      .[0] as $A | .[1] as $x1 | .[2] as $x2 | .[3] as $prevdelta
      | ( $x2 | pow(n-1)) as $power
      | if $power <= 2.155094094640383e-309
        then  [$A, $x1, ($x1 + $x2)/2, n] | _iterate
	else (((n-1)*$x2 + ($A/$power))/n) as $x1
	| (($x1 - $x2)|abs) as $delta
        | if (precision == 0 and $delta == $prevdelta and $delta < 1e-15)
             or (precision > 0 and $delta <= precision) or $delta == 0 then $x1
          else [$A, $x2, $x1, $delta] | _iterate
          end
        end
    ;
    if n == 1 then .
    elif . == 0 then 0
    elif . < 0 then error("iterative_nth_root: input \(.) < 0")
    elif n != (n|floor) then error("iterative_nth_root: argument \(n) is not an integer")
    elif n == 0 then error("iterative_nth_root(0): domain error")
    elif n < 0 then 1/iterative_nth_root(-n; precision)
    else [., ., (./n), n, 0]  | _iterate
    end
;
