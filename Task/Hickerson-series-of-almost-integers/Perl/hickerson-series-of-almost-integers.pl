use strict;
use warnings;
use Math::BigFloat;

my $iln2 = 1 / Math::BigFloat->new(2)->blog;
my $h = $iln2 / 2;

for my $n ( 1 .. 17 ) {
	$h *= $iln2;
	$h *= $n;
	my $s = $h->copy->bfround(-3)->bstr;
	printf "h(%2d) = %22s is%s almost an integer.\n",
		$n, $s, ($s =~ /\.[09]/ ? "" : " NOT");
}
