use Lingua::EN::Numbers;

sub sliding-window(@list, $window) { (^(+@list - $window)).map: { @list[$_ .. $_+$window] } }

for flat (1e2, 1e3, 1e4, 1e5).map: { (1, 2.5, 5) »×» $_ } -> $upto {

    my @primes = (^$upto).grep: &is-prime;

    for +@primes ... 1 {
        my @sums = @primes.&sliding-window($_).grep: { .sum.is-prime }
        next unless @sums;
        say "\nFor primes up to {$upto.Int.&cardinal}:\nLongest sequence of consecutive primes yielding a prime sum: elements: {comma 1+$_}";
        for @sums {  say " {join '...', .[0..5, *-5..*]».&comma».join(' + ')}, sum: {.sum.&comma}" }
        last
    }
}
