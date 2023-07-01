words = IO.foreach('unixdict.txt').map(&:chomp).select {|word| word.chars.sort.join == word}
puts words.group_by(&:size).sort_by(&:first).last.last
