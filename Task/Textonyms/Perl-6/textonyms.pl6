my $src = 'unixdict.txt';

my @words = slurp($src).lines.grep(/ ^ <alpha>+ $ /);

my @dials = @words.classify: {
    .trans('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
        => '2223334445556667777888999922233344455566677778889999');
}

my @textonyms = @dials.grep(*.value > 1);

say qq:to 'END';
    There are {+@words} words in $src which can be represented by the digit key mapping.
    They require {+@dials} digit combinations to represent them.
    {+@textonyms} digit combinations represent Textonyms.
    END

say "Top 5 in ambiguity:";
say "    ",$_ for @textonyms.sort(-*.value)[^5];

say "\nTop 5 in length:";
say "    ",$_ for @textonyms.sort(-*.key.chars)[^5];
