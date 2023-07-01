my @a = <1 2 4>;
my @b = <1 2 4>;
say @a," before ",@b," = ", @a before @b;

@a = <1 2 4>;
@b = <1 2>;
say @a," before ",@b," = ", @a before @b;

@a = <1 2>;
@b = <1 2 4>;
say @a," before ",@b," = ", @a before @b;

for 1..10 {
    my @a = flat (^100).roll((2..3).pick);
    my @b = flat @a.map: { Bool.pick ?? $_ !! (^100).roll((0..2).pick) }
    say @a," before ",@b," = ", @a before @b;
}
