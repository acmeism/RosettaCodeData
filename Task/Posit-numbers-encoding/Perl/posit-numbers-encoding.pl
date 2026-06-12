# 20240928 Perl programming solution

use strict;
use warnings;
use POSIX qw(INFINITY);

my ($npat, $useed) = (1 << (my $nbits = 8), 1 << (1 << (my $es = 2)));

sub x2p {
   my $x = shift;
   my ($e, $y, $i, $p) = (1 << ($es - 1), abs($x));

   return 0 if ($y == 0);
   return (1 << ($nbits - 1)) if ($y == INFINITY);

   if ($y >= 1) {
      ($p, $i) = (1, 2);
      while ($y >= $useed && $i < $nbits) {
         $p += $p + 1;
         $y /= $useed;
         $i++;
      }
      $p += $p;
      $i++;
   } else {
      ($p, $i) = (0, 1);
      while ($y < 1 && $i <= $nbits) {
         $y *= $useed;
         $i++;
      }
      if ($i >= $nbits) {
         ($p, $i) = (2, $nbits + 1);
      } else {
         $p = 1;
         $i++;
      }
   }

   while ($e > 0.5 && $i <= $nbits) {
      $p = 2 * $p;
      if ($y >= 2 * $e) {
         $y /= (1 << $e);
         $p++;
      }
      $e /= 2;
      $i++;
   }
   $y -= 1;

   while ($y > 0 && $i <= $nbits) {
      $y *= 2;
      $p = 2 * $p + int($y);
      $y -= int($y);
      $i++;
   }
   $p *= (1 << ($nbits + 1 - $i));
   $i++;
   my $i_tmp = $p & 1;
   $p >>= 1;
   if ($i_tmp != 0) { ($y == 1 || $y == 0) ? $p += ($p & 1) : $p++ }
   return ($x < 0 ? $npat - $p : $p) % $npat;
}

print x2p(3.14159265358979), "\n";
