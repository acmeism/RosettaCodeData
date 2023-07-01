sub comma { $^i.flip.comb(3).join(',').flip }

use Math::Primesieve;

my $sieve = Math::Primesieve.new;

my @primes = $sieve.primes(10_000_000);

my %filter = @primes.Set;

my $primes = @primes.classify: { %filter{($_ - 1)/2} ?? 'safe' !! 'unsafe' };

for 'safe', 35, 'unsafe', 40 -> $type, $quantity {
    say "The first $quantity $type primes are:";

    say $primes{$type}[^$quantity]».&comma;

    say "The number of $type primes up to {comma $_}: ",
    comma $primes{$type}.first(* > $_, :k) // +$primes{$type} for 1e6, 1e7;

    say '';
}
