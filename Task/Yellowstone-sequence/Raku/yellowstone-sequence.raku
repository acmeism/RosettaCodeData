my @yellowstone = 1, 2, 3, -> $q, $p {
    state @used = True xx 4;
    state $min  = 3;
    my \index = ($min .. *).first: { not @used[$_] and $_ gcd $q != 1 and $_ gcd $p == 1 };
    @used[index] = True;
    $min = @used.first(!*, :k) // +@used - 1;
    index
} … *;

put "The first 30 terms in the Yellowstone sequence:\n", @yellowstone[^30];

use SVG;
use SVG::Plot;

my @x = ^500;

my $chart = SVG::Plot.new(
    background  => 'white',
    width       => 1000,
    height      => 600,
    plot-width  => 950,
    plot-height => 550,
    x           => @x,
    x-tick-step => { 10 },
    y-tick-step => { 50 },
    min-y-axis  => 0,
    values      => [@yellowstone[@x],],
    title       => "Yellowstone Sequence - First {+@x} values (zero indexed)",
);

my $line = './Yellowstone-sequence-line-perl6.svg'.IO;
my $bars = './Yellowstone-sequence-bars-perl6.svg'.IO;

$line.spurt: SVG.serialize: $chart.plot: :lines;
$bars.spurt: SVG.serialize: $chart.plot: :bars;
