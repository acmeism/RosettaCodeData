# Sort groups of digits in number order. Sort by order of magnitude then lexically.
sub naturally ($a) { $a.lc.subst(/(\d+)/, ->$/ {0~$0.chars.chr~$0},:g) ~"\x0"~$a }

# Collapse multiple ws characters to a single.
sub collapse ($a) { $a.subst( / ( \s ) $0+ /, -> $/ { $0 }, :g ) }

# Convert all ws characters to a space.
sub normalize ($a) { $a.subst( / ( \s ) /, ' ', :g ) }

# Ignore common leading articles for title sorts
sub title ($a) { $a.subst( / :i ^ ( a | an | the ) >> \s* /, '' ) }

# Decompose ISO-Latin1 glyphs to their base character.
sub latin1_decompose ($a) {
    my %tr = <
       Æ AE æ ae Þ TH þ th Ð TH ð th ß ss À A Á A Â A Ã A Ä A Å A à a á a
        â a ã a ä a å a Ç C ç c È E É E Ê E Ë E è e é e ê e ë e Ì I Í I Î
        I Ï I ì i í i î i ï i Ò O Ó O Ô O Õ O Ö O Ø O ò o ó o ô o õ o ö o
        ø o Ñ N ñ n Ù U Ú U Û U Ü U ù u ú u û u ü u Ý Y ÿ y ý y
    >;

# Would probably be better implemented as
#   $a.trans( [%tr.keys] => [%tr.values] );
# but the underlying Parrot VM leaks through in current Rakudo.
    my $re = '<[' ~ %tr.keys.join('|') ~ ']>';
    $a.subst(/ (<$re>) /, -> $/ { %tr{$0} }, :g)
}
