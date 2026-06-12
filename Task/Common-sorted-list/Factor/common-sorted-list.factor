USING: formatting kernel sets sorting ;

{ { 5 1 3 8 9 4 8 7 } { 3 5 9 8 4 } { 1 3 7 9 } }
dup union-all natural-sort
"Sorted union of %u is:\n%u\n" printf
