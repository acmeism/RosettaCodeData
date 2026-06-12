# 20240916 Perl programming solution

use strict;
use warnings;
use POSIX qw(floor);

sub sturmian_word {
   my ($m, $n) = @_;
   if ($m > $n) {
      my $sw = sturmian_word($n, $m);
      return $sw =~ tr/01/10/;
   }
   my $res = "";
   my ($k, $prev) = (1, 0);
   while (($k * $m) % $n > 0) {
      my $curr = floor($k * $m / $n);
      $res .= ($prev == $curr) ? "0" : "10";
      $prev = $curr;
      $k++;
   }
   return $res;
}

sub fib_word {
   my ($n) = @_;
   my ($Sn_1, $Sn) = ("0", "01");
   for (2..$n) { ($Sn, $Sn_1) = ($Sn.$Sn_1, $Sn) }
   return $Sn;
}

my $fib = fib_word(7);
my $sturmian = sturmian_word(13, 21);
print "$sturmian <== 13/21\n" if substr($fib, 0, length($sturmian)) eq $sturmian;

sub cfck {
   my ($a, $b, $m, $n, $k) = @_;
   my @p = (0, 1);
   my @q = (1, 0);
   my $r = (sqrt($a) * $b + $m) / $n;
   for (1..$k) {
      my $whole = int($r);
      my ($pn, $qn) = ($whole * $p[-1] + $p[-2],  $whole * $q[-1] + $q[-2]);

      push @p, $pn;
      push @q, $qn;
      $r = 1 / ($r - $whole);
   }
   return ($p[-1], $q[-1]);
}

my ($p, $q) = cfck(5, 1, -1, 2, 8);
print sturmian_word($p, $q) . " <== 1/phi (8th convergent golden ratio)\n";
