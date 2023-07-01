use v5.36;
use enum <false true>;

sub isprime ($n) {
    return $n > 1 if $n < 4;
    return false unless $n % 2 and $n % 3;
    for (my $i = 5; $i <= int sqrt $n; $i += 6) {
        return false unless $n % $i and $n % ($i+2);
    }
    true
}

say join ' ', grep { isprime $_ } 0 .. 100;
say join ' ', grep { isprime $_ } 12345678 .. 12345678+100;
