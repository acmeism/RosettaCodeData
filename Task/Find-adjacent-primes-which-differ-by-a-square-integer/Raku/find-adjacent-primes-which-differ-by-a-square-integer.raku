use Lingua::EN::Numbers;
use Math::Primesieve;

my $iterator = Math::Primesieve::iterator.new;
my $limit    = 1e10;
my @squares  = (1..30).map: *²;
my $last     = 2;
my @gaps;
my @counts;

loop {
    my $this = (my $p = $iterator.next) - $last;
    quietly @gaps[$this].push($last) if +@gaps[$this] < 10;
    @counts[$this]++;
    last if $p > $limit;
    $last = $p;
}

print "Adjacent primes up to {comma $limit.Int} with a gap value that is a perfect square:";
for @gaps.pairs.grep: { (.key ∈ @squares) && .value.defined} -> $p {
    my $ten = (@counts[$p.key] > 10) ?? ', (first ten)' !! '';
    say "\nGap {$p.key}: {comma @counts[$p.key]} found$ten:";
    put join "\n", $p.value.batch(5)».map({"($_, {$_+ $p.key})"})».join(', ');
}
