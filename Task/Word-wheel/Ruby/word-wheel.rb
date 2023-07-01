wheel  = "ndeokgelw"
middle, wheel_size = wheel[4], wheel.size

res = File.open("unixdict.txt").each_line.select do |word|
  w = word.chomp
  next unless w.size.between?(3, wheel_size)
  next unless w.match?(middle)
  wheel.each_char{|c| w.sub!(c, "") } #sub! substitutes only the first occurrence (gsub would substitute all)
  w.empty?
end

puts res
