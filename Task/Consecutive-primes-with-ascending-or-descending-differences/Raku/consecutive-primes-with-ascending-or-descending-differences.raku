use Math::Primesieve;
use Lingua::EN::Numbers;

my $sieve = Math::Primesieve.new;

my $limit = 1000000;

my @primes = $sieve.primes($limit);

sub runs (&op) {
    my $diff = 1;
    my $run = 1;

    my @diff = flat 1, (1..^@primes).map: {
        my $next = @primes[$_] - @primes[$_ - 1];
        if &op($next, $diff) { ++$run } else { $run = 1 }
        $diff = $next;
        $run;
    }

    my $max = max @diff;
    my @runs = @diff.grep: * == $max, :k;

    @runs.map( {
        my @run = (0..$max).reverse.map: -> $r { @primes[$_ - $r] }
        flat roundrobin(@run».&comma, @run.rotor(2 => -1).map({[R-] $_})».fmt('(%d)'));
    } ).join: "\n"
}

say "Longest run(s) of ascending prime gaps up to {comma $limit}:\n" ~ runs(&infix:«>»);

say "\nLongest run(s) of descending prime gaps up to {comma $limit}:\n" ~ runs(&infix:«<»);
