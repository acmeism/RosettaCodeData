use Lingua::EN::Numbers;
use List::Divvy;

my @primes = lazy (^∞).hyper.grep( &is-prime ).map: { $_ => .comb.sort.join };
my @Ormistons = @primes.kv.map: { ($^value.key, @primes[$^key+1].key) if $^value.value eq @primes[$^key+1].value };

say "First thirty Ormiston pairs:";
say @Ormistons[^30].batch(3)».map( { "({.[0].fmt: "%5d"}, {.[1].fmt: "%5d"})" } ).join: "\n";
say '';
say +@Ormistons.&before( *[1] > $_ ) ~ " Ormiston pairs before " ~ .Int.&cardinal for 1e5, 1e6, 1e7;
