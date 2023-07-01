$tuples = [ map { [split /:/] } glob '{1,2,3}:{30}:{500,100}' ];

for $a (@$tuples) { printf "(%1d %2d %3d) ", @$a; }
