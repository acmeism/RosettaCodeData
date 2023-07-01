use ntheory:from<Perl5> <ramanujan_primes nth_ramanujan_prime>;
use Lingua::EN::Numbers;

my @rp = ramanujan_primes nth_ramanujan_prime 1_000_000;

for (1e5, 1e6)».Int -> $limit {
    say "\nThe {comma $limit}th Ramanujan prime is { comma @rp[$limit-1]}";
    say "There are { comma +(^($limit-1)).race.grep: { @rp[$_+1] == @rp[$_]+2 } } twins in the first {comma $limit} Ramanujan primes.";
}

say (now - INIT now).fmt('%.3f') ~ ' seconds';
