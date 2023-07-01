proc product[T](a: varargs[seq[T]]): seq[seq[T]] =
  ## Return the product of several sets (sequences).

  if a.len == 1:
    for x in a[0]:
      result.add(@[x])
  else:
    for x in a[0]:
      for s in product(a[1..^1]):
        result.add(x & s)

#———————————————————————————————————————————————————————————————————————————————————————————————————

when isMainModule:

  import strformat

  let
    a = @[1, 2]
    b = @[3, 4]
    c = @[5, 6]
  echo &"{a} x {b} x {c} = {product(a, b, c)}"
