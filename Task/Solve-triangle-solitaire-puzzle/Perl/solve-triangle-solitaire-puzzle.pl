@start = qw<
        0
       1 1
      1 1 1
     1 1 1 1
    1 1 1 1 1
>;

@moves = (
    [ 0, 1, 3], [ 0, 2, 5], [ 1, 3, 6],
    [ 1, 4, 8], [ 2, 4, 7], [ 2, 5, 9],
    [ 3, 4, 5], [ 3, 6,10], [ 3, 7,12],
    [ 4, 7,11], [ 4, 8,13], [ 5, 8,12],
    [ 5, 9,14], [ 6, 7, 8], [ 7, 8, 9],
    [10,11,12], [11,12,13], [12,13,14]
);

$format .= (" " x (5-$_)) . ("%d " x $_) . "\n" for 1..5;

sub solve {
    my ($move, $turns, @board) = @_;
    $turns = 1 unless $turns;
    return "\nSolved" if $turns + 1 == @board;
    return undef if $board[$$move[1]] == 0;
    my $valid = do  {
        if ($board[$$move[0]] == 0) {
            return undef if $board[$$move[2]] == 0;
            "\nmove $$move[2] to $$move[0]\n";
        } else {
            return undef if $board[$$move[2]] == 1;
            "\nmove $$move[0] to $$move[2]\n";
        }
    };

    my $new_result;
    my @new_layout = @board;
    @new_layout[$_] = 1 - @new_layout[$_] for @$move;
    for $this_move (@moves) {
        $new_result = solve(\@$this_move, $turns + 1, @new_layout);
        last if $new_result
    }
    $new_result ? "$valid\n" . sprintf($format, @new_layout) . $new_result : $new_result}

$result = "Starting with\n\n" . sprintf($format, @start), "\n";

for $this_move (@moves) {
    $result .= solve(\@$this_move, 1, @start);
    last if $result
}

print $result ? $result : "No solution found";
