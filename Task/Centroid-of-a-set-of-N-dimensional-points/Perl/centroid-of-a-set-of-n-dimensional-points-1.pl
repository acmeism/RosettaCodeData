use v5.36;
use PDL;

sub centroid ($LoL) {
    return pdl($LoL)->transpose->average;
}

sub plot_with_centroid ($LoL) {
    require PDL::Graphics::Gnuplot;
    my $p   = pdl($LoL);
    my $pc  = $p->glue(1, centroid($p));
    my @xyz = map { $pc->slice("($_)") } 0..2;

    my $colors = [8,8,8,8,7];

    PDL::Graphics::Gnuplot->new('png')->plot3d(
        square => 1,
        grid   => [qw<xtics ytics ztics>],
        { with => 'points', pt => 7, ps => 2, linecolor => 'variable', },
        @xyz, $colors,
    );
}

my @tests = (
    [ [1,], [2,], [3,] ],
    [ [8, 2], [0, 0] ],
    [ [5, 5, 0], [10, 10, 0] ],
    [ [1, 3.1, 6.5], [-2, -5, 3.4], [-7, -4, 9], [2, 0, 3] ],
    [ [0, 0, 0, 0, 1], [0, 0, 0, 1, 0], [0, 0, 1, 0, 0], [0, 1, 0, 0, 0] ],
);
say centroid($_) for @tests;
plot_with_centroid($tests[3]);
