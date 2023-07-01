use Test::More tests => 1000;

for (1 .. 1000) {
    my @l = map int rand(2000) - 1000, 0 .. 20;
    is_deeply([radix(@l)], [sort { $a <=> $b } @l]);
}
