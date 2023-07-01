proc insertAfter[T](l: var List[T], r, n: Node[T]) =
  n.prev = r
  n.next = r.next
  n.next.prev = n
  r.next = n
  if r == l.tail: l.tail = n
