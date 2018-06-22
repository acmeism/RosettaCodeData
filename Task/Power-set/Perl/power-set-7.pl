use List::Util qw(reduce);

sub powerset {
    @{( reduce { [@$a, map { Set->new($_->elements, $b) } @$a ] }
               [Set->new()], shift->elements )};
}

my $set = Set->new(1, 2, 3);
my @subsets = powerset($set);

print $_->as_string, "\n" for @subsets;
