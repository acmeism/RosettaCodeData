sub G (Int $n) { +(2..$n/2).grep: { .is-prime && ($n - $_).is-prime } }

# Task
put "The first 100 G values:\n", (^100).map({ G 2 × $_ + 4 }).batch(10)».fmt("%2d").join: "\n";

put "\nG 1_000_000 = ", G 1_000_000;

# Stretch
use SVG;
use SVG::Plot;

my @x = map 2 × * + 4, ^2000;
my @y = @x.map: &G;

'Goldbachs-Comet-Raku.svg'.IO.spurt: SVG.serialize: SVG::Plot.new(
    width       => 1000,
    height      => 500,
    background  => 'white',
    title       => "Goldbach's Comet",
    x           => @x,
    values      => [@y,],
).plot: :points;
