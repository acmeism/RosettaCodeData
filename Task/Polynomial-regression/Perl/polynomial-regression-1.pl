use strict;
use warnings;
use Statistics::Regression;

my @x = <0 1 2 3 4 5 6 7 8 9 10>;
my @y = <1 6 17 34 57 86 121 162 209 262 321>;

my @model = ('const', 'X', 'X**2');

my $reg = Statistics::Regression->new( '', [@model] );
$reg->include( $y[$_], [ 1.0, $x[$_], $x[$_]**2 ]) for 0..@y-1;
my @coeff = $reg->theta();

printf "%-6s %8.3f\n", $model[$_], $coeff[$_] for 0..@model-1;
