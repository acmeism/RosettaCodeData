use strict;
use warnings;
use feature 'say';
use utf8;
binmode(STDOUT, ':utf8');
use Unicode::Normalize 'NFC';
use Unicode::UCD qw(charinfo charprop);

while ('Δ̂🇺🇸👨‍👩‍👧‍👦' =~ /(\X)/g) {
    my @ordinals = map { ord } split //, my $c = $1;
    printf "%14s: %s\n"x7 . "\n",
    'Character',        NFC $c,
    'Character name',   join(', ', map { charinfo($_)->{'name'} } @ordinals),
    'Unicode property', join(', ', map { charprop($_, "Gc")     } @ordinals),
    'Ordinal(s)',       join(' ', @ordinals),
    'Hex ordinal(s)',   join(' ',  map { sprintf("0x%x", $_)    } @ordinals),
    'UTF-8',            join('',   map { sprintf "%x ", ord     } (utf8::encode($c), split //, $c)),
    'Round trip',       join('',   map { chr                    } @ordinals);
}
