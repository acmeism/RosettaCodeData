words = File.readlines("words.txt", chomp: true).reject{|word| word.size <= 6}
reversed_words = words.map(&:reverse)
reversables = (words & reversed_words).reject{|word| word == word.reverse}
res = reversables.uniq{|w| [w, w.reverse].sort}
res.each{|w| puts "#{w} - #{w.reverse}".center(20) }
