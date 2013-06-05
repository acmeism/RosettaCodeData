proto combine (Int, @) {*}

multi combine (0,  @)  { [] }
multi combine ($,  []) { () }
multi combine ($n, [$head, *@tail]) {
    gather {
	take [$head, @$_] for combine($n-1, @tail);
	take [ @$_ ]      for combine($n  , @tail);
    }
}

sub stats ( @test, @all ) {
    (([+] @test) / +@test ) - ([+] @all, (@test X* -1)) / (@all - @test)
}


my @treated = <85 88 75 66 25 29 83 39 97>;
my @control = <68 41 10 49 16 65 32 92 28 98>;
my @all = @treated, @control;

my $base = stats( @treated, @all );

my @trials = 0, 0, 0;

map { @trials[ 1 + ( stats( $_, @all ) <=> $base ) ]++ }, combine( +@treated, @all );

say 'Counts: <, =, > ', @trials;
say 'Less than    : %', 100 * @trials[0] / [+] @trials;
say 'Equal to     : %', 100 * @trials[1] / [+] @trials;
say 'Greater than : %', 100 * @trials[2] / [+] @trials;
say 'Less or Equal: %', 100 * ( [+] @trials[0,1] ) / [+] @trials;
