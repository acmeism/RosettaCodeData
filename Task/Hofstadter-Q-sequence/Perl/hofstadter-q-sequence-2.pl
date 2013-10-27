#!perl
use strict;
use warnings;
package Hofstadter;
sub TIEARRAY {
   bless [undef, 1, 1], shift;
}
sub FETCH {
   my ($self, $n) = @_;
   die if $n < 1;
   if( $n > $#$self ) {
      my $start = $#$self + 1;
      $#$self = $n; # pre-allocate for efficiency
      for my $nn ( $start .. $n ) {
         my ($a, $b) = (1, 2);
         $_ = $self->[ $nn - $_ ] for $a, $b;
         $_ = $self->[ $nn - $_ ] for $a, $b;
         $self->[$nn] = $a + $b;
      }
   }
   $self->[$n];
}

package main;

tie my (@q), "Hofstadter";

print "@q[1..10]\n";
print $q[1000], "\n";

my $count = 0;
for my $n ( 2 .. 100_000 ) {
   $count++ if $q[$n] < $q[$n - 1];
}
print "Extra credit: $count\n";
