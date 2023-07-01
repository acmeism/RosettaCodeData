# 20210602 Perl programming solution

use strict;
use warnings;

sub dow ($) {
   my ($year, $month, $day) = split /-/;
   my @D = $year%($year%25?4:16) ? (3,7,7,4,2,6,4,1,5,3,7,5) : (4,1,7,2,4,6,4,1,5,3,7,5);
   my $c = int($year / 100);
   my $s = ($year % 100) / 12;
   my $t = ($year % 100) % 12;
   my $a = ( 5 * ($c % 4) + 2 ) % 7;
   my $b = ( $s + $t + int($t / 4) + $a ) % 7;

   qw ( Sunday Monday Tuesday Wednesday Thursday Friday Saturday ) [
      ($b + $day - $D[$month - 1] + 7) % 7 ]
}

for (qw( 1800-01-06 1875-03-29 1915-12-07 1970-12-23 2043-05-14 2077-02-12 2101-04-02 )) {
   print  $_, " is a : ", dow $_, "\n";
}
