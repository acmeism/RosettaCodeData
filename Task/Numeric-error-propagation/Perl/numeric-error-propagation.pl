use v5.36;

package ErrVar;

# helper function, apply function 'f' to pairs (a, b) from listX and listY
sub zip ($f, $x, $y) {
    my @out;
    $y = [(0) x @$x] unless @$y; # if not defined
    push @out, $f->($x->[$_], $y->[$_]) for 0 .. $#$x;
    \@out
}

use overload
    '""'   => \&_str,
    '+'    => \&_add,
    '-'    => \&_sub,
    '*'    => \&_mul,
    '/'    => \&_div,
    'bool' => \&_bool,
    '<=>'  => \&_ncmp,
    'neg'  => \&_neg,
    'sqrt' => \&_sqrt,
    'log'  => \&_log,
    'exp'  => \&_exp,
    '**'   => \&_pow,
;

# make a variable with mean value and a list of coefficient to
# variables providing independent errors
sub make ($x, @v) { bless [$x, @v] }

# mean value of the var, or just the input if it's not of this class
sub mean ($x) { ref $x && $x->isa(__PACKAGE__) ? $x->[0] : $x }

# return variance index array
sub vlist ($x) { ref $x && $x->isa(__PACKAGE__) ? $x->[1] : [] }

sub variance ($x) {
    return 0 unless ref($x) and $x->isa(__PACKAGE__);
    my $s;
    $s += $_ * $_ for @{$x->[1]};
    $s
}

sub covariance ($x, $y) {
    return 0 unless ref($x) && $x->isa(__PACKAGE__);
    return 0 unless ref($y) && $y->isa(__PACKAGE__);
    my $s;
    zip sub ($a,$b) { $s += $a * $b }, vlist($x), vlist($y);
    $s
}

sub sigma ($v) { sqrt variance $v }

# to determine if a var is probably zero. we use 1σ here
sub _bool ($x, $, $)  {
    abs(mean $x) > sigma $x
}

sub _ncmp ($a, $b, $) {
    return 0 unless my $x = $a - $b;
    mean($x) > 0 ? 1 : -1
}

sub _neg ($x, $, $) {
    bless [ -mean($x), [map(-$_, @{vlist $x}) ] ];
}

sub _add ($x, $y, $) {
    my ($x0, $y0) = ( mean($x),  mean($y));
    my ($xv, $yv) = (vlist($x), vlist($y));
    bless [$x0 + $y0, zip sub ($a,$b) {$a + $b}, $xv, $yv]
}

sub _sub ($x, $y, $) {
    my ($x0, $y0) = ( mean($x),  mean($y));
    my ($xv, $yv) = (vlist($x), vlist($y));
    bless [$x0 - $y0, zip sub ($a,$b) {$a - $b}, $xv, $yv]
}

sub _mul ($x, $y, $) {
    my ($x0, $y0) = ( mean($x),  mean($y));
    my ($xv, $yv) = (vlist($x), vlist($y));
    $xv = [ map($y0 * $_, @$xv) ];
    $yv = [ map($x0 * $_, @$yv) ];
    bless [$x0 * $y0, zip sub ($a,$b) {$a + $b}, $xv, $yv]
}

sub _div ($x, $y, $) {
    my ($x0, $y0) = ( mean($x),  mean($y));
    my ($xv, $yv) = (vlist($x), vlist($y));
    $xv = [ map($_/$y0, @$xv) ];
    $yv = [ map($x0 * $_/$y0/$y0, @$yv) ];
    bless [$x0 / $y0, zip sub ($a,$b) {$a + $b}, $xv, $yv]
}

sub _sqrt ($x, $, $) {
    my ($x0, $xv) =  ( mean($x), vlist($x) );
    $x0 = sqrt($x0);
    $xv = [ map($_ / 2 / $x0, @$xv) ];
    bless [$x0, $xv]
}

sub _pow ($x, $y, $) {
    if ($x < 0) {
        die "Can't take pow of negative number $x" if int($y) != $y or $y & 1;
        $x = -$x;
    }
    exp($y * log $x)
}

sub _exp ($x, $, $) {
    my ($x0, $xv) =  ( exp(mean($x)), vlist($x) );
    bless [ $x0, [map($x0 * $_, @$xv) ] ]
}

sub _log ($x, $, $) {
    my ($x0, $xv) =  ( mean($x), vlist($x) );
    bless [ log($x0), [ map($_ / $x0, @$xv) ] ]
}

sub _str { sprintf '%g±%.3g', $_[0][0], sigma($_[0]) }

package main;

sub e { ErrVar::make @_ };

# x1 is of mean value 100, containing error 1.1 from source 1, etc.
# all error sources are independent.
my $x1 = e 100, [1.1, 0,   0,   0  ];
my $x2 = e 200, [0,   2.2, 0,   0  ];
my $y1 = e 50,  [0,   0,   1.2, 0  ];
my $y2 = e 100, [0,   0,   0,   2.3];

my $z1 = sqrt(($x1 - $x2) ** 2 + ($y1 - $y2) ** 2);
say "distance: $z1";

# this is not for task requirement
my $a = $x1 + $x2;
my $b = $y1 - 2 * $x2;
say "covariance between $a and $b: ", $a->covariance($b);
