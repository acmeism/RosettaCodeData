use strict;
use warnings;
use ntheory 'todigitstring';

sub pb { my $s = todigitstring(shift,shift); return $s eq join '', reverse split '', $s }

pb($_,2) and pb($_,4) and pb($_,16) and print "$_ " for 1..25000;
