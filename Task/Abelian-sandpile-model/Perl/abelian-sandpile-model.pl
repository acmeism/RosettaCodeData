use strict;
use warnings;
use feature 'bitwise';

my ($high, $wide) = split ' ', qx(stty size);
my $mask = "\0" x $wide . ("\0" . "\177" x ($wide - 2) . "\0") x ($high - 5) .
  "\0" x $wide;
my $pile = $mask =~ s/\177/ rand() < 0.02 ? chr 64 + rand 20 : "\0" /ger;

for (1 .. 1e6)
  {
  print "\e[H", $pile =~ tr/\0-\177/ 1-~/r, "\n$_";
  my $add = $pile =~ tr/\1-\177/\0\0\0\200/r; # set high bit for >=4
  $add =~ /\200/ or last;
  $pile =~ tr/\4-\177/\0-\173/; # subtract 4 if >=4
  for ("\0$add", "\0" x $wide . $add, substr($add, 1), substr $add, $wide)
    {
    $pile |.= $_;
    $pile =~ tr/\200-\377/\1-\176/; # add one to each neighbor of >=4
    $pile &.= $mask;
    }
  select undef, undef, undef, 0.1; # comment out for full speed
  }
