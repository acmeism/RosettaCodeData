my @vowels     = <a e i o u>;
my @consonants = <b c d f g h j k l m n p q r s t v w x y z>;

sub letter-check ($string) {
    my $letters = $string.lc.comb.Set;
    "{sum $letters{@vowels}} vowels and {sum $letters{@consonants}} consonants occur in the string \"$string\"";
}

say letter-check "Forever Ring Programming Language";
