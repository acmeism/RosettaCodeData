say "Numbers up to 100,000 which when expressed in hexadecimal and in decimal
are composed of the same digit glyphs. (All the same glyphs, all the same
quantity.)\n";
display-numbers calculated-with &infix:<eqv>, <Bag>;

say "\nNumbers up to 100,000 which when expressed in hexadecimal and in decimal
are composed from the same digit glyphs. (All the same glyphs  are present,
possibly different quantity.)\n";
display-numbers calculated-with &infix:<eqv>, <Set>;

say "\nNumbers up to 100,000 which, when expressed in hexadecimal use glyphs
that are a subset of those used when expressed in decimal. (Every glyph in
decimal is present in hexadecimal the same or fewer (possibly zero) times)\n";
display-numbers calculated-with &infix:<⊆>, <Bag>;

say "\nNumbers up to 100,000 which, when expressed in hexadecimal use glyphs
that are a subset of those used when expressed in decimal. (Every glyph in
decimal is present in hexadecimal in some quantity, possibly zero, possibly more
than in decimal)\n";
display-numbers calculated-with &infix:<⊆>, <Set>;

sub display-numbers ($_) { say .elems ~ " found:\n" ~ .batch(20)».fmt('%5d').join: "\n" }

sub calculated-with ( &op, $container ) {
    cache ^18699 .map( {:16(.Str)} ).hyper(:1000batch).grep( {
        reduce( &op, (.fmt('%x'), $_).map: { .comb."$container"() } )
    } )
}
