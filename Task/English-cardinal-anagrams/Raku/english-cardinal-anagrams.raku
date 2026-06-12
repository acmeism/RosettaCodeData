use Lingua::EN::Numbers;
use List::Allmax;

for 1_000, 10_000 {
    my %eca; # English cardinal anagrams
    (^$_).map: { %eca{.&cardinal.comb.sort.join}.push: $_ }

    once say "\nFirst 30 English cardinal anagrams:\n " ~
    (sort flat %eca.grep(+*.value > 1)».value.map: *.flat)[^30]\
    .batch(10)».fmt("%3d").join: "\n ";

    say "\nCount of English cardinal anagrams up to {.&comma}: " ~
        +%eca.grep(+*.value > 1)».value.map: *.flat;

    say "\nLargest group(s) of English cardinal anagrams up to {.&comma}:\n [" ~
        %eca.&all-max( :by(+*.value) )».value.sort.join("]\n [") ~ ']'
}
