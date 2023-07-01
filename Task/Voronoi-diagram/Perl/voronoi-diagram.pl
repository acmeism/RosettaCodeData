use strict;
use warnings;
use Imager;

my %type = (
     Taxicab   => sub { my($px, $py, $x, $y) = @_; abs($px - $x)    + abs($py - $y)    },
     Euclidean => sub { my($px, $py, $x, $y) = @_;    ($px - $x)**2 +    ($py - $y)**2 },
     Minkowski => sub { my($px, $py, $x, $y) = @_; abs($px - $x)**3 + abs($py - $y)**3 },
);

my($xmax, $ymax) = (400, 400);
my @domains;
for (1..30) {
    push @domains, {
        x   => int 5 + rand $xmax-10,
        y   => int 5 + rand $ymax-10,
        rgb => [int rand 255, int rand 255, int rand 255]
    }
}

for my $type (keys %type) {
    our $img = Imager->new(xsize => $xmax, ysize => $ymax, channels => 3);
    voronoi($type, $xmax, $ymax, @domains);
    dot(1,@domains);
    $img->write(file => "voronoi-$type.png");

    sub voronoi {
        my($type, $xmax, $ymax, @d) = @_;
        for my $x (0..$xmax) {
            for my $y (0..$ymax) {
                my $i = 0;
                my $d = 10e6;
                for (0..$#d) {
                    my $dd = &{$type{$type}}($d[$_]{'x'}, $d[$_]{'y'}, $x, $y);
                    if ($dd < $d) { $d = $dd; $i = $_ }
                }
                $img->setpixel(x => $x, y => $y, color => $d[$i]{rgb} );
            }
        }
    }

    sub dot {
        my($radius, @d) = @_;
        for (0..$#d) {
            my $dx = $d[$_]{'x'};
            my $dy = $d[$_]{'y'};
            for my $x ($dx-$radius .. $dx+$radius) {
                for my $y ($dy-$radius .. $dy+$radius) {
                    $img->setpixel(x => $x, y => $y, color => [0,0,0]);
                }
            }
        }
    }
}
