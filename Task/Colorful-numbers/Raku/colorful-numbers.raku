sub is-colorful (Int $n) {
    return True if 0 <= $n <= 9;
    return False if $n.contains(0) || $n.contains(1) || $n < 0;
    my @digits = $n.comb;
    my %sums = @digits.Bag;
    return False if %sums.values.max > 1;
    for 2..@digits -> $group {
        @digits.rotor($group => 1 - $group).map: { %sums{ [×] $_ }++ }
        return False if %sums.values.max > 1;
    }
    True
}

put "Colorful numbers less than 100:\n" ~ (^100).hyper.grep( &is-colorful).batch(10)».fmt("%2d").join: "\n";

my ($start, $total) = 23456789, 10;

print "\nLargest magnitude colorful number: ";
.put and last if .Int.&is-colorful for $start.flip … $start;


put "\nCount of colorful numbers for each order of magnitude:\n" ~
    "1 digit colorful number count: $total - 100%";

for 2..8 {
   put "$_ digit colorful number count: ",
   my $c = +(flat $start.comb.combinations($_).map: {.permutations».join».Int}).hyper.grep( &is-colorful ),
   " - {($c / (exp($_,10) - exp($_-1,10) ) * 100).round(.001)}%";
   $total += $c;
}

say "\nTotal colorful numbers: $total";
