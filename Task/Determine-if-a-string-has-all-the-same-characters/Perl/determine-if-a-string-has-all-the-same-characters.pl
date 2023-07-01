use strict;
use warnings;
use feature 'say';
use utf8;
binmode(STDOUT, ':utf8');
use List::AllUtils qw(uniq);
use Unicode::UCD 'charinfo';
use Unicode::Normalize qw(NFC);

for my $str (
    '',
    '   ',
    '2',
    '333',
    '.55',
    'tttTTT',
    '4444 444k',
    'Δ👍👨',
    '🇬🇧🇬🇧🇬🇧🇬🇧',
    "\N{LATIN CAPITAL LETTER A}\N{COMBINING DIAERESIS}\N{COMBINING MACRON}" .
    "\N{LATIN CAPITAL LETTER A WITH DIAERESIS}\N{COMBINING MACRON}" .
    "\N{LATIN CAPITAL LETTER A WITH DIAERESIS AND MACRON}"
) {
    my @S;
    push @S, NFC $1 while $str =~ /(\X)/g;
    printf qq{\n"$str" (length: %d) has }, scalar @S;
    my @U = uniq @S;
    if (1 != @U and @U > 0) {
        say 'different characters:';
        for my $l (@U) {
            printf "'%s' %s (0x%x) in positions: %s\n",
                $l, charinfo(ord $l)->{'name'}, ord($l), join ', ', map { 1+$_ } grep { $l eq $S[$_] } 0..$#S;
        }
    } else {
        say 'the same character in all positions.'
    }
}
