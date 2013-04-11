sub infix:<⚬>(&f, &g) { -> $x { &f(&g($x)) } }
sub continued-fraction(@a, @b) {
    [\⚬] map { @a[$_] + @b[$_] / * }, 0 .. *
}

printf "√2 ≈ %.9f\n", continued-fraction((1, 2 xx *), (1 xx *))[10](Inf);
printf "e  ≈ %.9f\n", continued-fraction((2, 1 .. *), (1, 1 .. *))[10](Inf);
printf "π  ≈ %.9f\n", continued-fraction((3, 6 xx *), ((1, 3, 5 ... *) X** 2))[1000](Inf);
