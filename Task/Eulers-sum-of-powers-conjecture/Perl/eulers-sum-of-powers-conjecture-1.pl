use constant MAX => 250;
my @p5 = (0,map { $_**5 } 1 .. MAX-1);
my $s = 0;
my %p5 = map { $_ => $s++ } @p5;
for my $x0 (1..MAX-1) {
  for my $x1 (1..$x0-1) {
    for my $x2 (1..$x1-1) {
      for my $x3 (1..$x2-1) {
        my $sum = $p5[$x0] + $p5[$x1] + $p5[$x2] + $p5[$x3];
        die "$x3 $x2 $x1 $x0 $p5{$sum}\n" if exists $p5{$sum};
      }
    }
  }
}
