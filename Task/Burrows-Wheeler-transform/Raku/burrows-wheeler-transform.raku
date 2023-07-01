# STX can be any character that doesn't appear in the text.
# Using a visible character here for ease of viewing.

constant \STX = '👍';

# Burrows-Wheeler transform
sub transform (Str $s is copy) {
    note "String can't contain STX character." and exit if $s.contains: STX;
    $s = STX ~ $s;
    (^$s.chars).map({ $s.comb.list.rotate: $_ }).sort[*;*-1].join
}

# Burrows-Wheeler inverse transform
sub ɯɹoɟsuɐɹʇ (Str $s) {
    my @t = $s.comb.sort;
    @t = ($s.comb Z~ @t).sort for 1..^$s.chars;
    @t.first( *.ends-with: STX ).chop
}

# TESTING
for |<BANANA dogwood SIX.MIXED.PIXIES.SIFT.SIXTY.PIXIE.DUST.BOXES>,
    'TO BE OR NOT TO BE OR WANT TO BE OR NOT?', "Oops{STX}"
    -> $phrase {
    say 'Original:            ', $phrase;
    say 'Transformed:         ', transform $phrase;
    say 'Inverse transformed: ', ɯɹoɟsuɐɹʇ transform $phrase;
    say '';
}
