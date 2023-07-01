sub rnd($) { int(rand(shift)) }

sub empties { grep !$_[0][$_], 0 .. 7 }

sub chess960 {
	my @s = (undef) x 8;
	@s[2*rnd(4), 1 + 2*rnd(4)] = qw/B B/;

	for (qw/Q N N/) {
		my @idx = empties \@s;
		$s[$idx[rnd(@idx)]] = $_;
	}

	@s[empties \@s] = qw/R K R/;
	@s
}
print "@{[chess960]}\n" for 0 .. 10;
