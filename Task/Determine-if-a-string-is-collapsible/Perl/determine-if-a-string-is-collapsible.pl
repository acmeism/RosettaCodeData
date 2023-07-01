use strict;
use warnings;
use utf8;
binmode STDOUT, ":utf8";

my @lines = split "\n", <<~'STRINGS';

    "If I were two-faced, would I be wearing this one?" --- Abraham Lincoln
    ..1111111111111111111111111111111111111111111111111111111111111117777888
    I never give 'em hell, I just tell the truth, and they think it's hell.
                                                        --- Harry S Truman
    The American people have a right to know if their president is a crook.
                                                        --- Richard Nixon
    AАΑAАΑAАΑAАΑAАΑAАΑAАΑAАΑAАΑAАΑAАΑAАΑAАΑAАΑAАΑAАΑAАΑAАΑAАΑAАΑAАΑAАΑAАΑAАΑ
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    STRINGS

for (@lines) {
    my $squish = s/(.)\1+/$1/gr;
    printf "\nLength: %2d <<<%s>>>\nCollapsible: %s\nLength: %2d <<<%s>>>\n",
      length($_), $_, $_ ne $squish ? 'True' : 'False', length($squish), $squish
}
