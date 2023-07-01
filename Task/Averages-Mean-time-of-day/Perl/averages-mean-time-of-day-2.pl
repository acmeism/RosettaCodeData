use v5.36;
use POSIX 'fmod';
use Math::Complex;
use List::Util 'sum';
use utf8;

use constant τ => 2 * 2 * atan2(1, 0);

sub R_to_ToD ($radians) { my $x = $radians * 86400 / τ; sprintf '%02d:%02d:%02d', fm($x/3600,24), fm($x/60,60), fm($x,60) }
sub ToD_to_R ($h,$m,$s) { (3600*$h + 60*$m + $s) * τ / 86400 }
sub fm       ($n,$b)    { my $x = fmod($n,$b); $x += $b if $x < 0 }
sub cis      ($radians) { cos($radians) + i*sin($radians) }
sub phase    ($Θ)       { arg( $Θ ) }
sub mean_time(@t)       { R_to_ToD phase sum map { cis ToD_to_R split ':', $_ } @t }

my @times = <23:00:17 23:40:20 00:12:45 00:17:19>;
say my $result = mean_time(@times) . ' is the mean time of ' . join ' ', @times;
