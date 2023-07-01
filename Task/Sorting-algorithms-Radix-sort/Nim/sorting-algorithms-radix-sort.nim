func radixSort[T](a: openArray[T]): seq[T] =

  result = @a

  ## Loop for every bit in the integers.
  for shift in countdown(63, 0):
    var tmp = newSeq[T](result.len)   # The array to put the partially sorted array into.
    var j = 0                         # The number of 0s.
    for i in 0..result.high:
      # If there is a 1 in the bit we are testing, the number will be negative.
      let move = result[i] shl shift >= 0
      # If this is the last bit, negative numbers are actually lower.
      let toBeMoved = if shift == 0: not move else: move
      if toBeMoved:
        tmp[j] = result[i]
        inc j
      else:
        # It's a 1, so stick it in the result array for now.
        result[i - j] = result[i]
    # Copy over the 1s from the old array.
    for i in j..tmp.high:
      tmp[i] = result[i - j]
    # And now the tmp array gets switched for another round of sorting.
    result =move(tmp)


when isMainModule:

  const arrays = [@[170, 45, 75, -90, -802, 24, 2, 66],
                  @[-4, 5, -26, 58, -990, 331, 331, 990, -1837, 2028]]

  for a in arrays:
    echo radixSort(a)
