use List::Util qw(reduce);

sub powerset {
    @{( reduce { [@$a, map([@$_, $b], @$a)] } [[]], @_ )}
}
