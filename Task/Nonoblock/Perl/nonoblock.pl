use strict;
use warnings;

while( <DATA> )
  {
  print "\n$_", tr/\n/=/cr;
  my ($cells, @blocks) = split;
  my $letter = 'A';
  $_ = join '.', map { $letter++ x $_ } @blocks;
  $cells < length and print("no solution\n"), next;
  $_ .= '.' x ($cells - length) . "\n";
  1 while print, s/^(\.*)\b(.*?)\b(\w+)\.\B/$2$1.$3/;
  }

__DATA__
5 2 1
5
10 8
15 2 3 2 3
5 2 3
