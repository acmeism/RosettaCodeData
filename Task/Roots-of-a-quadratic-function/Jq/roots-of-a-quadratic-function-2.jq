# If there are infinitely many solutions, emit true;
# if none, emit empty;
# otherwise always emit two.
# For numerical accuracy, Middlebrook's approach is adopted:
def quadratic_roots(a; b; c):
  if a == 0 and b == 0 then
     if c == 0 then true # infinitely many
     else empty          # none
     end
  elif a == 0 then [-c/b, 0]
  elif b == 0 then (complex_sqrt(1/a) | (., negate(.)))
  else
    divide( plus(1.0; complex_sqrt( minus(1.0; (4 * a * c / (b*b))))); 2) as $f
    | negate(divide(multiply(b; $f); a)),
      negate(divide(c; multiply(b; $f)))
  end
;
