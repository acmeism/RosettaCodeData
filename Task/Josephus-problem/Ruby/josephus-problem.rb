n = (ARGV[0] || 41).to_i
k = (ARGV[1] || 3).to_i

prisoners = (0...n).to_a
prisoners.rotate!(k-1).shift  while prisoners.length > 1
puts prisoners.first
