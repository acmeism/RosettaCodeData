sub halve  (Int $n is rw)    { $n div= 2 }
sub double (Int $n is rw)    { $n *= 2 }
sub even   (Int $n --> Bool) { $n %% 2 }

sub ethiopicmult (Int $a is copy, Int $b is copy --> Int) {
    my Int $r = 0;
    while $a {
	even $a or $r += $b;
	halve $a;
	double $b;
    }
    return $r;
}
