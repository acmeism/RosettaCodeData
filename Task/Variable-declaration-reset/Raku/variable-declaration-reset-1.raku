my @s = 1, 2, 2, 3, 4, 4, 5;
loop (my $i = 0; $i < 7; $i += 1) {
    my $curr = @s[$i];
    my $prev;
    if $i > 1 and $curr == $prev {
        say $i;
    }
    $prev = $curr;
}
