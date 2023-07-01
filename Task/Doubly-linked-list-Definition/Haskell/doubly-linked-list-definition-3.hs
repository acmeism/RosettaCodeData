class DoubleList (item)

  method head ()
    node := item
    every (node := node.traverse_backwards ()) # move to start of list
    return node
  end

  method tail ()
    node := item
    every (node := node.traverse_forwards ()) # move to end of list
    return node
  end

  method insert_at_head (value)
    head().insert_before (DoubleLink(value))
  end

  method insert_at_tail (value)
    tail().insert_after (DoubleLink (value))
  end

  # insert a node for new_value after that for target_value,
  # i.e. in the middle of the list
  method insert_after (target_value, new_value)
    node := head ()
    every node := head().traverse_forwards () do
      if (node.value = target_value)
        then {
          node.insert_after (DoubleLink (new_value))
         break
        }
  end

  # constructor initiates a list making a node from given value
  initially (value)
    self.item := DoubleLink (value)
end
