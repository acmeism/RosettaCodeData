use strict;
use warnings;

# This code uses "Even's Speedup," as described on
# the Wikipedia page about the Steinhaus–Johnson–
# Trotter algorithm.

# Any resemblance between this code and the Python
# code elsewhere on the page is purely a coincidence,
# caused by them both implementing the same algorithm.

# The code was written to be read relatively easily
# while demonstrating some common perl idioms.

sub perms :prototype(&@) {
   my $callback = shift;
   my @perm = map [$_, -1], @_;
   $perm[0][1] = 0;

   my $sign = 1;
   while( ) {
      $callback->($sign, map $_->[0], @perm);
      $sign *= -1;

      my ($chosen, $index) = (-1, -1);
      for my $i ( 0 .. $#perm ) {
         ($chosen, $index) = ($perm[$i][0], $i)
           if $perm[$i][1] and $perm[$i][0] > $chosen;
      }
      return if $index == -1;

      my $direction = $perm[$index][1];
      my $next = $index + $direction;

      @perm[ $index, $next ] = @perm[ $next, $index ];

      if( $next <= 0 or $next >= $#perm ) {
         $perm[$next][1] = 0;
      } elsif( $perm[$next + $direction][0] > $chosen ) {
         $perm[$next][1] = 0;
      }

      for my $i ( 0 .. $next - 1 ) {
         $perm[$i][1] = +1 if $perm[$i][0] > $chosen;
      }
      for my $i ( $next + 1 .. $#perm ) {
         $perm[$i][1] = -1 if $perm[$i][0] > $chosen;
      }
   }
}

my $n = shift(@ARGV) || 4;

perms {
   my ($sign, @perm) = @_;
   print "[", join(", ", @perm), "]";
   print $sign < 0 ? " => -1\n" : " => +1\n";
} 1 .. $n;
