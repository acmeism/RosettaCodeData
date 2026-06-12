use strict;
use warnings;
use feature <say switch>;
no warnings 'experimental::smartmatch';

use constant CW => '%-11s'; # set column width

#            (     scale  -->    seconds   )  (minutes) (     scale -->  hours )
my @shaved = map { 60 * $_ } 1/60, 1/12, 1/2, 1, 5, 30, map { 60 * $_ } 1, 6, 24;
my @columns = (' 1 Second', ' 5 Seconds', '30 Seconds', ' 1 Minute', ' 5 Minutes', '30 Minutes', ' 1 Hour', ' 6 Hours', ' 1 Day');
my $diy     = 365.25;
my @freq    = ((map { $diy * $_ } 50, 5, 1, 1/7), 12, 1);
my $week    = 7 * (my $day = 24 * (my $hour = 60 * (my $minute = 60)));
my $month   = (my $year = $day * $diy) / 12;
my $mult    = 5;

sub fmt { my($t, $interval) = @_; sprintf CW.' ', (sprintf '%2d', int $t) . ' ' . $interval . ($t > 1 and 's') }

say ' ' x 34 . 'How Often You Do the Task';                                              say '';
say sprintf  CW.' | '.(' '.CW)x6, <Shaved-off 50/Day 5/Day Daily Weekly Monthly Yearly>; say '';

for my $y (0..8) {
   my $row = sprintf CW.' | ', $columns[$y];
   for my $x (0..5) {
      given ($freq[$x] * $shaved[$y] * $mult) {
         when ($_ < $minute) { $row .= fmt $_,         "Second" }
         when ($_ < $hour  ) { $row .= fmt $_/$minute, "Minute" }
         when ($_ < $day   ) { $row .= fmt $_/$hour,   "Hour"   }
         when ($_ < 14*$day) { $row .= fmt $_/$day,    "Day"    }
         when ($_ < 9*$week) { $row .= fmt $_/$week,   "Week"   }
         when ($_ < $year  ) { $row .= fmt $_/$month,  "Month"  }
         default             { $row .= ' ' . sprintf CW, ' '    }
      }
   }
   say $row;
}
