use warnings;
use strict;

sub mdr {
  my $n = shift;
  my($count, $mdr) = (0, $n);
  while ($mdr > 9) {
    my($m, $dm) = ($mdr, 1);
    while ($m) {
      $dm *= $m % 10;
      $m = int($m/10);
    }
    $mdr = $dm;
    $count++;
  }
  ($count, $mdr);
}

print "Number: (MP, MDR)\n======  =========\n";
foreach my $n (123321, 7739, 893, 899998) {
  printf "%6d: (%d, %d)\n", $n, mdr($n);
}
print "\nMP: [n0..n4]\n==  ========\n";
foreach my $target (0..9) {
  my $i = 0;
  my @n = map { $i++ while (mdr($i))[1] != $target; $i++; } 1..5;
  print " $target: [", join(", ", @n), "]\n";
}
