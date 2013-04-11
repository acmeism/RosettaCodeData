sub gnome_sort (@a is rw) {
    my ($i, $j) = 1, 2;
    while $i < @a {
        if @a[$i - 1] <= @a[$i] {
            ($i, $j) = $j, $j + 1;
        }
        else {
            (@a[$i - 1], @a[$i]) = @a[$i], @a[$i - 1];
            --$i or ($i, $j) = $j, $j + 1;
        }
    }
}
