VOWELS =%w(a e i o u).map(&:freeze)

res = File.open("unixdict.txt").each_line.select do |line|
  word = line.chomp
  word.size > 9 && word.chars.each_cons(2).all?{|c1, c2| VOWELS.include?(c1) != VOWELS.include?(c2) }
end
puts res
