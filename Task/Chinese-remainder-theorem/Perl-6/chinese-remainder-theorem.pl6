# returns x where (a * x) % b == 1
sub mul-inv($a is copy, $b is copy) {
    return 1 if $b == 1;
    my ($b0, @x) = $b, 0, 1;
    ($a, $b, @x) = (
	$b,
	$a % $b,
	@x[1] - ($a div $b)*@x[0],
	@x[0]
    ) while $a > 1;
    @x[1] += $b0 if @x[1] < 0;
    return @x[1];
}

sub chinese-remainder(*@n) {
    my \N = [*] @n;
    -> *@a {
	N R% [+] map {
	    my \p = N div @n[$_];
	    @a[$_] * mul-inv(p, @n[$_]) * p
	}, ^@n
    }
}

say chinese-remainder(3, 5, 7)(2, 3, 2);
