#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Word_wheel
use warnings;

$_ = <<END;
                    N  D  E
                    O  K  G
                    E  L  W
END

my $file = do { local(@ARGV, $/) = 'unixdict.txt'; <> };
my $length = my @letters = lc =~ /\w/g;
my $center = $letters[@letters / 2];
my $toomany = (join '', sort @letters) =~ s/(.)\1*/
  my $count = length "$1$&"; "(?!(?:.*$1){$count})" /ger;
my $valid = qr/^(?=.*$center)$toomany([@letters]{3,$length}$)$/m;

my @words = $file =~ /$valid/g;

print @words . " words for\n$_\n@words\n" =~ s/.{60}\K /\n/gr;
