dict = File.readlines("unixdict.txt", chomp: true).reject{|w| w.size < 5}
dict.each do |w|
  next if w.size < 9
  odd = w.chars.each_slice(2).map(&:first).join
  puts w.ljust(14) + odd if dict.bsearch{|w| odd <=> w}
end
