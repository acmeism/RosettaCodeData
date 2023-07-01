#!perl
use strict;
use warnings;
use List::Util qw(max);
use Math::BigRat;

my $one = Math::BigRat->new(1);
sub bernoulli_print {
	my @a;
	for my $m ( 0 .. 60 ) {
		push @a, $one / ($m + 1);
		for my $j ( reverse 1 .. $m ) {
				# This line:
				( $a[$j-1] -= $a[$j] ) *= $j;
				# is a faster version of the following line:
				# $a[$j-1] = $j * ($a[$j-1] - $a[$j]);
				# since it avoids unnecessary object creation.
		}
		next unless $a[0];
		printf "B(%2d) = %44s/%s\n", $m, $a[0]->parts;
	}
}

bernoulli_print();
