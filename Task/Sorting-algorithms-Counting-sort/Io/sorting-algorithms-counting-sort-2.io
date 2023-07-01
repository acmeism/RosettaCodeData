List do(
    fill := method(x, size,
        /* Resizes list to a given size and fills it with a given value. */
        setSize(size) mapInPlace(x)
    )

    countingSort := method(min, max,
        count := list() fill(0, max - min + 1)
        foreach(x,
            count atPut(x - min, count at(x - min) + 1)
        )

        return count map(i, x, list() fill(i + min, x)) \
            prepend(list()) reduce(xs, x, xs appendSeq(x))
    )

    countingSortInPlace := method(
        copy(countingSort(min, max))
    )
)

l := list(2, 3, -4, 5, 1)
l countingSortInPlace println # ==> list(-4, 1, 2, 3, 5)
