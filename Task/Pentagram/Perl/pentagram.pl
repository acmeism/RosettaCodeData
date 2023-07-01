use SVG;

my $tau   = 2 * 4*atan2(1, 1);
my $dim   = 200;
my $sides = 5;

for $v (0, 2, 4, 1, 3, 0) {
    push @vx, 0.9 * $dim * cos($tau * $v / $sides);
    push @vy, 0.9 * $dim * sin($tau * $v / $sides);
}

my $svg= SVG->new( width => 2*$dim, height => 2*$dim);

my $points = $svg->get_path(
    x     => \@vx,
    y     => \@vy,
    -type => 'polyline',
);

$svg->rect (
    width  => "100%",
    height => "100%",
    style  => {
        'fill' => 'bisque'
    }
);

$svg->polyline (
    %$points,
    style => {
        'fill'         => 'seashell',
        'stroke'       => 'blue',
        'stroke-width' => 3,
    },
    transform => "translate($dim,$dim) rotate(-18)"
);

open  $fh, '>', 'pentagram.svg';
print $fh  $svg->xmlify(-namespace=>'svg');
close $fh;
