words = File.read_lines("unixdict.txt").to_set
words.compact_map {|word|
  next if word.size < 6
  chars = word.chars
  subwords = { chars.each_step(2).join, chars.each_step(2, offset: 1).join }
  { word, subwords } if subwords.all? {|sw| sw.in? words }
}.sort!.each do |w, sw|
  puts "#{w} => #{sw}"
end
