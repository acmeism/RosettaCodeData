type

  Tree = seq[Node]

  Node = object
    sub: string   # a substring of the input string.
    ch: seq[int]  # list of child nodes.


proc addSuffix(t: var Tree; suf: string) =
  var n, i = 0
  while i < suf.len:
    let b = suf[i]
    let ch = t[n].ch
    var x2, n2: int
    while true:
      if x2 == ch.len:
        # No matching child, remainder of "suf" becomes new node.
        n2 = t.len
        t.add Node(sub: suf[i..^1])
        t[n].ch.add n2
        return
      n2 = ch[x2]
      if t[n2].sub[0] == b: break
      inc x2

    # Find prefix of remaining suffix in common with child.
    let sub2 = t[n2].sub
    var j = 0
    while j < sub2.len:
      if suf[i+j] != sub2[j]:
        # Split "sub2".
        let n3 = n2
        # New node for the part in common.
        n2 = t.len
        t.add Node(sub: sub2[0..<j], ch: @[n3])
        t[n3].sub = sub2[j..^1]   # Old node loses the part in common.
        t[n].ch[x2] = n2
        break   # Continue down the tree.
      inc j
    inc i, j  # Advance past part in common.
    n = n2    # Continue down the tree.


func newTree(s: string): Tree =
  result.add Node()     # root node.
  for i in 0..s.high:
    result.addSuffix s[i..^1]


proc vis(t: Tree) =
  if t.len == 0:
    echo "<empty>"
    return

  proc f(n: int; pre: string) =
    let children = t[n].ch
    if children.len == 0:
      echo "╴", t[n].sub
      return
    echo "┐", t[n].sub
    for i in 0..<children.high:
      stdout.write pre, "├─"
      f(children[i], pre & "│ ")
    stdout.write pre, "└─"
    f(children[^1], pre & "  ")

  f(0, "")


newTree("banana$").vis()
