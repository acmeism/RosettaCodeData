# 20201028 Raku programming solution

my \F = [ <1 -1 1 0 1 1 2 1>,  <0 1 1 -1 1 0 2 0>,   <1 0 1 1 1 2 2 1>,
          <1 0 1 1 2 -1 2 0>,  <1 -2 1 -1 1 0 2 -1>, <0 1 1 1 1 2 2 1>,
          <1 -1 1 0 1 1 2 -1>, <1 -1 1 0 2 0 2 1> ];

my \I = [ <0 1 0 2 0 3 0 4>, <1 0 2 0 3 0 4 0> ];

my \L = [ <1 0 1 1 1 2 1 3>,  <1 0 2 0 3 0 3 1>,   <0 1 0 2 0 3 1 3>,
          <0 1 1 0 2 0 3 0>,  <0 1 1 1 2 1 3 1>,   <0 1 0 2 0 3 1 0>,
          <1 0 2 0 3 -1 3 0>, <1 -3 1 -2 1 -1 1 0> ];

my \N = [ <0 1 1 -2 1 -1 1 0>, <1 0 1 1 2 1 3 1>,   <0 1 0 2 1 -1 1 0>,
          <1 0 2 0 2 1 3 1>,   <0 1 1 1 1 2 1 3>,   <1 0 2 -1 2 0 3 -1>,
          <0 1 0 2 1 2 1 3>,   <1 -1 1 0 2 -1 3 -1> ];

my \P = [ <0 1 1 0 1 1 2 1>,  <0 1 0 2 1 0 1 1>, <1 0 1 1 2 0 2 1>,
          <0 1 1 -1 1 0 1 1>, <0 1 1 0 1 1 1 2>, <1 -1 1 0 2 -1 2 0>,
          <0 1 0 2 1 1 1 2>,  <0 1 1 0 1 1 2 0> ];

my \T = [ <0 1 0 2 1 1 2 1>,  <1 -2 1 -1 1 0 2 0>,
          <1 0 2 -1 2 0 2 1>, <1 0 1 1 1 2 2 0> ];

my \U = [ <0 1 0 2 1 0 1 2>, <0 1 1 1 2 0 2 1>,
          <0 2 1 0 1 1 1 2>, <0 1 1 0 2 0 2 1> ];

my \V = [ <1 0 2 0 2 1 2 2>,   <0 1 0 2 1 0 2 0>,
          <1 0 2 -2 2 -1 2 0>, <0 1 0 2 1 2 2 2>  ];

my \W = [ <1 0 1 1 2 1 2 2>, <1 -1 1 0 2 -2 2 -1>,
          <0 1 1 1 1 2 2 2>, <0 1 1 -1 1 0 2 -1>  ];

my \X = [ <1 -1 1 0 1 1 2 0> , ]; # self-ref: reddit.com/r/rakulang/comments/jpys5p/gbi71jt/

my \Y = [ <1 -2 1 -1 1 0 1 1>, <1 -1 1 0 2 0 3 0>, <0 1 0 2 0 3 1 1>,
          <1 0 2 0 2 1 3 0>,   <0 1 0 2 0 3 1 2>,  <1 0 1 1 2 0 3 0>,
          <1 -1 1 0 1 1 1 2>,  <1 0 2 -1 2 0 3 0> ];

my \Z = [ <0 1 1 0 2 -1 2 0>, <1 0 1 1 1 2 2 2>,
          <0 1 1 1 2 1 2 2>,  <1 -2 1 -1 1 0 2 -2> ];

our @shapes =  F, I, L, N, P, T, U, V, W, X, Y, Z ;

my @symbols = "FILNPTUVWXYZ-".comb;
my %symbols = @symbols.pairs;
my $nRows = my $nCols = 8; my $blank = 12;
my @grid = [ [-1 xx $nCols ] xx $nRows ];
my @placed;

sub shuffleShapes {
   my @rand = (0 ..^+@shapes).pick(*);
   for (0 ..^+@shapes) -> \i {
      (@shapes[i],  @shapes[@rand[i]])  = (@shapes[@rand[i]],  @shapes[i]);
      (@symbols[i], @symbols[@rand[i]]) = (@symbols[@rand[i]], @symbols[i])
   }
}

sub solve($pos,$numPlaced)  {
   return True if $numPlaced == +@shapes;

   my \row = $pos div $nCols;
   my \col = $pos mod $nCols;

   return solve($pos + 1, $numPlaced) if @grid[row;col] != -1;

   for ^+@shapes -> \i {
      if !@placed[i] {
         for @shapes[i] -> @orientation {
            for @orientation -> @o {
               next if !tryPlaceOrientation(@o, row, col, i);
               @placed[i] = True;
               return True if solve($pos + 1, $numPlaced + 1);
               removeOrientation(@o, row, col);
               @placed[i] = False;
            }
         }
      }
   }
   return False
}

sub tryPlaceOrientation (@o, $r, $c, $shapeIndex) {

   loop (my $i = 0; $i < +@o; $i += 2) {
      my \x = $c + @o[$i + 1];
      my \y = $r + @o[$i];
      return False if
         (x < 0 or x ≥ $nCols or y < 0 or y ≥ $nRows or @grid[y;x] != -1)
   }

   @grid[$r;$c] = $shapeIndex;
   loop ($i = 0; $i < +@o; $i += 2) {
      @grid[ $r + @o[$i] ; $c + @o[$i + 1] ] = $shapeIndex;
   }
   return True
}

sub removeOrientation(@o, $r, $c) {
   @grid[$r;$c] = -1;
   loop (my $i = 0; $i < +@o; $i += 2) {
      @grid[ $r + @o[$i] ; $c + @o[$i + 1] ] = -1;
   }
}

sub PrintResult {
   my $output;
   for @grid[*] -> @line {
      $output ~= "%symbols{$_}  " for @line;
      $output ~= "\n"
   }
   if my \Embedded_Marketing_Mode = True {
      $output .= subst('-', $_.chr) for < 0x24c7 0x24b6 0x24c0 0x24ca >
   }
   say $output
}

#shuffleShapes(); # xkcd.com/221

for ^4 {
   loop {
      if @grid[my \R = (^$nRows).roll;my \C = (^$nCols).roll] != $blank
         { @grid[R;C] = $blank and last }
   }
}

PrintResult() if solve 0,0
