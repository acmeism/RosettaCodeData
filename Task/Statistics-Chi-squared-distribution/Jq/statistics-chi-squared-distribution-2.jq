def Chi2_pdf($x; $k):
  if $x <= 0 then 0
  else # ((-$x/2)|exp) * pow($x; $k/2 -1) / (pow(2;$k/2) * (($k/2)|gamma))
         ((-$x/2) + ($k/2 -1) * ($x|log) - ( ($k/2)*(2|log) + (($k/2)|lgamma))) | exp
  end;

# $k is the degrees of freedom
# Use recursive relation for gamma: G(x+1) = x * G(x)
def Chi2_cdf($x; $k):
  if $x == 0 then 0
  elif $x > (1e3 * $k) then 1
  else 1e-15 as $tol  # for example
  | { s: 0, m: 0, term: (1 / ((($k/2)+1)|gamma)) }
  | until (.term|length < $tol;
      .s += .term
      | .m += 1
      | .term *= (($x/2) / (($k/2) + .m )) )
  | .s * ( ((-$x/2) + ($k/2)*(($x/2)|log)) | exp)
  end ;
