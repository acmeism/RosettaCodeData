my ($q, $r);

($q, $r) = poly_long_div([1, -12, 0, -42], [1, -3]);
poly_print(@$q);
poly_print(@$r);
print "\n";
($q, $r) = poly_long_div([1,-12,0,-42], [1,1,-3]);
poly_print(@$q);
poly_print(@$r);
print "\n";
($q, $r) = poly_long_div([1,3,2], [1,1]);
poly_print(@$q);
poly_print(@$r);
print "\n";
# the example from the OCaml solution
($q, $r) = poly_long_div([1,-4,6,5,3], [1,2,1]);
poly_print(@$q);
poly_print(@$r);
