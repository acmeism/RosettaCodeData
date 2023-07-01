import os, strformat, strutils

type
  Tree = int
  Trees = object
    list: seq[Tree]
    offsets: array[32, int]


func isOdd(n: int): bool = (n and 1) != 0


func append(trees: var Trees; tree: Tree) =
  trees.list.add(1 or tree shl 1)


proc show(tree: Tree; n: int) =
  var tree = tree
  var n = n
  while n > 0:
    dec n
    stdout.write if tree.isOdd: '(' else: ')'
    tree = tree shr 1
  stdout.write '\n'


proc print(trees: Trees; n: int) =
  for i in trees.offsets[n]..<trees.offsets[n + 1]:
    trees.list[i].show(n * 2)


#[ Assemble tree from subtrees
	 n:   length of tree we want to make
	 t:   assembled parts so far
	 sl:  length of subtree we are looking at
	 pos: offset of subtree we are looking at
	 rem: remaining length to be put together
]#

func assemble(trees: var Trees; n: int; t: Tree; sl, pos, rem: int) =

  if rem == 0:
    trees.append(t)
    return

  var p = pos
  var s = sl

  if s > rem:
    s = rem
    p = trees.offsets[s]
  elif p >= trees.offsets[s + 1]:
    # Used up sl-trees, try smaller ones.
    dec s
    if s == 0: return
    p = trees.offsets[s]

  trees.assemble(n, t shl ( 2 * s) or trees.list[p], s, p, rem - s)
  trees.assemble(n, t, s, p + 1, rem)


func make(trees: var Trees; n: int) =
  if trees.offsets[n + 1] != 0: return
  if n > 0: trees.make(n - 1)
  trees.assemble(n, 0, n - 1, trees.offsets[n - 1], n - 1)
  trees.offsets[n + 1] = trees.list.len


when isMainModule:

  if paramCount() != 1:
    raise newException(ValueError, "there must be exactly one command line argument")
  let n = try:
            paramStr(1).parseInt()
          except ValueError:
            raise newException(ValueError, "argument is not a valid number")
  # Insure "n" is limited to 12 to avoid overflowing default stack.
  if n notin 1..12:
    raise newException(ValueError, "argument must be between 1 and 12")

  # Init 1-tree.
  var trees: Trees
  trees.offsets[1] = 1
  trees.append(0)

  trees.make(n)
  echo &"Number of {n}-trees: {trees.offsets[n + 1] - trees.offsets[n]}"
  trees.print(n)
