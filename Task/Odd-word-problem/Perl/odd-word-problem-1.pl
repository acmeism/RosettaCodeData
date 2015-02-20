sub r
{
	my ($f, $c) = @_;
	return sub { print $c; $f->(); };
}

$r = sub {};

while (read STDIN, $_, 1) {
	$w = /^[a-zA-Z]$/;
	$n++ if ($w && !$l);
	$l = $w;
	if ($n & 1 || !$w) {
		$r->(); $r = sub{};
		print;
	} else {
		$r = r($r, $_);
	}
}
$r->();
