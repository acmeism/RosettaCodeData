subset Pos960 of Int where { $_ ~~ ^960 };
sub chess960(Pos960 $position = (^960).pick) {

  # We remember the remainder used to place first bishop in order to place the
  # second
  my $b1;

  # And likewise remember the chosen combination for knights between those
  # placements
  my @n;

  # Piece symbols and positioning rules in order.  Start with the position
  # number. At each step, divide by the divisor; the quotient becomes the
  # dividend for the next step.  Feed the remainder into the specified code block
  # to get a space number N, then place the piece in the Nth empty space left in
  # the array.
  my @rules = (
    #divisor, mapping function,                      piece
    ( 4,      { $b1 = $_; 2 * $_ + 1 },              '♝'  ),
    ( 4,      { 2 * $_ - ($_ > $b1 ?? 1 !! 0) },     '♝'  ),
    ( 6,      { $_ },                                '♛'  ),
    (10,      { @n = combinations(5,2)[$_]; @n[0] }, '♞'  ),
    ( 1,      { @n[1]-1 },                           '♞'  ),
    ( 1,      { 0 },                                 '♜'  ),
    ( 1,      { 0 },                                 '♚'  ),
    ( 1,      { 0 },                                 '♜'  )

  );

  # Initial array, using '-' to represent empty spaces
  my @array = «-» xx 8;

  # Working value that starts as the position number but is divided by the
  # divisor at each placement step.
  my $p = $position;

  # Loop over the placement rules
  for @rules -> ($divisor, $block, $piece) {

    # get remainder when divided by divisor
    (my $remainder, $p) = $p.polymod($divisor);

    # apply mapping function
    my $space = $block($remainder);

    # find index of the $space'th element of the array that's still empty
    my $index = @array.kv.grep(-> $i,$v { $v eq '-' })[$space][0];

    # and place the piece
    @array[$index] = $piece;
  }
  return @array;
}

# demo code
say chess960(518); #standard optning position
say chess960; # (it happened to pick #300)
