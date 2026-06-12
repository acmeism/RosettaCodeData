word_list = File.open("unixdict.txt") do |f|
  f.each_line.select(&.size.>= 9).map(&.chars).to_a
end

word_set = word_list.to_set

word_list.each_cons(9, reuse: true) do |nonad|
  newword = nonad.map_with_index { |word, idx| word[idx] }
  puts newword.join if newword.in? word_set
end
