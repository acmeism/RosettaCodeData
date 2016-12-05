use Hailstone;
my %score; %score{hailstone($_).elems}++ for 1 .. 100_000;
say "Most common length is {.key}, occurring {.value} times." given max :by(*.value), %score;
