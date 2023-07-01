use Prime::Factor;
use Lingua::EN::Numbers;
use Math::Primesieve;
my $sieve = Math::Primesieve.new;

my %cat = 2 => 1, 3 => 1;

sub Erdös-Selfridge ($n) {
    my @factors = prime-factors $n + 1;
    my $category = max %cat{ @factors };
    unless %cat{ @factors[*-1] } {
        $category max= ( 1 + max %cat{ prime-factors 1 + @factors[*-1] } );
        %cat{ @factors[*-1] } = $category;
    }
    $category
}

my $upto = 200;

say "First { cardinal $upto } primes; Erdös-Selfridge categorized:";
.say for sort $sieve.n-primes($upto).categorize: &Erdös-Selfridge;

$upto = 1_000_000;

say "\nSummary of first { cardinal $upto } primes; Erdös-Selfridge categorized:";
printf "Category %2d: first: %9s  last: %10s  count: %s\n", ++$, |(.[0], .[*-1], .elems).map: &comma
for $sieve.n-primes($upto).categorize( &Erdös-Selfridge ).sort(+*.key)».value;
