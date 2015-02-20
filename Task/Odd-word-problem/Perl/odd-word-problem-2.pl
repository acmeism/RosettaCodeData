sub rev
{
	my $c;
	read STDIN, $c, 1;
	if ($c =~ /^[a-zA-Z]$/) {
		my $r = rev();
		print $c;
		return $r;
	} else {
		return $c;
	}
}

while (read STDIN, $_, 1) {
	$w = /^[a-zA-Z]$/;
	$n++ if ($w && !$l);
	$l = $w;
	if ($n & 1) {
		print;
	} else {
		my $r = rev();
		print $_;
		print $r;
		$n = 0; $l = 0;
	}
}
