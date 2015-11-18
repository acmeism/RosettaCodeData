my $n = 3;
my @a = (0,1,1, -> $p { @a[$p] + @a[$n++ - $p] } ... *);

my $last55;
for 1..19 -> $power {
    my @range := 2**$power .. 2**($power+1)-1;
    my @ratios = (@a[@range] Z/ @range) Z=> @range;
    my $max = @ratios.max;
    ($last55 = .value if .key >= .55 for @ratios) if $max.key >= .55;
    say $power.fmt('%2d'), @range.min.fmt("%10d"), '..', @range.max.fmt("%-10d"),
        $max.key, ' at ', $max.value;
}
say "Mallows' number would appear to be ", $last55;
