no strict;
@s = 1, 2, 2, 3, 4, 4, 5;
loop ($i = 0; $i < 7; $i += 1) {
    $curr = @s[$i];
    if $i > 1 and $curr == $prev {
        say $i;
    }
    $prev = $curr;
}
