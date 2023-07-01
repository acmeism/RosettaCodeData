  # insert given node before this one, losing its existing connections
  method insert_before (node)
    if (\prev_link) then prev_link.next_link := node
    node.prev_link := prev_link
    node.next_link := self
    self.prev_link := node
  end
