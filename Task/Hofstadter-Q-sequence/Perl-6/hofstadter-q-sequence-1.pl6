class Hofstadter {
  has @!c = 1,1;
  method AT-POS ($me: Int $i) {
    @!c.push($me[@!c.elems-$me[@!c.elems-1]] +
	     $me[@!c.elems-$me[@!c.elems-2]]) until @!c[$i]:exists;
    return @!c[$i];
  }
}

# Testing:

my Hofstadter $Q .= new();

say "first ten: $Q[^10]";
say "1000th: $Q[999]";

my $count = 0;
$count++ if $Q[$_ +1 ] < $Q[$_] for  ^99_999;
say "In the first 100_000 terms, $count terms are less than their preceding terms";
