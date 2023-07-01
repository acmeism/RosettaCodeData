type

  Node[T] = ref object
    value: T
    next: Node[T]

  Queue*[T] = object
    head, tail: Node[T]
    length: Natural

func initQueue*[T](): Queue[T] = Queue[T]()

func len*(queue: Queue): Natural =
  queue.length

func isEmpty*(queue: Queue): bool {.inline.} =
  queue.len == 0

func push*[T](queue: var Queue[T]; value: T) =
  let node = Node[T](value: value, next: nil)
  if queue.isEmpty: queue.head = node
  else: queue.tail.next = node
  queue.tail = node
  inc queue.length

func pop*[T](queue: var Queue[T]): T =
  if queue.isEmpty:
    raise newException(ValueError, "popping from empty queue.")
  result = queue.head.value
  queue.head = queue.head.next
  dec queue.length
  if queue.isEmpty: queue.tail = nil


when isMainModule:

  var fifo = initQueue[int]()

  fifo.push(26)
  fifo.push(99)
  fifo.push(2)
  echo "Fifo size: ", fifo.len()
  try:
    echo "Popping: ", fifo.pop()
    echo "Popping: ", fifo.pop()
    echo "Popping: ", fifo.pop()
    echo "Popping: ", fifo.pop()
  except ValueError:
    echo "Exception catched: ", getCurrentExceptionMsg()
