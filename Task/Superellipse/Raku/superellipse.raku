my (\a, \b, \n) = 200, 200, 2.5;

# y in terms of x
sub y ($x) { floor b × (1 - ($x/a).abs ** n ) ** (1/n) }

# find point pairs for one quadrant
my @q = flat map -> \x { x, y(x) }, ^(a+1);

my $out = open('superellipse.svg', :w);
$out.print: [~] qq|<svg height="{b×2}" width="{a×2}" xmlns="http://www.w3.org/2000/svg">\n|,
  pline( @q ),
  pline( @q «×» < 1 -1> ), # flip and mirror
  pline( @q «×» <-1 -1> ), # for the other
  pline( @q «×» <-1  1> ), # three quadrants
  '</svg>';

sub pline (@q) {
  qq|<polyline points="{@q}"
  style="fill:none;stroke:black;stroke-width:3"
  transform="translate({a}, {b})" />\n|
}
