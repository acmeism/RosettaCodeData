# 20241002 Perl programming solution

use strict;
use warnings;
use Math::Polynomial;
use Math::BigRat;
use PDL;

sub Lagrange {
   my $pts = shift;
   my ($xs, $cs) = map {
                      my $outer = $_;
                      [ map { Math::BigRat->new($_->[$outer]) } @$pts ]
                   } (0, 1);
   my $n = scalar @$xs;

   return Math::Polynomial->new($cs->[0]) if $n == 1;

   my @arr = (Math::BigRat->bone) x $n;
   for my $j (1 .. $n - 1) {
      for my $k (0 .. $j - 1) { $arr[$k] *= $xs->[$k] - $xs->[$j] }
      $arr[$j] = Math::BigRat->bone;
      $arr[$j] *= $_ for map { $xs->[$j] - $xs->[$_] } (0 .. $j - 1);
   }
   my @ws = map { Math::BigRat->bone / $_ } @arr;
   my ($q, $x) = (Math::Polynomial->new(0), Math::Polynomial->new(0, 1));

   for my $i (0 .. $n - 1) {
      my $m = Math::Polynomial->new(1);
      for my $j (0 .. $n - 1) {
         next if $j == $i;
         $m *= $x - Math::Polynomial->new($xs->[$j]);
      }
      $q += $m * $ws[$i] * Math::Polynomial->new($cs->[$i]);
   }
   $q->string_config({ fold_sign => 1 });
   return $q
}

my $testpoints = [[1, 1], [2, 4], [3, 1], [4, 5]];
print "Lagrange(testpoints) = ", Lagrange($testpoints), "\n";
