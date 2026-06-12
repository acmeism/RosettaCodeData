use strict;
use warnings;
use bignum;

sub steepestDescent {
    my($alpha, $tolerance, @x) = @_;
    my $N = @x;
    my $h = $tolerance;
    my $g0 = g(@x) ;    # Initial estimate of result.

    my @fi = gradG($h, @x) ;    #  Calculate initial gradient

    # Calculate initial norm.
    my $delG = 0;
    for (0..$N-1) { $delG += $fi[$_]**2 }
    my $b = $alpha / sqrt($delG);

    while ( $delG > $tolerance ) {   # Iterate until value is <= tolerance.
       #  Calculate next value.
       for (0..$N-1) { $x[$_] -= $b * $fi[$_] }
       $h /= 2;

       @fi = gradG($h, @x);    # Calculate next gradient.
       # Calculate next norm.
       $delG = 0;
       for (0..$N-1) { $delG += $fi[$_]**2 }
       $b = $alpha / sqrt($delG);

       my $g1 = g(@x);   # Calculate next value.

       $g1 > $g0 ? ($alpha /= 2) : ($g0 = $g1);  # Adjust parameter.
    }
    @x
}

# Provides a rough calculation of gradient g(x).
sub gradG {
    my($h, @x) = @_;
    my $N = @x;
    my @y = @x;
    my $g0 = g(@x);
    my @z;
    for (0..$N-1) { $y[$_] += $h ; $z[$_] = (g(@y) - $g0) / $h }
    return @z
}

# Function for which minimum is to be found.
sub g { my(@x) = @_; ($x[0]-1)**2 * exp(-$x[1]**2) + $x[1]*($x[1]+2) * exp(-2*$x[0]**2) };

my $tolerance = 0.0000001;
my $alpha     = 0.01;
my @x = <0.1 -1>; # Initial guess of location of minimum.

printf "The minimum is at x[0] = %.6f, x[1] = %.6f", steepestDescent($alpha, $tolerance, @x);
