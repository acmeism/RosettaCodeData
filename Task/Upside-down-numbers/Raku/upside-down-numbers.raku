use Lingua::EN::Numbers;

sub udgen (@r) {
    my @u = @r.hyper.map: { next if .contains: 0; ($_, (10 «-« .flip.comb).join) };
    @u».join, @u».join(5)
}

my @upside-downs = lazy flat 5, (^∞).map({ udgen exp($_,10) .. exp(1+$_,10) });

say "First fifty upside-downs:\n" ~ @upside-downs[^50].batch(10)».fmt("%4d").join: "\n";

say '';

for 5e2, 5e3, 5e4, 5e5, 5e6 {
    say "{.Int.&ordinal.tc}: " ~ comma @upside-downs[$_-1]
}
