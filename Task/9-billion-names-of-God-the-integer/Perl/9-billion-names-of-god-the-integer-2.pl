use strict;
use warnings;

# Where Raku uses arbitrary precision integers everywhere
# that you don't tell it not to do so, Perl 5 will only use
# them where you *do* tell it do so.
use Math::BigInt;
use constant zero => Math::BigInt->bzero;
use constant one  => Math::BigInt->bone;

my @todo = [one];
my @sums = (zero);
sub nextrow {
   my $n = shift;
   for my $l (@todo .. $n) {
      $sums[$l] = zero;
      #print "$l\r" if $l < $n;
      my @r;
      for my $x (reverse 0 .. $l-1) {
         my $todo = $todo[$x];
         $sums[$x] += shift @$todo if @$todo;
         push @r, $sums[$x];
      }
      push @todo, \@r;
   }
   @{ $todo[$n] };
}

print "rows:\n";
for(1..25) {
   printf("%2d: ", $_);
   print join(' ', nextrow($_)), "\n";
}
print "\nsums:\n";
for (23, 123, 1234, 12345) {
   print $_, "." x (8 - length);
   my $i = 0;
   $i += $_ for nextrow($_);
   print $i, "\n";
}
