my @f = lazy flat 1, [\×] 1..*;

sink @f[700]; # pre-reify for concurrency

my @least-m = lazy (^∞).hyper(:2batch).map: {(1..*).first: -> \n {(@f[$_] + n).is-prime}};

say "Least positive m such that n! + m is prime; first fifty:\n"
 ~ @least-m[^50].batch(10)».fmt("%3d").join: "\n";

for (1..10).map: * × 1e3 {
    my $key = @least-m.first: * > $_, :k;
    printf "\nFirst m > $_ is %d at position %d\n", @least-m[$key], $key;
}
