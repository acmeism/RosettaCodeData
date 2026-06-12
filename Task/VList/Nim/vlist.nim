type

  VSeg[T] = ref object
    next: VSeg[T]
    elems: seq[T]

  VList[T] = ref object
    base: VSeg[T]
    offset: int


func newVList[T](): VList[T] = new(VList[T])


func `[]`[T](v: VList[T]; k: int): T =
  ## Primary operation 1: locate the kth element.
  if k >= 0:
    var i = k + v.offset
    var sg = v.base
    while not sg.isNil:
      if i < sg.elems.len:
        return sg.elems[i]
      dec i, sg.elems.len
      sg = sg.next
  raise newException(IndexDefect, "index out of range; got " & $k)


func cons[T](v: VList[T]; a: T): VList[T] =
  ## Primary operation 2: add an element to the front of the VList.
  if v.base.isNil:
    return VList[T](base: VSeg[T](elems: @[a]))

  if v.offset == 0:
    let l2 = v.base.elems.len * 2
    var elems = newSeq[T](l2)
    elems[l2 - 1] = a
    return VList[T](base: VSeg[T](next: v.base, elems: move(elems)), offset: l2 - 1)

  dec v.offset
  v.base.elems[v.offset] = a
  result = v


func cdr[T](v: VList[T]): VList[T] =
  ## Primary operation 3: obtain a new array beginning at the second element of an old array.
  if v.base.isNil:
    raise newException(NilAccessDefect, "cdr on empty list")

  if v.offset + 1 < v.base.elems.len:
    inc v.offset
    return v
  result = VList[T](base: v.base.next, offset: 0)


func len[T](v: VList[T]): Natural =
  ## Primary operation 4:  compute the length of the list.
  if v.base.isNil: return 0
  result = v.base.elems.len * 2 - v.offset - 1


func `$`[T](v: VList[T]): string =
  if v.base.isNil: return "[]"
  result = '[' & $v.base.elems[v.offset]
  var sg = v.base
  var sl = v.base.elems[v.offset+1..^1]
  while true:
    for e in sl: result.add ' ' & $e
    sg = sg.next
    if sg.isNil: break
    sl = sg.elems
  result.add ']'


proc printStructure[T](v: VList[T]) =
  echo "offset: ", v.offset
  var sg = v.base
  while not sg.isNil:
    echo "  ", sg.elems
    sg = sg.next
  echo()


when isMainModule:

  var v = newVList[string]()

  echo "Zero value for type.  Empty vList:", v
  v.printStructure()

  for a in countdown('6', '1'): v = v.cons($a)
  echo "Demonstrate cons. Six elements added:", v
  v.printStructure()

  v = v.cdr()
  echo "Demonstrate cdr. One element removed:", v
  v.printStructure()

  echo "Demonstrate length. Length = ", v.len()
  echo()

  echo "Demonstrate element access. v[3] = ", v[3]
  echo()

  v = v.cdr().cdr()
  echo "Show cdr releasing segment. Two elements removed: ", v
  v.printStructure()
