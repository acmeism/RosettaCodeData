# 20240910 Perl programming solution

use strict;
use warnings;
use Math::Prime::Util qw(is_prime next_prime);

for ( my ($ecount,$p,$n) = (0,0,0); $ecount < 50_000; ) {
   if ( is_prime($n += $p = next_prime($p)) ) {
      $ecount++;
      if ($ecount < 31) { print "Sum of prime series up to $p: prime $n\n" }
      if ($ecount =~ /^(1000|2000|3000|4000|5000|30000|40000|50000)$/) {
         print "Sum of $ecount in prime series up to $p: prime $n\n"
      }
   }
}
