iterator product[T1, T2](a: openArray[T1]; b: openArray[T2]): tuple[a: T1, b: T2] =
  # Yield the element of the cartesian product of "a" and "b".
  # Yield tuples rather than arrays as it allows T1 and T2 to be different.

  for x in a:
    for y in b:
      yield (x, y)

#———————————————————————————————————————————————————————————————————————————————————————————————————

when isMainModule:

  from seqUtils import toSeq
  import strformat
  from strutils import addSep

  #-------------------------------------------------------------------------------------------------

  proc `$`[T1, T2](t: tuple[a: T1, b: T2]): string =
    ## Overloading of `$` to display a tuple without the field names.
    &"({t.a}, {t.b})"

  proc `$$`[T](s: seq[T]): string =
    ## New operator to display a sequence using mathematical set notation.
    result = "{"
    for item in s:
      result.addSep(", ", 1)
      result.add($item)
    result.add('}')

#-------------------------------------------------------------------------------------------------

  const Empty = newSeq[int]()   # Empty list of "int".

  for (a, b) in [(@[1, 2], @[3, 4]),
                 (@[3, 4], @[1, 2]),
                 (@[1, 2],  Empty ),
                 ( Empty,  @[1, 2])]:

    echo &"{$$a} x {$$b} = {$$toSeq(product(a, b))}"
