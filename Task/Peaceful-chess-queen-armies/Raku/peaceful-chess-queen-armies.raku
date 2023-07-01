# recursively place the next queen
sub place ($board, $n, $m, $empty-square) {
    my $cnt;
    state (%seen,$attack);
    state $solution = False;

    # logic of regex: queen ( ... paths between queens containing only empty squares ... ) queen of other color
    once {
      my %Q = 'WBBW'.comb; # return the queen of alternate color
      my $re =
        '(<[WB]>)' ~                # 1st queen
        '[' ~
          join(' |',
            qq/<[$empty-square]>*/,
            map {
              qq/ . ** {$_}[<[$empty-square]> . ** {$_}]*/
            }, $n-1, $n, $n+1
          ) ~
        ']' ~
        '<{%Q{$0}}>';               # 2nd queen
      $attack = "rx/$re/".EVAL;
    }

    # return first result found (omit this line to get last result found)
    return $solution if $solution;

    # bail out if seen this configuration previously, or attack detected
    return if %seen{$board}++ or $board ~~ $attack;

    # success if queen count is m×2, set state variable and return from recursion
    $solution = $board and return if $m * 2 == my $queens = $board.comb.Bag{<W B>}.sum;

    # place the next queen (alternating colors each time)
    place( $board.subst( /<[◦•]>/, {<W B>[$queens % 2]}, :nth($cnt) ), $n, $m, $empty-square )
        while $board ~~ m:nth(++$cnt)/<[◦•]>/;

    return $solution
}

my ($m, $n) = @*ARGS == 2 ?? @*ARGS !! (4, 5);
my $empty-square = '◦•';
my $board = ($empty-square x $n**2).comb.rotor($n)>>.join[^$n].join: "\n";

my $solution = place $board, $n, $m, $empty-square;

say $solution
    ?? "Solution to $m $n\n\n{S:g/(\N)/$0 / with $solution}"
    !! "No solution to $m $n";
