use Lingua::EN::Numbers;
use List::Divvy;

my @f = (1..*).map: *×8-1;

my @forbidden = lazy flat @f[0], gather for ^∞ {
    state ($p0, $p1) = 1, 0;
    take (@f[$p0] < @forbidden[$p1]×4) ?? @f[$p0++] !! @forbidden[$p1++]×4;
}

put "First fifty forbidden numbers: \n" ~
  @forbidden[^50].batch(10)».fmt("%3d").join: "\n";

put "\nForbidden number count up to {.Int.&cardinal}: " ~
  comma +@forbidden.&upto: $_ for 5e2, 5e3, 5e4, 5e5, 5e6;
