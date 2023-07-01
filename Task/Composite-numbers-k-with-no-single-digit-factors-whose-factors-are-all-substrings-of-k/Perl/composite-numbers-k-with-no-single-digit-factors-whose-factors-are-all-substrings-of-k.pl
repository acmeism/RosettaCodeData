 use strict;
use warnings;
use ntheory qw<is_prime factor gcd>;

my($values,$cnt);
LOOP: for (my $k = 11; $k < 1E10; $k += 2) {
    next if 1 < gcd($k,2*3*5*7) or is_prime $k;
    map { next if index($k, $_) < 0 } factor $k;
    $values .= sprintf "%10d", $k;
    last LOOP if ++$cnt == 20;
}
print $values =~ s/.{1,100}\K/\n/gr;
