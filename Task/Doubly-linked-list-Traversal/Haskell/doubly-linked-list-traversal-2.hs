class DoubleLink (value, prev_link, next_link)

  # insert given node after this one, removing its existing connections
  method insert_after (node)
    node.prev_link := self
    if (\next_link) then next_link.prev_link := node
    node.next_link := next_link
    self.next_link := node
  end

  # use a generator to traverse
  # - keep suspending the prev/next link until a null node is reached
  method traverse_backwards ()
    current := self
    while \current do {
      suspend current
      current := current.prev_link
    }
  end

  method traverse_forwards ()
    current := self
    while \current do {
      suspend current
      current := current.next_link
    }
  end

  initially (value, prev_link, next_link)
    self.value := value
    self.prev_link := prev_link    # links are 'null' if not given
    self.next_link := next_link
end

procedure main ()
  l1 := DoubleLink (1)
  l2 := DoubleLink (2)
  l1.insert_after (l2)
  l1.insert_after (DoubleLink (3))

  write ("Traverse from beginning to end")
  every (node := l1.traverse_forwards ()) do
    write (node.value)

  write ("Traverse from end to beginning")
  every (node := l2.traverse_backwards ()) do
    write (node.value)
end
