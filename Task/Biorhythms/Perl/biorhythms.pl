use strict;
use warnings;
use DateTime;

use constant PI => 2 * atan2(1, 0);

my %cycles = ( 'Physical' => 23, 'Emotional' => 28, 'Mental' => 33 );
my @Q = ( ['up and rising',    'peak'],
          ['up but falling',   'transition'],
          ['down and falling', 'valley'],
          ['down but rising',  'transition']
        );

my $target = DateTime->new(year=>1863, month=>11, day=>19);
my $bday   = DateTime->new(year=>1809, month=> 2, day=>12);

my $days   = $bday->delta_days( $target )->in_units('days');

print "Day $days:\n";
for my $label (sort keys %cycles) {
    my($length) = $cycles{$label};
    my $position = $days % $length;
    my $quadrant = int $position / $length * 4;
    my $percentage = int(sin($position / $length * 2 * PI )*1000)/10;
    my $description;
    if    (    $percentage  >  95) { $description = 'peak' }
    elsif (    $percentage  < -95) { $description = 'valley' }
    elsif (abs($percentage) <   5) { $description = 'critical transition' }
    else {
        my $transition = $target->clone->add( days => (int(($quadrant + 1)/4 * $length) - $position))->ymd;
        my ($trend, $next) = @{$Q[$quadrant]};
        $description = sprintf "%5.1f%% ($trend, next $next $transition)", $percentage;
    }
    printf "%-13s %2d: %s", "$label day\n", $position, $description;
}
