use strict;
use utf8;
binmode STDOUT, ":utf8";

sub auto_abbreviate {
    my($string) = @_;
    my @words = split ' ', $string;
    my $max = 0;
    return '' unless @words;
    map { $max = length($_) if length($_) > $max } @words;
    for $i (1..$max) {
        my %seen;
        return $i if @words == grep {!$seen{substr($_,0,$i)}++} @words;
    }
    return '∞';
}

open $fh, '<:encoding(UTF-8)', 'DoWAKA.txt';
while ($_ = <$fh>) {
    print "$.) " . auto_abbreviate($_) . '  ' . $_;
}
