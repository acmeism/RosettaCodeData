sub overhand {
    our @cards; local *cards = shift;
    my(@splits,@shuffle);
    my $x = int +@cards / 5;
    push @splits, (1..$x)[int rand $x] for 1..+@cards;
    while (@cards) {
        push @shuffle, [splice @cards, 0, shift @splits];
    }
    @cards = flatten(reverse @shuffle);
}

sub flatten { map { ref $_ eq 'ARRAY' ? @$_ : $_ } @_ }

sub riffle {
    our @cards; local *cards = shift;
    splice @cards, @cards/2 - $_, 0, pop @cards for 0 .. (@cards/2)-1;
}

@cards = 1..20;
overhand(\@cards) for 1..10;
print join ' ', @cards, "\n";

@cards = 1..20;
riffle(\@cards) for 1..10;
print join ' ', @cards, "\n";
