sub gnome_sort (@a) {
    my ($i, $j) = 1, 2;
    while $i < @a {
        if @a[$i - 1] <= @a[$i] {
            ($i, $j) = $j, $j + 1;
        }
        else {
            (@a[$i - 1], @a[$i]) = @a[$i], @a[$i - 1];
            $i--;
            ($i, $j) = $j, $j + 1 if $i == 0;
        }
    }
}

my @n = (1..10).roll(20);
say @n.&gnome_sort ~~ @n.sort ?? 'ok' !! 'not ok';
