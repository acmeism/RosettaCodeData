use Prime::Factor;

sub max_factor_if_cubefree ($i) {
    my @f = prime-factors($i);
    return @f.tail if @f.elems          < 3
                   or @f.Bag.values.all < 3;
}

constant @Aₙ = lazy flat 1, map &max_factor_if_cubefree, 2..*;

say 'The first terms of A370833 are:';
say .fmt('%3d') for @Aₙ.head(100).batch(10);

say '';

for 10 X** (3..6) -> $k {
    printf "The %8dth term of A370833 is %7d\n", $k, @Aₙ[$k-1];
}
