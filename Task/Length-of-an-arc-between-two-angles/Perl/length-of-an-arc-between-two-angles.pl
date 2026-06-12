use strict;
use warnings;
use utf8;
binmode STDOUT, ":utf8";
use POSIX 'fmod';

use constant π => 2 * atan2(1, 0);
use constant τ => 2 * π;

sub d2r { $_[0] * τ / 360 }

sub arc {
    my($a1, $a2, $r) = (d2r($_[0]), d2r($_[1]), $_[2]);
    my @a = map { fmod( ($_ + τ), τ) } ($a1, $a2);
    printf "Arc length: %8.5f  Parameters: (%9.7f, %10.7f, %10.7f)\n",
       (fmod(($a[0]-$a[1] + τ), τ) * $r), $a2, $a1, $r;
}

arc(@$_) for
    [ 10, 120,   10],
    [ 10, 120,    1],
    [120,  10,    1],
    [-90, 180, 10/π],
    [-90,   0, 10/π],
    [ 90,   0, 10/π];
