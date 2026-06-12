# 20210208 Raku programming solution

my \minDelta = 1;

sub getMaxPrice { @_.max }

sub getPRangeCount(@prices,\min,\max) { +@prices.grep: min ≤ * ≤ max }

sub get5000(@prices, $min, $max is copy, \n) {
   my $count = getPRangeCount(@prices, $min, $max);
   my $delta = ($max - $min) / 2;
   while $count != n && $delta ≥ minDelta/2 {
      $count > n ?? ($max -= $delta) !! ($max += $delta);
      $count = getPRangeCount(@prices, $min, $max);
      $delta /= 2;
   }
   $max, $count
}

sub getAll5000(@prices, \min, \max, \n) {
   my ( $pmax, $pcount ) = get5000(@prices, min, max, n);
   my @res = [ min, $pmax, $pcount ] , ;
   while $pmax < max {
      my $pmin = $pmax + 1;
      ( $pmax, $pcount ) = get5000(@prices, $pmin, max, n);
      $pcount == 0 and note "Price list from $pmin has too many duplicates.";
      @res.push: [ $pmin, $pmax, $pcount ];
   }
   @res
}

my $numPrices = (99000..101001).roll;
my \maxPrice  = 1e5;
my @prices    = (1..$numPrices+1).roll xx $numPrices ;

my $actualMax = getMaxPrice(@prices);
say "Using $numPrices items with prices from 0 to $actualMax:";

my @res = getAll5000(@prices, 0, $actualMax, 5000);
say "Split into ", +@res, " bins of approx 5000 elements:";

for @res -> @row {
   my ($min,$max,$subtotal) = @row;
   $max = $actualMax if $max > $actualMax ;
   printf "  From %6d to %6d with %4d items\n", $min, $max, $subtotal
}
