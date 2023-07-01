use strict;
use warnings;
use Statistics::Regression;

my @y =  (52.21, 53.12, 54.48, 55.84, 57.20, 58.57, 59.93, 61.29, 63.11, 64.47, 66.28, 68.10, 69.92, 72.19, 74.46);
my @x =  ( 1.47,  1.50,  1.52,  1.55,  1.57,  1.60,  1.63,  1.65,  1.68,  1.70,  1.73,  1.75,  1.78,  1.80,  1.83);

my @model = ('const', 'X', 'X**2');
my $reg = Statistics::Regression->new( '', [@model] );
$reg->include( $y[$_], [ 1.0, $x[$_], $x[$_]**2 ]) for 0..@y-1;
my @coeff = $reg->theta();

printf "%-6s %8.3f\n", $model[$_], $coeff[$_] for 0..@model-1;
