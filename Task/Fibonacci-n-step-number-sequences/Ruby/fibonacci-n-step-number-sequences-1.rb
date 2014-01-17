def anynacci(start_sequence, count)
  n = start_sequence.length    # Get the n-step for the type of fibonacci sequence
  result = start_sequence.dup  # Create a new result array with the values copied from the array that was passed by reference

  (n+1..count).each do         # Loop for the remaining results up to count
    result << result.last(n).reduce(:+)    # Get the last n element from result and append its total to Array
  end

  result                       # Return result
end

naccis = { lucus:      [2,1],
           fibonacci:  [1,1],
           tribonacci: [1,1,2],
           tetranacci: [1,1,2,4],
           pentanacci: [1,1,2,4,8],
           hexanacci:  [1,1,2,4,8,16],
           heptanacci: [1,1,2,4,8,16,32],
           octonacci:  [1,1,2,4,8,16,32,64],
           nonanacci:  [1,1,2,4,8,16,32,64,128],
           decanacci:  [1,1,2,4,8,16,32,64,128,256] }

def print_nacci(naccis, count=15)
  puts naccis.map {|name, seq| "%12s : %p" % [name, anynacci(seq, count)]}
end

print_nacci(naccis)
