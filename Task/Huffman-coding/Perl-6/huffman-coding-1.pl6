sub huffman ($s) {
    my $de = $s.chars;
    my @q = $s.comb.classify({$_}).map({[+.value / $de, .key]}).sort;
    while @q > 1 {
	my ($a,$b) = @q.splice(0,2);
	@q = sort [$a[0] + $b[0], [$a[1], $b[1]]], @q;
    }
    sort *.value, gather walk @q[0][1], '';
}

multi walk (@node, $prefix) {
    walk @node[0], $prefix ~ 1;
    walk @node[1], $prefix ~ 0;
}
multi walk ($node, $prefix) { take $node => $prefix }

say .perl for huffman('this is an example for huffman encoding');
