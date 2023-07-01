use strict;
use List::Util qw(reduce);

sub horner($$){
	my ($coeff_ref, $x) = @_;
	reduce { $a * $x + $b } reverse @$coeff_ref;
}

my @coeff = (-19.0, 7, -4, 6);
my $x = 3;
print horner(\@coeff, $x), "\n";
