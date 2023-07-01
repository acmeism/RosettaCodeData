my @anagrams = 'unixdict.txt'.IO.words
    .map(*.comb.cache)             # explode words into lists of characters
    .classify(*.sort.join).values  # group words with the same characters
    .grep(* > 1)                   # only take groups with more than one word
    .sort(-*[0])                   # sort by length of the first word
;

for @anagrams -> @group {
    for @group.combinations(2) -> [@a, @b] {
        if none @a Zeq @b {
            say "{@a.join}   {@b.join}";
            exit;
        }
    }
}
