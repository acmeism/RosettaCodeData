use Image::PNG::Portable;

my @bars = '▁▂▃▄▅▆▇█▇▆▅▄▃▂▁'.comb;

my %type = ( # Voronoi diagram type distance calculation
    'Taxicab'   => sub ($px, $py, $x, $y) { ($px - $x).abs  + ($py - $y).abs  },
    'Euclidean' => sub ($px, $py, $x, $y) { ($px - $x)²     + ($py - $y)²     },
    'Minkowski' => sub ($px, $py, $x, $y) { ($px - $x)³.abs + ($py - $y)³.abs },
);

my $width  = 400;
my $height = 400;
my $dots   = 30;

my @domains = map { Hash.new(
    'x' => (5..$width-5).roll,
    'y' => (5..$height-5).roll,
    'rgb' => [(64..255).roll xx 3]
) }, ^$dots;

for %type.keys -> $type {
    print "\nGenerating $type diagram...    ", ' ' x @bars;
    my $img = voronoi(@domains, :w($width), :h($height), :$type);
    @domains.map: *.&dot($img);
    $img.write: "Voronoi-{$type}-perl6.png";
}

sub voronoi (@domains, :$w, :$h, :$type) {
    my $png = Image::PNG::Portable.new: :width($w), :height($h);
    for ^$w -> $x {
        print "\b" x 2+@bars, @bars.=rotate(1).join , '  ';
        for ^$h -> $y {
            my ($, $i) = min @domains.map: { %type{$type}(%($_)<x>, %($_)<y>, $x, $y), $++ };
            $png.set: $x, $y, |@domains[$i]<rgb>
        }
    }
    $png
}

sub dot (%h, $png, $radius = 3) {
    for %h<x> - $radius .. %h<x> + $radius -> $x {
        for %h<y> - $radius .. %h<y> + $radius -> $y {
            $png.set($x, $y, 0, 0, 0) if ( %h<x> - $x + (%h<y> - $y) * i ).abs <= $radius;
        }
    }
}
