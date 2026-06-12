use v5.36;
use bigint;
use ntheory 'is_prime';

for my $n (1..400) {
    for (my $m=0 ; ; $m += 1) {
        if (is_prime(my $p = $n * 2**$m + 1)) { printf "%3d %4d: %s\n",$n,$m,$p; last }
    }
}
