my %positional-iterable-types =
    array    => [<Sunday Monday Tuesday Wednesday Thursday Friday Saturday>],
    list     => <Red Orange Yellow Green Blue Purple>,
    range    => 'Rako' .. 'Raky',
    sequence => (1.25, 1.5, * × * … * > 50),
;

sub first-fourth-fifth ($iterable) {
    my $iterator = $iterable.iterator;
    gather {
        take $iterator.pull-one;
        $iterator.skip-one xx 2;
        take $iterator.pull-one;
        take $iterator.pull-one;
    }
}

say "Note: here we are iterating over the %positional-iterable-types hash, but
the order we get elements out is not the same as the order they were inserted.
Hashes are not guaranteed to be in any specific order, in fact, they are
guaranteed to _not_ be in any specific order.";

for %positional-iterable-types.values {
    say "\nType " ~ .^name ~ ', contents: ' ~ $_ ~
    "\nUsing iterators    : first, fourth and fifth from start: " ~ first-fourth-fifth($_) ~ ', and from end: ' ~ first-fourth-fifth(.reverse) ~
    "\nUsing object slices: first, fourth and fifth from start: " ~ .[0, 3, 4] ~ ', and from end: ' ~ .[*-1, *-4, *-5] ~ "\n";
};


say "\nWhere iterators really shine; when you are collating the values from several infinite generators.";
my @i = (1, * × 2 … *).iterator, (1, * × 3 … *).iterator, (1, * × 5 … *).iterator;
my @v = @i[0].pull-one, @i[1].pull-one, @i[2].pull-one;

my @seq = lazy gather loop {
    take my $min := @v.min;
    for ^@v { @v[$_] = @i[$_].pull-one if @v[$_] == $min };
}

say @seq[^25];
