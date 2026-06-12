words = File.open("unixdict.txt").readlines.map(&:chomp).select{|w| w.size > 11 }

size_groups = words.group_by(&:size).sort.map(&:last)
res =  size_groups.flat_map do |group|
  group.combination(2).select{|word1, word2| word1.chars.zip(word2.chars).one?{|c1, c2| c1 != c2} }
end

puts "Found #{res.size} changeable word pairs:"
res.each{|w1, w2|puts "#{w1} - #{w2}" }
