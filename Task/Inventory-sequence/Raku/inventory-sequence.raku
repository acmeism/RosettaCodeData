use Lingua::EN::Numbers;

my ($i, %i) = 0;

my @inventory = (^∞).map: {
    my $count = %i{$i} // 0;
    $i = $count ?? $i+1 !! 0;
    ++%i{$count};
    $count
}

say "Inventory sequence, first 100 elements:\n" ~
  @inventory[^100].batch(20)».fmt("%2d").join: "\n";

say '';

for (1..10).map: * × 1000 {
    my $k = @inventory.first: * >= $_, :k;
    printf "First element >= %6s is %6s in position: %s\n",
      .&comma, @inventory[$k].&comma, comma $k;
}


use SVG;
use SVG::Plot;

my @x = ^10000;

'Inventory-raku.svg'.IO.spurt:
 SVG.serialize: SVG::Plot.new(
    background  => 'white',
    width       => 1000,
    height      => 600,
    plot-width  => 950,
    plot-height => 550,
    x           => @x,
    values      => [@inventory[@x],],
    title       => "Inventory Sequence - First {+@x} values (zero indexed)",
).plot: :lines;
