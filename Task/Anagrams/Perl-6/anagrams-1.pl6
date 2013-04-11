my %anagram = slurp('unixdict.txt').words.classify( { .comb.sort.join } );

my $max = [max] map { +@($_) }, %anagram.values;

%anagram.values.grep( { +@($_) >= $max } )».join(' ')».say;
