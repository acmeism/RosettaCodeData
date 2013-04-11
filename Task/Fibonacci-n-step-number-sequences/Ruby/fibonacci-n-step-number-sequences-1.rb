def anynacci(start_sequence, count)
  n = start_sequence.length    # Get the n-step for the type of fibonacci sequence
  result = start_sequence.dup  # Create a new result array with the values copied from the array that was passed by reference

  (n+1..count).each do         # Loop for the remaining results up to count
    tail = result.last(n)      # Get the last n elements from result
    next_num = tail.reduce(:+) # In Rails: tail.sum
    result << next_num         # Array append
  end

  result                       # Return result
end
