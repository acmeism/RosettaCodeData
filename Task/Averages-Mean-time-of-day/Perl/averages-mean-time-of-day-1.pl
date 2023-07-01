use strict;
use warnings;
use POSIX 'fmod';
use Math::Complex;
use List::Util qw(sum);
use utf8;

use constant τ => 2 * 3.1415926535;

# time-of-day to radians
sub tod2rad {
    ($h,$m,$s) = split /:/, @_[0];
    (3600*$h + 60*$m + $s) * τ / 86400;
}

# radians to time-of-day
sub rad2tod {
    my $x = $_[0] * 86400 / τ;
    sprintf '%02d:%02d:%02d', fm($x/3600,24), fm($x/60,60), fm($x,60);
}

# float modulus, normalized to positive values
sub fm  {
    my($n,$b) = @_;
    $x = fmod($n,$b);
    $x += $b if $x < 0;
}

sub phase     { arg($_[0]) }  # aka theta
sub cis       { cos($_[0]) + i*sin($_[0]) }
sub mean_time { rad2tod phase sum map { cis tod2rad $_ } @_ }

@times = ("23:00:17", "23:40:20", "00:12:45", "00:17:19");
print mean_time(@times) . " is the mean time of " . join(' ', @times) . "\n";
