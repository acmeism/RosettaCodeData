use Math::Primesieve;
use Lingua::EN::Numbers;

my $primes = Math::Primesieve.new;

my @mem;

sub ramanujan-prime (\n) {
   1 + (1..(4×n × (4×n).log / 2.log).floor).first: :end, -> \x {
       my \y = x div 2;
       ((@mem[x] //= $primes.count(x)) - (@mem[y] //= $primes.count(y))) < n
   }
}

say 'First 100:';
say (1..100).map( &ramanujan-prime ).batch(10)».&comma».fmt("%6s").join: "\n";
say "\n 1,000th: { comma 1000.&ramanujan-prime }";
say "10,000th: {  comma 10000.&ramanujan-prime }";
say (now - INIT now).fmt('%.3f') ~ ' seconds';
