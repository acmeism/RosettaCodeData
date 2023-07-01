def orderedSort(Collection table, column = 0, reverse = false, ordering = {x, y -> x <=> y } as Comparator) {
    table.sort(false) { x, y -> (reverse ? -1 : 1) * ordering.compare(x[column], y[column])}
}
