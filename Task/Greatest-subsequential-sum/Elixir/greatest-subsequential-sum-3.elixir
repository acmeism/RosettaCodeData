data = [ [1, 2, 3, 4, 5, -8, -9, -20, 40, 25, -5],
         [-1, -2, 3, 5, 6, -2, -1, 4, -4, 2, -1],
         [-1, -2, -3, -4, -5],
         [] ]
Enum.each(data, fn input ->
  IO.puts "\nInput seq: #{inspect input}"
  {max, subseq} = Greatest.subseq_sum(input)
  IO.puts "  Max sum: #{max}\n   Subseq: #{inspect subseq}"
end)
