List do(
    insertionSortInPlace := method(
        # In fact, we could've done slice(1, size - 1) foreach(...)
        # but creating a new list in memory can only make it worse.
        foreach(idx, key,
            newidx := slice(0, idx) map(x, x > key) indexOf(true)
            if(newidx, insertAt(removeAt(idx), newidx))
        )
    self)
)

lst := list(7, 6, 5, 9, 8, 4, 3, 1, 2, 0)
lst insertionSortInPlace println # ==> list(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
