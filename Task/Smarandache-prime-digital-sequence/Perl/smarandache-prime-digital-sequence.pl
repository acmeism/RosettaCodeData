use strict;
use warnings;
use feature 'say';
use feature 'state';
use ntheory qw<is_prime>;
use Lingua::EN::Numbers qw(num2en_ordinal);

my @prime_digits = <2 3 5 7>;
my @spds = grep { is_prime($_) && /^[@{[join '',@prime_digits]}]+$/ } 1..100;
my @p    = map { $_+3, $_+7 } map { 10*$_ } @prime_digits;

while ($#spds < 100_000) {
    state $o++;
    my $oom = 10**(1+$o);
    my @q;
    for my $l (@prime_digits) {
        push @q, map { $l*$oom + $_ } @p;
    }
    push @spds, grep { is_prime($_) } @p = @q;
}

say 'Smarandache prime-digitals:';
printf "%22s: %s\n", ucfirst(num2en_ordinal($_)), $spds[$_-1] for 1..25, 100, 1000, 10_000, 100_000;
