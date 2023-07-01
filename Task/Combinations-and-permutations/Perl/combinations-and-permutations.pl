use strict;
use warnings;

showoff( "Permutations", \&P, "P", 1 .. 12 );
showoff( "Combinations", \&C, "C", map $_*10, 1..6 );
showoff( "Permutations", \&P_big, "P", 5, 50, 500, 1000, 5000, 15000 );
showoff( "Combinations", \&C_big, "C", map $_*100, 1..10 );

sub showoff {
	my ($text, $code, $fname, @n) = @_;
	print "\nA sample of $text from $n[0] to $n[-1]\n";
	for my $n ( @n ) {
		my $k = int( $n / 3 );
		print $n, " $fname $k = ", $code->($n, $k), "\n";
	}
}

sub P {
	my ($n, $k) = @_;
	my $x = 1;
	$x *= $_ for $n - $k + 1 .. $n ;
	$x;
}

sub P_big {
	my ($n, $k) = @_;
	my $x = 0;
	$x += log($_) for $n - $k + 1 .. $n ;
	eshow($x);
}

sub C {
	my ($n, $k) = @_;
	my $x = 1;
	$x *= ($n - $_ + 1) / $_ for 1 .. $k;
	$x;
}

sub C_big {
	my ($n, $k) = @_;
	my $x = 0;
	$x += log($n - $_ + 1) - log($_) for 1 .. $k;
	exp($x);
}

sub eshow {
	my ($x) = @_;
	my $e = int( $x / log(10) );
	sprintf "%.8Fe%+d", exp($x - $e * log(10)), $e;
}
