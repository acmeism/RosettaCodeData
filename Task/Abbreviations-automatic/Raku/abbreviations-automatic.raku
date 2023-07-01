sub auto-abbreviate ( Str $string ) {
    return Nil unless my @words = $string.words;
    return $_ if @words».substr(0, $_).Set == @words for 1 .. @words».chars.max;
    return '∞';
}

# Testing
 say ++$, ') ', .&auto-abbreviate, '  ', $_ for './DoWAKA.txt'.IO.lines;
