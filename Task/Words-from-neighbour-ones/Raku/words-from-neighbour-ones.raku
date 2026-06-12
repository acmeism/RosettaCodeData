my @words_ge_9 = 'unixdict.txt'.IO.lines.grep( *.chars >= 9 );
my %words_eq_9  = @words_ge_9           .grep( *.chars == 9 ).Set;

my @new_words = gather for @words_ge_9.rotor( 9 => -8 ) -> @nine_words {
    my $new_word = [~] map { @nine_words[$_].substr($_, 1) }, ^9;

    take $new_word if %words_eq_9{$new_word};
}

.say for unique @new_words;
