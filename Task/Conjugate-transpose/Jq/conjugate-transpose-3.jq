# a and b are arrays of real/complex numbers
def dot_product(a; b):
  a as $a | b as $b
  | reduce range(0;$a|length) as $i
      (0; . as $s | plus($s; multiply($a[$i]; $b[$i]) ));
