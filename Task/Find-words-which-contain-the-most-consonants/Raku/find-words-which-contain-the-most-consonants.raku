unit sub MAIN ($min = 11);
my @vowel = <a e i o u>;
my $vowel = rx/ @vowel /;
my @consonant = ('a'..'z').grep: { $_ ∉ @vowel };
my $consonant = rx/ @consonant /;

say "Minimum characters in a word: $min";

say "Number found, consonant count and list of words with the largest absolute number of unique, unrepeated consonants:";
say +.value, ' @ ', $_ for 'unixdict.txt'.IO.words.grep( {.chars >= $min and so all(.comb.Bag{@consonant}) <= 1} )
    .classify( { +.comb(/$consonant/) } ).sort(-*.key).head(2);

say "\nNumber found, ratio and list of words with the highest ratio of unique, unrepeated consonants to vowels:";
say +.value, ' @ ', $_  for 'unixdict.txt'.IO.slurp.words.grep( {.chars >= $min and so all(.comb.Bag{@consonant}) <= 1} )
    .classify( { +.comb(/$vowel/) ?? (+.comb(/$consonant/) / +.comb(/$vowel/) ) !! Inf } ).sort(-*.key).head(3);
