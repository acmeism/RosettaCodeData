sub stats ( @test, @all ) {
    ([+] @test / +@test) - ([+] flat @all, (@test X* -1)) / @all - @test
}

my int @treated = <85 88 75 66 25 29 83 39 97>;
my int @control = <68 41 10 49 16 65 32 92 28 98>;
my int @all = flat @treated, @control;

my $base = stats( @treated, @all );

my atomicint @trials[3] = 0, 0, 0;

@all.combinations(+@treated).race.map: { @trials[ 1 + ( stats( $_, @all ) <=> $base ) ]⚛++ }

say 'Counts: <, =, > ', @trials;
say 'Less than    : %', 100 * @trials[0] / [+] @trials;
say 'Equal to     : %', 100 * @trials[1] / [+] @trials;
say 'Greater than : %', 100 * @trials[2] / [+] @trials;
say 'Less or Equal: %', 100 * ( [+] @trials[0,1] ) / [+] @trials;
