words = File.readlines("unixdict.txt").map(&:chomp)
words.each do |word|
  next if word.size < 6
  next unless word.match?(/e/)
  e2i = word.tr("e", "i")
  next unless words.bsearch{|w| e2i <=> w}
  puts "#{word.ljust(10)} -> #{e2i}"
end
