repeat while [<] my @jumbled-list {
    @jumbled-list = (1..9).pick(*)
}

my $turn = 0;
repeat until [<] @jumbled-list {
    my $d = prompt $turn.=succ.fmt('%2d: ') ~
                   @jumbled-list ~
                   " - Flip how many digits? "
        or exit;
    @jumbled-list[^$d] .= reverse;
}

say "    @jumbled-list[]";
say "You won in $turn turns.";
