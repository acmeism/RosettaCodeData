function binary_search(array, value, left, right,       middle) {
    while (left <= right) {
        middle = int((right + left) / 2)
        if (value == array[middle]) return 1
        if (value <  array[middle]) right = middle - 1
        else                        left  = middle + 1
    }
    return 0
}
