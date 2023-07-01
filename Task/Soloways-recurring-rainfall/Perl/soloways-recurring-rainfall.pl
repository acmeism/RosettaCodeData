use strict;
use warnings;

use Scalar::Util qw(looks_like_number);

my ($periods, $accumulation, $rainfall);

sub so_far { printf "Average rainfall %.2f units over %d time periods.\n", ($accumulation / $periods) || 0, $periods }

while () {
    while () {
        print 'Integer units of rainfall in this time period? (999999 to finalize and exit)>: ';
        $rainfall = <>;
        last if looks_like_number($rainfall) and $rainfall and $rainfall == int $rainfall;
        print "Invalid input, try again.\n";
    }
    (so_far, exit) if $rainfall == 999999;
    $periods++;
    $accumulation += $rainfall;
    so_far;
}
