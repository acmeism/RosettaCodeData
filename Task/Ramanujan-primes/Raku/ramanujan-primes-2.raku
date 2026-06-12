use ntheory:from<Perl5> <ramanujan_primes nth_ramanujan_prime>;
use Lingua::EN::Numbers;

say 'First 100:';
say ramanujan_primes( nth_ramanujan_prime(100) ).batch(10)».&comma».fmt("%6s").join: "\n";

for (2..12).map: {exp $_, 10} -> $limit {
    say "\n{tc ordinal $limit}: { comma nth_ramanujan_prime($limit) }";
}

say (now - INIT now).fmt('%.3f') ~ ' seconds';
