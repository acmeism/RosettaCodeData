my Hofstadter $Q .= new();

say "first ten: $Q[^10]";
say "1000th: $Q[999]";

my $count = 0;
$count++ if $Q[$_ +1 ] < $Q[$_] for  ^99_999;
say "In the first 100_000 terms, $count terms are less than their preceding terms";
