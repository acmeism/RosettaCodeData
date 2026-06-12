use Lingua::EN::Numbers;

my @qpps = lazy (1..*).hyper(:5000batch).grep: -> \n { my \k = n + 1; (n+k).is-prime && (n²+k).is-prime && (n³+k).is-prime && (n⁴+k).is-prime }

say "First fifty quad-power prime seeds:\n" ~ @qpps[^50].batch(10)».&comma».fmt("%7s").join: "\n";

say "\nFirst quad-power prime seed greater than:";

for 1..10 {
    my $threshold = Int(1e6 × $_);
    my $key = @qpps.first: * > $threshold, :k;
    say "{$threshold.&cardinal.fmt: '%13s'} is the {ordinal-digit $key + 1}: {@qpps[$key].&comma}";
}
