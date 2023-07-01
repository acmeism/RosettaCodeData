use strict;
use warnings;
use feature 'say';

use List::Util <max sum>;
use ntheory <is_prime divisors>;
use Lingua::EN::Numbers qw(num2en num2en_ordinal);

sub comma { reverse ((reverse shift) =~ s/(.{3})/$1,/gr) =~ s/^,//r }
sub table { my $t = 10 * (my $c = 1 + length max @_); ( sprintf( ('%'.$c.'d')x@_, @_) ) =~ s/.{1,$t}\K/\n/gr }

my @A = 0;
for my $n (1..2E6)  {
    my @div = divisors $n;
    push @A, $n if 0 == sum(@div) % @div;
}

say "The first @{[num2en 100]} arithmetic numbers:";
say table @A[1..100];

for my $x (1E3, 1E4, 1E5, 1E6) {
    say "\nThe @{[num2en_ordinal $x]}: " . comma($A[$x]) .
        "\nComposite arithmetic numbers ≤ @{[comma $A[$x]]}: " . comma -1 + grep { not is_prime($_) } @A[1..$x];
}
