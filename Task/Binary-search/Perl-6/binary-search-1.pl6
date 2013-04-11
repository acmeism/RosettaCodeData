sub search (@a, Num $x --> Int) {
    binary_search { $x <=> @a[$^i] }, 0, @a.end
}
