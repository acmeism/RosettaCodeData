use strict;
use warnings;
use utf8;
binmode(STDOUT, ':utf8');
use Encode;
use Unicode::UCD 'charinfo';
use List::AllUtils qw(zip natatime);

for my $c (split //, 'AΑА薵') {
    my $o = ord $c;
    my $utf8 = join '', map { sprintf "%x ", ord } split //, Encode::encode("utf8", $c);
    my $iterator = natatime 2, zip
        @{['Character', 'Character name',       'Ordinal(s)', 'Hex ordinal(s)',   'UTF-8', 'Round trip']},
        @{[ $c,          charinfo($o)->{'name'}, $o,           sprintf("0x%x",$o), $utf8,   chr $o,    ]};
    while ( my ($label, $value) = $iterator->() ) {
        printf "%14s: %s\n", $label, $value
    }
    print "\n";
}
