use strict;
use warnings;
use List::Util <min max shuffle>;

sub getPRangeCount {
    my($min,$max,@prices) = @_;
    grep { $min <= $_ <= $max } @prices;
}

sub get5000 {
   my($min, $max, $n, @prices) = @_;
   my $count = getPRangeCount($min, $max, @prices);
   my $delta = ($max - $min) / 2;
   while ($count != $n and $delta >= 1/2) {
      $count > $n ? $max -= $delta : ($max += $delta);
      $count = getPRangeCount($min, $max, @prices);
      $delta /= 2;
   }
   $max, $count
}

sub getAll5000 {
   my($min, $max, $n, @prices) = @_;
   my ( $pmax, $pcount ) = get5000($min, $max, $n, @prices);
   my @results = [ $min, $pmax, $pcount ];
   while ($pmax < $max) {
      my $pmin = $pmax + 1;
      ( $pmax, $pcount ) = get5000($pmin, $max, $n, @prices);
      $pcount == 0 and print "Price list from $pmin has too many duplicates.\n";
      push @results, [ $pmin, $pmax, $pcount ];
   }
   @results
}

my @prices;
push @prices, int rand 10_000+1 for 1 .. (my $numPrices = shuffle 99_990..100_050);

my $actualMax = max @prices;
print "Using $numPrices items with prices from 0 to $actualMax:\n";

my @results = getAll5000(0, $actualMax, 5000, @prices);
print "Split into " . @results . " bins of approx 5000 elements:\n";

for my $row (@results) {
   my ($min,$max,$subtotal) = @$row;
   $max = $actualMax if $max > $actualMax;
   printf "  From %6d to %6d with %4d items\n", $min, $max, $subtotal
}
