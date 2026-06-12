use Lingua::EN::Numbers;
use Math::Primesieve;
use List::Allmax;

my $p = Math::Primesieve.new;

for 3 .. 9 {
    my @largest = $p.primes(10**($_-1), 10**$_).classify(*.comb.sort.join).List.&all-max(:by(+*.value)).values;

    put "\nLargest group of anaprimes before {cardinal 10 ** $_}: {+@largest[0].value} members.";
    put 'First: ', ' Last: ' Z~ .value[0, *-1] for sort @largest;
}
