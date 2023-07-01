use strict;
use warnings;
use feature 'say';

use List::Util qw(first);
use GD::Graph::bars;

use constant Inf  => 1e5;

sub gcd {
  my ($u, $v) = @_;
  while ($v) {
    ($u, $v) = ($v, $u % $v);
  }
  return abs($u);
}

sub yellowstone {
    my($terms) = @_;
    my @s = (1, 2, 3);
    my @used = (1) x 4;
    my $min  = 3;
    while (1) {
        my $index = first { not defined $used[$_] and gcd($_,$s[-2]) != 1 and gcd($_,$s[-1]) == 1 } $min .. Inf;
        $used[$index] = 1;
        $min = (first { not defined $used[$_] } 0..@used-1) || @used-1;
        push @s, $index;
        last if @s == $terms;
    }
    @s;
}

say "The first 30 terms in the Yellowstone sequence:\n" . join ' ', yellowstone(30);

my @data = ( [1..500], [yellowstone(500)]);
my $graph = GD::Graph::bars->new(800, 600);
$graph->set(
    title          => 'Yellowstone sequence',
    y_max_value    => 1400,
    x_tick_number  => 5,
    r_margin       => 10,
    dclrs          => [ 'blue' ],
) or die $graph->error;
my $gd = $graph->plot(\@data) or die $graph->error;

open my $fh, '>', 'yellowstone-sequence.png';
binmode $fh;
print $fh $gd->png();
close $fh;
