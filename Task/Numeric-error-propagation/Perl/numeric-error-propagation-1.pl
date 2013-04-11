use utf8;
package ErrVar;
use strict;

# helper function, apply f to pairs (a, b) from listX and listY
sub zip(&$$) {
	my ($f, $x, $y) = @_;
	my $l = $#$x;
	if ($l < $#$y) { $l = $#$y };

	my @out;
	for (0 .. $l) {
		local $a = $x->[$_];
		local $b = $y->[$_];
		push @out, $f->();
	}
	\@out
}

use overload
	'""'	=> \&_str,
	'+'	=> \&_add,
	'-'	=> \&_sub,
	'*'	=> \&_mul,
	'/'	=> \&_div,
	'bool'	=> \&_bool,
	'<=>'	=> \&_ncmp,
	'neg'	=> \&_neg,
	
	'sqrt'	=> \&_sqrt,
	'log'	=> \&_log,
	'exp'	=> \&_exp,
	'**'	=> \&_pow,
;

# make a variable with mean value and a list of coefficient to
# variables providing independent errors
sub make {
	my $x = shift;
	bless [$x, [@{+shift}]]
}

sub _str { sprintf "%g±%.3g", $_[0][0], sigma($_[0]) }

# mean value of the var, or just the input if it's not of this class
sub mean {
	my $x = shift;
	ref($x) && $x->isa(__PACKAGE__) ? $x->[0] : $x
}

# return variance index array
sub vlist {
	my $x = shift;
	ref($x) && $x->isa(__PACKAGE__) ? $x->[1] : [];
}

sub variance {
	my $x = shift;
	return 0 unless ref($x) and $x->isa(__PACKAGE__);
	my $s;
	$s += $_ * $_ for (@{$x->[1]});
	$s
}

sub covariance {
	my ($x, $y) = @_;
	return 0 unless ref($x) && $x->isa(__PACKAGE__);
	return 0 unless ref($y) && $y->isa(__PACKAGE__);

	my $s;
	zip { $s += $a * $b } vlist($x), vlist($y);
	$s
}

sub sigma { sqrt variance(shift) }

# to determine if a var is probably zero. we use 1σ here
sub _bool {
	my $x = shift;
	return abs(mean($x)) > sigma($x);
}

sub _ncmp {
	my $x = shift() - shift()	or return 0;
	return mean($x) > 0 ? 1 : -1;
}

sub _neg {
	my $x = shift;
	bless [ -mean($x), [map(-$_, @{vlist($x)}) ] ];
}

sub _add {
	my ($x, $y) = @_;
	my ($x0, $y0) = (mean($x), mean($y));
	my ($xv, $yv) = (vlist($x), vlist($y));
	bless [$x0 + $y0, zip {$a + $b} $xv, $yv];
}

sub _sub {
	my ($x, $y, $swap) = @_;
	if ($swap) { ($x, $y) = ($y, $x) }
	my ($x0, $y0) = (mean($x), mean($y));
	my ($xv, $yv) = (vlist($x), vlist($y));
	bless [$x0 - $y0, zip {$a - $b} $xv, $yv];
}

sub _mul {
	my ($x, $y) = @_;
	my ($x0, $y0) = (mean($x), mean($y));
	my ($xv, $yv) = (vlist($x), vlist($y));

	$xv = [ map($y0 * $_, @$xv) ];
	$yv = [ map($x0 * $_, @$yv) ];

	bless [$x0 * $y0, zip {$a + $b} $xv, $yv];
}

sub _div {
	my ($x, $y, $swap) = @_;
	if ($swap) { ($x, $y) = ($y, $x) }

	my ($x0, $y0) = (mean($x), mean($y));
	my ($xv, $yv) = (vlist($x), vlist($y));

	$xv = [ map($_/$y0, @$xv) ];
	$yv = [ map($x0 * $_/$y0/$y0, @$yv) ];

	bless [$x0 / $y0, zip {$a + $b} $xv, $yv];
}

sub _sqrt {
	my $x = shift;
	my $x0 = mean($x);
	my $xv = vlist($x);
	$x0 = sqrt($x0);
	$xv = [ map($_ / 2 / $x0, @$xv) ];
	bless [$x0, $xv]
}

sub _pow {
	my ($x, $y, $swap) = @_;
	if ($swap) { ($x, $y) = ($y, $x) }
	if ($x < 0) {
		if (int($y) != $y || ($y & 1)) {
			die "Can't take pow of negative number $x";
		}
		$x = -$x;
	}
	exp($y * log $x)
}

sub _exp {
	my $x = shift;
	my $x0 = exp(mean($x));
	my $xv = vlist($x);
	bless [ $x0, [map($x0 * $_, @$xv) ] ]
}

sub _log {
	my $x = shift;
	my $x0 = mean($x);
	my $xv = vlist($x);
	bless [ log($x0), [ map($_ / $x0, @$xv) ] ]
}

"If this package were to be in its own file, you need some truth value to end it like this.";

package main;

sub e { ErrVar::make @_ };

# x1 is of mean value 100, containing error 1.1 from source 1, etc.
# all error sources are independent.
my $x1 = e 100, [1.1, 0,   0,   0  ];
my $x2 = e 200, [0,   2.2, 0,   0  ];
my $y1 = e 50,  [0,   0,   1.2, 0  ];
my $y2 = e 100, [0,   0,   0,   2.3];

my $z1 = sqrt(($x1 - $x2) ** 2 + ($y1 - $y2) ** 2);
print "distance: $z1\n\n";

# this is not for task requirement
my $a = $x1 + $x2;
my $b = $y1 - 2 * $x2;
print "covariance between $a and $b: ", $a->covariance($b), "\n";
