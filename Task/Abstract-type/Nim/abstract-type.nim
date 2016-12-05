type
  Comparable = generic x, y
    (x < y) is bool

  Container[T] = generic c
    c.len is ordinal
    items(c) is iterator
    for value in c:
      type(value) is T
