use 5.10.0;
use strict;
use warnings;

sub horner(\@$){
	my ($coef, $x) = @_;
	my $result = 0;
	$result = $result * $x + $_ for reverse @$coef;
	return $result;
}

my @coeff = (-19.0, 7, -4, 6);
my $x = 3;
say horner @coeff, $x;
