use v5.36;
use ntheory 'primes';
use List::Util 'max';
use Lingua::EN::Numbers qw(num2en);

for my $l (3..9) {
    my %p;
    $p{ join '', sort split //, "$_" } .= "$_ " for @{ primes 10**($l-1), 10**$l };
    my $m = max map { length $p{$_} } keys %p;
    printf "Largest group of anaprimes before %s: %d members.\n", num2en(10**$l), $m/($l+1);
    for my $k (sort grep { $m == length $p{$_} } keys %p) {
        printf "First: %d  Last: %d\n", $p{$k} =~ /^(\d+).* (\d+) $/;
    }
    say '';
}
