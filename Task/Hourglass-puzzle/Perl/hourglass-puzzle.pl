use strict;
use warnings;
use feature 'bitwise';

findinterval( $_, 4, 7 ) for 1 .. 20;

sub findinterval
  {
  my ($want, $hour1, $hour2) = @_;
  local $_ = (('1' |. ' ' x $hour1) x $hour2 | ('2' |. ' ' x $hour2) x $hour1) x $want;
  print /(?=\d).{$want}(?=\d)/
    ? "To get $want minute@{[$want == 1 ? '' : 's'
      ]}, Start at time $-[0] and End at time $+[0]\n"
    : "$want is not possible\n";
  }
