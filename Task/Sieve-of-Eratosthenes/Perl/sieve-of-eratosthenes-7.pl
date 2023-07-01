sub sieve{ my ($s, $i);
	grep { not vec $s, $i  = $_, 1 and do
		{ (vec $s, $i += $_, 1) = 1 while $i <= $_[0]; 1 }
	} 2..$_[0]
}

print join ", " => sieve 100;
