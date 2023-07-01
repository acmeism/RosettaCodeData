use strict;
use warnings;
use feature 'bitwise';

print "lcs is ", lcs('thisisatest', 'testing123testing'), "\n";

sub lcs
  {
  my ($c, $d) = @_;
  for my $len ( reverse 1 .. length($c &. $d) )
    {
    "$c\n$d" =~ join '.*', ('(.)') x $len, "\n", map "\\$_", 1 .. $len and
      return join '', @{^CAPTURE};
    }
  return '';
  }
