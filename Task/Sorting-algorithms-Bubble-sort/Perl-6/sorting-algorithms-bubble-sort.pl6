sub bubble_sort (@a is rw) {
    for ^@a -> $i {
        for $i ^..^ @a -> $j {
            @a[$j] < @a[$i] and @a[$i, $j] = @a[$j, $i];
        }
    }
}
