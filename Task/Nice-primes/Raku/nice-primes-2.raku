sub digroot ($r) { ($r, { .comb.sum } … { .chars == 1 }).tail }
sub is-nice ($_) { .is-prime && .&digroot.is-prime }
say (500 ^..^ 1000).grep( *.&is-nice ).batch(11)».fmt("%4d").join: "\n";
