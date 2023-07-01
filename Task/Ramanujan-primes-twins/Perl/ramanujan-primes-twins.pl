use strict;
use warnings;
use ntheory <ramanujan_primes nth_ramanujan_prime>;

sub comma { reverse ((reverse shift) =~ s/(.{3})/$1,/gr) =~ s/^,//r }

my $rp = ramanujan_primes nth_ramanujan_prime 1_000_000;
for my $limit (1e5, 1e6) {
    printf "The %sth Ramanujan prime is %s\n", comma($limit), comma $rp->[$limit-1];
    printf  "There are %s twins in the first %s Ramanujan primes.\n\n",
        comma( scalar grep { $rp->[$_+1] == $rp->[$_]+2 } 0 .. $limit-2 ), comma $limit;
}
