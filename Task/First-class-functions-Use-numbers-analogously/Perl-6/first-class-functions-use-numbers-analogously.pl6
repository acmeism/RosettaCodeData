sub multiplied ($g, $f) { return { $g * $f * $^x } }

my $x  = 2.0;
my $xi = 0.5;
my $y  = 4.0;
my $yi = 0.25;
my $z  = $x + $y;
my $zi = 1.0 / ( $x + $y );

my @numbers = $x, $y, $z;
my @inverses = $xi, $yi, $zi;

for flat @numbers Z @inverses { say multiplied($^g, $^f)(.5) }
