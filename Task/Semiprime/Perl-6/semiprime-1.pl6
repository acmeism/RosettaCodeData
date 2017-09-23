sub is-semiprime (Int $n --> Bool) {
    not $n.is-prime and
        .is-prime given
        $n div first $n %% *,
            grep &is-prime, 2 .. *;
}

use Test;
my @primes = grep &is-prime, 2 .. 100;
for ^5 {
    nok is-semiprime([*] my @f1 = @primes.roll(1)), ~@f1;
    ok  is-semiprime([*] my @f2 = @primes.roll(2)), ~@f2;
    nok is-semiprime([*] my @f3 = @primes.roll(3)), ~@f3;
    nok is-semiprime([*] my @f4 = @primes.roll(4)), ~@f4;
}
