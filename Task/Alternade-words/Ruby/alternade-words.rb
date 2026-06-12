words = File.open("unixdict.txt").map(&:chomp)

res = words.filter_map do |word|
  next if word.size < 6
  splitted = word.each_char.partition.with_index{|_,i| i.even? }.map(&:join)
  next unless splitted.all?{|split| words.bsearch{|w| split <=> w} }
  "#{word}: #{splitted.join(", ")}"
end

puts res
