def print_sequence(input_sequence, seq=10)
  return unless seq > 0
  puts input_sequence.join
  result_array = input_sequence.cluster.map do |cluster|
    [cluster.count, cluster.first]
  end
  print_sequence(result_array.flatten, seq-1)
end

print_sequence([1])
