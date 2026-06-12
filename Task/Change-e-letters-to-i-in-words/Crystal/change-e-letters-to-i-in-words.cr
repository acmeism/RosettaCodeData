words = File.open("unixdict.txt") do |f|
  f.each_line.select {|line| line.size > 5 }.to_set
end
words.compact_map {|word|
  if word =~ /e/ && (word_i = word.gsub(/e/, "i")) && word_i.in? words
    { word, word_i }
  end
}.sort.each do |we, wi|
  puts "#{we} -> #{wi}"
end
