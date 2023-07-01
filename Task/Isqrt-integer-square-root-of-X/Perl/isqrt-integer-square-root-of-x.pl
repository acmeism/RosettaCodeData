# 20201029 added Perl programming solution

use strict;
use warnings;
use bigint;

use CLDR::Number 'decimal_formatter';

sub integer_sqrt {
   ( my $x = $_[0] ) >= 0 or die;
   my $q = 1;
   while ($q <= $x) {
      $q <<= 2
   }
   my ($z, $r) = ($x, 0);
   while ($q > 1) {
      $q >>= 2;
      my $t = $z - $r - $q;
      $r >>= 1;
      if ($t >= 0) {
         $z  = $t;
         $r += $q;
      }
   }
   return $r
}

print "The integer square roots of integers from 0 to 65 are:\n";
print map { ( integer_sqrt $_ ) . ' ' } (0..65);

my $cldr = CLDR::Number->new();
my $decf = $cldr->decimal_formatter;

print "\nThe integer square roots of odd powers of 7 from 7^1 up to 7^73 are:\n";
print "power", " "x36, "7 ^ power", " "x60, "integer square root\n";
print "----- ", "-"x79, "  ------------------------------------------\n";

for (my $i = 1; $i < 74; $i += 2) {
   printf("%2s ", $i);
   printf("%82s", $decf->format( 7**$i ) );
   printf("%44s", $decf->format( integer_sqrt(7**$i) ) ) ;
   print "\n";
}
