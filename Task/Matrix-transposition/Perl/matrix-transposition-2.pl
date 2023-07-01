my @m = (
  [1, 1, 1, 1],
  [2, 4, 8, 16],
  [3, 9, 27, 81],
  [4, 16, 64, 256],
  [5, 25, 125, 625],
);

my @transposed;
foreach my $j (0..$#{$m[0]}) {
  push(@transposed, [map $_->[$j], @m]);
}
