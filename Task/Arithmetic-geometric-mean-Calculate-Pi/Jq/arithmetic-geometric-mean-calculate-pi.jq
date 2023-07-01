# include "rational";  # a reminder

def pi(precision):
  (precision | (. + log) | ceil) as $digits
  | def sq: . as $in | rmult($in; $in) | rround($digits);
  {an: r(1;1),
   bn: (r(1;2) | rsqrt($digits)),
   tn: r(1;4),
   pn: 1 }
  | until (.pn > $digits;
      .an as $prevAn
      | .an = (rmult(radd(.bn; .an); r(1;2)) | rround($digits) )
      | .bn = ([.bn, $prevAn] | rmult | rsqrt($digits) )
      | .tn = rminus(.tn; rmult(rminus($prevAn; .an)|sq; .pn))
      | .pn *= 2
      )
   | rdiv( radd(.an; .bn)|sq; rmult(.tn; 4))
   | r_to_decimal(precision);

pi(500)
