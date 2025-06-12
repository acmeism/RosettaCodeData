use strict;
use warnings;
use utf8;

my $top = 10;

open my $fh, '<', 'ref/word-count.txt';
(my $text = join '', <$fh>) =~ tr/A-Z/a-z/;

my @matcher = (
    qr/[a-z]+/,     # simple 7-bit ASCII
    qr/\w+/,        # word characters with underscore
    qr/[a-z0-9]+/,  # word characters without underscore
);

for my $reg (@matcher) {
    print "\nTop $top using regex: " . $reg . "\n";
    my @matches = $text =~ /$reg/g;
    my %words;
    for my $w (@matches) { $words{$w}++ };
    my $c = 0;
    for my $w ( sort { $words{$b} <=> $words{$a} } keys %words ) {
        printf "%-7s %6d\n", $w, $words{$w};
        last if ++$c >= $top;
    }
}
