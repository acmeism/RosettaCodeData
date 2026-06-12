use strict;
use warnings;
use List::Util qw( none );

local $_ = <<END;
.............XXXX.............
.............X..X.............
.............X..X.............
..........XXXX..XXXX..........
..........X........X..........
..........X........X..........
..........XXXX..XXXX..........
.............X..X.............
.............X..X.............
.............XXXX.............
END
$_ = tr/X/ /r . $_ . tr/X/ /r; # expand to 30x30
tr/./ /; # and convert dots to spaces

my @moves;
my %used;
my $count = 0;
while( 1 )
  {
#	print s/\A(?: +\n)*|(?:^ +\n)*\z//gmr, "count $count\n"; # uncomment for each step
  tr/O/X/;
  my @try; # find valid moves
  for my $i ( 0, 29 .. 31 )
    {
    my $gap = qr/.{$i}/s;
    while( / (?=$gap(X)$gap(X)$gap(X)$gap(X))/g ) # add to top
      {
      my $cand = join ' ', map $-[$_], 0 .. 4;
      none { $used{$_} } $cand =~ /(?=\b(\d+ \d+)\b)/g and push @try, $cand;
      }
    while( /X(?=$gap(.)$gap(.)$gap(.)$gap(.))/g ) # add inside/bottom downward
      {
      "$1$2$3$4" =~ tr/X// == 3 or next;
      my $cand = join ' ', map $-[$_], 0 .. 4;
      none { $used{$_} } $cand =~ /(?=\b(\d+ \d+)\b)/g and push @try, $cand;
      }
    }
  @try ? $count++ : last;
  my $pick = $try[rand @try]; #pick one valid move
  push @moves, $pick;
  for my $pos (split ' ', $pick)
    {
    substr $_, $pos, 1, 'O';
    }
  $used{$1} = 1 while $pick =~ /(?=\b(\d+ \d+)\b)/g;
  }
print join(' ', map s/ .* /->/r =~ s!\d+! ($& % 31).','.int $& / 31 !ger, @moves)
  =~ s/.{60}\K /\n/gr, "\n";
tr/O/X/;
print $_, "move count: $count\n";
