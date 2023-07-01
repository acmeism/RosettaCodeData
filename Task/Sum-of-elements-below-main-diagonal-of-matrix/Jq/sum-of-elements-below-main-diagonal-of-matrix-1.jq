def add(s): reduce s as $x (null; . + $x);

# input: a square matrix
def sum_below_diagonal:
  add( range(0;length) as $i | .[$i][:$i][] ) ;
