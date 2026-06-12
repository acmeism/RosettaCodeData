# 20240906 Perl programming solution

use strict;
use warnings;

sub convergents {
   my ($x, $maxcount)   = @_;
   my ($epsilon, @comp) = 1e-9;
   for (1..$maxcount) {
      push(@comp, my $ix = int($x));
      my $fpart = $x - $ix;
      abs($fpart) < $epsilon ? ( last ) : ( $x = 1 / $fpart )
   }
   my ($numa, $denoma, $numb, $denomb) = ( 1, 0, $comp[0], 1 );
   my @return = ( "$numb/$denomb" ) ;
   for my $i (1 .. $#comp) {
      (  $numa, $denoma, $numb                  , $denomb                     )
      = ($numb, $denomb, $numa + $comp[$i]*$numb, $denoma + $comp[$i]*$denomb );
      push(@return, "$numb/$denomb")
   }
   @return
}

my @tests = (
   [ "415/93", 415/93 ],   [ "649/200", 649/200 ], [ "sqrt(2)", sqrt(2) ],
   [ "sqrt(5)", sqrt(5) ], [ "golden ratio", (sqrt(5) + 1) / 2 ]
);

print "The continued fraction convergents for the following (maximum 8 terms) are:\n";
foreach my $test (@tests) {
   my ($s, $x) = @$test;
   printf "%15s = %s\n", $s, join(' ', convergents($x, 8));
}
