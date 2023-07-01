iterator r2cf*(n1, n2: int): int =
  var (n1, n2) = (n1, n2)
  while n2 != 0:
    yield n1 div n2
    n1 = n1 mod n2
    swap n1, n2

#———————————————————————————————————————————————————————————————————————————————————————————————————

when isMainModule:

  from sequtils import toSeq

  for pair in [(1, 2), (3, 1), (23, 8), (13, 11), (22, 7), (-151, 77)]:
    echo pair, " -> ", toSeq(r2cf(pair[0], pair[1]))

  echo ""
  for pair in [(14142, 10000), (141421, 100000), (1414214, 1000000), (14142136, 10000000)]:
    echo pair, " -> ", toSeq(r2cf(pair[0], pair[1]))

  echo ""
  for pair in [(31,10), (314,100), (3142,1000), (31428,10000), (314285,100000),
              (3142857,1000000), (31428571,10000000), (314285714,100000000)]:
    echo pair, " -> ", toSeq(r2cf(pair[0], pair[1]))
