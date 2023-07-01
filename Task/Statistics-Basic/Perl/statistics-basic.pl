my @histogram = (0) x 10;
my $sum = 0;
my $sum_squares = 0;
my $n = $ARGV[0];

for (1..$n) {
  my $current = rand();
  $sum+= $current;
  $sum_squares+= $current ** 2;
  $histogram[$current * @histogram]+= 1;
}

my $mean = $sum / $n;

print "$n numbers\n",
      "Mean:   $mean\n",
      "Stddev: ", sqrt(($sum_squares / $n) - ($mean ** 2)), "\n";

for my $i (0..$#histogram) {
  printf "%.1f - %.1f : ", $i/@histogram, (1 + $i)/@histogram;

  print "*" x (30 * $histogram[$i] * @histogram/$n); # 30 stars expected per row
  print "\n";
}
