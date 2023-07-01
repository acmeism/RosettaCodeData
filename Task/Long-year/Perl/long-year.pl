use strict;
use warnings;
use DateTime;

for my $century (19 .. 21) {
  for my $year ($century*100 .. ++$century*100 - 1) {
    print "$year " if DateTime->new(year => $year, month => 12, day => 28)->week_number > 52
  }
  print "\n";
}
