my @primes = 2, 3, -> $n is copy {
    repeat { $n += 2 } until $n %% none do for @primes -> $p {
        last if $p > sqrt($n);
        $p;
    }
    $n;
} ... *;

multi factors(1) { 1 }
multi factors(Int $remainder is copy) {
  gather for @primes -> $factor {
    if $factor * $factor > $remainder {
      take $remainder if $remainder > 1;
      last;
    }
    while $remainder %% $factor {
        take $factor;
        last if ($remainder div= $factor) === 1;
    }
  }
}

sub is_prime($x) { (state %){$x} //= factors($x) == 1 }

sub mtest($bits, $p) {
    my @bits = $bits.base(2).comb;
    loop (my $sq = 1; @bits; $sq %= $p) {
	$sq *= $sq;
	$sq += $sq if 1 == @bits.shift;
    }
    $sq == 1;
}

for flat 2 .. 60, 929 -> $m {
    next unless is_prime($m);
    my $f = 0;
    my $x = 2**$m - 1;
    my $q;
    for 1..* -> $k {
	$q = 2 * $k * $m + 1;
	next unless $q % 8 == 1|7 or is_prime($q);
	last if $q * $q > $x or $f = mtest($m, $q);
    }

    say $f ?? "M$m = $x\n\t= $q × { $x div $q }"
           !! "M$m = $x is prime";
}
