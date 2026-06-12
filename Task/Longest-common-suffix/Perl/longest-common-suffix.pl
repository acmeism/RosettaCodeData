use strict;
use warnings;
use feature 'say';

sub lcs {
    for (0..$#_) { $_[$_] = reverse $_[$_] }
    join '', reverse split '', (join("\0", @_) =~ /^ ([^\0]*) [^\0]* (?:\0 \1 [^\0]*)* $/sx)[0];
}

for my $words (
  [ <Sunday Monday Tuesday Wednesday Thursday Friday Saturday> ],
  [ <Sondag Maandag Dinsdag Woensdag Donderdag Vrydag Saterdag dag> ],
  [ 2347, 9312347, 'acx5g2347', 12.02347 ],
  [ <longest common suffix> ],
  [ ('one, Hey!', 'three, Hey!', 'ale, Hey!', 'me, Hey!') ],
  [ 'suffix' ],
  [ '' ]) {
    say qq{'@$words' ==> '@{[lcs(@$words)]}';
}
