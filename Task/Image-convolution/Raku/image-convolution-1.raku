use PDL:from<Perl5>;
use PDL::Image2D:from<Perl5>;

my $kernel = pdl [[-2, -1, 0],[-1, 1, 1], [0, 1, 2]]; # emboss

my $image = rpic 'frog.png';
my $smoothed = conv2d $image, $kernel, {Boundary => 'Truncate'};
wpic $smoothed, 'frog_convolution.png';
