use strict;
use warnings;

sub is_close {
    my($a,$b,$eps) = @_;
    $eps //= 15;
    my $epse = $eps;
    $epse++ if sprintf("%.${eps}f",$a) =~ /\./;
    $epse++ if sprintf("%.${eps}f",$a) =~ /\-/;
    my $afmt = substr((sprintf "%.${eps}f", $a), 0, $epse);
    my $bfmt = substr((sprintf "%.${eps}f", $b), 0, $epse);
    printf "%-5s %s ≅ %s\n", ($afmt eq $bfmt ? 'True' : 'False'), $afmt, $bfmt;
}

for (
    [100000000000000.01, 100000000000000.011],
    [100.01, 100.011],
    [10000000000000.001 / 10000.0, 1000000000.0000001000],
    [0.001, 0.0010000001],
    [0.000000000000000000000101, 0.0],
    [sqrt(2) * sqrt(2), 2.0],
    [-sqrt(2) * sqrt(2), -2.0],
    [100000000000000003.0, 100000000000000004.0],
    [3.14159265358979323846, 3.14159265358979324]
    ) {
        my($a,$b) = @$_;
        is_close($a,$b);
}

print "\nTolerance may be adjusted.\n";
my $real_pi  = 2 * atan2(1, 0);
my $roman_pi = 22/7;
is_close($real_pi,$roman_pi,$_) for <10 3>;
