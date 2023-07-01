sub comma { $^i.flip.comb(3).join(',').flip }

use Math::Primesieve;

my $sieve = Math::Primesieve.new;

my @primes = $sieve.primes(10_000_019);

my (@weak, @balanced, @strong);

for 1 ..^ @primes - 1 -> $p {
    given (@primes[$p - 1] + @primes[$p + 1]) / 2 {
        when * > @primes[$p] {     @weak.push: @primes[$p] }
        when * < @primes[$p] {   @strong.push: @primes[$p] }
        default              { @balanced.push: @primes[$p] }
    }
}

for @strong,   'strong',   36,
    @weak,     'weak',     37,
    @balanced, 'balanced', 28
  -> @pr, $type, $d {
    say "\nFirst $d $type primes:\n", @pr[^$d]».&comma;
    say "Count of $type primes <=  {comma 1e6}:  ", comma +@pr[^(@pr.first: * > 1e6,:k)];
    say "Count of $type primes <= {comma 1e7}: ", comma +@pr;
}
