# 20240908 Perl programming solution

use strict;
use warnings;

sub chenfoxlyndonfactorization {
   my ($s) = @_;
   my ($n, $i, @factorization) = (length($s), 0);
   while ($i < $n) {
      my ($j, $k) = ($i+1, $i);
      while ($j < $n && substr($s, $k, 1) le substr($s, $j, 1)) {
         (substr($s, $k, 1) lt substr($s, $j, 1)) ?  $k = $i : $k++;
         $j++
      }
      while ($i <= $k) {
         my $substring = substr($s, $i, $j - $k);
         push @factorization, $substring;
         $i += $j - $k
      }
   }
   return \@factorization;
}

my $m = "0";
for my $i (1..7) { $m .= ($m =~ tr/01/10/r) }
my $factors = chenfoxlyndonfactorization($m);
print "[", join(" ", @$factors), "]\n";
