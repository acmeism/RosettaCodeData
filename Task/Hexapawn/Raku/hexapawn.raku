# 20250714 Raku programming solution

my (   $black-pawn,   $white-pawn, $empty-square ) =
     " \x[265f]  ", " \x[2659]  ",        "    ";

sub draw-board(@board-data) {
   my (      $bg-black,      $bg-white,  $clear-to-eol ) =
        "\e[48;5;237m", "\e[48;5;245m",  "\e[0m\e[K\n";

   say "\n", |(
      "1 ", $bg-black, @board-data[0;0], $bg-white, @board-data[0;1], $bg-black, @board-data[0;2], $clear-to-eol,
      "2 ", $bg-white, @board-data[1;0], $bg-black, @board-data[1;1], $bg-white, @board-data[1;2], $clear-to-eol,
      "3 ", $bg-black, @board-data[2;0], $bg-white, @board-data[2;1], $bg-black, @board-data[2;2], $clear-to-eol,
      "   A   B   C"
   );
}

sub get-movement-direction($color) {
   my $direction = -1;
   if $color eq $black-pawn {
      $direction = 1;
   } elsif $color ne $white-pawn {
      die "Invalid piece color";
   }
   return $direction;
}

sub get-other-color($color) {
   return do given $color { when $black-pawn { $white-pawn }
                            when $white-pawn { $black-pawn }
                            die "Invalid piece color"        }
}

sub get-allowed-moves(@board-data, $row, $col) {
   return my @allowed-moves if @board-data[$row][$col] eq $empty-square;

   my $color       = @board-data[$row][$col];
   my $other-color = get-other-color($color);
   my $direction   = get-movement-direction($color);

   return @allowed-moves if $row + $direction < 0 || $row + $direction > 2;

   if @board-data[$row + $direction][$col] eq $empty-square {
      @allowed-moves.push("f");
   }
   if $col > 0 && @board-data[$row + $direction][$col - 1] eq $other-color {
      @allowed-moves.push("dl");
   }
   if $col < 2 && @board-data[$row + $direction][$col + 1] eq $other-color {
      @allowed-moves.push("dr");
   }
   return @allowed-moves;
}

sub get-human-move(@board-data, $color) {
   # The direction the pawns may move depends on the colour; assuming that white starts at the bottom.
   my $direction = get-movement-direction($color);
   my @keys = ( my %valid-inputs = (
      <   a3     c3     b1     c2     c1     a1     a2     b3     b2 > Z=>
      [<2 0>, <2 2>, <0 1>, <1 2>, <0 2>, <0 0>, <1 0>, <2 1>, <1 1> ]
   )).keys;

   loop {
      my $piece-posn = prompt "What $color do you want to move? : ";
      unless @keys.grep($piece-posn) {
         say "LOL that's not a valid position! Try again." and next
      }

      my ($row, $col) = |%valid-inputs{$piece-posn};

      if ( my $piece = @board-data[$row][$col] ) eq $empty-square {
         say "What are you trying to pull, there's no piece in that space!";
         next;
      }

      if $piece ne $color {
         say "LOL that's not your piece, try again!" and next
      }

      my @allowed-moves = get-allowed-moves(@board-data, $row, $col);

      if @allowed-moves.elems == 0 {
         say "LOL nice try. That piece has no valid moves." and next
      }

      my $move = @allowed-moves[0];
      if @allowed-moves.elems > 1 {
         my $options = @allowed-moves.join(", ");
         $move = prompt "What move do you want to make [$options]? : ";
         unless @allowed-moves.grep($move) {
            say "LOL that move is not allowed. Try again." and next
         }
      }

      if $move eq "f" {
         @board-data[$row + $direction][$col] = @board-data[$row][$col]
      } elsif $move eq "dl" {
         @board-data[$row + $direction][$col - 1] = @board-data[$row][$col]
      } elsif $move eq "dr" {
         @board-data[$row + $direction][$col + 1] = @board-data[$row][$col]
      }

      @board-data[$row][$col] = $empty-square;
      return @board-data;
   }
}

sub is-game-over(@board-data, $current-color = Nil) {
   # Check if any pawn has reached the opposite side
   return $white-pawn if $white-pawn ∈ @board-data[0];
   return $black-pawn if $black-pawn ∈ @board-data[2];

   my ($white-count, $black-count) = 0, 0;
   my (@black-allowed-moves, @white-allowed-moves);

   for 0..2 X 0..2 -> ($i, $j) {
      my @moves = get-allowed-moves(@board-data, $i, $j);
      if @board-data[$i][$j] eq $white-pawn {
         $white-count++;
         if @moves.elems > 0 { @white-allowed-moves.push([$i, $j, @moves]) }
      } elsif @board-data[$i][$j] eq $black-pawn {
         $black-count++;
         if @moves.elems > 0 { @black-allowed-moves.push([$i, $j, @moves]) }
      }
   }

   # If current player has no moves, other player wins
   if $current-color.defined {
      if $current-color eq $white-pawn && @white-allowed-moves.elems == 0 {
         return $black-pawn;
      }
      if $current-color eq $black-pawn && @black-allowed-moves.elems == 0 {
         return $white-pawn;
      }
   }

   # Check if all pawns of one color are gone
   return $black-pawn if $white-count == 0;
   return $white-pawn if $black-count == 0;

   # Check if either side has no moves (regardless of turn)
   return $black-pawn if @white-allowed-moves.elems == 0;
   return $white-pawn if @black-allowed-moves.elems == 0;
   return "LOL NOPE";
}

sub play-game(&black-move, &white-move) {
   my @board-data = [
      [$black-pawn, $black-pawn, $black-pawn],
      [$empty-square, $empty-square, $empty-square],
      [$white-pawn, $white-pawn, $white-pawn]
   ];
   my ($last-player, $next-player) = $black-pawn, $white-pawn;

   while is-game-over(@board-data, $next-player) eq "LOL NOPE" {
      draw-board(@board-data);
      @board-data = $next-player eq $black-pawn
         ?? black-move(@board-data, $next-player)
         !! white-move(@board-data, $next-player);
      ($last-player, $next-player) = ($next-player, $last-player);
   }
   draw-board(@board-data);
   my $winner = is-game-over(@board-data, $next-player);
   say "Congratulations $winner!";
}

play-game(&get-human-move, &get-human-move);
