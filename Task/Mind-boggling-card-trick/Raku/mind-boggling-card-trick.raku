# Generate a shuffled deck
my @deck = shuffle;
put 'Shuffled deck:          ', @deck;

my (@discard, @red, @black);
# Deal cards following task description
deal(@deck, @discard, @red, @black);

put 'Discard pile:           ', @discard;
put '"Red"   pile:           ', @red;
put '"Black" pile:           ', @black;

# swap the same random number of random
# cards between the red and black piles
my $amount = ^(+@red min +@black) .roll;
put 'Number of cards to swap: ', $amount;
swap(@red, @black, $amount);

put 'Red pile after swaps:   ', @red;
put 'Black pile after swaps: ', @black;

say 'Number of Red   cards in the Red   pile: ', +@red.grep('R');
say 'Number of Black cards in the Black pile: ', +@black.grep('B');

sub shuffle { (flat 'R' xx 26, 'B' xx 26).pick: * }

sub deal (@deck, @d, @r, @b) {
    while @deck.elems {
        my $top = @deck.shift;
        if $top eq 'R' {
            @r.push: @deck.shift;
        }
        else {
            @b.push: @deck.shift;
        }
        @d.push: $top;
    }
}

sub swap (@r, @b, $a) {
    my @ri  = ^@r .pick($a);
    my @bi  = ^@b .pick($a);
    my @rs  = @r[@ri];
    my @bs  = @b[@bi];
    @r[@ri] = @bs;
    @b[@bi] = @rs;
}
