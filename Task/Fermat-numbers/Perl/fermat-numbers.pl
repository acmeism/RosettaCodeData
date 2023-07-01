use strict;
use warnings;
use feature 'say';
use bigint try=>"GMP";
use ntheory qw<factor>;

my @Fermats = map { 2**(2**$_) + 1 } 0..9;

my $sub = 0;
say 'First 10 Fermat numbers:';
printf "F%s = %s\n", $sub++, $_ for @Fermats;

$sub = 0;
say "\nFactors of first few Fermat numbers:";
for my $f (map { [factor($_)] } @Fermats[0..8]) {
   printf "Factors of F%s: %s\n", $sub++, @$f == 1 ? 'prime' : join ' ', @$f
}
