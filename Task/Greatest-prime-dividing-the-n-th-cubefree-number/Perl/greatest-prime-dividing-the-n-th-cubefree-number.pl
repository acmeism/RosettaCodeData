# 20240918 Perl programming solution

use strict;
use warnings;
use Math::Prime::Util qw(factor);

my ($count, $i, $lim1, $lim2, $max, @result) = (1, 2, 100, 1000, 1e7, (1));

while ($count < $max) {
   my ($cubeFree, @factors) = (1, factor($i));
   if (scalar @factors >= 3) {
      for my $j (2..$#factors) {
         if ($factors[$j-2]==$factors[$j-1] && $factors[$j-1]==$factors[$j]) {
            $cubeFree = 0;
            last;
         }
      }
   }
   if ($cubeFree) {
      if ($count < $lim1) { push @result, $factors[-1] }
      $count++;
      if ($count == $lim1) {
         print "The first terms of A370833 are:\n";
         for (my $k = 0; $k < @result; $k += 10) {
            printf "%3d " x 10 . "\n", @result[$k..$k+9];
         }
         print "\n";
      }
      if ($count == $lim2) {
         printf "The %8dth term of A370833 is %7d\n", $count, $factors[-1];
         $lim2 *= 10;
      }
   }
   $i++;
}
