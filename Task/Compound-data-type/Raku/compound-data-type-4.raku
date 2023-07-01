my $s1 = set <a b c d>; # order is not preserved
my $s2 = set <c d e f>;
say $s1 (&) $s2; # OUTPUT«set(c, e)»
say $s1 ∩ $s2; # we also do Unicode
