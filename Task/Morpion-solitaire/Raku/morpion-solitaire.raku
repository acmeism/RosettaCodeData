# 20250727 Raku programming solution

my $line-len = 5;           # Length of lines to form
my $disjoint = False;       # Whether lines can connect end-to-end

enum BoardState ( # Board state flags
   BLANK        => 0,
   OCCUPIED     => 1 +< 0,
   DIR_NS       => 1 +< 1,  # North-South direction
   DIR_EW       => 1 +< 2,  # East-West direction
   DIR_NE_SW    => 1 +< 3,  # Northeast-Southwest diagonal
   DIR_NW_SE    => 1 +< 4,  # Northwest-Southeast diagonal
   NEWLY_ADDED  => 1 +< 5,  # Recently added point
   CURRENT      => 1 +< 6,  # Current move
);

my @directions = ( # Direction offsets: [dx, dy, direction_flag]
   [ 0,  1, DIR_NS    ],  # Vertical
   [ 1,  0, DIR_EW    ],  # Horizontal
   [ 1, -1, DIR_NE_SW ],  # NE-SW diagonal
   [ 1,  1, DIR_NW_SE ],  # NW-SE diagonal
);

class MorpionGame {
   has @.board;
   has ( $.width, $.height, $.move-count ) is rw;

   method init-board() {
      $!move-count = 0;
      $!width = $!height = 3 * ($line-len - 1);
      @!board = [[ BLANK xx ^$!width ] xx ^$!height ]; # Initialize empty board

      # Create initial cross pattern
      self.set-region(OCCUPIED,                                 # Vertical bar
         $line-len - 1, 1, 2 * $line-len - 3, $!height - 2);

      self.set-region(OCCUPIED,                               # Horizontal bar
         1, $line-len - 1, $!width - 2, 2 * $line-len - 3);

      self.set-region(BLANK,                      # Clear the inner cross area
         $line-len, 2, 2 * $line-len - 4, $!height - 3);

      self.set-region(BLANK, 2, $line-len, $!width - 3, 2 * $line-len - 4);
   }

   method set-region($value, $x0, $y0, $x1, $y1) {
      for $y0..$y1 X $x0..$x1 -> ($y,$x) { @!board[$y][$x] = $value }
   }

   method expand-board($dw, $dh) {
      my (     $new-width,      $new-height,   $offset-x,   $offset-y ) =
           $!width + ?$dw,  $!height + ?$dh,  ?($dw < 0),  ?($dh < 0);
      my @new-board = [ [ BLANK xx ^$new-width ] xx ^$new-height ];

      for ^$!height X ^$!width -> ($y,$x) { # Copy old board to new position
         @new-board[$y + $offset-y][$x + $offset-x] = @!board[$y][$x];
      }
      @!board = @new-board;
      ( $!width, $!height ) = $new-width, $new-height;
   }

   method show-board() {
      say "Move: $!move-count\n";
      for ^$!height -> $y {
         say [~] gather for ^$!width -> $x {
            take do given my $cell = @!board[$y][$x] {
               when ?($cell +& CURRENT)      { "X " }
               when ?($cell +& NEWLY_ADDED)  { "O " }
               when ?($cell +& OCCUPIED)     { "+ " }
               default                       { ". " }
            }
         }
      }
      say "";
   }

   method test-position($y, $x) {
      return () if @!board[$y][$x] +& OCCUPIED;

      return gather for @directions.kv -> $dir-idx, [$dx, $dy, $dir-flag] {
         for (1 - $line-len)..0 -> $offset {
            my $valid = True;

            # Check if we can form a line starting at this offset
            for ^$line-len -> $k {
               next if $offset + $k == 0; # Skip the position we're testing

               my $xx = $x + $dx * ($offset + $k);
               my $yy = $y + $dy * ($offset + $k);

               if    # Out of bounds
                  $xx < 0 || $xx >= $!width || $yy < 0 || $yy >= $!height   or
                     # No piece at position
                  not (@!board[$yy][$xx] +& OCCUPIED)                       or
                     # Direction already taken
                  @!board[$yy][$xx] +& $dir-flag {
                  $valid = False;
                  last
               }
            }
            if $valid { take { :dir($dir-idx),:offset($offset),:x($x),:y($y) } }
         }
      }
   }

   method add-piece(%move) {
      my ($dx, $dy, $dir-flag) = @directions[ %move<dir> ];

      @!board[%move<y>;%move<x>] +|= (CURRENT +| OCCUPIED); # Mark the new piece

      # Mark the line
      for ^$line-len -> $k {
         my $xx = %move<x> + $dx * ($k + %move<offset>);
         my $yy = %move<y> + $dy * ($k + %move<offset>);

         @!board[$yy][$xx] +|= NEWLY_ADDED;

         if $k >= $disjoint || $k < $line-len - $disjoint {
            @!board[$yy][$xx] +|= $dir-flag;
         }
      }
   }

   method next-move() {
      # Clear previous move markers and find all possible moves
      my @all-moves = ();
      for ^$!height X ^$!width -> ($y,$x) {
         @!board[$y][$x] +&= +^(NEWLY_ADDED +| CURRENT);
         @all-moves.append: self.test-position($y, $x)
      }
      return False unless @all-moves;

      self.add-piece( my %move = @all-moves.pick ); # Pick a random move

      # Check if we need to expand the board
      my $expand-x = %move<x> == $!width -  1 ?? 1 !! %move<x> == 0 ?? -1 !! 0;
      my $expand-y = %move<y> == $!height - 1 ?? 1 !! %move<y> == 0 ?? -1 !! 0;

      if $expand-x || $expand-y { self.expand-board($expand-x, $expand-y) }

      $!move-count++;
      return True;
   }

   method play-auto($max-moves = 1000) {
      self.init-board;

      say "Playing Morpion Solitaire automatically...";
      say "Line length: $line-len";
      say "Disjoint mode: " ~ ($disjoint ?? "enabled" !! "disabled");

      while $!move-count < $max-moves {
         last unless self.next-move;
         self.show-board;
      }

      say "Game finished!";
      self.show-board;
      say "Final score: $!move-count moves";
   }
}

MorpionGame.new.play-auto;
