File.open("unixdict.txt").each_line do |word|
  puts word if word.size > 10 && word.chars.tally.values_at('a','e','i','o','u').all?(1) rescue nil
end
