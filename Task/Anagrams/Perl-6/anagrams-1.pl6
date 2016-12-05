my @anagrams = 'unixdict.txt'.IO.words.classify(*.comb.sort.join).values;

my $max = @anagrams».elems.max;

.put for @anagrams.grep(*.elems == $max);
