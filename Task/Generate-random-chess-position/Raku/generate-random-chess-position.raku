sub pick-FEN {
    # First we chose how many pieces to place
    my $n = (2..32).pick;

    # Then we pick $n squares
    my @n = (^64).pick($n);

    # We try to find suitable king positions on non-adjacent squares.
    # If we could not find any, we return recursively
    return pick-FEN() unless
    my @kings[2] = first -> [$a, $b] {
        $a !== $b && abs($a div 8 - $b div 8) | abs($a mod 8 - $b mod 8) > 1
    }, (@n X @n);

    # We make a list of pieces we can pick (apart from the kings)
    my @pieces = <p P n N b B r R q Q>;

    # We make a list of two king symbols to pick randomly a black or white king
    my @k = <K k>.pick(*);

    return (gather for ^64 -> $sq {
        if $sq == @kings.any { take @k.shift }
        elsif $sq == @n.any {
            my $row = 7 - $sq div 8;
            take
            $row == 7 ?? @pieces.grep(none('P')).pick !!
            $row == 0 ?? @pieces.grep(none('p')).pick !!
            @pieces.pick;
        }
        else { take 'ø' }
    }).rotor(8)».join».subst(/ø+/,{ .chars }, :g).join('/') ~ ' w - - 0 1';
}

say pick-FEN();
