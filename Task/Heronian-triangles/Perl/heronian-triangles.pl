use strict;
use warnings;
use List::Util qw(max);

sub gcd { $_[1] == 0 ? $_[0] : gcd($_[1], $_[0] % $_[1]) }

sub hero {
    my ($a, $b, $c) = @_[0,1,2];
    my $s = ($a + $b + $c) / 2;
    sqrt $s*($s - $a)*($s - $b)*($s - $c);
}

sub heronian_area {
    my $hero = hero my ($a, $b, $c) = @_[0,1,2];
    sprintf("%.0f", $hero) eq $hero ? $hero : 0
}

sub primitive_heronian_area {
    my ($a, $b, $c) = @_[0,1,2];
    heronian_area($a, $b, $c) if 1 == gcd $a, gcd $b, $c;
}

sub show {
    print "   Area Perimeter   Sides\n";
    for (@_) {
        my ($area, $perim, $c, $b, $a) = @$_;
	printf "%7d %9d    %d×%d×%d\n", $area, $perim, $a, $b, $c;
    }
}

sub main {
    my $maxside = shift // 200;
    my $first = shift // 10;
    my $witharea = shift // 210;
    my @h;
    for my $c (1 .. $maxside) {
	for my $b (1 .. $c) {
	    for my $a ($c - $b + 1 .. $b) {
		if (my $area = primitive_heronian_area $a, $b, $c) {
		    push @h, [$area, $a+$b+$c, $c, $b, $a];
		}
	    }
	}
    }
    @h = sort {
	$a->[0] <=> $b->[0]
	    or
	$a->[1] <=> $b->[1]
	    or
	max(@$a[2,3,4]) <=> max(@$b[2,3,4])
    } @h;
    printf "Primitive Heronian triangles with sides up to %d: %d\n",
    $maxside,
    scalar @h;
    print "First:\n";
    show @h[0 .. $first - 1];
    print "Area $witharea:\n";
    show grep { $_->[0] == $witharea } @h;


}

&main();
