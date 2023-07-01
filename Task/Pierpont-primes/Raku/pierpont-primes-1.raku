use ntheory:from<Perl5> <is_prime>;

sub pierpont ($kind is copy = 1) {
    fail "Unknown type: $kind. Must be one of 1 (default) or 2" if $kind !== 1|2;
    $kind = -1 if $kind == 2;
    my $po3 = 3;
    my $add-one = 3;
    my @iterators = [1,2,4,8 … *].iterator, [3,9,27 … *].iterator;
    my @head = @iterators».pull-one;

    gather {
        loop {
            my $key = @head.pairs.min( *.value ).key;
            my $min = @head[$key];
            @head[$key] = @iterators[$key].pull-one;

            take $min + $kind if "{$min + $kind}".&is_prime;

            if $min >= $add-one {
                @iterators.push: ([|((2,4,8).map: * * $po3) … *]).iterator;
                $add-one = @head[+@iterators - 1] = @iterators[+@iterators - 1].pull-one;
                $po3 *= 3;
            }
        }
    }
}

say "First 50 Pierpont primes of the first kind:\n" ~ pierpont[^50].rotor(10)».fmt('%8d').join: "\n";

say "\nFirst 50 Pierpont primes of the second kind:\n" ~ pierpont(2)[^50].rotor(10)».fmt('%8d').join: "\n";

say "\n250th Pierpont prime of the first kind: " ~ pierpont[249];

say "\n250th Pierpont prime of the second kind: " ~ pierpont(2)[249];
