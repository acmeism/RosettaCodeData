sub lis(@deck is copy) {
    my @S = [@deck.shift() => Nil].item;
    for @deck -> $card {
        with first { @S[$_][*-1].key > $card }, ^@S -> $i {
            @S[$i].push: $card => @S[$i-1][*-1] // Nil
        } else {
            @S.push: [ $card => @S[*-1][*-1] // Nil ].item
        }
    }
    reverse map *.key, (
        @S[*-1][*-1], *.value ...^ !*.defined
    )
}

say lis <3 2 6 4 5 1>;
say lis <0 8 4 12 2 10 6 14 1 9 5 13 3 11 7 15>;
