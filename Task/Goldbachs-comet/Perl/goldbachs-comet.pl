use strict;
use warnings;
use feature 'say';

use List::Util 'max';
use GD::Graph::bars;
use ntheory 'is_prime';

sub table { my $t = shift() * (my $c = 1 + max map {length} @_); ( sprintf( ('%'.$c.'s')x@_, @_) ) =~ s/.{1,$t}\K/\n/gr }

sub G {
    my($n) = @_;
    scalar grep { is_prime($_) and is_prime($n - $_) } 2 .. $n/2;
}

my @y;
push @y, G(2*$_ + 4) for my @x = 0..1999;

say $_ for table 10, @y;
printf "G $_: %d", G($_) for 1e6;

my @data = ( \@x, \@y);
my $graph = GD::Graph::bars->new(1200, 400);
$graph->set(
    title          => q/Goldbach's Comet/,
    y_max_value    => 170,
    x_tick_number  => 10,
    r_margin       => 10,
    dclrs          => [ 'blue' ],
) or die $graph->error;
my $gd = $graph->plot(\@data) or die $graph->error;

open my $fh, '>', 'goldbachs-comet.png';
binmode $fh;
print $fh $gd->png();
close $fh;
