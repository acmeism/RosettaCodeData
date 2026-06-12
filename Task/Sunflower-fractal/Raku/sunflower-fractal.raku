use SVG;

my $seeds  = 3000;
my @center = 300, 300;
my $scale  = 5;

constant \φ = (3 - 5.sqrt) / 2;

my @c = map {
    my ($x, $y) = ($scale * .sqrt) «*« |cis($_ * φ * τ).reals »+« @center;
    [ $x.round(.01), $y.round(.01), (.sqrt * $scale / 100).round(.1) ]
}, 1 .. $seeds;

say SVG.serialize(
    svg => [
        :600width, :600height, :style<stroke:yellow>,
        :rect[:width<100%>, :height<100%>, :fill<black>],
        |@c.map( { :circle[:cx(.[0]), :cy(.[1]), :r(.[2])] } ),
    ],
);
