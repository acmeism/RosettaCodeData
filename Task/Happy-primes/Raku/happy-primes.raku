my %seen = 1 => 1;

sub is-happy ($n) {
    my @h = $n, { %seen{$_} // .comb».².sum } … * == 1|4;
    map { %seen{$_} = @h.tail }, +@h > 2 ?? @h[0..*-3] !! @h[0];
    @h.tail == 1
}

my @happy = (1..*).grep: &is-happy;

say "First fifty happy primes:";
say @happy.grep(&is-prime)[^50]».fmt("%4d").batch(10).join: "\n";

my ($index, $prime) = 0, 0;

say "\nPrime\nfraction  Index  Value";
for 2..12 -> $d {
   repeat { ++$prime if @happy[++$index].is-prime } until $prime / (1+$index) <= 1/$d;
   printf "1/%-2d:   %7d  %d\n", $d, 1+$index, @happy[$index]
}
