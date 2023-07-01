def split(str)
  puts " input string: #{str}"
  s = str.chars.chunk(&:itself).map{|_,a| a.join}.join(", ")
  puts "output string: #{s}"
  s
end

split("gHHH5YY++///\\")
