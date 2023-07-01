use strict;
use List::Util 'sum';

my ($min_sum, $hero_attr_min, $hero_count_min) = <75 15 3>;
my @attr_names = <Str Int Wis Dex Con Cha>;

sub heroic { scalar grep { $_ >= $hero_attr_min } @_ }

sub roll_skip_lowest {
    my($dice, $sides) = @_;
    sum( (sort map { 1 + int rand($sides) } 1..$dice)[1..$dice-1] );
}

my @attr;
do {
    @attr = map { roll_skip_lowest(6,4) } @attr_names;
} until sum(@attr) >= $min_sum and heroic(@attr) >= $hero_count_min;

printf "%s = %2d\n", $attr_names[$_], $attr[$_] for 0..$#attr;
printf "Sum = %d, with %d attributes >= $hero_attr_min\n", sum(@attr), heroic(@attr);
