use utf8;
use constant π => 3.14159265;
use constant φ => (1 + sqrt(5)) / 2;

my $scale = 600;
my $seeds = 5*$scale;

print qq{<svg xmlns="http://www.w3.org/2000/svg" width="$scale" height="$scale" style="stroke:gold">
           <rect width="100%" height="100%" fill="black" />\n};

for $i (1..$seeds) {
    $r = 2 * ($i**φ) / $seeds;
    $t = 2 * π * φ * $i;
    $x = $r * sin($t) + $scale/2;
    $y = $r * cos($t) + $scale/2;
    printf qq{<circle cx="%.2f" cy="%.2f" r="%.1f" />\n}, $x, $y, sqrt($i)/13;
}

print "</svg>\n";
