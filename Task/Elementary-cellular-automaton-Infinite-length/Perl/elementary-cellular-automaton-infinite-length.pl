sub evolve {
	my ($rule, $pattern) = @_;
	my $offset = 0;

	while (1) {
		my ($l, $r, $st);
		$pattern =~ s/^((.)\g2*)/$2$2/ and $l = $2, $offset -= length($2);
		$pattern =~ s/(.)\g1*$/$1$1/   and $r = $1;

		$st = $pattern;

		$pattern =~ tr/01/.#/;
		printf "%5d| %s%s\n", $offset, ' ' x (40 + $offset), $pattern;

		$pattern = join '', map(1 & ($rule>>oct "0b$_"),
				$l x 3,
				map(substr($st, $_, 3), 0 .. length($st)-3),
				$r x 3);
	}
}

evolve(90, "010");
