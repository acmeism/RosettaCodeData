for 8, 24, 52, 100, 1020, 1024, 10000 -> $size {
    my ($n, @deck) = 1, |^$size;
    $n++ until [<] @deck = flat [Z] @deck.rotor: @deck/2;
    printf "%5d cards: %4d\n", $size, $n;
}
