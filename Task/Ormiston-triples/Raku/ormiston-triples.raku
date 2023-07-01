use Lingua::EN::Numbers;
use List::Divvy;

my @primes = lazy (^∞).hyper.grep( &is-prime ).map: { $_ => .comb.sort.join };
my @Ormistons = @primes.kv.map: { $^value.key if $^value.value eq @primes[$^key+1].value eq @primes[$^key+2].value};

say "First twenty-five Ormiston triples:";
say @Ormistons[^25].batch(5)».join(', ').join: "\n";
say '';
say +@Ormistons.&before( *[0] > $_ ) ~ " Ormiston triples before " ~ .Int.&cardinal for 1e8, 1e9;
