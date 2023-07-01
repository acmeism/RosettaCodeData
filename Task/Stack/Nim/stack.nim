type Stack[T] = distinct seq[T]

func initStack[T](initialSize = 32): Stack[T] =
  Stack[T](newSeq[T](initialSize))

func isEmpty[T](stack: Stack[T]): bool =
  seq[T](stack).len == 0

func push[T](stack: var Stack[T]; item: sink T) =
  seq[T](stack).add(item)

func pop[T](stack: var Stack[T]): T =
  if stack.isEmpty:
    raise newException(IndexDefect, "stack is empty.")
  seq[T](stack).pop()

func top[T](stack: Stack[T]): T =
  if stack.isEmpty:
    raise newException(IndexDefect, "stack is empty.")
  seq[T](stack)[^1]

func mtop[T](stack: var Stack[T]): var T =
  if stack.isEmpty:
    raise newException(IndexDefect, "stack is empty.")
  seq[T](stack)[^1]

func `mtop=`[T](stack: var Stack[T]; value: T) =
  if stack.isEmpty:
    raise newException(IndexDefect, "stack is empty.")
  seq[T](stack)[^1] = value

when isMainModule:

  var s = initStack[int]()
  s.push 2
  echo s.pop
  s.push 3
  echo s.top
  s.mtop += 1
  echo s.top
  s.mtop = 5
  echo s.top
