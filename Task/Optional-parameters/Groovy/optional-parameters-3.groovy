Collection.metaClass.orderedSort = { params ->
    def column = params?.column ?: 0
    def reverse = params?.reverse ?: false
    def ordering = params?.ordering ?: {x, y -> x <=> y } as Comparator

    table.sort(false) { x, y -> (reverse ? -1 : 1) * ordering.compare(x[column], y[column])}
}
