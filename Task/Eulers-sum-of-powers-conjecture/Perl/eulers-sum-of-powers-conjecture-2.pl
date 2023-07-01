use constant MAX => 250;
my @p5 = (0,map { $_**5 } 1 .. MAX-1);
my $rs = 5;
for my $x0 (1..MAX-1) {
  for my $x1 (1..$x0-1) {
    for my $x2 (1..$x1-1) {
      my $s2 = $p5[$x0] + $p5[$x1] + $p5[$x2];
      $rs-- while $rs > 0 && $p5[$rs] > $s2;
      for (my $x3 = 1;  $x3 < $x2;  $x3++) {
        my $e30 = ($x0 + $x1 + $x2 + $x3 - $rs) % 30;
        $x3 += (30-$e30) if $e30;
        last if $x3 >= $x2;
        my $sum = $s2 + $p5[$x3];
        $rs++ while $rs < MAX-1 && $p5[$rs] < $sum;
        die "$x3 $x2 $x1 $x0 $rs\n" if $p5[$rs] == $sum;
      }
    }
  }
}
