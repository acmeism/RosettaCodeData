use strict;
use warnings;
use Math::BigRat;

my ($n, @P) = map Math::BigRat->new($_), qw{
2 17/91 78/85 19/51 23/38 29/33 77/29 95/23 77/19 1/17 11/13 13/11 15/14 15/2 55/1
};

$|=1;
MAIN: for( 1 .. 5000 ) {
	print " " if $_ > 1;
	my ($pow, $rest) = (0, $n->copy);
	until( $rest->is_odd ) {
		++$pow;
		$rest->bdiv(2);
	}
	if( $rest->is_one ) {
		print "2**$pow";
	} else {
		#print $n;
	}
	for my $f_i (@P) {
		my $nf_i = $n * $f_i;
		next unless $nf_i->is_int;
		$n = $nf_i;
		next MAIN;
	}
	last;
}

print "\n";
