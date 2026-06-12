# 20200913 added Raku programming solution

srand 123456;

my @board = [ (1..9).roll xx my \w = 79 ] xx my \h = 22 ;
my \X = $ = w.rand.Int ; my \Y = $ = h.rand.Int;
@board[Y;X] = '@';
my \score = $ = 0;

sub execute (\y,\x) {
   my \i = $ = @board[Y+y;X+x];
   if countSteps(i, x, y) {
      score += i;
      @board[ Y +  y*$_ ; X +  x*$_ ] = ' ' for ^i;
      @board[ Y += y*i  ; X += x*i  ] = '@';
   }
}

sub countSteps(\i, \x, \y) {
   my \tX = $ = X ; my \tY = $ = Y;
   for ^i {
      tX += x; tY += y;
      return False if tX < 0 or tY < 0 or tX ≥ w or tY ≥ h or @board[tY;tX] eq ' '
   }
   return True;
}

sub existsMoves {
   for (-1 .. 1) X (-1 .. 1) -> (\x,\y) {
      next if x == 0 and y == 0;
      next if X+x < 0 or X+x > w or Y+y < 0 or Y+y > h ;
      my \i = @board[Y+y;X+x];
      return True if ( i ne ' ' and countSteps(i, x, y) )
   }
   return False;
}

loop {
   for @board { .join.print ; print "\r\n" } ;
   { say "Game over." and last } unless existsMoves();
   print "Current score : ", score, "\r\n";
   given my $c = $*IN.getc {
      when 'q' { say "So long." and last}
      when 'e' { execute(-1,-1) if X > 0 and Y > 0 } # North-West
      when 'r' { execute(-1, 0) if           Y > 0 } # North
      when 't' { execute(-1, 1) if X < w and Y > 0 } # North-East
      when 'd' { execute( 0,-1) if X > 0           } # West
      when 'g' { execute( 0, 1) if X < w           } # East
      when 'x' { execute( 1,-1) if X > 0 and Y < h } # South-West
      when 'c' { execute( 1, 0) if           Y < h } # South
      when 'v' { execute( 1, 1) if X < w and Y < h } # South-East
   }
}
