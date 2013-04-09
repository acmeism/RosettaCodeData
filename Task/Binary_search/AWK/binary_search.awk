function binary_search(array, value, left, right,       middle) {
    if (right < left) return 0
    middle = int((right + left) / 2)
    if (value == array[middle]) return 1
    if (value <  array[middle])
        return binary_search(array, value, left, middle - 1)
    return binary_search(array, value, middle + 1, right)
}
