type
  Comparable = concept x, y
    (x < y) is bool

  Stack[T] = concept s, var v
    s.pop() is T
    v.push(T)

    s.len is Ordinal

    for value in s:
      value is T
