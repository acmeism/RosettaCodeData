use PDL:from<Perl5>;
use PDL::Image2D:from<Perl5>;

my $image = rpic 'plasma.png';
my $smoothed = med2d($image, ones(3,3), {Boundary => 'Truncate'});
wpic $smoothed, 'plasma_median.png';
