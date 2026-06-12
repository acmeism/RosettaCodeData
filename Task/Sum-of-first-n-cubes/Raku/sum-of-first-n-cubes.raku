my @sums_of_all_cubes = [\+] ^Inf X** 3;

say .fmt('%7d') for @sums_of_all_cubes.head(50).batch(10);
