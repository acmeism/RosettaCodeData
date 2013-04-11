my @nums = 12757923, 12878611, 123456789, 15808973, 15780709, 197622519;

my @factories;
@factories[$_] := factors(@nums[$_]) for ^@nums;
my $gmf = ([max] @factories»[0] »=>« @nums).value;
