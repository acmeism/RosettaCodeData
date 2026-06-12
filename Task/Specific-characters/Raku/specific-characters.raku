say "Specific characters: characters that occur exactly twice in one word and not in any other.\n\nThe words: ",
     my @words = <ahwiueshaiu ajxxfioaaf ajrdsfroiwr AА🇧🇬ΑAS🤔ää☃☃̂☃o🇬🇧ö🤔👨‍👩‍👧‍👧>;

say "\nThe specific characters: ", my @ans = specific @words;

say "\nThe specific character counts: ", @ans».elems;

say "\n\nCharacters in each word that are NOT specific characters:\n\nThe characters: ",
    @words.map: {(.comb (-) @ans[$++]).keys};

say "\nThe counts: ", @words.map: {+(.comb (-) @ans[$++]).keys};

sub specific (@n) {
    my $all = @n.flat».comb.Bag;
    @n.map: { .comb.Bag.grep({.value == 2})».key.grep: {$all{$_} == 2} }
}
