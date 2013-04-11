List do(
  insertionSortInPlace := method(
    for(j, 1, size - 1,
      key := at(j)
      i := j - 1

      while(i >= 0 and at(i) > key,
        atPut(i + 1, at(i))
        i = i - 1
      )
      atPut(i + 1, key)
    )
  )
)

lst := list(7, 6, 5, 9, 8, 4, 3, 1, 2, 0)
lst insertionSortInPlace println # ==> list(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
