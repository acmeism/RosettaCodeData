use SVG;
use SVG::Plot;

my @x = 0..9;
my @y = (2.7, 2.8, 31.4, 38.1, 58.0, 76.2, 100.5, 130.0, 149.3, 180.0);

say SVG.serialize: SVG::Plot.new(
    width       => 512,
    height      => 512,
    x           => @x,
    x-tick-step => { 1 },
    min-y-axis  => 0,
    values      => [@y,],
    title  => 'Coordinate Pairs',
).plot(:xy-lines);
