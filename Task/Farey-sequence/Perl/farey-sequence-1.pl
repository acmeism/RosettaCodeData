use warnings;
use strict;
use Math::BigRat;
use ntheory qw/euler_phi vecsum/;

sub farey {
  my $N = shift;
  my @f;
  my($m0,$n0, $m1,$n1) = (0, 1, 1, $N);
  push @f, Math::BigRat->new("$m0/$n0");
  push @f, Math::BigRat->new("$m1/$n1");
  while ($f[-1] < 1) {
    my $m = int( ($n0 + $N) / $n1) * $m1 - $m0;
    my $n = int( ($n0 + $N) / $n1) * $n1 - $n0;
    ($m0,$n0, $m1,$n1) = ($m1,$n1, $m,$n);
    push @f, Math::BigRat->new("$m/$n");
  }
  @f;
}
sub farey_count { 1 + vecsum(euler_phi(1, shift)); }

for (1 .. 11) {
  my @f = map { join "/", $_->parts }   # Force 0/1 and 1/1
          farey($_);
  print "F$_: [@f]\n";
}
for (1 .. 10, 100000) {
  print "F${_}00: ", farey_count(100*$_), " members\n";
}
