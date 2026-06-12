use strict;
use warnings;
use feature 'say';

use List::AllUtils <max firstidx>;
use GD::Graph::bars;

sub comma { reverse ((reverse shift) =~ s/.{3}\K/,/gr) =~ s/^,//r }
sub table { my $t = 20 * (my $c = 1 + length max @_); ( sprintf( ('%'.$c.'d')x@_, @_) ) =~ s/.{1,$t}\K/\n/gr }

my($i, @inventory, %i) = 0;
do {
    my $count = $i{$i} // 0;
    $i = $count ? $i+1 : 0;
    ++$i{$count};
    push @inventory, $count
} until $inventory[-1] > 10_000;

say "Inventory sequence, first 100 elements:\n" .  table @inventory[0..99]; say '';

for my $n (map { $_ * 1000 } 1..10) {
    my $i = firstidx { $_ >= $n } @inventory;
    printf "First element >= %6s is %6s in position: %s\n", comma($n), comma($inventory[$i]), comma $i;
}

# graph
my @data = ( [0..5000], [@inventory[0..5000]] );
my $graph = GD::Graph::bars->new(800, 600);
$graph->set(
    title          => 'Inventory sequence',
    y_max_value    => 250,
    x_tick_number  => 5,
    r_margin       => 10,
    dclrs          => [ 'blue' ],
) or die $graph->error;
my $gd = $graph->plot(\@data) or die $graph->error;

open my $fh, '>', 'Perl-inventory-sequence.png';
binmode $fh;
print $fh $gd->png();
close $fh;
