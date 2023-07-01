iterator inplacePermutations[T](xs: var seq[T]): var seq[T] =
    assert xs.len <= 24, "permutation of array longer than 24 is not supported"

    let n = xs.len - 1
    var
      c: array[24, int8]
      i: int = 0

    for i in 0 .. n: c[i] = int8(i+1)

    while true:
      yield xs
      if i >= n: break

      c[i] -= 1
      let j = if (i and 1) == 1: 0 else: int(c[i])
      swap(xs[i+1], xs[j])

      i = 0
      while c[i] == 0:
        let t = i+1
        c[i] = int8(t)
        i = t
