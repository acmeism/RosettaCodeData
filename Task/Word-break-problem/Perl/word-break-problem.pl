use strict;
use warnings;

my @words = <a o is pi ion par per sip miss able>;
print "$_: " . word_break($_,@words) . "\n" for <a aa amiss parable opera operable inoperable permission mississippi>;

sub word_break {
    my($word,@dictionary) = @_;
    my @matches;
    my $one_of = join '|', @dictionary;
    @matches = $word =~ /^ ($one_of) ($one_of)? ($one_of)? ($one_of)? $/x; # sub-optimal: limited number of matches
    return join(' ', grep {$_} @matches) || "(not possible)";
}
