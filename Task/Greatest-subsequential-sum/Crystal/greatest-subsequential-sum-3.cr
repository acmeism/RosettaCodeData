[ [1, 2, 3, 4, 5, -8, -9, -20, 40, 25, -5],
  [-1, -2, 3, 5, 6, -2, -1, 4, -4, 2, -1],
  [-1, -2, -3, -4, -5],
  [] of Int32
].each do |input|
  puts "\nInput seq: #{input}"
  puts "  Max sum: %d\n   Subseq: %s" % subarray_sum(input)
end
