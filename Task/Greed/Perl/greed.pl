use strict;
use warnings;
use feature 'say';

my @board;
my $w = 79;
my $h = 22;
for (1..$h) {
    my @row;
    push @row, int 1 + rand 9 for 1..$w;
    push @board, [@row];
}
my $X = int 0.5 + rand $w;
my $Y = int 0.5 + rand $h;
$board[$Y][$X] = '@';

my $score = 0;

sub execute {
   my($y,$x) = @_;
   my $i = $board[$Y+$y][$X+$x];
   if (countSteps($i, $x, $y)) {
      $score += $i;
      $board[ $Y +  $y*$_ ][ $X +  $x*$_ ] = ' ' for 0..$i;
      $board[ $Y += $y*$i ][ $X += $x*$i ] = '@';
   }
}

sub countSteps {
    my($i, $x, $y) = @_;
    my $tX = $X;
    my $tY = $Y;
    for (0..$i) {
        $tX += $x;
        $tY += $y;
        return 0 if $tX < 0 or $tY < 0 or $tX >= $w or $tY >= $h or $board[$tY][$tX] eq ' '
    }
    return 1
}

sub existsMoves {
   for ([-1,-1], [-1,0], [-1,1], [0,-1], [0,0], [0,1], [1,-1], [1,0], [1,1]) {
      my($x,$y) = @$_;
      next if $x == 0 and $y == 0;
      next if $X+$x < 0 or $X+$x > $w or $Y+$y < 0 or $Y+$y > $h ;
      my $i = $board[$Y+$y][$X+$x];
      return 1 if ( $i ne ' ' and countSteps($i, $x, $y) )
   }
   return 0;
}

while () {
   say join '', @$_ for @board;
   say "Game over." and last unless existsMoves();
   print "Current score : " . $score . "\n";
   my $c = <> ; chomp $c;
   if ($c eq 'q') { say "So long." and last}
   if ($c eq 'e') { execute(-1,-1) if $X >  0 and $Y >  0 } # North-West
   if ($c eq 'r') { execute(-1, 0) if             $Y >  0 } # North
   if ($c eq 't') { execute(-1, 1) if $X < $w and $Y >  0 } # North-East
   if ($c eq 'd') { execute( 0,-1) if $X >  0             } # West
   if ($c eq 'g') { execute( 0, 1) if $X < $w             } # East
   if ($c eq 'x') { execute( 1,-1) if $X >  0 and $Y < $h } # South-West
   if ($c eq 'c') { execute( 1, 0) if             $Y < $h } # South
   if ($c eq 'v') { execute( 1, 1) if $X < $w and $Y < $h } # South-East
}
