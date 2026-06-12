use Lingua::EN::Numbers;

my @ppps = lazy (^∞).hyper(:5000batch).map(* × 2 + 1).grep: -> \n { my \k = n + 1; (1+k).is-prime && (n+k).is-prime && (n²+k).is-prime && (n³+k).is-prime && (n⁴+k).is-prime }

say "First thirty penta-power prime seeds:\n" ~ @ppps[^30].batch(10)».&comma».fmt("%9s").join: "\n";

say "\nFirst penta-power prime seed greater than:";

for 1..10 {
    my $threshold = Int(1e6 × $_);
    my $key = @ppps.first: * > $threshold, :k;
    say "{$threshold.&cardinal.fmt: '%13s'} is the {ordinal-digit $key + 1}: {@ppps[$key].&comma}";
}
