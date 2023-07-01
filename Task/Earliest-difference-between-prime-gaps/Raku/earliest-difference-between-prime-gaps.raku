use Math::Primesieve;
use Lingua::EN::Numbers;

my $iterator = Math::Primesieve::iterator.new;
my @gaps;
my $last = 2;

for 1..9 {
    my $m = exp $_, 10;
    my $this;
    loop {
        $this = (my $p = $iterator.next) - $last;
        if !@gaps[$this].defined {
             @gaps[$this]= $last;
             check-gap($m, $this, @gaps) && last
               if $this > 2 and @gaps[$this - 2].defined and (abs($last - @gaps[$this - 2]) > $m);
        }
        $last = $p;
    }
}

sub check-gap ($n, $this, @p) {
    my %upto = @p[^$this].pairs.grep: *.value;
    my @upto = (1..$this).map: { last unless %upto{$_ * 2}; %upto{$_ * 2} }
    my $key = @upto.rotor(2=>-1).first( {.sink; abs(.[0] - .[1]) > $n}, :k );
    return False unless $key;
    say "Earliest difference > {comma $n} between adjacent prime gap starting primes:";
    printf "Gap %s starts at %s, gap %s starts at %s, difference is %s\n\n",
    |(2 * $key + 2, @upto[$key], 2 * $key + 4, @upto[$key+1], abs(@upto[$key] - @upto[$key+1]))».&comma;
    True
}
