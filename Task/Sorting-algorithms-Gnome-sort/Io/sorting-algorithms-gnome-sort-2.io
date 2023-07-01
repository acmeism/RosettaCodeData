List do(
    gnomeSortInPlace := method(
        idx1 := 1
        idx2 := 2

        while(idx1 <= size,
            if(idx1 == 0 or at(idx1) > at(idx1 - 1)) then(
                idx1 = idx2
                idx2 = idx2 + 1
            ) else(
                swapIndices(idx1, idx1 - 1)
                idx1 = idx1 - 1
            )
        )
    self)
)

lst := list(5, -1, -4, 2, 9)
lst gnomeSortInPlace println # ==> list(-4, -1, 2, 5, 9)
