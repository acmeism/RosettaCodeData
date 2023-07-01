sub trick {
    my(@deck) = @_;
    my $result .= sprintf "%-28s @deck\n", 'Starting deck:';

    my(@discard, @red, @black);
    deal(\@deck, \@discard, \@red, \@black);

    $result .= sprintf "%-28s @red\n", 'Red     pile:';
    $result .= sprintf "%-28s @black\n", 'Black   pile:';

    my $n = int rand(+@red < +@black ? +@red : +@black);
    swap(\@red, \@black, $n);

    $result .= sprintf "Red pile   after %2d swapped: @red\n", $n;
    $result .= sprintf "Black pile after %2d swapped: @black\n", $n;

    $result .= sprintf "Red in Red, Black in Black:  %d = %d\n", (scalar grep {/R/} @red), scalar grep {/B/} @black;
    return "$result\n";
}

sub deal {
    my($c, $d, $r, $b) = @_;
    while (@$c) {
        my $top = shift @$c;
        if ($top eq 'R') { push @$r, shift @$c }
        else             { push @$b, shift @$c }
        push @$d, $top;
    }
}

sub swap {
    my($r, $b, $n) = @_;
    push @$r, splice @$b, 0, $n;
    push @$b, splice @$r, 0, $n;
}

@deck = split '', 'RB' x 26;               # alternating red and black
print trick(@deck);
@deck = split '', 'RRBB' x 13;             # alternating pairs of reds and blacks
print trick(@deck);
@deck = sort @deck;                        # all blacks precede reds
print trick(@deck);
@deck = sort { -1 + 2*int(rand 2) } @deck; # poor man's shuffle
print trick(@deck);
