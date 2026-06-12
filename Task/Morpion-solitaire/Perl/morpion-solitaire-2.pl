use strict;
use warnings;
use feature 'bitwise';
use List::Util 'none';

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
$_ = tr/X./ /r . tr/./ /r . tr/X./ /r; # expand to 30x30 and spaces

my($count, @moves, %used) = 0;
while( 1 )
  {
  my @try; # valid moves
  for my $i ( 1, 30 .. 32 ) # directions 1 - 30 / 31 | 32 \
    {
    my $combined =           tr/X \n/A\0/r |.
      (substr $_, $i)     =~ tr/X \n/B\0/r |.
      (substr $_, 2 * $i) =~ tr/X \n/D\0/r |.
      (substr $_, 3 * $i) =~ tr/X \n/H\0/r |.
      (substr $_, 4 * $i) =~ tr/X \n/P\0/r;
    while( $combined =~ /[OW\[\]\^]/g ) # exactly four Xs and one space
      {
      my $cand = join ' ', map $-[0] + $_ * $i, 0 .. 4;
      none { $used{$_} } $cand =~ /(?=\b(\d+ \d+)\b)/g and push @try, $cand;
      }
    }
  @try ? $count++ : last;
  my $pick = $try[rand @try]; #pick one valid move
  push @moves, $pick;
  for my $pos (split ' ', $pick)
    {
    substr $_, $pos, 1, 'X';
    }
  @used{ $pick =~ /(?=\b(\d+ \d+)\b)/g } = (1) x 4;
  }
print join(' ', map s/ .* /->/r =~ s!\d+! ($& % 31).','.int $& / 31 !ger,
  @moves) =~ s/.{60}\K /\n/gr, "\n";
print $_, "move count: $count\n";
