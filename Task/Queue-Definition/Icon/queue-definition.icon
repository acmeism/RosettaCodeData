# Use a record to hold a Queue, using a list as the concrete implementation
record Queue(items)

procedure make_queue ()
  return Queue ([])
end

procedure queue_push (queue, item)
  put (queue.items, item)
end

# if the queue is empty, this will 'fail' and return nothing
procedure queue_pop (queue)
  return pop (queue.items)
end

procedure queue_empty (queue)
  return *queue.items = 0
end

# procedure to test class
procedure main ()
  queue := make_queue()

  # add the numbers 1 to 5
  every (item := 1 to 5) do
    queue_push (queue, item)

  # pop them in the added order, and show a message when queue is empty
  every (1 to 6) do {
    write ("Popped value: " || queue_pop (queue))
    if (queue_empty (queue)) then write ("empty queue")
  }
end
