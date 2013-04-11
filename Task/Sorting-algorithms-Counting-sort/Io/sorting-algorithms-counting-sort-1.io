List do(
    countingSort := method(min, max,
        count := list() setSize(max - min + 1) mapInPlace(0)
        foreach(x,
            count atPut(x - min, count at(x - min) + 1)
        )

        j := 0
        for(i, min, max,
            while(count at(i - min) > 0,
                atPut(j, i)
                count atPut(i - min, at(i - min) - 1)
                j = j + 1
            )
        )
    self)

    countingSortInPlace := method(
        countingSort(min, max)
    )
)

l := list(2, 3, -4, 5, 1)
l countingSortInPlace println # ==> list(-4, 1, 2, 3, 5)
