my @range = -15..16;

my @points = gather for @range X @range -> ($x, $y) {
    take [$x,$y] if 10 <= sqrt($x*$x+$y*$y) <= 15
}
my @samples = @points.roll(100); # or .pick(100) to get distinct points

# format and print
my %matrix;
for @range X @range -> ($x, $y) { %matrix{$y}{$x} = ' ' }
%matrix{$_[1]}{$_[0]} = '*' for @samples;
%matrix{$_}{@range}.join(' ').say for @range;
