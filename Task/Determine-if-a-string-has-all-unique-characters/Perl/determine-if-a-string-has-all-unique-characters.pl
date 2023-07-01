use strict;
use warnings;
use feature 'say';
use utf8;
binmode(STDOUT, ':utf8');
use List::AllUtils qw(uniq);
use Unicode::UCD 'charinfo';

for my $str (
    '',
    '.',
    'abcABC',
    'XYZ ZYX',
    '1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ',
    '01234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ0X',
    'Δ👍👨👍Δ',
    'ΔδΔ̂ΔΛ',
) {
    my @S;
    push @S, $1 while $str =~ /(\X)/g;
    printf qq{\n"$str" (length: %d) has }, scalar @S;
    if (@S != uniq @S ) {
        say "duplicated characters:";
        my %P;
        push @{ $P{$S[$_]} }, 1+$_ for 0..$#S;
        for my $k (sort keys %P) {
            next unless @{$P{$k}} > 1;
            printf "'%s' %s (0x%x) in positions: %s\n", $k, charinfo(ord $k)->{'name'}, ord($k), join ', ', @{$P{$k}};
        }
    } else {
        say "no duplicated characters."
    }
}
