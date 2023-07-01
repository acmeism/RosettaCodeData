my ( $min_sum, $hero_attr_min, $hero_count_min ) = 75, 15, 2;
my @attr-names = <Str Int Wis Dex Con Cha>;

sub heroic { + @^a.grep: * >= $hero_attr_min }

my @attr;
repeat until @attr.sum     >= $min_sum
         and heroic(@attr) >= $hero_count_min {

    @attr = @attr-names.map: { (1..6).roll(4).sort(+*).skip(1).sum };
}

say @attr-names Z=> @attr;
say "Sum: {@attr.sum}, with {heroic(@attr)} attributes >= $hero_attr_min";
