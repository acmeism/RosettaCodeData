sub sieve {
	my ($s, $p) = "." . ("x" x shift);

	1 while ++$p
		and $s =~ /^(.{$p,}?)x/g
		and $p = length($1)
		and $s =~ s/(.{$p})./${1}./g
		and substr($s, $p, 1) = "x";
	$s
}

print sieve(1000);
