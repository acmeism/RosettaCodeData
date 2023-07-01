# Use a class to hold a Queue, with a list as the concrete implementation
class Queue (items)
  method push (item)
    put (items, item)
  end

  # if the queue is empty, this will 'fail' and return nothing
  method take ()
    return pop (items)
  end

  method is_empty ()
    return *items = 0
  end

  initially () # initialises the field on creating an instance
    items := []
end

procedure main ()
  queue := Queue ()

  every (item := 1 to 5) do
    queue.push (item)

  every (1 to 6) do {
    write ("Popped value: " || queue.take ())
    if queue.is_empty () then write ("empty queue")
  }
end
