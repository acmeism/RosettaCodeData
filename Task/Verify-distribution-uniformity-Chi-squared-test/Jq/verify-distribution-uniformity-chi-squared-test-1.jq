def round($dec):
   if type == "string" then .
   else pow(10;$dec) as $m
   | . * $m | floor / $m
   end;

# sum of squares
def ss(s): reduce s as $x (0; . + ($x * $x));

# Cumulative density function of the chi-squared distribution with $k
# degrees of freedom
# The recursion formula for gamma is used for efficiency and robustness.
def Chi2_cdf($x; $k):
  if $x == 0 then 0
  elif $x > (1e3 * $k) then 1
  else 1e-15 as $tol  # for example
  | { s: 0, m: 0, term: (1 / ((($k/2)+1)|gamma)) }
  | until (.term|length < $tol; # length here is abs
      .s += .term
      | .m += 1
      | .term *= (($x/2) / (($k/2) + .m )) )
  | .s * ( ((-$x/2) + ($k/2)*(($x/2)|log)) | exp)
  end ;
