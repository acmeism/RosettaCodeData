sub selectionSort(@tmp) {
    for ^@tmp -> $i {
        my $min = $i; @tmp[$i, $_] = @tmp[$_, $i] if @tmp[$min] > @tmp[$_] for $i^..^@tmp;
    }
    return @tmp;
}
