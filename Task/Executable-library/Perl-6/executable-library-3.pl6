use Hailstone;
my %score;
(1 .. 100_000).race.map: { %score{hailstone($_).elems}++ };
say "Most common length is {.key}, occurring {.value} times." given max :by(*.value), %score;
