use v5.36;
my($a, $b, $n, @q) = (200, 200, 2.5);

# y in terms of x
sub y_from_x ($x) { int $b * abs(1 - ($x/$a) ** $n ) ** (1/$n) }

# find point pairs for one quadrant
push @q, $_, y_from_x($_) for 0..$a;

open  $fh, '>', 'superellipse.svg';
print $fh
  qq|<svg height="@{[2*$b]}" width="@{[2*$a]}" xmlns="http://www.w3.org/2000/svg">\n|,
  pline( 1, 1, @q ),
  pline( 1,-1, @q ), # flip and mirror
  pline(-1,-1, @q ), # for the other
  pline(-1, 1, @q ), # three quadrants
  '</svg>';

sub pline ($sx, $sy, @q) {
  (@q[2*$_] *= $sx, @q[1+2*$_] *= $sy) for 0 .. $#q/2;
  qq|<polyline points="@q"
  style="fill:none;stroke:black;stroke-width:3"
  transform="translate($a, $b)" />\n|
}
