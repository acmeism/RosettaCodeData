class DoubleLink (value, prev_link, next_link)

  # insert given node after this one, losing its existing connections
  method insert_after (node)
    node.prev_link := self
    if (\next_link) then next_link.prev_link := node
    node.next_link := next_link
    self.next_link := node
  end

  initially (value, prev_link, next_link)
    self.value := value
    self.prev_link := prev_link    # links are 'null' if not given
    self.next_link := next_link
end
