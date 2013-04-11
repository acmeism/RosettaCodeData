sub nub (@a) {
    my @b;
    none(@b) eqv $_ and push @b, $_ for @a;
    return @b;
}

my @unique = nub [1, 2, 3, 5, 2, 4, 3, -3, 7, 5, 6];
