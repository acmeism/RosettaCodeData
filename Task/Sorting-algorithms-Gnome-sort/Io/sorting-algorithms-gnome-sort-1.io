List do(
    gnomeSortInPlace := method(
        idx := 1
        while(idx <= size,
            if(idx == 0 or at(idx) > at(idx - 1)) then(
                idx = idx + 1
            ) else(
                swapIndices(idx, idx - 1)
                idx = idx - 1
            )
        )
    self)
)

lst := list(5, -1, -4, 2, 9)
lst gnomeSortInPlace println # ==> list(-4, -1, 2, 5, 9)
