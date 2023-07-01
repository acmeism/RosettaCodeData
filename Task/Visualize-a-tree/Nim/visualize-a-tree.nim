import strutils

type
  Node[T] = ref object
    data: T
    left, right: Node[T]

proc n[T](data: T; left, right: Node[T] = nil): Node[T] =
  Node[T](data: data, left: left, right: right)

proc indent[T](n: Node[T]): seq[string] =
  if n == nil: return @["-- (null)"]

  result = @["--" & $n.data]

  for a in indent n.left: result.add "  |" & a

  let r = indent n.right
  result.add "  `" & r[0]
  for a in r[1..r.high]: result.add "   " & a

let tree = 1.n(2.n(4.n(7.n),5.n),3.n(6.n(8.n,9.n)))

echo tree.indent.join("\n")
