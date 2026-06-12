say "\nUsing ", my $dict = 'unixdict.txt';
my @tests = <a b c>, 1, <t h e>, 1, <c i o>, 2;
filter $dict.IO.words;

say "\n\nUsing ", $dict = 'words_alpha.txt';
@tests[1,3,5]».++;
filter $dict.IO.words;

sub filter (@words) {
    for @tests -> ($a, $b, $c), $min {
        say "\nLetters: ($a $b $c) -- Minimum count $min\n",
          @words.race.grep(&incremental).sort.join("\n") || '<none>';

        sub incremental ($word) {
            my @v = $word.comb.Bag{$a,$b,$c}.values.sort;
            (@v[0] >= $min) && (@v[0]+1 == @v[1]) && (@v[0]+2 == @v[2])
        }
    }
}
