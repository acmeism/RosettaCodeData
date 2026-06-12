# 20240907 Perl programming solution

use strict;
use warnings;

sub bump {
   my ($n, $b)  = @_;
   my ($res,$i) = 0,0;
   while ($n) {
      if (my $d = int($n % $b)) { $res += $d * (($b + 1) ** &bump($i, $b)) }
      $n = int($n / $b);
      $i++;
   }
   return $res;
}

sub goodstein {
   my ($n, $maxterms) = @_;
   $maxterms = 10 unless defined $maxterms;
   my @res = ($n);
   while (@res < $maxterms && $res[-1] != 0) {
      push @res, &bump($res[-1], scalar @res + 1) - 1
   }
   return @res;
}

print "Goodstein(n) sequence (first 10) for values of n from 0 through 7:\n";
foreach (0..7) { print "Goodstein of $_: ", join(", ", goodstein($_)), "\n" }

my $max = 10;
print "\nThe Nth term of Goodstein(N) sequence counting from 0, for values of N from 0 through $max :\n";
foreach my $i (0..$max) {
   my @seq = goodstein($i, $i + 1);
   printf "Term %2d of Goodstein(%2d): %s\n", $i, $i, $seq[-1]
}
