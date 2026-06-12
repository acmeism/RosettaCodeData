# 20240925 Perl programming solution

use strict;
use warnings;
use ntheory qw(is_carmichael carmichael_lambda);

sub iterated_to_one {
   my ($n) = @_;
   for (my $k = 0;;) { ($n = carmichael_lambda($n)) > 1 ? $k++ : return ++$k }
}

print " n   λ   k\n----------\n";
for my $n (1..25) {
   printf "%2d  %2d  %2d\n", $n, carmichael_lambda($n), iterated_to_one($n)
}

print "\nIterations to 1       i     lambda(i)\n",'='x37,"\n";
print "   0                  1            1\n";

my ($max_n, $max_i, @found) = (15, 5_000_000, (1));
for my $i (1 .. $max_i) {
   unless ($found[ my $n = iterated_to_one($i) ]) {
      printf "%4d %18d %12d\n", $n, $i, carmichael_lambda($i);
      $n == $max_n ?  last  : ( $found[$n] = 1 )
   }
}
