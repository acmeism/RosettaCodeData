sub search (@a, $x --> Int) {
    binary_search { $x cmp @a[$^i] }, 0, @a.end
}
