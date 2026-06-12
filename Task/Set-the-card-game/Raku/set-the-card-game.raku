my @attributes = <one two three>, <solid striped open>, <red green purple>, <diamond oval squiggle>;

sub face ($_) { .polymod(3 xx 3).kv.map({ @attributes[$^k;$^v] }) ~ ('s' if $_%3) }

sub sets (@cards) { @cards.combinations(3).race.grep: { !(sum ([Z+] $_».polymod(3 xx 3)) »%» 3) } }

for 4,8,12 -> $deal {
    my @cards = (^81).pick($deal);
    my @sets = @cards.&sets;
    say "\nCards dealt: $deal";
    for @cards { put .&face };
    say "\nSets found: {+@sets}";
    for @sets { put .map(&face).join("\n"), "\n" };
}

say "\nIn the whole deck, there are {+(^81).&sets} sets.";
