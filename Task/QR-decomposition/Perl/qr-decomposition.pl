use strict;
use warnings;

use PDL;
use PDL::LinearAlgebra qw(mqr);

my $a = pdl(
      [12, -51,   4],
      [ 6, 167, -68],
      [-4,  24, -41],
      [-1,   1,   0],
      [ 2,   0,   3]
);

my ($q, $r) = mqr($a);
print $q, $r, $q x $r;
