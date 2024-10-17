n = ARGV.fetch(0, 41).to_i  # n default is 41 or ARGV[0]
k = ARGV.fetch(1,  3).to_i  # k default is 3 or ARGV[1]

prisoners = (0...n).to_a
while prisoners.size > 1; prisoners.rotate!(k-1).shift end
puts "From #{n} prisoners, eliminating each prisoner #{k} leaves prisoner #{prisoners.first}."
