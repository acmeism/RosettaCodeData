use strict;
use warnings;
use feature 'say';
use ntheory 'is_prime';

sub magnanimous {
    my($n) = @_;
    my $last;
    for my $c (1 .. length($n) - 1) {
        ++$last and last unless is_prime substr($n,0,$c) + substr($n,$c)
    }
    not $last;
}

my @M;
for ( my $i = 0, my $count = 0; $count < 400; $i++ ) {
    ++$count and push @M, $i if magnanimous($i);
}

say "First 45 magnanimous numbers\n".
    (sprintf "@{['%4d' x 45]}", @M[0..45-1]) =~ s/(.{60})/$1\n/gr;

say "241st through 250th magnanimous numbers\n" .
    join ' ', @M[240..249];

say "\n391st through 400th magnanimous numbers\n".
    join ' ', @M[390..399];
