my @board;

my $I = 8;
my $J = 8;
my $F = $I*$J > 99 ?? "%3d" !! "%2d";

# Choose starting position - may be passed in on command line; if
# not, choose random square.
my ($i, $j);

if my $sq = shift @*ARGS {
  die "$*PROGRAM_NAME: illegal start square '$sq'\n" unless ($i, $j) = from_algebraic($sq);
}
else {
  ($i, $j) = (^$I).pick, (^$J).pick;
}

# Move sequence
my @moves = ();

for 1 .. $I * $J -> $move {
  # Record current move
  push @moves, to_algebraic($i,$j);
  # @board[$i] //= [];	 # (uncomment if autoviv is broken)
  @board[$i][$j] = $move;

  # Find move with the smallest degree
  my @min = (9);
  for possible_moves($i,$j) -> @target {
      my ($ni, $nj) = @target;
      my $next = possible_moves($ni,$nj);
      @min = $next, $ni, $nj if $next < @min[0];
  }

  # And make it
  ($i, $j) = @min[1,2];
}

# Print the move list
for @moves.kv -> $i, $m {
    print ',', $i %% 16 ?? "\n" !! " " if $i;
    print $m;
}
say "\n";

# And the board, with move numbers
for ^$I -> $i {
  for ^$J -> $j {
    # Assumes (1) ANSI sequences work, and (2) output
    # is light text on a dark background.
    print "\e[7m" if $i % 2 == $j % 2;
    printf $F, @board[$i][$j];
    print "\e[0m";
  }
  print "\n";
}

# Find the list of positions the knight can move to from the given square
sub possible_moves($i,$j) {
  grep -> [$ni, $nj] { $ni ~~ ^$I and $nj ~~ ^$J and !@board[$ni][$nj] },
    [$i-2,$j-1], [$i-2,$j+1], [$i-1,$j-2], [$i-1,$j+2],
    [$i+1,$j-2], [$i+1,$j+2], [$i+2,$j-1], [$i+2,$j+1];
}

# Return the algebraic name of the square identified by the coordinates
# i=rank, 0=black's home row; j=file, 0=white's queen's rook
sub to_algebraic($i,$j) {
    chr(ord('a') + $j) ~ ($I - $i);
}

# Return the coordinates matching the given algebraic name
sub from_algebraic($square where /^ (<[a..z]>) (\d+) $/) {
   $I - $1, ord(~$0) - ord('a');
}
