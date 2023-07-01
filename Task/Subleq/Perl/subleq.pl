#!/usr/bin/env perl
use strict;
use warnings;
my $file = shift;
my @memory = ();
open (my $fh, $file);
while (<$fh>) {
  chomp;
  push @memory, split;
}
close($fh);
my $ip = 0;
while ($ip >= 0 && $ip < @memory) {
  my ($a, $b, $c) = @memory[$ip,$ip+1,$ip+2];
 $ip += 3;
 if ($a < 0) {
    $memory[$b] = ord(getc);
 } elsif ($b < 0) {
    print chr($memory[$a]);
 } else {
    if (($memory[$b] -= $memory[$a]) <= 0) {
     $ip = $c;
   }
 }
}
